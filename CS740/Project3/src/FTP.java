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
 * An RFC959 compliant FTP client.
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
	public static final String PROMPT = "FTP> ";

	/**
	 * Array of available commands supported by this client
	 * and the corresponding indices for these commands.
	 */
	public static final String COMMANDS[] = 
	{ 
		"ascii", "binary", "cd", "cdup", "debug", "dir", 
		"get", "help", "passive", "put", "pwd", "quit", "user" 
	};

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
	
	/**
	 * Default timeout of 2000 seconds for connections
	 */
	public static final int DEFAULT_TIMEOUT = 2000;

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
	 * Read commands and execute commands entered from the keyboard. The user
	 * must specify the address of the server from the command line.
	 * 
	 * @param args - command line arguments 
	 */
	public static void main(String args[]) 
	{
		Scanner in = new Scanner(System.in);
		boolean eof = false;
		String input = null;

		// Ensure we have the right amount of command line arguments
		if (args.length != 1) 
		{
			System.err.println("Usage: java FTP server");
			System.exit(1);
		}
		
		System.out.println("Connecting to: " + args[0]);
		FTPClient client = new FTPClient();
		try {
			System.out.println(client.open(args[0], DEFAULT_TIMEOUT));
		} catch (UnknownHostException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		// Begin accepting and processing user commands to interact
		// with the FTP server.
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
				int cmd = -1;
				String argv[] = input.split("\\s+");

				// What command was entered?
				for (int i = 0; i < COMMANDS.length && cmd == -1; i++) 
				{
					if (COMMANDS[i].equalsIgnoreCase(argv[0])) 
					{
						cmd = i;
					}
				}

				// Execute the command
				switch (cmd) 
				{
				case ASCII:
					break;

				case BINARY:
					break;

				case CD:
					break;

				case CDUP:
					break;

				case DEBUG:
					break;

				case DIR:
					try {
						System.out.println(client.sendAndReceiveControl("dir"));
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					break;

				case GET:
					break;

				case HELP:
					for (int i = 0; i < HELP_MESSAGE.length; i++) 
					{
						System.out.println(HELP_MESSAGE[i]);
					}
					break;

				case PASSIVE:
					break;

				case PUT:
					break;

				case PWD:
					break;

				case QUIT:
					eof = true;
					break;

				case USER:
					break;

				default:
					System.out.println("Invalid command");
				}
			}
		} 
		while (!eof);
	}

} // FTP
