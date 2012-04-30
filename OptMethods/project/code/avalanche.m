function [ p ] = avalanche( S, n )
%SAC Summary of this function goes here
%   Detailed explanation goes here

% Create the identity matrix c, where the dimensions equal the number
% of bits in the field elements (order 2^n of the field)
c = eye(log2(n));

% Compute the avalanche number for the field defined by the Sbox

% Now perform the sum over every element in S
% Extract rows:  A(3,:) 
for x = 1:n
    sum = 0;
    for i = 1:log2(n)
        ci = c(i,:);
        wt(xor(S(x), S(xor(x, 
    end
end
    
end

