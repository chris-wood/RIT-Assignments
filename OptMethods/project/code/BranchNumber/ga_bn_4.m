%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File: calculateBN.m
% Author: Christopher Wood, caw4567@rit.edu
% Description: Script that calculates the branch number for a 
% given S-box definition.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change this parameter to modify the S-box behavior
SBOX_SIZE = 4;
bits = log2(SBOX_SIZE);

% Initialize the S-box matrix here
S = zeros(1, SBOX_SIZE);
indices = zeros(1, SBOX_SIZE);

% Dumbly fill in the S-box contents
for i = 1:SBOX_SIZE
	S(i) = i - 1;
    indices(i) = i;
end
S(1) = 0;
S(2) = 0;
S(3) = 1;
S(4) = 1;

% Set up the options for the solver to make sure the interior-point 
% algorithm is used.
%options = optimset('Algorithm','interior-point','Display','iter-detailed','PlotFcns','optimplotfval');

% Invoke the fmincon function to find the minimum.
%[v1,v2] = fmincon('sboxavalancheobj',S,[],[],[],[],0,(2^SBOX_SIZE) - 1,'sboxcon',options);

% Set up for genetic algorithm
LB = 0;
UB = 2^bits - 1;
Bound = [LB;UB];
options = gaoptimset('CreationFcn', @bn_creation,'MutationFcn',@bn_mutate, ...
    'PopInitRange',Bound,'Display','diagnose','Generations',500,'PopulationSize',SBOX_SIZE,...
    'PlotFcns',{@gaplotbestf,@gaplotbestindiv,@gaplotdistance,@gaplotselection},'TolFun',1e-6,'StallGenLimit',2^SBOX_SIZE^2,...
    'InitialPopulation',S);

% Run the genetic algorithm now!
[x, fval] = ga(@bn_fitness, SBOX_SIZE, options)