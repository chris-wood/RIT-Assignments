import md5
import sys

easyRange = [32,33,36,42,43] + range(48, 58) + range(65, 91) + range(97, 123)
allRange = range(32,127)

hash = "<16 hex pairs here>"
salt = "<salt>"

def checkPassword(password):
    m = md5.new(password)
    m = md5.new(m.hexdigest() + salt)
    if (m.hexdigest() == hash):
        print "match [" + password + "]"
        sys.exit()

def recurse(width, position, baseString):
    #current position
    for char in easyRange:
        if (position < width - 1):
            recurse(width, position + 1, baseString + "%c" % char)
        checkPassword(baseString + "%c" % char)

print "Target Hash [" + hash + "] Salt [" + salt + "]"
maxChars = 13
for baseWidth in range(1, maxChars + 1):
    print "checking passwords width [" + `baseWidth` + "]"
    recurse(baseWidth, 0, "")

if (__init__ == '__main__'):
    print("Hello.")    