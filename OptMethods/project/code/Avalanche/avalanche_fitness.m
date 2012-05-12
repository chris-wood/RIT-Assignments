function fitness = avalanche_fitness( X )
%AVALANCHE_FITNESS Summary of this function goes here
%   Detailed explanation goes here

% Debug stuff
%disp('inside fitness function')
SBOX_SIZE = length(X);
pVector = avalanche(X, SBOX_SIZE);
bits = log2(SBOX_SIZE);

% Sum up the bit weights to obtain the avalanche number
sum = 0;
for i = 1:bits
    sum = sum + (pVector(i) - (bits * (2^(bits - 1))));
end

%pVector
fitness = -sum;

end

