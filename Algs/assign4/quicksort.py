##########################################################################
#
# File: quicksort.py
# Author: Christopher Wood
# Description: Solution to project assignment 4-3.
#
##########################################################################

# For command line arguments
import sys

# For square root function
from math import sqrt 

##########################################################################
#
# TODO: answer the question here (or provide explanation of O(logn) size of stack
#
##########################################################################

def partition(A, p, r):
	x = A[r]
	i = p - 1
	j = p
	while (j != r):
		if (A[j] <= x):
			i = i + 1
			temp = A[i]
			A[i] = A[j]
			A[j] = temp
		j = j + 1
	i = i + 1
	temp = A[i]
	A[i] = A[r]
	A[r] = A[i]
	return i

def sort(A, p, r):
	if (p < r):
		q = partition(A, p, r)
		sort(A, p, q - 1)
		sort(A, q + 1, r)
	return A	

""" Run the quicksort function.
	
	If the user enters a valid set of numbers, run it on that
	set, else run the program with some random numbers.
"""
if (len(sys.argv) == 6):
	print "TODO"
else:
	# Run the quicksort routine with some random data
	newList = [1, 2, 5, 3, 1]
	print sort(newList, 0, 4)

