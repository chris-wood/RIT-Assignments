function fitness = comb_fitness( X )
%AVALANCHE_FITNESS Summary of this function goes here
%   Detailed explanation goes here

SBOX_SIZE = length(X);

aFitness = avalanche_fitness(X);
bFitness = bn_fitness(X);
nFitness = nl_fitness(X);

% Linear combination of all three algirithms
fitness = (aFitness) + (bFitness * -10) + (nFitness * -15);

end

