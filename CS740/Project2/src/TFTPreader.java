/*
 * TFTPreader.java
 * 
 * Version: 3/20/12
 */

/**
 * TODO
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class TFTPreader 
{	
	/**
	 * The main entry point into the program.
	 * 
	 * @param args - command line arguments containing the transfer
	 *               mode to use, the name of the host on which the
	 *               TFTP server is running, and the name of the 
	 *               file to transfer.
	 */
	public static void main(String[] args)
	{
		// Verify that the correct number of parameters was provided
		if (args.length != 3)
		{
			displayUsage();
		}
		else
		{
			// 1. verify valid machine/server name (else print another error - add error printing as a private static method)
			// 2. connect to the TFTP server
			// 3. transfer the file using the protocol specified
		}
	}
	
	/**
	 * Simple helper method that displays the usage message that explains
	 * how to run the TFTPreader program.
	 */
	private static void displayUsage()
	{
		System.err.println("Usage: java TFTPreader [netascii|octet] tftp-host file");
	}
}

