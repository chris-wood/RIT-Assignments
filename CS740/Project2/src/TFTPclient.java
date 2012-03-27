import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.UnknownHostException;

/*
 * TFTPclient.java
 * 
 * Version: 3/20/12
 */

/**
 * TODO
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class TFTPclient implements ITFTPclient 
{
	private DatagramSocket clientSocket = null;
	private String host;
	private int port;
	
	@Override
	public void open(String host, int port, int timeout) throws UnknownHostException,
			IOException {
		clientSocket = new DatagramSocket();
		clientSocket.setSoTimeout(timeout);
		this.host = host;
		this.port = port;
	}

	@Override
	public void close() 
	{
		if (clientSocket != null && clientSocket.isConnected())
		{
			clientSocket.close();
			clientSocket = null;
		}
	}
	
	@Override
	public void sendMessage(TFTPmessage message)
	{
		// Create and send the UDP packet  
		InetAddress IPAddress = null;
		try {
			IPAddress = InetAddress.getByName(host);
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		DatagramPacket packet = new DatagramPacket(message.rawData(), message.rawData().length, IPAddress, port);
		try {
			clientSocket.send(packet);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public TFTPmessage getMessage() throws TimeoutException, MalformedMessageException 
	{
		// Build a buffer to store the UDP message contents
		int messageSize = TFTPmessage.MESSAGE_SIZE;
		byte[] receiveData = new byte[messageSize];
		DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
		
	    try 
	    {
	    	// Try to receive a UDP packet
			clientSocket.receive(receivePacket);
		} 
	    catch (IOException e) 
		{
			e.printStackTrace();
		}
	    
	    // debug
	    System.out.print("Data received: ");
	    for (int i = 0; i < receiveData.length; i++)
		{
			System.out.print(receiveData[i] + " " );
		}
	    
	    TFTPmessage message = buildMessage(receiveData);
	    return message;
	}
	
	private TFTPmessage buildMessage(byte[] data) throws MalformedMessageException
	{
		TFTPmessage message = null;
		
		try
		{
			TFTPmessage.Opcode opcode = TFTPmessage.codes[(int)data[1]];
			
			// Create the appropriate packet
			switch (opcode)
			{
				case ACK:
					// TODO
					break;
				case DATA:
					// TODO
					break;
				case ERROR:
					// TODO
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
