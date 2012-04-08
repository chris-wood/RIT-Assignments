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
# TODO: answers to questions here
#
##########################################################################

# This is the fixed upper bound used for autonomous testing
# of the fibPow function.
FIXED_POWER = 31

def max5(x1, x2, x3, x4, x5):
	max1 = ((x1 + x2) / 2) + abs((x1 - x2) / 2)
	max2 = ((max1 + x3) / 2) + abs((max1 - x3) / 2)
	max3 = ((max2 + x4) / 2) + abs((max2 - x4) / 2)
	max4 = ((max3 + x5) / 2) + abs((max3 - x5) / 2)
	return max4

""" Run the fibPow function.
	
	If the user enters a valid input, run it on that
	number, else run it with a pre-defined constant.
	"""
if (len(sys.argv) > 1):
	print fibPow(int(sys.argv[1]), 2, 1)[0]
else:
	print fibPow(FIXED_POWER, 2, 1)[0]