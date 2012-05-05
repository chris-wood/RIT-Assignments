function [n,pair] = bn(S, n)
	minVal = n;
	pair = zeros(1,2);
	bits = log2(n);
    
    % Fetch the size of the S-box
    [~, sc] = size(S);
    
    % Perform the branch number calculation over all combinations of 
    % numbers in this field.
	for a = 1:sc
		for b = 1:sc
            if (a ~= b)
                x = wt(bitxor(a - 1,b - 1), bits);
                y = wt(bitxor(S(a), S(b)), bits);
                if (x + y < minVal)
                    minVal = x + y;
                    pair(1,1) = a - 1;
                    pair(1,2) = b - 1;
                end
            end
		end 
	end	
	n = minVal; 
end
