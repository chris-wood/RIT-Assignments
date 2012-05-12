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
	table = list()
	for i in range(0, n):
		rowList = list()
		for j in range(0, n):
			rowList.append(0)
		table.append(rowList)
		indexList.append(0)
		
	# Do the DP part now, kthx

""" Run the knapsack function.
	
	If the user enters a valid set of numbers, run it on that
	set, else run the program with some fixed numbers.
"""
if (len(sys.argv) > 2):
	print "TODO"

else:
	print "TODO"
	knapsack(5, [], [], 5)

