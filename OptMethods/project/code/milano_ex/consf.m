function [gval] = consf(x)

    gval = zeros(3,1);
    gval(1) = x(1) + 2*x(2) - 2;
    gval(2) = x(1) - x(2) + 1;
    gval(3) = -x(1) + 3;
    
end