function y = joint( X )
%JOINT Summary of this function goes here
%   Detailed explanation goes here

% Initialize for two objectives 
%y = zeros(3,1);
%y = zeros(1,1);

% Compute objectives
%disp(X);
y(1) = avalanche_fitness(X);
%y(2) = bn_fitness(X);
%y(3) = nl_fitness(X);

end

