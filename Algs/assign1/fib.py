###################################################
#
# File: fib.py
# Author: Christopher Wood
# Description: Solution to project assignment 1-3.
#
###################################################

# For command line arguments
import sys

# Fixed fib value for when cmd line arguments are not provided
UPPER_BOUND = 32

'''
This is the fib routine that computes the nth Fibonacci
	number using the recurrence relation defined in the 
	homework assignment.
'''
def fib(n):
	if (n == 0):
		return 0
	elif (n == 1):
		return 1
	else:
		return (fib(n - 1) + fib(n - 2))

'''
This is the main routine that reads in the command
	line arguments to run the fib function.
'''
if (len(sys.argv) > 1):
	print str(fib(int(sys.argv[1])))
else:
	print str(fib(UPPER_BOUND))