/*
 * FTPTransmissionManager.java
 *
 * Version: 4/3/12
 */

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.EOFException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.ArrayList;

/**
 * This class is responsible for handling the network communications
 * with the server and is utilized by the main FTP client in order
 * to perform actions according to the protocol specification outlined
 * in the FTP RFC.
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class FTPTransmissionManager 
{
	/**
	 * Socket and data streams for the control channel.
	 */
	private Socket controlSocket = null;
	private BufferedOutputStream controlOut = null;
	private BufferedReader controlIn = null;
	
	/**
	 * Socket and data streams for the data channel.
	 */
	private Socket dataSocket = null;
	private ServerSocket activeSocket = null;
	private DataInputStream dataIn = null;
	
	/**
	 * Commands for the port/passive controls that are below user level.
	 */
	private static final String PORT_COMMAND = "PORT";
	private static final String PASSIVE_COMMAND = "PASV";
	
	/**
	 * Open a connection to the host FTP server to begin a file
	 * read or write operation.
	 * 
	 * @precondition - server connection not already established.
	 * @postcondition - server connection open and established.
	 * 
	 * @param host - name of the host server.
	 * @param timeout - timeout value associated with socket transmissions.
	 * 
	 * @return entry message from FTP server.
	 * 
	 * @throws UnknownHostException - when the specified host does not exist.
	 * @throws IOException - when an I/O error occurs during socket transmission.
	 */
	public String open(String host, int timeout) throws UnknownHostException, 
		IOException 
	{	
		controlSocket = new Socket(host, FTPClient.FTP_PORT);
		controlOut = new BufferedOutputStream(controlSocket.getOutputStream());
		controlIn = new BufferedReader(new InputStreamReader(controlSocket.getInputStream()));
		
		// Get the initial reply from the server (if any) and return it
		FTP.debugPrint("Getting greeting.");
		return receiveControl(true);
	}

	/**
	 * Close the connection to the host FTP server.
	 * 
	 * @precondition - server connection established.
	 * @postcondition - server connection terminated.
	 * 
	 * @throws IOException - when the sockets are unable to close.
	 */
	public void close() throws IOException 
	{
		if (controlSocket != null && controlSocket.isConnected())
		{
			controlSocket.close();
			controlSocket = null;
		}
	}
	
	/**
	 * Prepare the data communication socket/stream for a connection.
	 * 
	 * @param timeout - the timeout for the socket communication
	 * 
	 * @throws IOException - when an I/O error occurs
	 */
	public void prepareActiveConnection(int timeout) throws IOException
	{
		activeSocket.setSoTimeout(2000);
		dataSocket = activeSocket.accept();
		dataIn = new DataInputStream(dataSocket.getInputStream());
	}
	
	/**
	 * Open a data connection with the server.
	 * 
	 * @param tMode - the transfer mode to use.
	 *  
	 * @return - true if successful, false otherwise
	 */
	public boolean openDataConnection(String host, FTPClient.TransferMode tMode)
	{
		boolean successful = true;
		
		switch (tMode)
		{
		case ACTIVE:
			// Initialize a new active socket and then send the port 
			// command to the server so it can connect.
			try 
			{
				activeSocket = new ServerSocket(0);
				String portParam = buildPortParam(activeSocket);
				FTP.debugPrint("Port command parameter: " + portParam);
				sendControl(PORT_COMMAND + " " + portParam);
				
				// Validate the response
				String response = receiveControl(true);
				System.out.println(response);
				if (!FTPClient.validResponseCode(PORT_COMMAND, response))
				{
					FTP.debugPrint("Failed to establish data connection.");
					successful = false;
				}
			} 
			catch (IOException e) 
			{
				e.printStackTrace();
				successful = false;
			}
			break;
			
		case PASSIVE:
			try 
			{
				FTP.debugPrint("Establishing passive connection.");
				int port = sendPassiveCommand();
				if (port != -1)
				{
					// Now attempt to directly connect to the server
					FTP.debugPrint("FTP server returned with port: " + port);
					FTP.debugPrint("Attempting to connect directly to server.");
					dataSocket = new Socket(host, port);
					FTP.debugPrint("Connection returned.");
					dataIn = new DataInputStream(dataSocket.getInputStream());
				}
				else
				{
					FTP.debugPrint("Failed to establish data connection.");
					successful = false;
				}
			} 
			catch (UnknownHostException e) 
			{
				e.printStackTrace();
				successful = false;
			} 
			catch (IOException e) 
			{
				e.printStackTrace();
				successful = false;
			}
			break;
		}
		
		return successful;
	}
	
	/**
	 * Close the data connection that is open with the server.
	 * 
	 * @param tMode - the transfer mode to use.
	 * 
	 * @return true if successful, false otherwise
	 */
	public boolean closeDataConnection(FTPClient.TransferMode tMode)
	{
		boolean successful = true;
		FTP.debugPrint("Closing data connection.");
		
		try 
		{
			switch (tMode)
			{
			case ACTIVE:
				dataSocket.close();
				activeSocket.close();
				break;
				
			case PASSIVE:
				dataSocket.close();
				break;
			}
		} 
		catch (IOException e)
		{
			successful = false;
		}
		
		return successful;
	}
	
	/**
	 * Send a command/control string to the FTP server.
	 * 
	 * @param command - the command to send
	 * 
	 * @throws IOException - when an I/O error occurs
	 */
	public void sendControl(String command) throws IOException
	{
		// Flush the stream first to get rid of back-logged data
		if (controlIn.ready() && (controlSocket.getInputStream().available() > 0))
		{
			System.out.println(receiveControl(true));
		}
		
		// Now strip out the commands and send them to the server
		FTP.debugPrint("Sending control: " + command);
		String cmd = command + FTPClient.TELNET_END;
		controlOut.write(cmd.getBytes(), 0, cmd.length());
		controlOut.flush();
	}
	
	/**
	 * Retrieve the control/command response from the server.
	 * 
	 * @param wait - parameter that indicates whether or not
	 * 				 this should block until the server returns something.
	 * 
	 * @return - the String response
	 * 
	 * @throws IOException - when an I/O error occurs
	 */
	public String receiveControl(boolean wait) throws IOException
	{
		// Reconstruct the input, byte by byte
		StringBuilder builder = new StringBuilder();
		try 
		{
			// Simulate a busy-wait while data is expected to retrieve
			if (wait)
			{
				while (!(controlSocket.getInputStream().available() > 0))
				{
					// Busy wait
				}
			}
			
			// Read in the immediate response and then check to see if more is on the way
			String line = controlIn.readLine();
			builder.append(line);
			boolean endOfReply = true;
			String response = line.substring(0, FTPClient.END_CODE_INDEX);
			if (line.charAt(FTPClient.END_CODE_INDEX) == FTPClient.HYPHEN)
			{
				endOfReply = false;
				
			}
			
			// Loop until we reach the end of the reply
			while (!endOfReply)
			{
				line = controlIn.readLine();
				builder.append("\n" + line);
				if (isFtpResponse(line) && 
						line.charAt(FTPClient.END_CODE_INDEX) == FTPClient.SPACE && 
						line.substring(0, FTPClient.END_CODE_INDEX).equals(response))
				{
					endOfReply = true;
				}
			}
		}
		catch (EOFException e)
		{
			// Do nothing, we have reached the end of the stream
		}
		
		return builder.toString();
	}
	
	/**
	 * Send a passive command to the server (this is special).
	 * 
	 * @return the port to connect to.
	 * 
	 * @throws IOException - when an I/O error occurs
	 */
	public int sendPassiveCommand() throws IOException
	{
		// Flush the stream first
		if (controlIn.ready() && (controlSocket.getInputStream().available() > 0))
		{
			System.out.println(receiveControl(false));
		}
		
		// Send the command to switch to passive mode
		sendControl(PASSIVE_COMMAND);
		
		// Retrieve the response and parse it 
		String result = receiveControl(true);
		System.out.println(result);
		if (FTPClient.validResponseCode(PASSIVE_COMMAND, result))
		{
			FTP.debugPrint("Passive command response: " + result);
			int startIndex = result.indexOf('(') + 1;
			int endIndex = result.indexOf(')', startIndex); 
			String data = result.substring(startIndex, endIndex);
			String[] splits = data.split(",");
		
			// Return the resulting port number to use
			return buildPort(splits[4], splits[5]);
		}
		else
		{
			FTP.debugPrint("Failed to establish passive connection.");
			return -1;
		}
	}
	
	/**
	 * Determine if the server response is a valid FTP message.
	 * 
	 * @param line - the server response
	 * 
	 * @return true if valid response, false otherwise.
	 */
	private boolean isFtpResponse(String line)
	{
		boolean valid = false;
		
		try
		{
			Integer.parseInt(line.substring(0, FTPClient.END_CODE_INDEX));
			valid = true;
		}
		catch (Exception e)
		{
			// Do nothing, this was handled okay.
		}
		
		return valid;
	}
	
	/**
	 * Rebuild the port number that was sent from the server.
	 * 
	 * @param v1 - part 1 of the port
	 * @param v2 - part 2 of the port
	 * 
	 * @return the corresponding port number
	 */
	private int buildPort(String v1, String v2)
	{
		int port = 0;
		
		try 
		{
			port = (Integer.parseInt(v1) * FTPClient.PORT_MODULUS) 
					+ Integer.parseInt(v2);
		}
		catch (NumberFormatException e)
		{
			FTP.errorPrint("Invalid port returned from host FTP server.");
			port = -1;
		}
		
		return port;
	}
	
	/**
	 * Build the port parameter used in active data connection mode.
	 * 
	 * @param socket - the socket hosting the data connection.
	 * 
	 * @return a String parameter for the PORT command
	 */
	private String buildPortParam(ServerSocket socket)
	{
		StringBuilder builder = new StringBuilder();
		
		try 
		{
			// Get the IP address and convert into bytes
			InetAddress addr = InetAddress.getLocalHost();
			String strAddr = addr.getHostAddress();
			strAddr = strAddr.replaceAll("\\.", ",");
			builder.append(strAddr);
			
			// Fill in the port information at the end
			int p1 = socket.getLocalPort() / FTPClient.PORT_MODULUS; 
			int p2 = socket.getLocalPort() % FTPClient.PORT_MODULUS; 
			builder.append("," + p1 + "," + p2);
		} 
		catch (UnknownHostException e) 
		{
			FTP.errorPrint(e.getMessage());
		}
		
		return builder.toString();
	}
	
	/**
	 * Read a stream of bytes from the data channel established with the 
	 * FTP server.
	 * 
	 * @return - a list of bytes retrieved from the FTP server.
	 * 
	 * @throws IOException - when an I/O exception occurs communicating with
	 * 						 the server.
	 */
	public ArrayList<Byte> readStream() throws IOException
	{
		ArrayList<Byte> data = new ArrayList<Byte>();
		
		// Read until the stream is end
		int dataByte = 0;
		while ((dataByte = dataIn.read()) != -1)
		{
			data.add((byte)dataByte);
		}
		
		return data;
	}
} // FTPTransmissionManager
