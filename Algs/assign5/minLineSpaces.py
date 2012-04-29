##########################################################################
#
# File: printParagraph.py
# Author: Christopher Wood
# Description: Solution to project assignment 5-3.
#
##########################################################################

# For command line arguments and maximum integer
import sys

##########################################################################
#
# 5-3: TODO
#
##########################################################################

def printSpaces(matrix, n):
	print "Matrix:"
	for i in range(0, n):
		for j in range(0, n):
			print str(matrix[i][j]) + " ",
		print ""
	print ""

def minSpaces(S, M):
	""" TODO
	"""
	n = len(S)
	
	# Initialize the table that we will use in the bottom-up
	# calculation of the minimum number of spaces
	spaces = list()
	inserts = list()
	for i in range(0, n):
		spaces.append(list())
		inserts.append(list())
		for j in range(0, n):
			spaces[i].append(0)
			inserts[i].append(0)

	# Initialize the base case, which is when we are dealing with single
	# words - the number of spaces is equal to M - len(word) (except in base case)
	for i in range(0, n): #	TODO: should this base case actually happen? 8 111 111 1111 11
		spaces[i][i] = M - len(S[i])
	#spaces[n-1][n-1] = 0

	# Perform a preprocessing step where we check to see if 
	# we even need to break up the set of words at all
	sum = 0
	for index in range(0, n):
		sum = sum + len(S[index])
	numSpaces = M - sum
	if (numSpaces > 0):
		return 0

	# Traverse over all other subsequences of words with length >= 2
	for l in range(1, n):
		for i in range(0, n - l):
			j = i + l
			
			# Check to see if this subsequence needs to be broken up
			# into two lines because it cannot fit on one
			sum = 0
			for index in range(i, j + 1):
				sum = sum + len(S[index])
			numSpaces = M - sum
			if (numSpaces > 0):
				spaces[i][j] = numSpaces - j + i
			else:
				spaces[i][j] = sys.maxint
					
			# Perform the champion algorithm for the split to find the
			# smallest subsequence pair that will work
			kIndex = 0
			for k in range(i, j):
				maxVal = spaces[i][k] + spaces[k+1][j]
				
				# If we found a new minimum in the partition, set the 
				# spaces table entry and log the split index for 
				# printing the paragraph based on the neatness criterion
				if (maxVal < spaces[i][j]):
					spaces[i][j] = maxVal
					kIndex = k
			print "optimal split with i,j,k = " + str(i) + "," + str(j) + "," + str(k)

	print inserts
	print spaces
	return spaces[0][n - 1]

# TODO
def printParagraph(S, M):
	""" TODO: describe
	"""
	

""" Run the printParagraph function.
	
	If the user enters a valid set of numbers, run it on that
	set, else run the program with some fixed numbers.
"""
if (len(sys.argv) > 2):
	words = list()
	lineSize = int(sys.argv[1])
	for i in range(2, len(sys.argv)):
		words.append(sys.argv[i])
	print "Minimum extra spaces: " + str(minSpaces(words, lineSize))
	
else:
	# Run the printParagraph routine with some random data
	print "Minimum extra spaces: " + str(minSpaces(["1", "def", "geh"], 6))

