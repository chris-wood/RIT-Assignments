function fitness = nl_fitness( X )
%AVALANCHE_FITNESS Summary of this function goes here
%   Detailed explanation goes here

% Debug stuff
%disp('inside fitness function')
SBOX_SIZE = length(X);
[ps,fa,fb] = nl(X, SBOX_SIZE);
fitness = -ps; % we want to minimize this number!

end

