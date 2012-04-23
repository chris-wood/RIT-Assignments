function [c, ceq] = confun(X)

% Nonlinear inequality constraints
c = [(X(1) * X(1)) + (X(2) * X(2)) + (X(3) * X(3)) + (X(4) * X(4)) + X(1) - X(2) + X(3) - X(4) - 100;
(X(1) * X(1)) + 2*(X(2) * X(2)) + (X(3) * X(3)) + 2*(X(4) * X(4)) - X(1) - X(4) - 10;
2*(X(1) * X(1)) + (X(2) * X(2)) + (X(3) * X(3)) + 2*X(1) - X(2) - X(4) - 5;];

% Nonlinear equality constraints
ceq = [];
