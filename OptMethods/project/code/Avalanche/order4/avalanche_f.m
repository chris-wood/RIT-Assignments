function f = avalanche_f(X, Prob)
%SBOXBNOBJ: TODO

[nr, ~] = size(X);
SBOX_SIZE = nr;
pVector = avalanche(X', SBOX_SIZE);
bits = log2(SBOX_SIZE);

X % display
pVector % display 
sum = 0;
for i = 1:bits
    sum = sum + pVector(i);
end
f = -sum; % Compute the percentage away from 100% (maximum avalanche)

end

