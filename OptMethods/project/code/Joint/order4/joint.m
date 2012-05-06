function y = joint( X )
%JOINT Summary of this function goes here
%   Detailed explanation goes here

% Initialize for two objectives 
y = zeros(2,1);

% Compute objectives
disp(X);
y(1) = avalanche_fitness(X);
y(2) = bn_fitness(X);


end

