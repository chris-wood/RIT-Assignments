%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File: calculateJoint.m
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

% Dumbly fill in the S-box contents
for i = 1:SBOX_SIZE
    S(i) = i - 1;
end

% Set up for genetic algorithm
LB = 0;
UB = 2^bits;
Bound = [LB;UB];
options = gaoptimset('CreationFcn',@joint_creation,'MutationFcn',@joint_mutate,...
    'PopInitRange',Bound,'Display','diagnose','Generations',500,'PopulationSize',SBOX_SIZE,...
    'PlotFcns',{@gaplotpareto,@gaplotspread},'TolFun',1e-6,'StallGenLimit',2^SBOX_SIZE^2,...
    'InitialPopulation',S,'CrossoverFraction',0.5,'CrossoverFcn',@crossoversinglepoint);
%'CrossoverFcn',@bn_crossover);

% Run the genetic algorithm now!
[x, fval] = gamultiobj(@joint, SBOX_SIZE, [], [], [], [], LB, UB, options);
disp(x);
disp(fval);