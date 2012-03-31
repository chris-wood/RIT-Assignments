##########################################################################
#
# File: fibPow.py
# Author: Christopher Wood
# Description: Solution to project assignment 2-4.
#
##########################################################################

# For command line arguments
import sys

##########################################################################
# Answer 4a: L is represented as the matrix product:
#            
#            L(a,b) = |0 1||a| = (b, a+b)
#                     |1 1||b|
#
# Answer 4b: The method of repeated squaring was implemented
#            to raise objects of type L to the nth power in 
#            O(logn) time. The corresponding function to perform
#            this operation is 'power'.
#
# Answer 4c: fibPow is implemented using the definition for 
#            L and the power function, as described.
#
# Answer 4d: Since the product of any two matrices is a constant
#            time operation running in O(1) (theta), and we are performing
#            O(logn) (theta) multiplications using the method of repeated
#            squaring for fast exponentiation, we can conclude that
#            fibPow runs in O(logn) (theta) time.
#
##########################################################################
class L(object):
	""" This representation for L consists of a matrix product
		between a vector containing the (a,b) input pair and 
		a simple 2x2 matrix. This relationship is described below.
		
		By mathematical definition: 
		
			L(a,b) = (b, a+b)
			L^n(a,b) = (f(n;a,b),f(n+1;a,b))
		
		By matrix representation: 
		
			L(a,b) = |0 1||a| = (b, a+b)
			         |1 1||b|
		
			L^n(a,b) = (|0 1|)^n|a| = (f(n;a,b), f(n+1;a,b))
			           (|1 1|)  |b|
	"""
	
	# The internal slots for the L object, consisting of the 
	# pair of elements a and b and the product matrix m.
	__slots__ = ['a', 'b', 'm']
	
	# Constructor for L that initializes the (a,b) variables
	# and the product matrix.
	def __init__(self, a, b, v1, v2, v3, v4):
		self.a = a
		self.b = b
		self.m = (v1, v2, v3, v4)
	
	# The overwritten multiplication operation that computes the
	# result of two L objects being multiplied by one another 
	# (meaning that their product matrices are multiplied together
	# to yield a new 2x2 matrix) and returns a new L instance.
	def __mul__(self, other):
		# Perform the constant time matrix multiplication (L * L)
		v1 = (self.m[0] * other.m[0]) + (self.m[1] * other.m[2])
		v2 = (self.m[0] * other.m[1]) + (self.m[1] * other.m[3])
		v3 = (self.m[2] * other.m[0]) + (self.m[3] * other.m[2])
		v4 = (self.m[2] * other.m[1]) + (self.m[3] * other.m[3])
		
		# Return a new L object that represents the result of this mult
		return L(self.a, self.b, v1, v2, v3, v4)
	
	# Evaluate the L object to compute and return the resulting 
	# (a,b) tuple based on the product matrix.
	def evaluate(self):
		v1 = (self.m[0] * self.a) + (self.m[1] * self.b)
		v2 = (self.m[2] * self.a) + (self.m[3] * self.b)
		return (v1, v2)

# The identity matrix used by power in the base case
# where the power value is 0 (i.e. o ^ 0 = I)
IDENTITY = L(0, 0, 1, 0, 0, 1)

def power(o, p):
	""" Raise the object o to the power p
		
		This function implements the method of repeated
		squaring to perform exponentiation in O(logn) time.
	"""
	if (p == 0):
		return IDENTITY
	elif (p == 1):
		return o
	elif ((p % 2) == 0):
		return power(o * o, p / 2)
	else:
		return o * power(o * o, (p - 1) / 2)


def fibPow(n):
	""" Return the nth Fibonacci number.
		
		This function utilizes the method of repeated
		squaring to raise an object of type L to the
		nth power and then return the first pair
		in L's evaluated tuple.
	"""
	o = L(0, 1, 0, 1, 1, 1)
	o = power(o, n)
	return o.evaluate()[0]

# This is the fixed upper bound used for autonomous testing
# of the fibPow function.
FIXED_POWER = 31

""" Run the fibPow function.
	
	If the user enters a valid input, run it on that
	number, else run it with a pre-defined constant.
"""
if (len(sys.argv) > 1):
	print fibPow(int(sys.argv[1]))
else:
	print fibPow(FIXED_POWER)