function w = wt(x, n)
	w = 0;
    if (x == 0)
        w = 0;
    else
        for i = 1:n
            w = w + bitget(uint8(x), i);	
        end
    end
end
