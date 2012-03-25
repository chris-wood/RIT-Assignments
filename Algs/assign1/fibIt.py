###################################################
#
# File: fibIt.py
# Author: Christopher Wood
# Description: Solution to project assignment 1-5.
#
###################################################

# For command line arguments
import sys

# Fixed fib value for when cmd line arguments are not provided
UPPER_BOUND = 32

def fibIt(n, a, b):
	""" Compute the nth value of the recurrence relation, f.
		
		This implementation follows the recurrence relation
		described in the homework assignment exactly.
	"""
	if (n == 0):
		return a
	elif (n == 1):
		return b
	else:
		return fibIt(n - 1, b, a + b)

""" Run the fibIt function.
	
	If the user enters a valid input, run it on that
	number, else run it with a pre-defined constant.
"""
if (len(sys.argv) > 1):
	print str(fibIt(int(sys.argv[1]), 0, 1))
else:
	print str(fibIt(UPPER_BOUND, 0, 1))