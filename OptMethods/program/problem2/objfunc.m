% X(1) = r
% X(2) = w
function f = objfunc(X)
f = -((1/4) * pi * (X(1)^4) * X(2) * 8000 * (100 * pi)^2);
