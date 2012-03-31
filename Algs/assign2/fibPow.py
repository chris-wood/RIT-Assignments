###################################################
#
# File: fibPow.py
# Author: Christopher Wood
# Description: Solution to project assignment 2-4.
#
###################################################

# For command line arguments
import sys

# TODO: answer questions here
UPPER_BOUND = 31

def fibPow(n):
	""" Return the nth Fibonacci number.
		
		This function follows the recurrence relation
		defined in the homework assignment.
		"""
	if (n == 0):
		return 0
	elif (n == 1):
		return 1
	else:
		return (fib(n - 1) + fib(n - 2))

""" Run the fib function.
	
	If the user enters a valid input, run it on that
	number, else run it with a pre-defined constant.
	"""
if (len(sys.argv) > 1):
	print str(fib(int(sys.argv[1])))
else:
	print str(fib(UPPER_BOUND))