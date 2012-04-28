function [c, ceq] = confun(X)
% Description: confun is a function that represents the nonlinear 
%   inequality (and equality) constraints for the flywheel design
%   parameters specified in problem #2. 
%
% Prototype: [c, ceq] = confun(X) (where size(X) == 2, X(1) == r, 
%                                  and X(2) == w)
%
% Usage: [c, ceq] = confun([0.2, 0.04]) 
%
% Author: Christopher Wood, caw4567@rit.edu
% Date: 4/24/12
% Version: 1.0

% Nonlinear inequality constraints based on the maximumal weight, stress,
% and radius.
c = [X(1) - 0.5;
(8000 * pi * (X(1))^2 * X(2)) - 70;
((1/2) * 8000 * 3.3 * (100 * pi)^2 * (X(1))^2) - (140 * (10^6));];

% Display the inequality constraints for each iteration.
c

% Nonlinear equality constraints (empty since we have no equalities).
ceq = [];
