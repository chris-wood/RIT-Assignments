Author: Christopher Wood
Language: Java

Compile Instructions:
javac Birch.java BirchCommandString.java BirchElement.java BirchInteger.java

   or

javac *.java

Execute Instructions:
java Birch prog01.bir

Design Notes:
My design is driven by a variation of the interpreter pattern with help by the 
command pattern. The main class, Birch, is responsible for managing the data stack
and main executing command sequence, parsing Birch command sequences from files, 
and running the "interpret" loop. Both data structures in the Birch class are composed
of BirchElement objects (either BirchInteger or BirchCommandString objects), which
allows additional types (such as BirchVariable) to be defined and stored as well.

Each BirchElement implements an evaluate() method that either returns its internal value
(which is expected to be a BigInteger) or executes some operation (such as 'add' or 'sub').
By using all BirchElements through this interface, we separate the program interpretation
from the command logic, which is encapsulated inside the BirchCommandString class. 

Adding new operations is also straightforward. It only requires a command enumerator to
be defined in Birch, which is then added to the command translation map (string name -> enum),
and then implementing a handler within the BirchCommandString class. This makes the
interpreter fairly extensible in terms of modifications to the Birch language. 

Furthermore, runtime errors are handled by Java's built-in exception handling framework.
The evaluate() method has the possibility to throw an exception whenever an error occurs,
which is propagated up the main method and handled appropriately, thus halting executing without
any further interpretation (as any interpreter would do). 