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
		/*
		// Create the byte array message content
		byte[] codeBuffer = opcodeToByteArray(code);
		char[] fileBuffer = fileName.toCharArray();
		char[] modeBuffer = mode.getValue().toCharArray();
		
		// Create a dynamically sized byte buffer
		int messageSize = codeBuffer.length + fileBuffer.length 
				+ modeBuffer.length + 2;
		byte[] rawData = new byte[messageSize];
		
		// Fill the byte array with the message contents
		int offset = 0;
		for (int i = 0; i < codeBuffer.length; i++)
		{
			rawData[offset++] = codeBuffer[i];
		}
		for (int i = 0; i < fileBuffer.length; i++)
		{
			rawData[offset++] = (byte)fileBuffer[i]; 
		}
		rawData[offset++] = MESSAGE_PAD;;
		for (int i = 0; i < modeBuffer.length; i++)
		{
			rawData[offset++] = (byte)modeBuffer[i]; 
		}
		rawData[offset++] = MESSAGE_PAD;
		
		// Create and send the UDP packet  
		InetAddress IPAddress = null;
		try {
			IPAddress = InetAddress.getByName(host);
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		DatagramPacket packet = new DatagramPacket(rawData, rawData.length, IPAddress, port);
		System.out.print("Data sent: ");
		for (int i = 0; i < rawData.length; i++)
		{
			System.out.print(rawData[i] + " ");
		}
		System.out.println();
		try {
			clientSocket.send(packet);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		*/
	}

	@Override
	public TFTPmessage getMessage() throws TimeoutException 
	{
		return null;	
		/*
		// Now try to receive (just debugging the connection status now)
		int messageSize = ITFTPmessage.MESSAGE_SIZE;
		byte[] receiveData = new byte[messageSize];
		DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
	    try {
			clientSocket.receive(receivePacket);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    System.out.print("Data received: ");
	    for (int i = 0; i < receiveData.length; i++)
		{
			System.out.print(receiveData[i] + " " );
		}
	    
	    int index = 0;
	    for (index = OPCODE_SIZE + BLOCK_NUMBER_SIZE; index < receiveData.length; index++)
	    {
	    	if (receiveData[index] == 0)
	    	{
	    		break;
	    	}
	    }
		
		// TODO Auto-generated method stub
	    // TODO: change this plz...
		return Arrays.copyOfRange(receiveData, 4, index);
		*/
	}
}
