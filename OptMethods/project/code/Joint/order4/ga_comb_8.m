%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File: ga_comb_8.m
% Author: Christopher Wood, caw4567@rit.edu
% Description: Script that calculates the branch number for a 
% given S-box definition.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change this parameter to modify the S-box behavior
SBOX_SIZE = 8;
bits = log2(SBOX_SIZE);

% Initialize the S-box matrix here
S = zeros(1, SBOX_SIZE);
indices = zeros(1, SBOX_SIZE);

% Dumbly fill in the S-box contents
for i = 1:SBOX_SIZE
	S(i) = i - 1;
    indices(i) = i;
end

% Set up for genetic algorithm
LB = 0;
UB = 2^bits - 1;
Bound = [LB;UB];
options = gaoptimset('CreationFcn', @joint_creation,'MutationFcn',@joint_mutate, ...
    'PopInitRange',Bound,'Display','diagnose','Generations',500,'PopulationSize',SBOX_SIZE,...
    'PlotFcns',{@gaplotbestf,@gaplotdistance},...
    'TolFun',1e-6,'StallGenLimit',2^SBOX_SIZE^2,'InitialPopulation',S,'CreationFcn',@joint_creation,...
    'PenaltyFactor',100);

% Run the genetic algorithm now!
[x, fval] = ga(@comb_fitness, SBOX_SIZE, options)
