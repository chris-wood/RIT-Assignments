function fitness = comb_fitness( X )
%AVALANCHE_FITNESS Summary of this function goes here
%   Detailed explanation goes here

SBOX_SIZE = length(X);

aFitness = avalanche_fitness(X);
bFitness = bn_fitness(X);
nFitness = nl_fitness(X);

% Linear combination of all three algirithms
X
fitness = ((aFitness) + (bFitness * -(2^SBOX_SIZE)) + (nFitness * -(2^SBOX_SIZE)));

% Rotate for additional randomness
%for i = 1:SBOX_SIZE
%   X(i) = mod(X(i) + SBOX_SIZE, SBOX_SIZE); 
%end

end

