/*
 * FTP.java
 *
 * Version: 4/3/12
 */

import java.io.IOException;
import java.net.UnknownHostException;
import java.util.Scanner;
import java.util.NoSuchElementException;

/**
 * The user interface to an RFC959 compliant FTP client.
 * 
 * @author Paul Tymann (ptt@cs.rit.edu)
 * @author Jeremy Brown (jsb@cs.rit.edu)
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class FTP 
{
	/**
	 * The fixed terminal prompt string.
	 */
	private static final String PROMPT = "FTP> ";
	
	/**
	 * The regex string used to split up user commands.
	 */
	private static final String SPLIT_STRING = "\\s+";

	/**
	 * Array of user-friendly available commands supported by 
	 * this client.
	 */
	public static final String USER_COMMANDS[] = 
	{ 
		"ascii", "binary", "cd", "cdup", "debug", "dir", "get", 
		"help", "passive", "put", "pwd", "quit", "user", "pass", "port"
	};
	
	/**
	 * Array of FTP-compliant commands that can be parsed 
	 * and interpreted by the server (used to translate user-
	 * friendly commands to send to the server).
	 */
	public static final String FTP_COMMANDS[] = 
	{
		"A", "I", "CWD", "CDUP", "DEBUG", "LIST", "RETR", 
		"HELP", "PASV", "PUT", "PWD", "QUIT", "USER", "PASS", "PORT"
	};
	
	/**
	 * Array that maintains the length of each command line argument
	 * array (including the command itself) to aid in command validation.
	 */
	public static final int FTP_CMD_LENGTH[] = 
	{
		1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1
	};

	/**
	 * The indices into the command arrays for each supported user command.
	 */
	public static final int ASCII = 0;
	public static final int BINARY = 1;
	public static final int CD = 2;
	public static final int CDUP = 3;
	public static final int DEBUG = 4;
	public static final int DIR = 5;
	public static final int GET = 6;
	public static final int HELP = 7;
	public static final int PASSIVE = 8;
	public static final int PUT = 9;
	public static final int PWD = 10;
	public static final int QUIT = 11;
	public static final int USER = 12;
	public static final int PASSWORD = 13;
	public static final int PORT = 14;
	
	/**
	 * Debug mode flag.
	 */
	private static boolean debugMode = false;

	/**
	 * Array of help messages displayed to the user when requested.
	 */
	public static final String[] HELP_MESSAGE = 
	{
		"ascii      --> Set ASCII transfer type",
		"binary     --> Set binary transfer type",
		"cd <path>  --> Change the remote working directory",
		"cdup       --> Change the remote working directory to the",
		"               parent directory (i.e., cd ..)",
		"debug      --> Toggle debug mode",
		"dir        --> List the contents of the remote directory",
		"get path   --> Get a remote file",
		"help       --> Displays this text",
		"passive    --> Toggle passive/active mode",
		"put path   --> Transfer the specified file to the server",
		"pwd        --> Print the working directory on the server",
		"quit       --> Close the connection to the server and terminate",
		"user login --> Specify the user name (will prompt for password" 
	};
	
	/**
	 * The FTP client that this main class uses.
	 */
	private FTPClient client;
	
	/**
	 * Helper method that handles debug messages (printing to console, 
	 * file, etc).
	 *
	 * @param message - the debug message to handle.
	 */
	public static void debugPrint(String message)
	{
		if (debugMode)
		{
			System.out.println("Debug: " + message);
		}
	}
	
	/**
	 * Helper method that will print all error messages to the 
	 * standard err stream.
	 *  
	 * @param error - the error message
	 */
	public static void errorPrint(String error)
	{
		System.err.println("Error: " + error);
	}
	
	/**
	 * Attempt to establish a control connection with the 
	 * specified server.
	 * 
	 * @param server - the host target server
	 * 
	 * @return true if successful, false otherwise
	 */
	public boolean connect(String server)
	{
		boolean successful = true;
		client = new FTPClient();
		
		try 
		{
			debugPrint("Connecting to: " + server + ".");
			System.out.println(client.connect(server));
			debugPrint("Connection successful.");
		}
		catch (UnknownHostException e) 
		{
			System.err.println("Error: Unknown host: " + e.getMessage());
			successful = false;
		} catch (IOException e) 
		{
			System.err.println("Error: " + e.getMessage());
			successful = false;
		}
		
		return successful;
	}
	
	/**
	 * Read commands and execute commands entered from the keyboard in order
	 * to interact with the FTP server specified.
	 * 
	 * @param server - the host FTP server to connect to.
	 */
	public void processInput()
	{
		Scanner in = new Scanner(System.in);
		boolean eof = false;
		String input = null;
	
		do 
		{
			try 
			{
				// Read in the command
				System.out.print(PROMPT);
				input = in.nextLine();
			} 
			catch (NoSuchElementException e) 
			{
				eof = true;
			}

			// Keep going if we have not hit end of file
			if (!eof && input.length() > 0) 
			{
				// Parse the command and handle it appropriately 
				String argv[] = input.split(SPLIT_STRING);
				int cmd = parseCommand(argv[0]);
				
				try 
				{
					if (cmd != -1 && argv.length == FTP_CMD_LENGTH[cmd])
					{
						switch (cmd) 
						{
						case ASCII:
							client.setTransferType(FTPClient.TransferType.ASCII, 
									FTP_COMMANDS[ASCII]);
							break;
							
						case BINARY:
							client.setTransferType(FTPClient.TransferType.BINARY, 
									FTP_COMMANDS[BINARY]);
							break;
							
						case DIR:
							debugPrint("Requesting current working directory contents.");
							client.sendRequest(FTP_COMMANDS[DIR], null);
							break;
							
						case PASSIVE:
							client.toggleTransferMode();
							break;
							
						case CDUP:
							debugPrint("Changing to parent directory.");
							client.sendCommand(cmd, null);
							break;
							
						case PWD:
							debugPrint("Requesting current working directory.");
							client.sendCommand(cmd, null);
							break;
							
						case CD:
							debugPrint("Requesting to change to directory: " + argv[1]);
							client.sendCommand(cmd, argv[1]);
							break;
	
						case DEBUG:
							if (debugMode)
							{
								debugPrint("Debug mode disabled.");
								debugMode = !debugMode;
							}
							else
							{
								debugMode = !debugMode;
								debugPrint("Debug mode enabled.");
							}
							break;
	
						case GET:
							debugPrint("Requesting to get file: " + argv[1]);
							client.getFile(FTP_COMMANDS[cmd], argv[1]);
							break;
	
						case HELP:
							debugPrint("Displaying list of available commands.");
							for (int i = 0; i < HELP_MESSAGE.length; i++) 
							{
								System.out.println(HELP_MESSAGE[i]);
							}
							break;
	
						case PUT:
							System.err.println("Error: command not supported");
							break;
	
						case QUIT:
							debugPrint("Goodbye!");
							client.close();
							eof = true;
							break;
	
						case USER:
							debugPrint("Trying to log in with user: " + argv[1]);
							if (client.sendCommand(cmd, argv[1]))
							{
								System.out.print("Enter a password: ");
								String pw = in.nextLine();
								debugPrint("Trying to enter password: " + pw);
								client.sendCommand(PASSWORD, pw);
							}
							break;
						}
					}
					else if (cmd == -1)
					{
						errorPrint("Invalid command.");
					}
					else
					{
						errorPrint("Invalid number of arguments for command " + argv[0] + ".");
					}
				}
				catch (IOException e)
				{
					errorPrint(e.getMessage());
					eof = true;
				}
			}
		} 
		while (!eof);
	}
	
	/**
	 * Helper routine to handle the translation between string 
	 * commands and their integer command equivalents.
	 * 
	 * @param input - string representation for a user command.
	 * @return corresponding command ID if valid, -1 if not.
	 */
	private int parseCommand(String input)
	{	
		int cmd = -1;

		// Loop through the list of available user commands and return 
		// the appropriate command ID.
		for (int i = 0; i < USER_COMMANDS.length && cmd == -1; i++) 
		{
			if (USER_COMMANDS[i].equalsIgnoreCase(input)) 
			{
				cmd = i;
			}
		}
		
		return cmd;
	}

	/**
	 * The main entry point into the program that checks the validity
	 * of the command line arguments and then jumps into the main
	 * user input processing loop.
	 * 
	 * @param args - command line arguments 
	 */
	public static void main(String args[]) 
	{
		if (args.length != 1) 
		{
			System.err.println("Usage: java FTP server");
			System.exit(1);
		}
		else
		{
			// Attempt to establish a connection with the server and, if successful,
			// begin parsing user input.
			FTP ftp = new FTP();
			if (ftp.connect(args[0]))
			{
				ftp.processInput();
			}
		}
	}
} // FTP
