import java.io.IOException;
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
	
	/**
	 * TODO
	 */
	private Socket dataSocket = null;
	
	/**
	 * The server host name and port that we connect to for file I/O.
	 */
	private String host;
	
	/**
	 * TODO
	 */
	private static final int FTP_PORT = 21;
	
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
	 * @throws UnknownHostException - when the specified host does not exist.
	 * @throws IOException - when an I/O error occurs during socket transmission.
	 */
	public void open(String host, int timeout) throws UnknownHostException, 
		IOException 
	{
		controlSocket = new Socket(host, FTP_PORT);
		dataSocket = new Socket(host, FTP_PORT);
		this.host = host;
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
	
	/**
	 * Send a generic TFTP message to the host server.
	 * 
	 * @precondition - server connection established.
	 * @postcondition - none.
	 * 
	 * @param message - the message to send.
	 * @param port - the port to send the message to.
	 * 
	 * @throws IOException - when an I/O error occurs during socket transmission.
	 */
	public void sendMessage(TFTPmessage message, int port) throws IOException
	{
		// Create and send the UDP packet  
		InetAddress IPAddress = null;
		IPAddress = InetAddress.getByName(host);
		
		// Send the message to the server
		byte[] data = message.rawData();
		DatagramPacket packet = new DatagramPacket(data, data.length, IPAddress, port);
		serverSocket.send(packet);
	}

	/**
	 * Receive a generic TFTP message from the host server.
	 * 
	 * @precondition - server connection establish.
	 * @postcondition - none.
	 * 
	 * @return - a generic TFTP message object instance. 
	 * 
	 * @throws IOException - when a socket I/O error occurs
	 * @throws SocketTimeoutException - when the socket I/O times out.
	 * @throws MalformedMessageException - when the message received is not valid. 
	 */
	public TFTPmessage getMessage() throws 
		IOException, SocketTimeoutException, MalformedMessageException 
	{
		// Build a buffer to store the UDP message contents
		int messageSize = TFTPmessage.MESSAGE_SIZE;
		byte[] receiveData = new byte[messageSize];
		DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
		
	    // Get and return the next message
		serverSocket.receive(receivePacket);
	    TFTPmessage message = buildMessage(receivePacket);
	    return message;
	}
	
	/**
	 * Helper method that will construct a new TFTPmessage based on the contents
	 * of the datagram packet that was received from the TFTP server.
	 * 
	 * @param packet - the received datagram packet.
	 * 
	 * @return value TFTPmessage object.
	 * 
	 * @throws MalformedMessageException - when the message type/format is invalid.
	 */
	private TFTPmessage buildMessage(DatagramPacket packet) throws MalformedMessageException
	{
		TFTPmessage message = null;
		
		try
		{
			// Determine the opcode
			int codeNumber = TFTPmessage.byteArrayToInt(packet.getData(), 
					TFTPmessage.OPCODE_INDEX, TFTPmessage.OPCODE_SIZE); 
			
			// Determine the opcode from this packet
			TFTPmessage.Opcode opcode = TFTPmessage.codes[codeNumber - 1];
			
			// Create the appropriate packet based on the opcode
			switch (opcode)
			{
				case ACK:
					message = new AckMessage(packet);
					break;
				case DATA:
					message = new DataMessage(packet);
					break;
				case ERROR:
					message = new ErrorMessage(packet);
					break;
				default:
					throw new MalformedMessageException(host);
			}
		}
		catch (IndexOutOfBoundsException e)
		{
			throw new MalformedMessageException(host);
		}
		
		return message;
	}

	/**
	 * Send a message to the TFTP server and wait for a response, retrying the
	 * message send a specific number of times.
	 * 
	 * @precondition - server connection established.
	 * @postcondition - none.
	 * 
	 * @param msg - message to send.
	 * @param port - port to send the message to.
	 * 
	 * @return a new TFTPmessage if transfer was successful, false otherwise.
	 * 
	 * @throws IOException - when an I/O error occurs. 
	 * @throws SocketTimeoutException - when the socket I/O times out more than numRetries times.
	 * @throws MalformedMessageException - when the message received is not valid.
	 */
	public TFTPmessage sendAndReceiveMessage(TFTPmessage msg, int port, int numRetries) 
			throws IOException, SocketTimeoutException, MalformedMessageException 
	{
		int failures = 0;
		TFTPmessage result = null;

		// Continue until we fail out
		while (failures < numRetries)
		{	
			try 
			{
				// Try to send the message and then receive the result
				sendMessage(msg, port);
				result = getMessage();
				failures = numRetries + 1;
			}
			catch (SocketTimeoutException e)
			{
				failures++;
				
				// Propagate the exception up the stack if we failed for the last time
				if (failures >= numRetries)
				{
					throw e;
				}
			}
			catch (IOException e)
			{
				failures++;
				
				// Propagate the exception up the stack if we failed for the last time
				if (failures >= numRetries)
				{
					throw e;
				}
			}
		}
		
		return result;
	}

}
