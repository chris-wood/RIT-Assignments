function [c,ceq] = avalanche_const(X)
%AVALANCHE_CONST Summary of this function goes here
%   Detailed explanation goes here

SBOX_SIZE = length(X);
bits = log2(SBOX_SIZE);
c = zeros(1, SBOX_SIZE);
for i = 1:SBOX_SIZE
    c(i) = avalanche(X, SBOX_SIZE) - (bits * (2^(bits - 1)));
end

ceq = [];

end
