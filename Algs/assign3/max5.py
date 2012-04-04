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

""" Run the fibPow function.
	
	If the user enters a valid input, run it on that
	number, else run it with a pre-defined constant.
	"""
if (len(sys.argv) > 1):
	print fibPow(int(sys.argv[1]), 2, 1)[0]
else:
	print fibPow(FIXED_POWER, 2, 1)[0]