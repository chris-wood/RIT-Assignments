function [c, ceq] = confun(X)

% Nonlinear inequality constraints
c = [X(1) - 0.5;
(pi * (X(1)^2) * X(2) * 8000) - 70;
(1/2) * 8000 * (3 + 0.3) * (100 * pi)^2 * (X(1)^2) - (140 * (10^6));];

% Nonlinear equality constraints
ceq = [];
