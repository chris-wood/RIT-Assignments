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
	 * Debug mode flag.
	 */
	private boolean debugMode = false;

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
	 * Helper method that handles debug messages (printing to console, file, etc).
	 *
	 * @param message - the debug message to handle.
	 */
	public void debugPrint(String message)
	{
		System.out.println("TFTP DEBUG: " + message);
	}
	
	/**
	 * Read commands and execute commands entered from the keyboard in order
	 * to interact with the FTP server specified.
	 * 
	 * @param server - the host FTP server to connect to.
	 */
	public void processInput(String server)
	{
		Scanner in = new Scanner(System.in);
		boolean eof = false;
		String input = null;
		
		System.out.println("DEBUG: Connecting to: " + server);
		FTPClient client = new FTPClient();
		System.out.println("DEBUG: Connection successful.");
		try {
			System.out.println(client.connect(server, DEFAULT_TIMEOUT));
		} catch (UnknownHostException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		} catch (IOException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
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
				
				//debug
				for (int i = 0; i < argv.length; i++)
				{
					System.out.println("argv[" + i + "]: " + argv[i]);
				}

				// TODO
				for (int i = 0; i < COMMANDS.length && cmd == -1; i++) 
				{
					if (COMMANDS[i].equalsIgnoreCase(argv[0])) 
					{
						cmd = i;
					}
				}
				
				// TODO: write method that forwards immediate queries (e.g. ascii, pwd, dir, etc...)

				// Handle the command appropriately
				switch (cmd) 
				{
				case ASCII:
					try {
						client.setTransferType(FTPClient.TransferType.ASCII);
					} catch (IOException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
					break;
				case BINARY:
					try {
						client.setTransferType(FTPClient.TransferType.BINARY);
					} catch (IOException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
					break;
					
				case DIR:
					if (argv.length == 1)
					{
						// TODO: make a map of user commands to FTP protocol commands
						try {
							System.out.println(client.sendRequest("list", null));
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					break;
					
				case PASSIVE:
					if (argv.length == 1)
					{
						// TODO: make a map of user commands to FTP protocol commands
						try
						{
							client.toggleTransferMode();
						}
						catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					break;
					
				case CDUP:
				case PWD:
					if (argv.length == 1)
					{
						// TODO: make a map of user commands to FTP protocol commands
						try {
							System.out.println(client.sendCommand(argv[0]));
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					break;
					
				case CD:
					if (argv.length == 2)
					{
						// TODO: make a map of user commands to FTP protocol commands
						try {
							System.out.println(client.sendCommand("cwd " + argv[1]));
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					break;

				case DEBUG:
					debugMode = !debugMode;
					if (debugMode)
					{
						debugPrint("Debug mode enabled.");
					}
					else
					{
						debugPrint("Debug mode disabled.");
					}
					break;

				case GET:
					if (argv.length == 2)
					{
						//client.getFile(argv[0], argv[1]);
					}
					break;

				case HELP:
					for (int i = 0; i < HELP_MESSAGE.length; i++) 
					{
						System.out.println(HELP_MESSAGE[i]);
					}
					break;

				case PUT:
					System.err.println("Error: command not supported");
					break;

				case QUIT:
					eof = true;
					break;

				case USER:
					// Parse the user information
					if (argv.length == 2)
					{
						//try 
						{
							try {
								System.out.println("DEBUG: received: " + client.sendCommand(argv[0] + " " + argv[1]));
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							System.out.print("Enter a password: ");
							String pw = in.nextLine();
							
							// TODO: how should we send the password
							System.out.println("Sending password: " + pw + " to server...");
							try {
								System.out.println(client.sendCommand("pass" + " " + pw));
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						} 
						//catch (IOException e) 
						{
							//e.printStackTrace();
						}
					}
					else
					{
						//System.err.println("Error: ")
						// TODO: display user command error to user
					}
					break;

				default:
					System.out.println("Invalid command");
				}
			}
		} 
		while (!eof);
	}

	/**
	 * TODO
	 * 
	 * @param args - command line arguments 
	 */
	public static void main(String args[]) 
	{
		// Ensure we have the right amount of command line arguments
		if (args.length != 1) 
		{
			System.err.println("Usage: java FTP server");
			System.exit(1);
		}
		else
		{
			FTP ftp = new FTP();
			ftp.processInput(args[0]);
		}
	}

} // FTP
