/*
 * FTPClient.java
 *
 * Version: 4/3/12
 */

import java.io.FileOutputStream;
import java.io.IOException;
import java.net.UnknownHostException;
import java.util.ArrayList;

/**
 * This class is responsible for driving the FTP client 
 * and managing the protocol in order to communicate
 * with the server and provide the required functionality.
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class FTPClient 
{	
	/**
	 * The server host name and port that we connect to for file I/O.
	 */
	private String host;
	
	/**
	 * The default port for the FTP server.
	 */
	public static final int FTP_PORT = 21;
	
	/**
	 * Message end flag marker for Telnet protocol.
	 */
	public static final String TELNET_END = "\r\n";
	
	/**
	 * Parameters used to break up the FTP responses retrieved from the server.
	 */
	public static final int END_CODE_INDEX = 3;
	public static final char HYPHEN = '-';
	public static final char SPACE = ' ';
	
	/**
	 * Enumerations for the possible transfer types available.
	 */
	public static enum TransferType {ASCII, BINARY};
	private TransferType tType = TransferType.ASCII; 
	
	/**
	 * Enumerations for the possible transfer modes available.
	 */
	public static enum TransferMode {ACTIVE, PASSIVE};
	private TransferMode tMode = TransferMode.ACTIVE; 
	
	/**
	 * The FTP protocol manager 
	 */
	private FTPTransmissionManager ftpMgr;
	
	/**
	 * Default timeout of 2000 seconds for connections to the server.
	 */
	public static final int DEFAULT_TIMEOUT = 2000;
	
	/**
	 * THe modulus to use when converting IP strings retrieved from the server. 
	 */
	public static final int PORT_MODULUS = 256;
	
	/**
	 * Error response codes for the corresponding message.
	 */
	public static final String[] FTP_RESPONSE_CODES = 
	{
		"200", // 0
		"200", // 1
		"250", // 2
		"250", // 3
		"0",   // 4
		"150", // 5
		"150", // 6
		"0",   // 7
		"227", // 8
		"0",   // 9
		"257", // 10
		"331", // 11
		"331", // 12
		"230", // 13
		"200"  // 14
	};
	
	/**
	 * Constructor for the FTPClient that initializes the FTP protocol
	 * manager to control the communication with the server.
	 */
	public FTPClient()
	{
		ftpMgr = new FTPTransmissionManager();
	}
	
	/**
	 * Attempt to connect to the specified FTP location.
	 * 
	 * @param host - the remote host
	 * 
	 * @return true if successful, false otherwise
	 *  
	 * @throws UnknownHostException - when the remote host does not exist
	 * @throws IOException - when an I/O error occurs
	 */
	public String connect(String host) throws UnknownHostException, IOException
	{
		this.host = host;
		return ftpMgr.open(host, DEFAULT_TIMEOUT);
	}
	
	/**
	 * Close the server control connection.
	 */
	public void close()
	{
		try 
		{
			ftpMgr.close();
		} 
		catch (IOException e) 
		{
			FTP.errorPrint(e.getMessage());
		}
	}
	
	/**
	 * Send a control command to the FTP server and read its response.
	 * 
	 * @param command - the int command to send.
	 * @param param - parameter associated with this command
	 * 
	 * @return true if the response was appropriate, false otherwise
	 * 
	 * @throws IOException - when an I/O error occurs when communicating with the server.
	 */
	public boolean sendCommand(int command, String param) throws IOException
	{
		boolean successful = false;
		
		// Send the appropriate command to the user
		if (param == null)
		{
			ftpMgr.sendControl(FTP.FTP_COMMANDS[command]);
		}
		else
		{
			ftpMgr.sendControl(FTP.FTP_COMMANDS[command] + " " + param);
		}
		
		// Retrieve the response and check it for validity
		String response = ftpMgr.receiveControl(true);
		System.out.println(response);
		if (validResponseCode(command, response))
		{
			successful = true;
		}
		
		return successful;
	}
	
	/**
	 * Retrieve the specified file from the server and write its contents to disk.
	 * 
	 * @param command - get file command
	 * @param file - file to retrieve
	 * 
	 * @throws IOException - when an I/O error occurs 
	 */
	public void getFile(String command, String file) throws IOException
	{
		// This is a special request - just collect the bytes and then write them to disk 
		if (ftpMgr.openDataConnection(host, tMode))
		{
			// Handle the data connection logic first
			switch (tMode)
			{
			case ACTIVE:
				// Send the request command and display the response
				FTP.debugPrint("Establishing active connection");
				ftpMgr.sendControl(buildCommand(command, new String[]{file}));
				try
				{
					ftpMgr.prepareActiveConnection(DEFAULT_TIMEOUT);
				} 
				catch (Exception e)
				{
					FTP.errorPrint("Error while trying to establish active connection.");
					FTP.errorPrint(e.getMessage());
				}
				break;
				
			case PASSIVE:			
				// Send the request command
				ftpMgr.sendControl(buildCommand(command, new String[]{file}));
				break;
			}
			
			String response = ftpMgr.receiveControl(true);
			System.out.println(response);
			if (validResponseCode(command, response))
			{
				// Retrieve the raw file data from the server
				ArrayList<Byte> data = ftpMgr.readStream();
				
				// Create (overwrite, if already present) the new file
				FileOutputStream fos = new FileOutputStream(file, false);
				
				// Iterate across the entire data set and write the bytes (start at block 1)
				for (int i = 0; i < data.size(); i++)
				{
					fos.write(data.get(i));
				}
				
				// Flush and close the stream to finish
				fos.flush();
				fos.close();
				
				// Close the data connection and then read the server response
				ftpMgr.closeDataConnection(tMode);
				System.out.println(ftpMgr.receiveControl(true));
			}
		}
	}
	
	/**
	 * Send a request command to the server (one that requires a data connection).
	 * 
	 * @param command - the command to send
	 * @param arguments - the arguments to the command
	 * 
	 * @throws IOException - when a socket I/O error occurs.
	 */
	public void sendRequest(String command, String[] arguments) throws IOException
	{	
		if (ftpMgr.openDataConnection(host, tMode))
		{
			// Handle the data connection logic first
			switch (tMode)
			{
			case ACTIVE:
				// Send the request command and display the response
				FTP.debugPrint("Establishing active connection");
				ftpMgr.sendControl(buildCommand(command, arguments));
				ftpMgr.prepareActiveConnection(DEFAULT_TIMEOUT);
				break;
				
			case PASSIVE:			
				// Send the request command
				ftpMgr.sendControl(buildCommand(command, arguments));
				break;
			}
			
			String response = ftpMgr.receiveControl(true);
			System.out.println(response);
			if (validResponseCode(command, response))
			{
				// Retrieve and display the data that was sent from the server 
				// (assumed to be text for these commands).
				ArrayList<Byte> data = ftpMgr.readStream();
				StringBuilder builder = new StringBuilder();
				for (Byte b : data)
				{
					builder.append((char)b.byteValue());
				}
				System.out.println(builder.toString());
				
				// Close the data connection and then read the server response
				ftpMgr.closeDataConnection(tMode);
				System.out.println(ftpMgr.receiveControl(true));
			}
		}
	}
	
	/**
	 * Toggle the transfer mode that is used to retrieve data from 
	 * the FTP server.
	 */
	public void toggleTransferMode() 
	{
		switch (tMode)
		{
		case ACTIVE:
			tMode = TransferMode.PASSIVE;
			FTP.debugPrint("Changing to passive mode.");
			break;
		case PASSIVE:
			tMode = TransferMode.ACTIVE;
			FTP.debugPrint("Changing to active mode.");
			break;
		}
	}
	
	/**
	 * Set the transfer type for the data from the FTP server.
	 *  
	 * @param type - the new data type.
	 * 
	 * @throws IOException - when an I/O exception occurs after communicating 
	 * 						 with the server.
	 */
	public void setTransferType(FTPClient.TransferType type, String cmd) throws IOException
	{
		switch (type)
		{
		case ASCII:
			FTP.debugPrint("Chaning to ASCII transfer type.");
			tType = type;
			ftpMgr.sendControl("TYPE " + cmd);
			System.out.println(ftpMgr.receiveControl(true));
			break;
		case BINARY:
			FTP.debugPrint("Chaning to BINARY transfer type.");
			tType = type;
			ftpMgr.sendControl("TYPE " + cmd);
			System.out.println(ftpMgr.receiveControl(true));
			break;
		default:
			System.err.println("Error: invalid transfer type");
			break;
		}
	}
	
	/**
	 * Helper method that constructs a single string object
	 * from a single command and array of command arguments.
	 * 
	 * @param command - the single command to use as the basis.
	 * 
	 * @param arguments - the arguments appended to this command.
	 * 
	 * @return a single String that represents the command with its arguments.
	 */
	private String buildCommand(String command, String[] arguments)
	{
		StringBuilder builder = new StringBuilder();
		builder.append(command);
		if (arguments != null)
		{
			for (int i = 0; i < arguments.length; i++)
			{
				builder.append(" " + arguments[i]);
			}
		}
		return builder.toString();
	}
	
	/**
	 * Determine if the response for the specified code is correct.
	 * 
	 * @param command - command sent to the server
	 * @param response - server response.
	 * 
	 * @return true if successful code, false otherwise
	 */
	public static boolean validResponseCode(int command, String response)
	{
		return FTP_RESPONSE_CODES[command].equals(response.substring(0, END_CODE_INDEX));
	}
	
	/**
	 * Determine if the response for the specified code is correct.
	 * 
	 * @param command - command sent to the server
	 * @param response - server response.
	 * 
	 * @return true if successful code, false otherwise
	 */
	public static boolean validResponseCode(String command, String response)
	{
		for (int i = 0; i < FTP.FTP_COMMANDS.length; i++)
		{
			if (FTP.FTP_COMMANDS[i].equals(command))
			{
				return FTP_RESPONSE_CODES[i].equals(response.substring(0, END_CODE_INDEX)); 
			}
		}
		return false;
	}
} // FTPClient
