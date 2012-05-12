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
	S(i) = i - 1; %i - 1
    indices(i) = i;
end
S(1) = 1;
S(SBOX_SIZE) = 1;

% Set up for genetic algorithm
LB = 0;
UB = 2^bits - 1;
Bound = [LB;UB];
options = gaoptimset('CreationFcn', @avalanche_creation,'MutationFcn',@avalanche_mutate, ...
    'PopInitRange',Bound,'Display','iter','Generations',150,'PopulationSize',SBOX_SIZE,...
    'PlotFcns',{@gaplotbestf,@gaplotdistance});

% Run the genetic algorithm now!
[x, fval] = ga(@avalanche_fitness, SBOX_SIZE, options)