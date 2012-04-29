"""
	for(j = 1; j <= n; j++) { /* fill in c[] bottom-up */
	c[j] = LONG_MAX;
	/* find min i (only look at the O(M/2) possibilities) */
	for(i = max(1, j+1-(M+1)/2); i <= j; i++) {
	long lc = linecost(n, M, i, j), cost = c[i-1] + lc;
	if(lc > -1 && cost < c[j]) {
	c[j] = cost; /* record the cost (c indexed from 1) */
	p[j] = i; /* record the min i (p indexed from 0) */
	}
	}
}