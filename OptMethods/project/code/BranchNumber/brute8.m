function brute8()
%BRUTE Summary of this function goes here
%   Detailed explanation goes here

SBOX_SIZE = 8;
results = zeros(1, factorial(SBOX_SIZE));

x_opt = [];
f_opt = Inf;
index = 1;
for x1 = 1:SBOX_SIZE
    for x2 = 1:SBOX_SIZE
        for x3 = 1:SBOX_SIZE
            for x4 = 1:SBOX_SIZE
                for x5 = 1:SBOX_SIZE
                    for x6 = 1:SBOX_SIZE
                        for x7 = 1:SBOX_SIZE
                            for x8 = 1:SBOX_SIZE
                                x = [x1 - 1, x2 - 1, x3 - 1, x4 - 1, x5 - 1, x6 - 1, x7 - 1, x8 - 1];
                                f = bn_fitness(x)
                                results(index) = f;
                                index = index + 1;
                                if f < f_opt;
                                    x_opt = x;
                                    f_opt = f;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

disp(x_opt)
disp(f_opt)
plot(results)

end

