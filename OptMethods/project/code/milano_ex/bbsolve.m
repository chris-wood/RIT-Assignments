function [x,fval,exitflag] = bbsolve(f,gradf,g,jac,hessn,fixflag,intflag,init,K)
	
    global bestf bestx;
    
    % Problem size
	n = length(intflag);

	% Root node
    [x, y, fval] = ipmpen(f,gradf,g,jac,hessn,fixflag,init,K);
    exitflag = 1;
    
    if (exitflag == 1) % Problem had a feasible solution
        init.x = x;
        init.y = y;
        init.w = g(x);
        
        disp('	Soln                     Intflag    Fixflag');
        disp([x, intflag, fixflag]);
        disp('Objective Function Value = ');
        disp(fval);
        disp('');

        % Check for integrality of discrete variables
        res = abs(round(x)-x);          % Calculate the absolute value of the residual for integrality
        intres = res.*intflag;          % Include residuals for integer variables only
        [sortres, ix] = sort(intres);	% Sort the residuals (all between 0 and 1) in ascending order, save row in ix

        % While non-integer answers remain, do branch-and-bound
        if (sortres(n) > 1e-4)

            index = ix(n);
            
            % Left child - set lower bound and recurse
            fixflag(index) = 0;
            [x, fval,exitflag] = bbsolve(f,gradf,g,jac,hessn,fixflag,intflag,init,K);

            % Right child - set upper bound
            fixflag(index) = 1;
            [x, fval,exitflag] = bbsolve(f,gradf,g,jac,hessn,fixflag,intflag,init,K);

        else
            
            if (fval < bestf)
                bestf = fval;
                bestx = x;
                disp('Found new integer solution: ');
            end
            
        end
        
    else

        disp('Infeasible subproblem.  Moving on.');

    end
end
