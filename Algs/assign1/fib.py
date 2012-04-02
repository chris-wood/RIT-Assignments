###################################################
#
# File: fib.py
# Author: Christopher Wood
# Description: Solution to project assignment 1-3.
#
###################################################

# For command line arguments
import sys

# Question 1-3: What is the smallest n such that you notice fib
# running slowly?
#
# Answer: The smallest n that appears to make fib run slowly 
# is n = 31.
UPPER_BOUND = 4

def fib(n):
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
