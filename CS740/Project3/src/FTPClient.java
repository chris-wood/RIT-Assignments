import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;

/**
 * TODO
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class FTPClient 
{	
	/**
	 * TODO
	 */
	private Socket controlSocket = null;
	private DataOutputStream controlOut = null;
	private BufferedReader controlIn = null;
	
	/**
	 * TODO
	 */
	private Socket dataSocket = null;
	private DataOutputStream dataOut = null;
	private BufferedReader dataIn = null;
	
	/**
	 * The server host name and port that we connect to for file I/O.
	 */
	private String host;
	
	/**
	 * TODO
	 */
	private static final int FTP_PORT = 21;
	
	/**
	 * Message end flag marker for telnet protocol.
	 */
	private static final String TELNET_END = "\n";
	
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
		controlSocket = new Socket(host, FTP_PORT);
		controlOut = new DataOutputStream(controlSocket.getOutputStream());
		controlIn = new BufferedReader(new 
				InputStreamReader(controlSocket.getInputStream()));
		
		dataSocket = new Socket(host, FTP_PORT);
		dataOut = new DataOutputStream(dataSocket.getOutputStream());
		dataIn = new BufferedReader(new 
				InputStreamReader(dataSocket.getInputStream()));
		
		// Save the host name for future reference
		this.host = host;
		
		// Get the reply from the server (if any) and return it
		StringBuilder reply = new StringBuilder();
		String line = null;
		// TODO: this blocks?
		//controlOut.writeBytes("dir\n");
		//while ((line = controlIn.readLine()) != null)
		{
			reply.append(line);
		}
		return reply.toString();
	}

	/**
	 * Close the connection to the host TFTP server.
	 * 
	 * @precondition - server connection established.
	 * @postcondition - server connection terminated.
	 * 
	 * @throws IOException - when the sockets are unable to close
	 */
	public void close() throws IOException 
	{
		if (controlSocket != null && dataSocket != null && 
				controlSocket.isConnected() && dataSocket.isConnected())
		{
			controlSocket.close();
			dataSocket.close();
			controlSocket = null;
			dataSocket = null;
		}
	}
	
	public String sendAndReceiveControl(String command) throws IOException
	{
		String reply = null;
		
		controlOut.writeBytes(command + TELNET_END);
		reply = controlIn.readLine();
		
		return reply;
	}
}
