function pVector = avalanche(S, n)
%AVALANCHE: TODO DESCRIBE THIS BITCH

% Get the number of bits for field elements
bits = log2(n);

% Create results vector (1..n)
pVector = zeros(1, bits);

% Maximum weight sum
max = bits * (2^(bits - 1)); % don't do probabilities

% Now perform the sum over every element in S
% Extract rows: A(3,:)
for i = 1:bits
    sum = 0;
    for x = 1:n
        S
        first = S(x)
        second = S(bitxor(x - 1, 2^(i - 1)) + 1)
        sum = sum + wt(bitxor(S(x), S(bitxor(x - 1, 2^(i - 1)) + 1)), bits); % handle matlab +1 vector base indices
    end
    
    % Store the result
    pVector(i) = sum;
end

end % avalanche

