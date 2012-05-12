function fitness = bn_fitness(X)
%AVALANCHE_FITNESS Summary of this function goes here
%   Detailed explanation goes here

% Debug stuff
SBOX_SIZE = length(X);
[n,pair,box] = bn(X, SBOX_SIZE);
fitness = -n;

end

