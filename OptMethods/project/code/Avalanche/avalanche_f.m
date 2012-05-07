function f = avalanche_f(X, Prob)
%SBOXBNOBJ: TODO

[~, nc] = size(X);
SBOX_SIZE = nc;
pVector = avalanche(X, SBOX_SIZE);
bits = log2(SBOX_SIZE);

X % display
pVector % display 
sum = 0;
for i = 1:bits
    sum = sum + pVector(i);
end
f = sum; % Compute the percentage away from 100% (maximum avalanche)

end

