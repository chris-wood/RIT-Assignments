/*
 * TFTPclient.java
 * 
 * Version: 3/20/12
 */

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;

/**
 * This class implements the TFTP client interface methods that
 * allow other users to communicate with the TFTP server using
 * generic TFTP messages.
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class TFTPclient implements ITFTPclient 
{
	/**
	 * The datagram (UDP) socket used for communication with the server.
	 */
	private DatagramSocket serverSocket = null;
	
	/**
	 * The server host name and port that we connect to for file I/O.
	 */
	private String host;
	
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
	@Override
	public void open(String host, int timeout) throws UnknownHostException, 
		IOException 
	{
		serverSocket = new DatagramSocket();
		serverSocket.setSoTimeout(timeout);
		this.host = host;
	}

	/**
	 * Close the connection to the host TFTP server.
	 * 
	 * @precondition - server connection established.
	 * @postcondition - server connection terminated.
	 */
	@Override
	public void close() 
	{
		if (serverSocket != null && serverSocket.isConnected())
		{
			serverSocket.close();
			serverSocket = null;
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
	@Override
	public void sendMessage(TFTPmessage message, int port) throws IOException
	{
		// Create and send the UDP packet  
		InetAddress IPAddress = null;
		IPAddress = InetAddress.getByName(host);
		
		// Send the message to the server
		byte[] data = message.rawData();
		
		// debug
		System.out.print("Sending: ");
		for (int i = 0; i < data.length; i++)
		{
			System.out.print(data[i] + " ");
		}
		System.out.println();
		
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
	 * @throws TimeoutException - when the socket I/O times out.
	 * @throws MalformedMessageException - when the message received is not valid. 
	 */
	@Override
	public TFTPmessage getMessage() throws SocketTimeoutException, 
		MalformedMessageException 
	{
		// Build a buffer to store the UDP message contents
		int messageSize = TFTPmessage.MESSAGE_SIZE;
		byte[] receiveData = new byte[messageSize];
		DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
		
	    try 
	    {
	    	// Try to receive a UDP packet
			serverSocket.receive(receivePacket);
		} 
	    catch (IOException e) 
		{
			e.printStackTrace();
		}
	    
	    // debug
	    System.out.print("Received: ");
	    for (int i = 0; i < receiveData.length; i++)
		{
			System.out.print(receiveData[i] + " " );
		}
	    System.out.println("");
	    
	    TFTPmessage message = buildMessage(receivePacket);
	    return message;
	}
	
	private TFTPmessage buildMessage(DatagramPacket packet) throws MalformedMessageException
	{
		TFTPmessage message = null;
		
		try
		{
			// Determine the opcode from this packet
			TFTPmessage.Opcode opcode = TFTPmessage.codes[(int)packet.getData()[1] - 1];
			
			// Create the appropriate packet based on the opcode
			switch (opcode)
			{
				case ACK:
					// TODO
					System.out.println("Got ACK");
					message = new AckMessage(packet.getData());
					break;
				case DATA:
					System.out.println("Got DATA");
					message = new DataMessage(packet);
					break;
				case ERROR:
					// TODO
					System.out.println("Got ERROR");
					message = new ErrorMessage(packet.getData(), packet.getLength());
					break;
				default:
					System.err.println("Invalid message type encounterd.");
					throw new MalformedMessageException(host);
			}
		}
		catch (IndexOutOfBoundsException e)
		{
			e.printStackTrace();
			throw new MalformedMessageException(host);
		}
		
		return message;
	}
}
