function w = wt(x, n)
	w = 0;
	for i = 1:n
		w = w + bitget(uint8(x), i);	
    end
end
