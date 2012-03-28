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
	public void sendMessage(TFTPmessage message) throws IOException, 
		UnknownHostException
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
		clientSocket.send(packet);
	}

	@Override
	public TFTPmessage getMessage() throws TimeoutException, 
		MalformedMessageException 
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
	    System.out.println("");
	    
	    TFTPmessage message = buildMessage(receivePacket);
	    return message;
	}
	
	private TFTPmessage buildMessage(DatagramPacket packet) throws MalformedMessageException
	{
		TFTPmessage message = null;
		
		try
		{
			System.out.println("TELL ME ALL THE THOINGS");
			TFTPmessage.Opcode opcode = TFTPmessage.codes[(int)packet.getData()[1] - 1];
			
			// Create the appropriate packet
			switch (opcode)
			{
				case ACK:
					// TODO
					System.out.println("got this!asdasd");
					message = new AckMessage(packet.getData());
					break;
				case DATA:
					System.out.println("got this!");
					message = new DataMessage(packet.getData(), packet.getLength());
					break;
				case ERROR:
					// TODO
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
