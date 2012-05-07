%minlpQG is a small example problem for defining and solving
% mixed-integer nonlinear programming problems using the TOMLAB format.
Name='Avalanche Simulation - Christopher Wood.';

% SBOX design paramters
SBOX_SIZE = 8;
bits = log2(SBOX_SIZE);

% Initialize the integer variable constraints 
IntVars   = logical([ 1 1 1 1 1 1 1 1]); % Integer variables: x(1)-x(9)
VarWeight = []; % whatever

% There are divisions and square roots involving x(2), so we must
% have a small but positive value for the lower bound on x(2).
upperBound = 2^bits - 1;
x_L = [ 0 0 0 0 0 0 0 0]'; % Lower bounds on x
x_U = [ upperBound upperBound upperBound upperBound upperBound upperBound upperBound upperBound ]'; % Upper bounds on x

% Initailize the design variables (all zeros in the S-box)
x_0 = [1 1 1 1 1 1 1 1]; % relatively sparse values

x_min = [ 0 0 0 0 0 0 0 0 ]; % Used for plotting, lower bounds
x_max = [ upperBound upperBound upperBound upperBound upperBound upperBound upperBound upperBound ]; % Used for plotting, upper bounds

HessPattern = spalloc(SBOX_SIZE, SBOX_SIZE, 0); % All elements in Hessian are zero.
ConsPattern = [ 0 1 0 0 0 0 0 0 ; ... % Sparsity pattern of nonlinear
                1 0 1 0 1 0 1 0]; % constraint gradient
                
fIP = [2^(SBOX_SIZE * SBOX_SIZE)]; % An upper bound on the IP value wanted. Makes it possible
xIP = []; % to cut branches. xIP: the x value giving fIP

% Generate the problem structure using the TOMLAB Quick format
Prob = minlpAssign('avalanche_f', 'avalanche_g', [], HessPattern, ...
                    x_L, x_U, Name, x_0, IntVars, VarWeight, [], [], ...
                    [], [], [], [], [], [], ...
                    [], [], [], ...
                    x_min, x_max, [], []);
                
% Some additional parameters
% http://tomwiki.com/MinlpSolve
Prob.RandState = -1;
Prob.NodeSel = 1; % breadth-first
Prob.ROUNDH = 1; %knapsack heuristic
Prob.IterPrint = 1;
                
                
% Initialize the problem
Prob.DUNDEE.optPar(20) = 1; % Treat all constraints as nonlinear
Prob.DUNDEE.optPar(5) = 50; % Maximum number of refinement steps
Prob.DUNDEE.optPar(4) = SBOX_SIZE - 1;
Prob.P = 1; % Specify nonlinear constraints


% Get default TOMLAB solver for your current license, for "minlp" problems
% Solver = GetSolver('minlp');
% Call driver routine tomRun, 3rd argument > 0 implies call to PrintResult
Result = tomRun('minlpBB', Prob, 2);
