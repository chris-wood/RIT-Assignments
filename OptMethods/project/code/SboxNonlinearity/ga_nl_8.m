%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File: calculateAvalanche.m
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
	S(i) = 0; %i - 1
    indices(i) = i;
end

% Set up for genetic algorithm
LB = 0;
UB = 2^bits - 1;
Bound = [LB;UB];
options = gaoptimset('CreationFcn', @nl_creation,'MutationFcn',@nl_mutate, ...
    'PopInitRange',Bound,'Display','iter','Generations',150,'PopulationSize',SBOX_SIZE,...
    'PlotFcns',{@gaplotbestf,@gaplotbestindiv,@gaplotdistance,@gaplotselection});

% Run the genetic algorithm now!
[x, fval] = ga(@nl_fitness, SBOX_SIZE, options)