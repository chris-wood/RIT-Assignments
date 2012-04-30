function [x,y,fval] = ipmpen(objf, gradf, consf, jac, hessn, fixflag, init, K)

    % min f(x)
    % s.t. g(x) in K
    % f : R^n -> R
    % g : R^n -> R^m
    
    % min f(x) + pp'*xi
    % s.t. g(x) - w = 0
    %       w + xi in K
    %       dp - w in K
    %           xi in K
    % where pp is the array of primal penalty parameters, and
    % dp is the array of dual penalty parameters
    
    % K.l is the number of >= constraints
    % K.q are the sizes of the SOCP blocks
    % K.s are the sizes of the SDP blocks
    % Constraints are given in order of K
    
    fixed = find( (fixflag >= 0) );
    
    % Warmstart all variables.
    % To get problem dimensions, evaluate the constraints and their
    % derivatives.  The size of the transpose of the Jacobian (A) gives 
    % the number of constraints and variables.
    % Should also have m = length(gval) and n = length(x0)
    if (isempty(init.x))
        n = length(fixflag);
        x = zeros(n,1);
    else
        x = init.x;
    end
    x(fixed) = fixflag(fixed);
    
    A = jac(x);
    [m, n] = size(A);
    if (isempty(init.w))
        w = ones(m,1);
    else
        w = init.w;
    end
    if (isempty(init.y))
        y = ones(m,1);
    else
        y = init.y;
    end

    d = zeros(n,1);
    d(fixed) = 1;
    D = diag(d);
    
    xi = ones(m,1);
    psi = ones(m,1);
    pp = 10*abs(y+psi);
    dp = 10*abs(w+xi);
    
    % The KKT conditions are
    % grad f - A' y = 0
    % g(x) - w = 0
    % (w_i + xi_i) (y_i + psi_i) = 0, i=1,...,m
    % xi_i (pp_i - y_i - psi_i) = 0, i=1,...,m
    % psi_i (dp_i - w_i) = 0, i=1,...,m
    % (y,z,s) are the Lagrange multipliers
    % Change the last three conditions (complementarity) to equal mu > 0, 
    % where mu is the barrier parameter.  So that means we have to start with 
    % w + xi > 0
    % y + psi > 0 
    % dp - w > 0
    % pp - y - psi > 0
    % xi > 0
    % psi > 0
    % and keep them positive (in order to evaluate the logarithmic barrier terms
        
    % Take mu smaller than average complementarity to give incentive to
    % reducing the complementarity residual.
    mu = realmax;
    iter = 0;
    infmode = 0;
    penup = 0;
    
    line = sprintf('--------------------------------------------------------------------'); disp(line);
    line = sprintf('Iteration \t f(x) \t\t Primal Inf \t Dual Inf \t\t Max Comp'); disp(line);
    line = sprintf('--------------------------------------------------------------------'); disp(line);
    
    while (iter <= 25) 
        
        mu = min(mu,0.1*( (w+xi)'*(y+psi) + xi'*(pp-y-psi) + psi'*(dp-w) )/(3*m));
        
        fval = objf(x) + pp'*xi;
        c = gradf(x);
        gval = consf(x);
        A = jac(x);
        H = hessn(x,y);
        
        c(fixed) = 0;
        A(:,fixed) = 0;
        H(:,fixed) = 0;
        H(fixed,:) = 0;

        % KKT residuals for the barrier problem
        sigma = c - A'*y;
        sigma(fixed) = 0;
        rho = w - gval;

        % Check optimality conditions for the original problem
        kktres = max([norm(sigma,inf); norm(rho,inf); w.*y]);
        line = sprintf('%d \t\t %8.6e \t %8.6e \t %8.6e \t %8.6e', iter, fval, norm(sigma,inf),norm(rho,inf),...
            max([(w+xi).*(y+psi)]));
        disp(line);
        
        if (kktres < 1e-6)
            break;
        end
        
        % At each iteration, we'll solve a system with
        % | -(H+D)   A'    | |Dx| = | sigma             |
        % | A        WY^-1 | |Dy| = | rho + WY^-1 gamma |

        WYinv = diag( (w+xi)./(y+psi) );
        XiPpinv = diag( xi./(pp-y-psi) );
        PsiDpinv = diag( psi./(dp-w) );
        E = inv( inv(WYinv + XiPpinv) + PsiDpinv );
        gamma = inv(WYinv + XiPpinv)*(mu./(y+psi) - mu./(pp-y-psi) - w) - (mu./(dp-w) - psi);
        
        KKTmat = [-(H+D) A'; A E];
        KKTrhs = [sigma; rho + E*gamma];
        % disp(KKTmat);
        % disp(KKTrhs);

        step = linsolve(KKTmat, KKTrhs);

        Dx = step(1:n);
        Dy = step(n+1:n+m);
        Dpsi = -inv(WYinv + XiPpinv + inv(PsiDpinv))*(dp - mu./psi - mu./(y+psi) + mu./(pp-y-psi) + (WYinv+XiPpinv)*Dy);
        Dxi = XiPpinv*(Dy + Dpsi) + mu./(pp-y-psi) - xi;
        Dw = -WYinv*(-mu./(w+xi) + y + psi + Dy + Dpsi) - Dxi;
        
        % disp([x Dx]);
        % disp([w Dw y Dy]);
        % disp([xi Dxi psi Dpsi]);
        % disp([pp dp]);

        % x + alpha Dx
        % y + alpha Dy
        % w + alpha Dw
        % Find alpha so that w + alpha Dw > 0 and y + alpha Dy > 0
        % 0.95 is the "fraction to the boundary rule"

        alpha = max([ -(Dw+Dxi)./(w+xi); -(Dy+Dpsi)./(y+psi); -Dxi./xi; -Dpsi./psi ]);
        alpha = max(0.0, 1.0/alpha);
        alpha = 0.95*min( alpha, 1.0 );
                        
        oldfval = fval;
        newfval = objf(x+alpha*Dx) + pp'*(xi+alpha*Dxi);

        oldinf = norm(rho);
        newgval = consf(x+alpha*Dx);
        newinf = norm(newgval - (w+alpha*Dw));

        ncuts = 0;
        while (newfval >= oldfval && newinf >= oldinf && ncuts < 30)
            alpha = alpha/2;
            oldfval = fval;
            newfval = objf(x+alpha*Dx);

            oldinf = norm(rho);
            newgval = consf(x+alpha*Dx);
            newinf = norm(newgval - (w+alpha*Dw));
            
            ncuts = ncuts + 1;
        end
        % disp(ncuts);

        x = x + alpha*Dx;
        y = y + alpha*Dy;
        w = w + alpha*Dw;
        xi = xi + alpha*Dxi;
        psi = psi + alpha*Dpsi;
        
        if ( w > 0.75*dp )
            disp('upping the dual penalty parameters');
            dp = 10*max( w+xi, dp );
            penup = penup + 1;
        end
        if ( y + psi > 0.75*pp )
            disp('upping the primal penalty parameters');
            pp = 10*max( y+psi, pp );
            penup = penup + 1;
        end
        if (penup > 6)
            disp('infeasible problem');
            break;
            infmode = 1;
            penup = 0;
        end

        fval = newfval;

        iter = iter + 1;
    end
    
end