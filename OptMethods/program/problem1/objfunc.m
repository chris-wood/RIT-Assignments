function f = objfunc(X)
% Description: objfunc is a function that represents the objective 
%   function for the problem defined in part #1 of the assignment.
%
% Prototype: f = objfun(X) (where size(X) == 4)
%
% Usage: f = objfun([0, 0, 0, 0]) 
%
% Author: Christopher Wood, caw4567@rit.edu
% Date: 4/24/12
% Version: 1.0

% Direct copy of function definition from problem #1.
f = X(1)^2 + X(2)^2 + 2*X(3)^2 - X(4)^2 - 5*X(1)^2 - 5*X(2)^2 ...
    - 21*X(3) + 7*X(4) + 100;