function [A] = jac(x)

    A = zeros(3,2);
    A(1,1) = 1;
    A(1,2) = 2;
    A(2,1) = 1;
    A(2,2) = -1;
    A(3,1) = -1;

end