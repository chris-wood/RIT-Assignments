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
	S(i) = i - 1;
end

% Attempt to calculate the BN for this S-box (simple setup)
S;
[n, pair] = bn(S, SBOX_SIZE);

% Set up the options for the solver to make sure the interior-point 
% algorithm is used.
options = optimset('Algorithm','interior-point','Display','iter-detailed','PlotFcns','optimplotfval');

% Invoke the fmincon function to find the minimum.
S
[v1,v2] = fmincon('sboxbnobj',S,[],[],[],[],0,(2^SBOX_SIZE) - 1,'sboxcon', options);