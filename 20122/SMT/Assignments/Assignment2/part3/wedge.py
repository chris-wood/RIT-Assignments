################################################################
#
# File: wedge.py
# Author: Christopher A. Wood, caw4567@rit.edu
# Version: 12/4/12
#
################################################################

# Used libraries
import md5
import sys

easyRange = [32,33,36,42,43] + range(48, 58) + range(65, 91) + range(97, 123)
allRange = range(32,127)

hash = "<16 hex pairs here>"
salt = "<salt>"

# Wedge parameters
hashFile = ""
targetUser = ""
hashFormat = ""

# The hard-coded dictionary (that can be changed)

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

def print_banner():
    ''' Simply print the banner for Wedge.
    '''
    print("Wedge - password cracker by Christopher A. Wood (caw4567@cs.rit.edu)")
    print("Version: 0.1, 12/4/12")
    print("Homepage: www.christopher-wood.com")
    print("")

def print_usage():
    ''' Simply print the usage message for Wedge.
    '''
    print("Usage: python wedge.py file [OPTIONS]")
    print("  -f=FORMAT - the format to use for obfuscation (crypt/md5 supported)")
    print("  -u=USER - the user to target in the password file")
    print("  -d=DICT - the wordlist/dictionary to use in the dictionary attack")

#TODO: split into print_banner and print_usage...

def parse_commandline_string(param):
    if ("-f=" in param):
        hashFormat = param[3:]
    elif ("-u=" in param):
        targetUser = param[3:]
    else:
        raise Exception("Invalid command-line option: " + str(param))

def main():
    ''' The main method to parse command-line arguments and start the password cracking logic
    '''
    args = sys.argv

    # Banner...
    print_banner()

    try:
        # Check the command-line arguments
        print("Checking command line arguments...")
        if (len(args) == 2):
            hashFile = args[1]
        elif (len(args) == 3):
            hashFile = args[1]
            parse_commandline_string(args[2])
        elif (len(args) == 4):
            hashFile = args[1]
            parse_commandline_string(args[2])
            parse_commandline_string(args[3])
        else:
            raise Exception("Invalid number of command-line parameters")
    except Exception as e:
        print("ERROR: " + str(e))
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