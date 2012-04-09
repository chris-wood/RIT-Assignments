##########################################################################
#
# File: max5.py
# Author: Christopher Wood
# Description: Solution to project assignment 3-5.
#
##########################################################################

# For command line arguments
import sys

##########################################################################
#
# This implementation of max5 was written to use zero (0) comparisons.
# As proof, we introduce the following mathematical relation between 
# two numbers a and b:
#
# max(a,b) = ((a+b)/2) + abs((a-b)/2)
#
# Therefore, since addition, subtraction, division, and absolute value
# do not require any comparisons, the entire max5 routine doesn't either,
# since it iteratively applies this operation among all elements in the 
# set of 5 numbers to determine the maximum.
#
##########################################################################

# This is the fixed upper bound used for autonomous testing
# of the fibPow function.
FIXED_POWER = 31

def max5(x1, x2, x3, x4, x5):
	""" Compute the maximum of five numbers without any comparisons.
		
		The implementation of this function is based on the following
		relation:
		
		max(a,b) = ((a+b)/2) + abs((a-b)/2)
		
		Thus, the function simply compounds the maximum value across 
		all of the inputs and returns the result without ever using 
		a single comparison.
	"""
	max1 = (x1 + x2 + abs(x1 - x2)) / 2
	max2 = (max1 + x3 + abs(max1 - x3)) / 2
	max3 = (max2 + x4 + abs(max2 - x4)) / 2
	max4 = (max3 + x5 + abs(max3 - x5)) / 2
	return max4

""" Run the max5 function.
	
	If the user enters a valid set of numbers, run it on that
	set, else run the program with some random numbers.
"""
if (len(sys.argv) == 6):
	x1 = int(sys.argv[1])
	x2 = int(sys.argv[2])
	x3 = int(sys.argv[3])
	x4 = int(sys.argv[4])
	x5 = int(sys.argv[5])
	print max5(x1, x2, x3, x4, x5)
else:
	# Run the max5 routine with some random data
	print max5(-102, 203.54321, -238, 555, 555.001)