function [ps,fa,fb,fx] = nl( S, n )
%NL Summary of this function goes here
%   Detailed explanation goes here

max = 0;

% Try all possible a,b pairs
for a = 1:n
    for b = 1:n
        if (a ~= 1) %a ~= 1 is the same as a~=0, as in the equation
            for x = 1:n
                newX = x - 1;
                newA = a - 1;
                newB = b - 1;
                
                % Handle addition overflow
                index = mod(newX + newA, n);
                
                if (S(index + 1) - S(x) == newB)
                    if (newX > max)
                        max = newX;
                        fa = newA;
                        fb = newB;
                        fx = newX;
                    end
                end
            end
        end
    end
end

ps = max;

end
