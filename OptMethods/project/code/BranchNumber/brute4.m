function brute4()
%BRUTE Summary of this function goes here
%   Detailed explanation goes here

SBOX_SIZE = 4;
results = zeros(1, factorial(SBOX_SIZE));

x_opt = [];
f_opt = 0;
index = 1;
for x1 = 1:SBOX_SIZE
    for x2 = 1:SBOX_SIZE
        for x3 = 1:SBOX_SIZE
            for x4 = 1:SBOX_SIZE
                x = [x1 - 1, x2 - 1, x3 - 1, x4 - 1];
                fitness = bn_fitness(x);
                fitness
                y = -(fitness(1))
                results(index) = fitness;
                index = index + 1;
                if fitness > f_opt;
                    x_opt = x;
                    f_opt = fitness;
                end
            end
        end
    end
end

disp(x_opt)
disp(f_opt)
plot(results)

end

