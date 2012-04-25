##########################################################################
#
# File: hasSum.py
# Author: Christopher Wood
# Description: Solution to project assignment 4-2b.
#
##########################################################################

# For command line arguments
import sys

##########################################################################
#
# 4-2b: This function relies on merge sort (which always runs in 
# O(nlogn) time) to put the sequence S in sorted order and then 
# runs the same sortedHasSum routine again. Since the time complexity of
# sortedHasSum is O(n) and merge sort is O(nlogn), then we know the 
# time complexity T(n) of hasSum(S, x), where n = |S|, is T(n) = 
# O(nlogn) + O(n) = O(nlogn). 
#
##########################################################################
			
def merge(A, B):
	""" Merge together the two sorted sequences A and B
		and return the resulting sequence.
	"""
	# Allocate space for the new list and set up the
	# subsequence indices
	result = []
	i = 0
	j = 0
	
	# Ensure that we traverse over all of A's and B's elements
	while (i < len(A) and j < len(B)):
		if (A[i] <= B[j]):
			result.append(A[i])
			i = i + 1
		else:
			result.append(B[j])
			j = j + 1

	# Append the left overs
	while (i < len(A)):
		result.append(A[i])
		i = i + 1
	while (j < len(B)):
		result.append(B[j])
		j = j + 1
	
	# Return the newly sorted sequence
	return result

def msort(S):
	""" Sort the sequence S by splitting it into two
		separate sequences, calling sort on the two
		sub-sequences, and then merging those sequences
		back together.
	"""
	if (len(S) <= 1):
		return S
	else:
		# These substring operations are guaranteed to run in
		# O(1) time since they are simple array index lookups
		first = msort(S[:len(S)/2])
		second = msort(S[len(S)/2:len(S)])
		return merge(first, second)

def hasSum(S, x):
	""" Sort the sequence S using merge sort to guarantee a
		O(nlogn) time complexity and then perform the O(n)
		sortedHasSum routine that we used in part (a).
	"""
	# Sort the data to start using Merge Sort (O(nlogn))
	print "Unsorted list: " + str(S)
	sortedList = msort(S)
	print "Sorted list: " + str(sortedList)
	print "Target sum: " + str(x)

	# Now run the sortedHasSum routine on S with target sum x
	return sortedHasSum(sortedList, x)

def sortedHasSum(S, x):
	""" This function determines if there is a pair of elements in S
		that sum to x by taking advantage of the sorted nature of S and
		searching from the ends of the sequence towards the middle (in
		one pass) checking each pair of numbers and moving closer to
		termination at every step.
		"""
	# Initialize the start/end indices
	start = 0
	end = len(S) - 1
	
	# Loop until the endpoints reach each other (which will
	# only take one pass through the list)
	while (start < end):
		sum = S[start] + S[end]
		
		# Check to see where the sum would lie in the list
		if (sum < x):
			start = start + 1
		elif (x < sum):
			end = end - 1
		else:
			return True
	
	return False

""" Run the hasSum function.
	
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
	print "Result: " + str(hasSum(newList, sum))
else:
	# Fix some data for the sortedHasSum routine
	newList = [1, 5, 2, 100, 15, 23, 14]
	sum = 29
	
	# Run the sortedHasSum routine on the list and sum
	print "Result: " + str(hasSum(newList, sum))

