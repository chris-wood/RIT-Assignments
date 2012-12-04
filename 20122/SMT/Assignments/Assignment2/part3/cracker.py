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
    # current position
    for char in easyRange:
        if (position < width - 1):
            recurse(width, position + 1, baseString + "%c" % char)
        checkPassword(baseString + "%c" % char)

def print_usage():
    ''' Simply print the usage message and banner for Wedge.
    '''
    print("Wedge - password cracker by Christopher A. Wood (caw4567@cs.rit.edu)")
    print("Version: 0.1, 12/4/12")
    print("Homepage: www.christopher-wood.com")
    print("")
    print("Usage: python wedge.py file [OPTIONS]")
    print("  -f=FORMAT - the format to use for obfuscation (crypt/md5 supported)")
    print("  -u=USER - the user to target in the password file")

def main():
    ''' The main method to parse command-line arguments and start the password cracking logic
    '''
    args = sys.argv
    hashFile = ""
    targetUser = ""
    format = ""

    # TODO: make private method to parse a string read in from the command-line

    # Check the command-line arguments
    if (len(args) == 2):
        hashFile = args[1]
    elif (len(args) == 3):
        hashFile = args[1]
        if ("-f=" in args[2]):
            format = args[2][3:]
        elif ("-h=" in args[2]):
            targetUser = args[2][3:]
    elif (len(args) == 4):
        if ("-f=" in args[2]):
            format = args[2][3:]
        elif ("-h=" in args[2]):
            targetUser = args[2][3:]
    else:
        print_usage()


# Wedge our way in...
if (__name__ == '__main__'):
    main()
    '''
    print "Target Hash [" + hash + "] Salt [" + salt + "]"
    maxChars = 13
    for baseWidth in range(1, maxChars + 1):
        print "checking passwords width [" + `baseWidth` + "]"
        recurse(baseWidth, 0, "")
    '''