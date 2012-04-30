function [x,fval,exitflag] = milano(f, gradf, g, jac, hessn, intflag, K)

    global bestf bestx;
        
    bestf = realmax;
    bestx = [];
    fixflag = -ones( length(intflag), 1);
    init.x = [];
    init.y = [];
    init.w = [];
    [x, fval,exitflag] = bbsolve(f, gradf, g, jac, hessn, fixflag, intflag, init, K);
    x = bestx;
    fval = bestf;
    
end