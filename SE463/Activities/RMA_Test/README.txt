Advanced Schedulability Test 
Christopher Wood, caw4567@rit.edu
---------------------------------
Build instructions:
  The archive comes with an existing Makefile that can be
used to compile an executable version of the program on
*nix machines. Using this Makefile, the command to build 
the program is simply:

    make all

Program execution:
  In order to run the program once it has been compiled
into an executable, one may simple run the following 
command:

    ./RMATest

This assumes that the user is within the same directory
as the executable RMATest itself. Once the program
is executed, it will prompt the user to enter a 
number of tasks that must be strictly positive.
Runtime assertions are used to verify this number.
After this number is collected, the user is simply asked
to enter task compute and period time tuples (compute, period)
for the appropriate number of tasks, where each value is 
separated by whitespace. Again, runtime assertions are used
to verify that these numbers are strictly positive and that
the compute time is at most equal to the period time for 
each task.


