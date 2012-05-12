##########################################################################
#
# File: knapsack.py
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
		indexList.append(rowList)
		
	# Do the DP part now
	for i in range(0, n + 1):
		for j in range(0, W + 1):
			if (i == 0 or j == 0):
				# Both base cases handled this way
				value[i][j] = 0
			elif (w[i - 1] > j):
				# Check to see if this item can be included in the knapsack.
				# If not, then we exclude it from the value calculation.
				value[i][j] = value[i - 1][j]
			else:
				# Check to see if we gain more value by including this element
				# or not
				vIn = v[i - 1] + value[i - 1][j - w[i - 1]]
				vOut = value[i - 1][j]
				if (vIn >= vOut):
					value[i][j] = vIn
					#indexList[i - 1] = 1 # Include this in the list
					indexList[i][j] = i
				else:
					value[i][j] = vOut
					#indexList[i - 1] = 0 # Don't include this in the list

	return getItemIndices(value, n, w, W)

def getItemIndices(values, n, w, W):
	""" TODO
	"""
	# Initialize the final index and weight values and then 
	# traverse towards the front of the sequence, checking to see
	# which items were included in the knapsack or not.
	i = n
	j = W
	indices = list()
	while i > 0:
		# If the values for this item and the previous differ, then this
		# item was included in the knapsack, so mark it as such
		if (values[i][j] != values[i - 1][j]):
			indices.append(i - 1)
		
		# Go down in the list of items
		i = i - 1
		j = j - w[i]

	# Return the resulting positions
	return indices
			
""" Run the knapsack function.
	
	If the user enters a valid set of numbers, run it on that
	set, else run the program with some fixed numbers.
"""
if (len(sys.argv) > 2):
	print "TODO"
else:
	print knapsack(3, [60,100,120], [10,20,30], 50)

