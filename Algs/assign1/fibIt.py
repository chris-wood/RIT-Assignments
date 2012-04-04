###################################################
#
# File: fibIt.py
# Author: Christopher Wood
# Description: Solution to project assignment 1-5.
#
###################################################

# For command line arguments
import sys

# Question 1-5: Does fibIt also run slowly on the value of 
# n that you found made fib run slowly?
#
# Answer: No, fibIt does not run slowly on the same value
# of n (31) that made fib run slowly. In fact, I could not
# reach such a slow upper bound without exhausting
# the recursive call stack.
UPPER_BOUND = 31

def fibIt(n, a, b):
	""" Compute the nth value of the recurrence relation, f.
		
		This function follows the recurrence relation
		described in the homework assignment.
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
	print str(fibIt(int(sys.argv[1]), 2, 1))
else:
	print str(fibIt(UPPER_BOUND, 2, 1))