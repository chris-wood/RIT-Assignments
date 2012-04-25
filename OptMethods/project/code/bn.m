% TODO: comment
function [n,pair] = bn(S, n)
	min = n;
	pair = zeros(1,2);
	bits = log2(n);
	for a = 1:size(S)(2)
		for b = 2:size(S)(2)
			x = wt(a ^ b, bits);
			y = wt(S(a) ^ S(b), bits);
			if (x + y < min)
				min = x + y
				pair(1,1) = a
				pair(1,2) = b
			end
		end 
	end	
	n = min;
end
