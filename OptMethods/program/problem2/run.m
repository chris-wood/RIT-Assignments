% Description: This is a simple script that will initilize the fmincon
%   solver to use the provided objective function and its constraints
%   to produce an optimal solution using the interior-point algorithm.
%
% Author: Christopher Wood, caw4567@rit.edu
% Date: 4/24/12
% Version: 1.0

% The initial value for the objective function.
x0 = [0.2, 0.04];

% Set up the options for the solver to make sure the interior-point 
% algorithm is used.
options = optimset('Algorithm','interior-point','Display','iter-detailed','PlotFcns','optimplotfval');

% Invoke the fmincon function to find the minimum.
[v1,v2] = fmincon('objfunc',x0,[],[],[],[],0,Inf,'confun', options);

% Display the resulting solution.
v1
v2