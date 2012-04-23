##########################################################################
#
# File: sortedHasSum.py
# Author: Christopher Wood
# Description: Solution to project assignment 4-2a.
#
##########################################################################

# For command line arguments
import sys

# For square root function
from math import sqrt 

##########################################################################
#
# TODO: explain algorithm here
#
##########################################################################

def sortedHasSum(S, x):
	# List to store pair-wise differences 
	stack = list()

	# Traverse the list and compute the pair-wise differences
	# between x and each element a
	seqIndex = 0
	for a in S:
		if (2*a <= x):
			stack.append(x - a)
			seqIndex = seqIndex + 1

	# Traverse the list of elements and see if we can
	# find a match for the pair-wise difference
	while (len(stack) != 0 and seqIndex >= 0):
		item = stack.pop(len(stack) - 1)
		moveOn = False
		while (not moveOn):
			if (item == S[seqIndex]):
				return (x - item, S[seqIndex])
			elif (item > S[seqIndex]):
				seqIndex = seqIndex + 1
			else: # item < S[seqIndex]
				moveOn = True

	return (-1, -1)

""" Run the sortedHasSum function.
	
	If the user enters a valid set of numbers, run it on that
	set, else run the program with some random numbers.
"""
if (len(sys.argv) == 7):
	v1 = int(sys.argv[1])
	v2 = int(sys.argv[2])
	v3 = int(sys.argv[3])
	v4 = int(sys.argv[4])
	v5 = int(sys.argv[5])
	sum = int(sys.argv[6])
	newList = [v1, v2, v3, v4, v5]
	
	# Run the sortedHasSum routine on the list and sum
	print "List: " + str(newList)
	print "Target sum: " + str(sum)
	print "Result: " + str(sortedHasSum(newList, sum))
else:
	# Fix some data for the sortedHasSum routine
	newList = [1, 1, 5, 7, 14, 15, 100]
	sum = 16

	# Run the sortedHasSum routine on the list and sum
	print "List: " + str(newList)
	print "Target sum: " + str(sum)
	print "Result: " + str(sortedHasSum(newList, sum))

