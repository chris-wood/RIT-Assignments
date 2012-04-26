function f = objfunc(X)
% Description: objfunc is a function that represents the objective 
%   function for the minimum energy (which is the negation of the maximum 
%   energy equation) defined in part #2-b of the assignment.
%
% Prototype: f = objfunc(X) (where size(X) == 2, X(1) = r, and X(2) = w)
%
% Usage: f = objfunc([0.2, 0.04]) 
%
% Author: Christopher Wood, caw4567@rit.edu
% Date: 4/24/12
% Version: 1.0

% We use 8000 kg/m^3 and 100pi as the flywheel density and maximum 
% rotational speed, respectively, since we are seeking to optimize the 
% energy towards its maximum (or in this case, minimum) value.
f = -((1/4) * pi * (X(1)^4) * X(2) * 8000 * (100 * pi)^2);
