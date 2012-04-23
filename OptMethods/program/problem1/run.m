% The initial value for the objective function.
x0 = [0,0,0,0];

% Set up the options for the solver to make sure
% the interior-point algorithm is used.
options = optimset('Algorithm','interior-point','Display','iter','PlotFcns','optimplotfval');

% Invoke the fmincon function to find the minimum.
[v1,v2] = fmincon('objfunc',x0,[],[],[],[],-100,100,'confun', options);

% Display the resulting solution.
v1
v2