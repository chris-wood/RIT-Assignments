function [pVector] = sac(S, n)
%SAC: TODO DESCRIBE THIS BITCH

% Get the number of bits for field elements
bits = log2(n);

% Create results vector (1..n)
pVector = zeros(1, bits);

% Maximum weight sum
max = bits * (2^(bits - 1));

% Now perform the sum over every element in S
% Extract rows: A(3,:)
for i = 1:bits
    sum = 0;
    for x = 1:n
        sum = sum + wt(xor(S(x), S(xor(x - 1, 2^(i - 1)) + 1)), bits);
    end
    
    % Store the result
    pVector(i) = sum / max;
end

end % sac

