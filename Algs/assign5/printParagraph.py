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

def numLineEndSpaces(S, i, j, n, M):
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
	for i in range(0, n):
		spaces.append(list())
		for j in range(0, n):
			spaces[i].append(0)
	
	# TODO
	for i in range(0, n - 1): # was n-1
		spaces[i][i] = M - len(S[i])
	spaces[0][n - 1] = 0

	# TODO
	for l in range(1, n):
		for i in range(0, n - l):
			j = i + l
			numSpaces = numLineEndSpaces(S, i, j, n, M)
		
			# Check to see if a split is even necessary 
			if (numSpaces >= 0):
				spaces[i][j] = numSpaces
			else:
				spaces[i][j] = sys.maxint

			# Perform decision (do we even need to split?)
			maxVal = sys.maxint
			for k in range(i, j):
				val = max(spaces[i][k], spaces[k+1][j])
				
				# If we found a new minimum in the partition, set the 
				# spaces table entry and log the split index for 
				# printing the paragraph based on the neatness criterion
				if (val < maxVal):
					maxVal = val
		
			# If the subproblem maximum is less than this one then set it
			if (maxVal < spaces[i][j]):
				spaces[i][j] = maxVal

	return spaces[0][n - 1]

def mineLineSpacesFast(S, M):
	n = len(S)
	
	# TODO
	spaces = list()
	indices = list()
	
	# TODO
	for i in range(0, n + 1): 
		spaces.append(0)
		indices.append(0)

	# Base case (the last line)
	spaces[0] = 0

	for j in range(1, n + 1):
		spaces[j] = sys.maxint
		for i in range(1, j + 1): # we go up to j
			numSpaces = numLineEndSpaces(S, i - 1, j - 1, n - 1, M)
			newMax = max(numSpaces, spaces[i - 1])
			if (numSpaces > -1 and newMax < spaces[j]):
				spaces[j] = newMax
				indices[j] = i
		
	return (spaces[n], indices)

def formatWords(S, indices, n, M):
	start = indices[n]
	end = n
	maxLine = 0
	if (start != 1):
		result = formatWords(S, indices, start - 1, M)
		val = printLine(S, start, end, M)
		maxLine = max(result, val)
	else:
		maxLine = printLine(S, start, end, M)
	return maxLine

def printLine(S, i, j, M):
	index = i - 1
	for index in range(i - 1, j):
		print S[index],
	print ""
	return numLineEndSpaces(S, i - 1, j - 1, len(S) - 1, M)

# TODO
def printParagraph(S, M):
	""" TODO: describe
	"""
	# Minimize the maximum number of extra spaces on any one line
	result = mineLineSpacesFast(S, M)
	print "\nFormatted paragraph (minimum extra space = " + str(result[0]) + "\n"
	
	# Display the resulting formatted paragraph based on this optimal result
	formatWords(S, result[1], len(S), M)
	

""" Run the printParagraph function.
	
	If the user enters a valid set of numbers, run it on that
	set, else run the program with some fixed numbers.
"""
if (len(sys.argv) > 2):
	words = list()
	lineSize = int(sys.argv[1])
	for i in range(2, len(sys.argv)):
		words.append(sys.argv[i])
	printParagraph(words, lineSize)
	minLineSpaces(words, lineSize)

else:
	# Run the printParagraph routine with some random data
	S = ["hsssso", "lwod", "by", "caw"]
	M = 10
	printParagraph(S, M)
	minLineSpaces(S, M)

