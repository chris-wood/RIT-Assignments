function [c, ceq] = confun(X)
% Description: confun is a function that represents the nonlinear 
%   inequality (and equality) constraints for the problem defined 
%   in part #1 of the assignment.
%
% Prototype: [c, ceq] = confun(X) (where size(X) == 4)
%
% Usage: [c, ceq] = confun([0, 0, 0, 0]) 
%
% Author: Christopher Wood, caw4567@rit.edu
% Date: 4/24/12
% Version: 1.0

% Build up the inequality matrix as defined by the problem.
c = [(X(1) * X(1)) + (X(2) * X(2)) + (X(3) * X(3)) + (X(4) * X(4)) ...
    + X(1) - X(2) + X(3) - X(4) - 100;
    (X(1) * X(1)) + 2*(X(2) * X(2)) + (X(3) * X(3)) + 2*(X(4) * X(4)) ...
    - X(1) - X(4) - 10;
    2*(X(1) * X(1)) + (X(2) * X(2)) + (X(3) * X(3)) + 2*X(1) - X(2) ...
    - X(4) - 5;];

% There are no nonlinear equality constraints, so leave this empty
ceq = [];
