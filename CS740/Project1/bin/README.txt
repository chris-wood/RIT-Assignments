Christopher Wood
Data Communication and Networks I (4005-740)
Project 1 - README
--------------------------------------------
Part I usage:

  Part I can be compiled by invoking 'javac *.java', since both
  the interface file LogService.java and the implementation file
  LogServer.java need to be compiled.
  
Part II usage:

  Part II can be compiled by invoking 'javac *.java' and then
  running 'java HostLogServer', since the main routine to start
  the log server is located in HostLogServer.java.
  
Output:
 
  All server and client output is sent to stdout, in addition to 
  the server log and debug information that is saved in LogServer.log
  and LogServer.debug, respectively. These files are located in the
  same directory where the HostLogServer.java/class files are found.
  
Testing:

  To test this application I implemented the same client code provided
  by Program.cs. This was used to test against the solution running on 
  viking.cs.rit.edu. To test my server, I ran my own implementation
  on my local machine and used the same, verified client. All of the
  tests passed.
  
  For further experimentation, Jeff Zullo and I cross tested with each 
  other to make sure our socket communication was correct. In other words,
  I tested my client code against his server, and my server against his
  client code. This was done because we used different implementation languages
  and we wanted to make sure we conformed to the protocol exactly correctly.
   