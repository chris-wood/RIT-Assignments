import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;

public class FTPProtocolInterpreter 
{
	/**
	 * Socket and data streams for the control channel.
	 */
	private Socket controlSocket = null;
	private DataOutputStream controlOut = null;
	private BufferedReader controlIn = null;
	
	private FTPClient client;
	
	public FTPProtocolInterpreter(FTPClient client)
	{
		this.client = client;
	}
	
	/**
	 * Open a connection to the host TFTP server to begin a file
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
		controlOut = new DataOutputStream(controlSocket.getOutputStream());
		controlIn = new BufferedReader(new 
				InputStreamReader(controlSocket.getInputStream()));
		
		//dataSocket = new Socket(host, FTP_PORT);
		//dataOut = new DataOutputStream(dataSocket.getOutputStream());
		//dataIn = new DataInputStream(dataSocket.getInputStream());
		
		// Get the initial reply from the server (if any) and return it
		StringBuilder reply = new StringBuilder();
		String line = null;
		System.out.println("DEBUG: getting greeting.");
		// TODO: turn this into a handy helper method (isStreamReady)
		controlIn.readLine(); // TODO TODO TODO TODO WTF WTF WTF WTF WTF
		while (controlIn.ready())
		{
			line = controlIn.readLine();
			reply.append(line + FTPClient.TELNET_END);
		}
		System.out.println(reply.toString());
		
		// Save the host name for future reference
		client.host = host;
		
		// Set up the transfer mode and type (defaults!)
		// TODO: build logic into the FTP client to make it smarter about sending this command!
		//toggleTransferMode(TransferMode.PASSIVE);
		
		return ""; // TODO: remove this return type
	}

	/**
	 * Close the connection to the host FTP server.
	 * 
	 * @precondition - server connection established.
	 * @postcondition - server connection terminated.
	 * 
	 * @throws IOException - when the sockets are unable to close
	 */
	public void close() throws IOException 
	{
		// TODO: fix this logic
		if (controlSocket != null && 
				controlSocket.isConnected())
		{
			controlSocket.close();
			//dataSocket.close();
			controlSocket = null;
			//dataSocket = null;
		}
	}
	
	public String sendControl(String command) throws IOException
	{	
		controlOut.writeBytes(command + FTPClient.TELNET_END);
		
		// Read in the server response
		// TODO: make this into a helper method to reduce code everywhere
		StringBuilder builder = new StringBuilder();
		builder.append(controlIn.readLine());
		while (controlIn.ready())
		{
			builder.append(controlIn.readLine() + "\n");
		}
		
		return builder.toString();
	}
	
	public void getFile(String command, String file) throws IOException
	{
		// Ask the server for this specific file
		// TODO: use command as a map
		controlOut.writeBytes("retrieve" + " " + file + FTPClient.TELNET_END);
		
		StringBuilder builder = new StringBuilder();
		builder.append(controlIn.readLine());
		while (controlIn.ready())
		{
			builder.append(controlIn.readLine() + "\n");
		}
		System.out.println(builder.toString());
		
		// Now, establish a connection!
		
		// Receive the data appropriately 
		switch (client.tType)
		{
		case ASCII:
			builder = new StringBuilder();
			// TODO: do something here...
			break;
			
		case BINARY:
			System.err.println("Error: BINARY transfer type not supported.");
			break;
		}
	}
	
	public void putFile(String command, String file)
	{
		System.err.println("Error: unsupported connection.");
	}
}
