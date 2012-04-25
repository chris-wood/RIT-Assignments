%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File: calculateBN.m
% Author: Christopher Wood, caw4567@rit.edu
% Description: Script that calculates the branch number for a 
% given S-box definition.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Change this parameter to modify the S-box behavior
SBOX_SIZE = 4;

% Initialize the S-box matrix here
S = zeros(1, SBOX_SIZE);

% Dumbly fill in the S-box contents
for i = 1:SBOX_SIZE
	S(i) = i;
end

% Attempt to calculate the BN for this S-box
S
[n, pair] = bn(S, SBOX_SIZE);
n
pair

%plot(DT)
%title("Actual Packet Distribution Times");
%xlabel("N (number of nodes)");
%ylabel("Estimated Time (Td)");
