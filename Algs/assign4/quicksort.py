##########################################################################
#
# File: quicksort.py
# Author: Christopher Wood
# Description: Solution to project assignment 4-3.
#
##########################################################################

# For command line arguments
import sys

##########################################################################
#
# 4-3: Tail recursion was implemented by making the observation that
# only one 'recursive' call is needed after each partition of the target
# array. Therefore, by continuing this recursive call and placing the 
# other partition on a stack, we make use of tail-recursion by only 
# sorting both partitions of the target array once the other complete
# half has been finished.
#
##########################################################################

def partition(A, p, r):
	""" This function partitions the elements in the array A
		that are bounded by p and r. It runs in O(n) time because
		it only requires a single traversal through the range
		of elements provided in order to perform the partition.
	"""
	# Initialize the loop constructs
	x = A[r]
	i = p - 1
	j = p
	
	# Run the fast cut through the entire range, swapping
	# elements when found to be less than the pivot
	while (j != r):
		if (A[j] <= x):
			i = i + 1
			temp = A[i]
			A[i] = A[j]
			A[j] = temp
		j = j + 1

	# Perform the final swap and return the resulting pivot index
	i = i + 1
	temp = A[i]
	A[i] = A[r]
	A[r] = temp
	return i

def qsort(A, p, r):
	""" This is a non-recursive, stack-based implementation of quick-
		sort that makes use of tail-recursion to limit the size of 
		the stack of storage space for each call to O(log(n)).
	"""
	# Create a stack to hold all partition ranges for sorting
	stack = list()
	
	# Insert dummy value into the bottom of the stack to make the
	# iteration bottom out and return (no infinite loops)
	bottom = (0, -1)
	stack.append(bottom)
	
	# Loop while the stack is not empty (we haven't exhausted each singleton)
	while (len(stack) != 0):
		
		# Continue the sorting of the smaller branches
		while (p < r):
			# Continue splitting the smaller partition and place the larger
			# one on the stack - this limits the size of the stack to O(log(n)).
			q = partition(A, p, r)
			if (q - p + 1 < r - q):
				pair = (q + 1, r)
				stack.append(pair)
				r = q - 1
			else:
				pair = (p, q - 1)
				stack.append(pair)
				p = q + 1
				
		# Retrieve the next boundary pair to process 
		newBound = stack.pop(len(stack) - 1)
		p = newBound[0]
		r = newBound[1]
	
	return A

""" Run the quicksort function.
	
	If the user enters a valid set of numbers, run it on that
	set, else run the program with some fixed numbers.
"""
if (len(sys.argv) == 7):
	v1 = int(sys.argv[1])
	v2 = int(sys.argv[2])
	v3 = int(sys.argv[3])
	v4 = int(sys.argv[4])
	v5 = int(sys.argv[5])
	v6 = int(sys.argv[6])
	newList = [v1, v2, v3, v4, v5, v6]
	print "Unsorted: " + str(newList)
	print "Sorted: " + str(qsort(newList, 0, 5))
else:
	# Run the quicksort routine with some random data
	newList = [1, 2, 5, 3, 1]
	print "Unsorted: " + str(newList)
	print "Sorted: " + str(qsort(newList, 0, 4))

