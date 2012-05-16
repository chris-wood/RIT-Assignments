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
# 6-a: Here is the pseudocode for the recursive solution
#
# function RecursiveKnapsack(n, v, w, W)
#	if (n == 0)
#     return 0
#   else if (W < w[n])
#     return RecursiveKnapsack(n - 1, v, w, W)
#   else
#     return max(v[n] + RecursiveKnapsack(n - 1, v, w, W - w[n]),
#                RecursiveKnapsack(n - 1, v, w, W))
#
# 6-b: The dynamic programming solution to this problem is 
# implemented below.
#
# 6-c: The time complexity of this dynamic programming based algorithm 
# depends on the computation of the $value$ table and identifying the 
# items that were added to the knapsack. Since these procedures are 
# run back-to-back, we consider their time complexity separately in 
# order to determine the time complexity of the entire algorithm.
#
# The time complexity of the value computation depends on the 
# initialization procedure in which the table is constructed and 
# then the nested loops that perform the bottom-up computation. The 
# initialization procedure generates a table that has dimensions (n x W)
# so it runs in O(nW) time. Similarly, the table computation procedure
# performs a constant time table lookup (or returns a 0 in the base case) 
# when traversing across every possible knapsack capacity for every item, 
# so we can conclude that this procedure runs in O(nW) time as well.
#
# Analyzing the time complexity of the item identification procedure 
# indicates that it runs in O(n) time, because at every iteration 
# through the main loop the item counter is decreased by 1 until 
# we consider all items in the knapsack. Hence, the linear time 
# complexity of O(n).
#
# Now, putting these two results together, the dynamic programming 
# based algorithm that solves the 0-1 knapsack problem has a time 
# complexity of O(nW) + O(nW) + O(n), which can be reduced to O(nW). 
#
# 6-d: No, this analysis does not prove that P = NP, because the O(nW)
# time complexity depends on the value of $W$, not the size of W. 
# Time complexity measurements consider the size of the input of an 
# algorithm (i.e. the number of bits if the input is a numeric value), 
# and since W = 2^{lg W}, where lgW is the number of bits in 
# W, we can see that the resulting time complexity is thus O(n2^{lg W})
# in terms of the size of W. This means that this dynamic programming 
# solution is a pseudo-polynomial time algorithm in that it is 
# polynomial with respect to the value of the input, but exponential 
# with respect to the size of the input, and thus is not polynomial 
# in the traditional sense. Therefore, we can see that this does 
# \emph{not} prove that P = NP.
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
	cap = 60
	print "Values: " + str(V)
	print "Weights: " + str(W)
	print "Knapsack capacity: " + str(cap)
	print "Optimal Indices: " + str(knapsack(8, V, W, cap))
