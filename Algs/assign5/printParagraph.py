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
# 5-3: TODO - take from discussion in paper copy
#
##########################################################################

def numLineEndSpaces(S, i, j, n, M):
	""" Compute the number of additional line spaces at the end
		of the line of words indexed from i to j, using the line
		width as M. We assume that all lines that cannot fit on
		a single line (i.e. those that return a negative number
		of additional spaces) simply return -1, and that any line
		ending with the last word receives no additional spaces.
	"""
	# Compute the number of additional spaces at the end of this line
	sum = 0
	for index in range(i, j + 1):
		sum = sum + len(S[index])
	num = M - j + i - sum

	# Determine which value to return
	if (num < 0):
		return -1
	elif (j == n):
		return 0
	else:
		return num

def minLineSpaces(S, M):
	""" Utilize the dynamic programming algorithm described above to
		determine the minimum number of maximum spaces at the end
		of any line, while at the same time recording the line
		positions (newline characters) that were found to yield
		the optimal result.
	"""
	n = len(S)
	
	# Create the DP table and newline index container
	spaces = list()
	indices = list()
	
	# Initialize the tables (we go to n+1 because we treat the base
	# case n = 0 special)
	for i in range(0, n + 1): 
		spaces.append(0)
		indices.append(0)

	# Base case: assume that we have no maximal number of spaces
	# when there are no words yet added to any lines.
	spaces[0] = 0

	# Iteratively start adding words to the lines and re-calculating the
	# maximum number of spaces at each step, varying the newline positions 
	# accordingly so as to always yield a minimum number after the addition
	# of every word.
	for j in range(1, n + 1):
		
		# Infinity - special marker.
		spaces[j] = sys.maxint
		
		# Try all possible line combinations less than the current word index
		# in order to find the optimal value, relying on previously computed 
		# values.
		for i in range(1, j + 1): # So we go up to j
			
			# Compute the number of spaces for this new line (i and j are 
			# offset by 1).
			numSpaces = numLineEndSpaces(S, i - 1, j - 1, n - 1, M)
			
			# Determine which line (the previous or current one) yields
			# the maximum line spaces after appending the word.
			newMax = max(numSpaces, spaces[i - 1])
			
			# Check to see if we reached a new maximum, and if so set
			# the value and update the newline character appropriately.
			if (numSpaces > -1 and newMax < spaces[j]):
				spaces[j] = newMax
				indices[j] = i
		
	# Return the minimum number of maximal spaces and the index locations
	# that can be used to re-build this optimal value.
	return (spaces[n], indices)

def formatWords(S, indices, n, M):
	""" Format the words using the newline index locations according by recursively
		backtracking and printing words indices[n] through n on one line, and then
		words indices[indices[n] - 1] through indices[n] - 1 on the previous line,
		and so on and so forth.
	"""
	start = indices[n]
	end = n
	maxLine = 0
	
	# Check to see if we've reached the start of the words, in which case
	# we stop the recursion and start printing the lines.
	if (start == 1):
		maxLine = printLine(S, start, end, M)
	else:
		result = formatWords(S, indices, start - 1, M)
		val = printLine(S, start, end, M)
		maxLine = max(result, val)

	# Return the maximum number of line spaces seen so far (this is 
	# done as a test against the result of the DP algorithm) 
	return maxLine

def printLine(S, i, j, M):
	""" Print the words from index i through j on a single line.
		Then, return the number of spaces at the end of this line.
	"""
	index = i - 1
	for index in range(i - 1, j):
		print S[index],
	print ""
	
	# Compute and return the extra spaces.
	return numLineEndSpaces(S, i - 1, j - 1, len(S) - 1, M)

def printParagraph(S, M):
	""" Print the paragraph by first minimizing the maximum number
		of extra spaces over all lines of any one line (while recording
		the location of newline characters during this optimal computation),
		and then actually displaying the resulting formatted paragraph.
	"""
	# Minimize the maximum number of extra spaces on any one line
	result = minLineSpaces(S, M)
	print "\nFormatted paragraph (minimum extra space = " + str(result[0]) + ")\n"
	
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
	S = ["testing", "123", "12", "1234"]
	M = 10
	printParagraph(S, M)
	minLineSpaces(S, M)

