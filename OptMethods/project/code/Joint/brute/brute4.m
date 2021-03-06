function brute4()
%BRUTE Summary of this function goes here
%   Detailed explanation goes here

SBOX_SIZE = 4;
results = zeros(3, factorial(SBOX_SIZE));

bx_opt = [];
bf_opt = Inf;
ax_opt = [];
af_opt = [];
nx_opt = [];
nf_opt = [];
index = 1;
for x1 = 1:SBOX_SIZE
    for x2 = 1:SBOX_SIZE
        for x3 = 1:SBOX_SIZE
            for x4 = 1:SBOX_SIZE
                x = [x1 - 1, x2 - 1, x3 - 1, x4 - 1];
                fb = bn_fitness(x);
                fa = avalanche_fitness(x);
                fn = nl_fitness(x);
                results(1, index) = fb;
                results(2, index) = fa;
                results(3, index) = fn;
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

plot(results'); %, ones(1, factorial(SBOX_SIZE)), bresults, ones(1, factorial(SBOX_SIZE)))
%plot(bresults)

end

