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
# 5-3: TODO - discuss the paragraph thing
#
##########################################################################

def printMatrix(matrix, n):
	print "Matrix:"
	for i in range(0, n):
		for j in range(0, n):
			print str(matrix[i][j]) + " ",
		print ""
	print ""

def numLneEndSpaces(S, i, j, n, M):
	sum = 0
	for index in range(i, j + 1):
		sum = sum + len(S[index])
	num = M - j + i - sum

	# Treat the negative case special (since it is an
	# indication that we can't fit these words on one line)
	if (num < 0):
		return -1
	elif (j == n):
		return 0
	else:
		return num

def printSequence(S, i, j):
	print "Words from " + str(i) + "," + str(j) + ":",
	for index in range(j, j + 1):
		print S[index],
	print ""

def minLineSpaces(S, M):
	""" TODO
	"""
	n = len(S)
	
	# TODO
	spaces = list()
	indices = list()
	for i in range(0, n):
		spaces.append(list())
		indices.append(list())
		for j in range(0, n):
			spaces[i].append(0)
			indices[i].append(0)
	
	# TODO
	for i in range(0, n - 1): # was n-1
		spaces[i][i] = M - len(S[i])
	spaces[0][n - 1] = 0

	# TODO
	for l in range(1, n):
		for i in range(0, n - l):
			j = i + l
			numSpaces = numLneEndSpaces(S, i, j, n, M)
		
			# Check to see if a split is even necessary 
			if (numSpaces >= 0):
				spaces[i][j] = numSpaces
			else:
				spaces[i][j] = sys.maxint

			# Perform decision (do we even need to split?)
			maxVal = sys.maxint
			minIndex = -1
			for k in range(i, j):
				val = max(spaces[i][k], spaces[k+1][j])
				
				# If we found a new minimum in the partition, set the 
				# spaces table entry and log the split index for 
				# printing the paragraph based on the neatness criterion
				if (val < maxVal):
					maxVal = val
					minIndex = k
		
			# If the subproblem maximum is less than this one then set it
			if (maxVal < spaces[i][j]):
				spaces[i][j] = maxVal
				print str(i) + "," + str(j) + " - " + str(minIndex)
				indices[i][j] = (i + minIndex)
			else:
				indices[i][j] = -1

	printMatrix(indices, n)
	return spaces[0][n - 1]

def mineLineSpaces2(S, M):
	n = len(S)
	
	# TODO
	spaces = list()
	indices = list()
	
	# TODO
	for i in range(0, n + 1): 
		spaces.append(0)
		indices.append(0)

	# TODO

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
	print "Minimum max line spaces: " + str(minLineSpaces(words, lineSize))

else:
	# Run the printParagraph routine with some random data
	print "Minimum max line spaces: " + str(minLineSpaces(["hello", "world", "by", "caw"], 10))

