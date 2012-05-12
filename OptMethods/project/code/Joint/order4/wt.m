function w = wt(x, n)
	w = 0;
	for i = 1:n
		w = w + bitget(x, i);	
    end
end
