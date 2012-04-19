import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.EOFException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;

public class FTPTransmissionManager 
{
	/**
	 * Socket and data streams for the control channel.
	 */
	private Socket controlSocket = null;
	private BufferedOutputStream controlOut = null;
	private BufferedReader controlIn = null;
	
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
		System.out.println("DEBUG: getting greeting.");
		return receiveControl();
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
		// TODO: fix this logic
		if (controlSocket != null && 
				controlSocket.isConnected())
		{
			controlSocket.close();
			controlSocket = null;
		}
	}
	
	public void sendControl(String command) throws IOException
	{
		// Flush the stream first
		if (controlIn.ready() && (controlSocket.getInputStream().available() > 0))
		{
			System.out.println(receiveControl());
		}
		
		System.out.println("DEBUG: sending control: " + command);
		//controlOut.write(command + FTPClient.TELNET_END);
		//controlOut.flush();
		String cmd = command + FTPClient.TELNET_END;
		controlOut.write(cmd.getBytes(), 0, cmd.length());
		controlOut.flush();
		for (int i = 0; i < cmd.length(); i++)
		{
			System.out.println(cmd.getBytes()[i]);
		}
	}
	
	public String receiveControl() throws IOException
	{
		// Reconstruct the input, byte by byte
		StringBuilder builder = new StringBuilder();
		try 
		{
			String line;
			do 
			{
				line = controlIn.readLine();
				builder.append(line + "\n");
			}
			while (controlIn.ready());
		}
		catch (EOFException e)
		{
			// Do nothing, we have reached the end of the stream
		}
		
		return builder.toString();
	}
	
	// TODO: move into FTPClient.java
	public int sendPassiveCommand() throws IOException
	{
		// Send the command to switch to passive mode
		//controlOut.writeBytes("PASV" + FTPClient.TELNET_END);
		String cmd = "PASV" + FTPClient.TELNET_END;
		controlOut.write(cmd.getBytes(), 0, cmd.length());
		controlOut.flush();
		
		// Retrieve the response and parse it 
		String result = receiveControl();
		System.out.println("DEBUG: passive command response: " + result);
		int startIndex = result.indexOf('(') + 1;
		int endIndex = result.indexOf(')', startIndex); 
		String data = result.substring(startIndex, endIndex);
		String[] splits = data.split(",");
		
		// Return the resulting port number to use
		return buildPort(splits[4], splits[5]);
	}
	
	/**
	 * TODO 
	 * 
	 * @param v1
	 * @param v2
	 * @return
	 */
	public int buildPort(String v1, String v2)
	{
		int port = 0;
		
		try 
		{
			port = (Integer.parseInt(v1) * 256) + Integer.parseInt(v2);
		}
		catch (NumberFormatException e)
		{
			System.err.println("Error: invalid port returned from host FTP server.");
			port = -1;
		}
		
		return port;
	}
}
