##########################################################################
#
# File: knapsack.py
# Author: Christopher Wood
# Description: Solution to project assignment 7-6.
#
##########################################################################

# For command line arguments 
import sys

##########################################################################
#
# 6-a: TODO
#
# 6-b: TODO
#
# 6-c: TODO
#
# 6-d: TODO
#
##########################################################################

def knapsack(n, values, weights, capacity):
	""" Compute the item indices that correspond to which items
		should be placed in the knapsack to yield the maximum
		value under with weight capacity constraint.
	"""
	# Construct the DP table and item index list
	table = list() # table is matrix of [item][capacity]
	for i in range(0, n):
		rowList = list()
		for j in range(0, capacity + 1):
			rowList.append(0)
		table.append(rowList)
		
	# Consider all possible items and knapsack capacitities
	# in a bottom-up fashion
	for i in range(0, n):
		for w in range(0, capacity + 1):
			# Check to see if this item can be included in the knapsack.
			# If not, then we exclude it from the value calculation. If
			# yes, then the value for this item is the max of choosing
			# to include it or not in the knapsack (which is computed
			# using previous values).
			if (weights[i] > w):
				table[i][w] = table[i - 1][w]
			else:
				vIn = values[i] + table[i - 1][w - weights[i]]
				vOut = table[i - 1][w]
				table[i][w] = max(vIn, vOut)

	# Return the computation 
	return getItemIndices(table, n, weights, capacity)

def getItemIndices(values, n, w, capacity):
	""" Determine the indices that correspond to the elements
		that were added to the knapsack that yielded the 
		maximum value.
	"""
	i = len(values) - 1
	weight = capacity
	indices = []
	
	# Zero out the index of every element to start
	for i in range(0, n):
		indices.append(0)
	
	# Now mark those that were actually included
	while i >= 0 and weight >= 0:
		# If the values for this item and the previous differ, then this
		# item was included in the knapsack, so mark it as such
		if ((i == 0 and values[i][weight] > 0) or 
			(values[i][weight] != values[i - 1][weight])):
			indices[i] = 1
			weight = weight - w[i]
		
		# Go down in the list of items
		i = i - 1

	# Return the resulting positions
	return indices
			
""" Run the knapsack function.
	
	If the user enters a valid set of numbers, run it on that
	set, else run the program with some fixed numbers.
"""
if (len(sys.argv) > 2):
	print "Not implemented"
else:
	V = [60,100,5000,10,50,20,30,10]
	W = [10,20,50,61,120,36,50,21]
	print V
	print W
	print knapsack(8, V, W, 60)
