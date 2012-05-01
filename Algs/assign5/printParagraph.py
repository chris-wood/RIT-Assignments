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
# 5-3: The printParagraph procedure is composed of two internal procedure
# calls. Namely, minLineSpaces and formatWords, which are implemented to
# minimize the maximum amount of white space on any one line (excluding the
# last), while recording the optimal newline indices, and then print the 
# resulting paragraph based on these newline positions, respectively. 
# Analyzing the minLineSpaces routine shows that it runs in O(n^2) time,
# due to the fact that it considers all word sequences i through j starting
# from the beginning of S and terminating at the end. This time complexity
# is possible because we pre-compute the number of line endings for the 
# sequence S by realizing that the equation for the number of extra white
# spaces is an arithmetic progression, and we can simply store the compounded
# result of this progression for all i,i+1 pairs of words in O(n) time before
# the main work of the minLineSpaces algorithm starts.
#
# Then, examining the formatWords routine indicates that it runs in O(n)
# time, since it always makes one recursive call (in all cases except when
# the first word is reached) with a index decrement of at least 1 (meaning that
# in the worst case we will have one recursive call per word in S, which results
# in an upper bound of O(n)).
#
# Now, putting the time complexity of these two routines together, we have 
# the time T(n) for printParagraph equal to:
#	O(n) (line space precomputation) + O(n^2) (DP algorithm) + O(n) (format words)
# and we conclude that printParagraph thus runs in O(n^2) time.
#
# Note that this program offers two functions, minLineSpaces and minLineSpacesBack,
# that compute the same minimum number of extra spaces using dynamic programming
# both forwards and backwards.
#
##########################################################################

# Precomputed line spaces
wordSpaces = list()

def numLineEndSpaces(S, i, j, n, M):
	""" Compute the number of additional line spaces at the end
		of the line of words indexed from i to j, using the line
		width as M. We assume that all lines that cannot fit on
		a single line (i.e. those that return a negative number
		of additional spaces) simply return -1, and that any line
		ending with the last word receives no additional spaces.
	"""
	# Compute the number of additional spaces at the end of this line
	num = M - j + i - (wordSpaces[j + 1] - wordSpaces[i])

	# Determine which value to return
	if (num < 0):
		return -1
	elif (j == n):
		return 0
	else:
		return num

def minLineSpacesBack(S, M):
	""" Utilize the dynamic programming algorithm described (but backwards)
		to determine the minimum number of maximum spaces at the end
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
	
	# Pre-compute the line spaces
	wordSpaces.append(0)
	for i in range(1, n + 1):
		wordSpaces.append(wordSpaces[i - 1] + len(S[i - 1]))
	
	# Base case: assume that we have no maximal number of spaces
	# when there are no words yet added to any lines.
	spaces[n] = 0
	
	# Iteratively start adding words to the lines and re-calculating the
	# maximum number of spaces at each step, using the previous optimal
	# value when determining where newline character should be placed.
	i = n - 1
	while i >= 0:
		
		# Infinity - special marker.
		spaces[i] = sys.maxint
		
		# Compare the new line possibilities with past optimal values
		# in search of the new maximum (champion algorithm)
		j = i
		while j < n:
			
			# Compute the number of spaces for this new line (note: i and j 
			# are offset by 1).
			numSpaces = numLineEndSpaces(S, i, j, n - 1, M)
			
			# Determine which line (the previous or current one) yields
			# the maximum line spaces after putting the word i on the 
			# the current line or the next line.
			newMax = max(numSpaces, spaces[j + 1])
			
			# Check to see if we reached a new maximum, and if so set
			# the value and update the newline character appropriately.
			if (numSpaces > -1 and newMax < spaces[i]):
				spaces[i] = newMax
				indices[i] = j
			
			# Increment the back index
			j = j + 1
		
		# Decrement the start index
		i = i - 1
	
	# Return the minimum number of maximal spaces and the index locations
	# that can be used to re-build this optimal value.
	return (spaces[0], indices)

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
	
	# Pre-compute the line spaces
	wordSpaces.append(0)
	for i in range(1, n + 1):
		wordSpaces.append(wordSpaces[i - 1] + len(S[i - 1]))

	# Base case: assume that we have no maximal number of spaces
	# when there are no words yet added to any lines.
	spaces[0] = 0

	# Iteratively start adding words to the lines and re-calculating the
	# maximum number of spaces at each step, using the previous optimal
	# value when determining where newline character should be placed.
	for j in range(1, n + 1):
		
		# Infinity - special marker.
		spaces[j] = sys.maxint
		
		# Compare the new line possibilities with past optimal values
		# in search of the new maximum (champion algorithm)
		for i in range(1, j + 1): # So we go up to j
			
			# Compute the number of spaces for this new line (note: i and j 
			# are offset by 1).
			numSpaces = numLineEndSpaces(S, i - 1, j - 1, n - 1, M)
			
			# Determine which line (the previous or current one) yields
			# the maximum line spaces after putting the word i on the 
			# the current line or the next line.
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

