##########################################################################
#
# File: knapscak.py
# Author: Christopher Wood
# Description: Solution to project assignment 7-6.
#
##########################################################################

# For command line arguments and maximum integer
import sys

##########################################################################
#
# 6-c: TODO
#
# 6-d: TODO
#
##########################################################################

def knapsack(n, v, w, W):
	""" TODO
	"""
	# Construct the DP table and item index list
	indexList = list()
	value = list() #value is table of [item][capacity]
	for i in range(0, n + 1):
		rowList = list()
		for j in range(0, W + 1):
			rowList.append(0)
		value.append(rowList)
		indexList.append(0)
		
	# Do the DP part now
	for i in range(0, n + 1):
		for j in range(0, W + 1):
			if (i == 0 or j == 0):
				# Both base cases handled this way
				value[i][j] = 0
			else:
				# Check to see if we gain more value by including this element
				# or not
				value[i][j] = max(v[i - 1] + value[i - 1][j - w[i - 1]], 
								  value[i - 1][j])

	print value[n][W]
			
""" Run the knapsack function.
	
	If the user enters a valid set of numbers, run it on that
	set, else run the program with some fixed numbers.
"""
if (len(sys.argv) > 2):
	print "TODO"

else:
	knapsack(3, [60,100,120], [10,20,30], 50)

