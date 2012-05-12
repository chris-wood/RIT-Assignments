function children = bn_mutate( parents, options, GenomeLength, FitnessFcn, state, thisScore, thisPopulation )
%AVALANCHE_MUTATE Summary of this function goes here
%   Detailed explanation goes here

shrink = .01;
scale = 1;
scale = scale - shrink * scale * state.Generation/options.Generations;
range = options.PopInitRange;
lower = range(1,:);
upper = range(2,:);
scale = scale * (upper - lower);
mutationPop = length(parents);

children = repmat(lower, mutationPop, 1) + ...
    round(repmat(scale, mutationPop, 1) .* rand(mutationPop, GenomeLength));

end

