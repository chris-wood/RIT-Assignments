##########################################################################
#
# File: hasSum.py
# Author: Christopher Wood
# Description: Solution to project assignment 4-2b.
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

def split(S)
	if (len(S) == 0):
		return ([], [])
	elif (len(S) == 1):
		return ([S[0]], [])
	else:
		splitA = list()
		splitB = list()
		index = 0
		for x in S:
			if (index % 2 == 0):
				splitA.append(S[x])
			else:
				splitB.append(S[x])
		return (split(splitA), split(splitB))
			
def merge(A, B):
	# copy code from textbook for merge sort!

def msort(S):
	print "do something!"

def hasSum(S, x):
	# Sort the data to start using Merge Sort (O(nlogn))
	msort(S)

	# Now run the sortedHasSum routine on S with target sum x
	return sortedHasSum(S, x)

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
if (len(sys.argv) == 6):
	print "TODO"
else:
	# Fix some data for the sortedHasSum routine
	newList = [1, 1, 5, 7, 14, 15, 100]
	sum = 16

	# Run the sortedHasSum routine on the list and sum
	print "List: " + str(newList)
	print "Target sum: " + str(sum)
	print "Result: " + str(sortedHasSum(newList, sum))

