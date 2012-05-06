function brute4()
%BRUTE Summary of this function goes here
%   Detailed explanation goes here

SBOX_SIZE = 4;
results = zeros(2, factorial(SBOX_SIZE));

bx_opt = [];
bf_opt = Inf;
ax_opt = [];
af_opt = [];
index = 1;
for x1 = 1:SBOX_SIZE
    for x2 = 1:SBOX_SIZE
        for x3 = 1:SBOX_SIZE
            for x4 = 1:SBOX_SIZE
                x = [x1 - 1, x2 - 1, x3 - 1, x4 - 1];
                fb = bn_fitness(x);
                fa = avalanche_fitness(x);
                results(1, index) = fb;
                results(2, index) = fa;
                index = index + 1;
                if (fa < af_opt)
                    ax_opt = x;
                    af_opt = fa;
                end
                if (fb < bf_opt)
                    bx_opt = x;
                    bf_opt = fb;
                end
            end
        end
    end
end

disp(ax_opt)
disp(af_opt)
disp(bx_opt)
disp(bf_opt)
plot(results'); %, ones(1, factorial(SBOX_SIZE)), bresults, ones(1, factorial(SBOX_SIZE)))
%plot(bresults)

end

