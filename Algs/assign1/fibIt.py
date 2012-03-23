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

'''
This is the fibIt routine that computes the value of
	the recurrence relation defined in the first
	homework assignment.
'''
def fibIt(n, a, b):
	if (n == 0):
		return a
	elif (n == 1):
		return b
	else:
		return fibIt(n - 1, b, a + b)

'''
	This is the main routine that reads in the command
	line arguments to run the fib function.
'''
if (len(sys.argv) > 1):
	print str(fibIt(int(sys.argv[1]), 0, 1))
else:
	print str(fibIt(UPPER_BOUND, 0, 1))