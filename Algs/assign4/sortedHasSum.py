##########################################################################
#
# File: sortedHasSum.py
# Author: Christopher Wood
# Description: Solution to project assignment 4-2a.
#
##########################################################################

# For command line arguments
import sys

##########################################################################
#
# 4-2a: This algorithm relies on the sorted nature of the sequence S to 
# check for a pair of numbers by traversing from both endpoints of the 
# sequence (front and back) towards the middle. At each iteration, the 
# algorithm checks the pair of numbers at the front and back positions to 
# see if they sum to the target value and, if not, advances the front 
# pointer if the sum is less than the target or decrements the back pointer 
# if the sum is more than the target. Since the algorithm only traverses 
# through the list at most once before it terminates, the know the resulting 
# time complexity must be O(n).
#
##########################################################################

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
	sum = 101

	# Run the sortedHasSum routine on the list and sum
	print "List: " + str(newList)
	print "Target sum: " + str(sum)
	print "Result: " + str(sortedHasSum(newList, sum))

