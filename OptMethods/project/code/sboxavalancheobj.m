function f = sboxavalancheobj(X)
%SBOXBNOBJ: TODO

[nr, nc] = size(X);
SBOX_SIZE = nc;
[pVector] = avalanche(X, SBOX_SIZE);
bits = log2(SBOX_SIZE);

X % display
pVector % display 
sum = 0;
for i = 1:bits
    sum = sum + pVector(i);
end
f = -(sum / bits); % Compute the percentage away from 100% (maximum avalanche)

end

