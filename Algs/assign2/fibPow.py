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
#blah blah blah

# TODO: L is an object that represents a matrix product of (0 1 1 1)^n(a b)^T
class L(object):
	__slots__ = ['a', 'b', 'm']
	
	def __init__(self, a, b, v1, v2, v3, v4):
		self.a = a
		self.b = b
		self.m = (v1, v2, v3, v4)
	
	def __mul__(self, other):
		# Perform the constant time matrix multiplication (L * L)
		v1 = (self.m[0] * other.m[0]) + (self.m[1] * other.m[2])
		v2 = (self.m[0] * other.m[1]) + (self.m[1] * other.m[3])
		v3 = (self.m[2] * other.m[0]) + (self.m[3] * other.m[2])
		v4 = (self.m[2] * other.m[1]) + (self.m[3] * other.m[3])
		
		# Return a new L object that represents the result of this mult
		return L(self.a, self.b, v1, v2, v3, v4)
	
	def evaluate(self):
		v1 = (self.m[0] * self.a) + (self.m[1] * self.b)
		v2 = (self.m[2] * self.a) + (self.m[3] * self.b)
		return (v1, v2)

# The identity matrix used by fibPow
IDENTITY = L(0, 0, 1, 0, 0, 1)

def fibPow(o, p):
	""" Return the nth Fibonacci number.
		
		This function follows the recurrence relation
		defined in the homework assignment.
	"""
	if (p == 0):
		return IDENTITY
	elif (p == 1):
		return o
	elif ((p % 2) == 0):
		return fibPow(o * o, p / 2)
	else:
		return o * fibPow(o * o, (p - 1) / 2)

# Blah blah
FIXED_POWER = 31

""" Run the fib function.
	
	If the user enters a valid input, run it on that
	number, else run it with a pre-defined constant.
"""
if (len(sys.argv) > 1):
	print str(fibPow(int(sys.argv[1])))
else:
	# create new instance of L with and and b as 0/1 and then try the fibPow..
	o = L(0, 1, 0, 1, 1, 1)
	print (o * o * o * o * o).evaluate()
	o = fibPow(o, FIXED_POWER)
	print o.evaluate()