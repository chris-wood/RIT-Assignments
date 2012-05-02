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
indices = zeros(1, SBOX_SIZE);

% Dumbly fill in the S-box contents
for i = 1:SBOX_SIZE
	S(i) = i - 1;
    indices(i) = i;
end

% Attempt to calculate the BN for this S-box (simple setup)
S;
[n, pair] = bn(S, SBOX_SIZE);

% Set up the options for the solver to make sure the interior-point 
% algorithm is used.
options = optimset('Algorithm','interior-point','Display','iter-detailed','PlotFcns','optimplotfval');

% Invoke the fmincon function to find the minimum.
S
%[v1,v2] = fmincon('sboxbnobj',S,[],[],[],[],0,(2^SBOX_SIZE) - 1,'sboxcon', options);

% Help with genetic algorithm and optimization:
% http://www.mathworks.com/help/toolbox/gads/bs1cibj.html#bs1cihn
%indices %display the indicies of the design variables that must be integers
%opts = gaoptimset('StallGenLimit',50,'TolFun',1e-10,...
%    'Generations',300,'PlotFcns',@gaplotbestfun);
%
% Try to run the genetic algorithm instead
%rng(2,'twister') % for reproducibility
%[x,fval,exitflag] = ga(@sboxbnobj,SBOX_SIZE,[],[],[],[],0,2^SBOX_SIZE,@sboxcon,indices, opts); 

% Try to use the IP function to solve this problem
% f=[-17, -12]; %take the negative for maximization problems
% A=[ 10  7; 1 1];
% B=[40; 5];
% lb=[0 0];
% ub=[inf inf];
M=[1,2];
%e=2^-24; % integarilty tolerance
%[x v s] = IP(@sboxbnobj,[],[],[],[],0,4,indices,e)
