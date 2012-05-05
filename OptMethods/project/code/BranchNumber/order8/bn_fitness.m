function fitness = avalanche_fitness( X )
%AVALANCHE_FITNESS Summary of this function goes here
%   Detailed explanation goes here

% Debug stuff
%disp('inside fitness function')
SBOX_SIZE = length(X);
[n,pair] = bn(X, SBOX_SIZE);
fitness = n;

end

