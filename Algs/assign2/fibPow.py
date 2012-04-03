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
# The answers to these questions are discussed in more detail in the
# homework assignment handed in with this code. It seemed easier to
# represent all of the math using TeX markup instead of regular text.
#
# Answer 4a: L is represented as the 2x2 and 2x1 matrix product:
#            
#            L(a) = (0 1)(a) = (  b  )
#             (b)   (1 1)(b)   (a + b)
#
# Answer 4b: The method of repeated squaring was implemented
#            to raise objects of type L to the nth power in 
#            O(logn) (Theta) time. The corresponding function to perform
#            this operation is 'power'.
#
# Answer 4c: fibPow is implemented using the definition for 
#            L and the power function, as described.
#
# Answer 4d: Since the product of any two matrices is a constant
#            time operation running in O(1) (Theta) time, and we are using 
#            a fast exponentiation algorithm (the method of repeated
#            squaring) that performs in O(logn) (Theta) time, we can 
#            conclude that fibPow runs in O(logn) (Theta) time.
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
		
			L(a) = (0 1)(a) = (  b  )
			 (b)   (1 1)(b)   (a + b)
		
			L^n(a) = (0 1)^n(a) = ( f(n;a,b) )
			   (b)   (1 1)  (b)   (f(n+1;a,b))
	"""
	
	# The instance variables for the L object, consisting of the 
	# pair of elements a and b and the product matrix m.
	# The matrix is represented as a flat array/tuple.
	a = 0            # default to 0
	b = 0            # default to 0
	m = (1, 0, 0, 1) # default to identity matrix
	
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
		# Perform the constant time matrix multiplication (L1 * L2)
		#
		# Note: for-loops (or other iterative constructs) were not
		# used to compute this product because the matrix size
		# will always be fixed to 2x2 for objects of type L, so I 
		# unrolled the loop into four separate arithmetic operations.
		v1 = (self.m[0] * other.m[0]) + (self.m[1] * other.m[2])
		v2 = (self.m[0] * other.m[1]) + (self.m[1] * other.m[3])
		v3 = (self.m[2] * other.m[0]) + (self.m[3] * other.m[2])
		v4 = (self.m[2] * other.m[1]) + (self.m[3] * other.m[3])
		
		# Return a new L object that represents the result 
		return L(self.a, self.b, v1, v2, v3, v4)
	
	# Evaluate the L object to compute and return the resulting 
	# (a,b) tuple based on the product matrix.
	def evaluate(self):
		v1 = (self.m[0] * self.a) + (self.m[1] * self.b)
		v2 = (self.m[2] * self.a) + (self.m[3] * self.b)
		return (v1, v2)

def powerOne(base, p):
	""" Raise the object 'base' to the power p
		
		This function implements the method of repeated
		squaring using a recursive approach to perform 
		exponentiation in O(logn) time.
	"""
	if (p == 0):
		return L(base.a, base.b, 1, 0, 0, 1) # Identity 
	elif (p == 1):
		return base
	elif ((p % 2) == 0):
		return powerTwo(base * base, p / 2)
	else:
		return base * powerTwo(base * base, (p - 1) / 2)

def powerTwo(base, p):
	""" Raise the object 'base' to the power p
		
		This function implements the method of repeated
		squaring using an iterative based approach 
		to perform exponentiation in O(logn) time.
	"""
	# Initialize the product to the identity
	result = L(base.a, base.b, 1, 0, 0, 1)
	
	# Loop while the power is non-zero
	while (p != 0):
		
		# If the power is odd, multiply by the base 
		if ((p % 2) != 0):
			result = result * base
			p = p - 1
		
		# Square the base object and then cut the power in half 
		base = base * base
		p = p / 2

	# Return the resulting object 
	return result

def fibPow(n, a, b):
	""" Implement L^{n}(a,b), which requires three parameters
		for n, a, and b.
		
		This function utilizes the method of repeated
		squaring to raise an object of type L to the
		nth power and then return the first pair
		in L's evaluated tuple.
	"""
	base = L(a, b, 0, 1, 1, 1)
	return powerOne(base, n)

# This is the fixed upper bound used for autonomous testing
# of the fibPow function.
FIXED_POWER = 31

""" Run the fibPow function.
	
	If the user enters a valid input, run it on that
	number, else run it with a pre-defined constant.
"""
if (len(sys.argv) > 1):
	print fibPow(int(sys.argv[1]), 0, 1).evaluate()[0]
else:
	print fibPow(FIXED_POWER, 0, 1).evaluate()[0]