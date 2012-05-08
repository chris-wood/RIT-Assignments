function brute4()
%BRUTE Summary of this function goes here
%   Detailed explanation goes here

SBOX_SIZE = 4;
results = zeros(1, factorial(SBOX_SIZE));

x_opt = [];
f_opt = Inf;
a_opt = 0;
b_opt = 0;
%fx_opt = 0;
index = 1;
for x1 = 1:SBOX_SIZE
    for x2 = 1:SBOX_SIZE
        for x3 = 1:SBOX_SIZE
            for x4 = 1:SBOX_SIZE
                x = [x1 - 1, x2 - 1, x3 - 1, x4 - 1]
                [ps, a, b] = nl(x, SBOX_SIZE)
                results(index) = ps;
                index = index + 1;
                if (ps < f_opt)
                    x_opt = x;
                    f_opt = ps;
                    a_opt = a;
                    b_opt = b;
                    %fx_opt = fx;
                end
            end
        end
    end
end

disp(x_opt)
disp(f_opt)
disp(a_opt)
disp(b_opt)
%disp(fx_opt)
plot(results)

disp('Checking optimal results');
nl(x_opt, SBOX_SIZE)

end

