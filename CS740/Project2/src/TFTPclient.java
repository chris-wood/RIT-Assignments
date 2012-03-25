import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Arrays;

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
	public void open(String host, int port) throws UnknownHostException,
			IOException {
		clientSocket = new DatagramSocket();
		clientSocket.setSoTimeout(2000); // TODO: fix the magic number
		System.out.println("clientSocket connection? " + clientSocket.isConnected());
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
	public byte[] request(Opcode code, String fileName, TransferMode mode)
	{
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
			System.out.println(codeBuffer[i]);
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
		rawData[offset++] = MESSAGE_PAD;;
		
		System.out.print("here we go: ");
		for (int i = 0; i < rawData.length; i++)
		{
			System.out.print(rawData[i] + " " );
		}
		
		// Create the UDP packet here
		InetAddress IPAddress = null;
		try {
			IPAddress = InetAddress.getByName(host);
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		DatagramPacket packet = new DatagramPacket(rawData, rawData.length, IPAddress, port);
		try {
			clientSocket.send(packet);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		// Now try to receive (just debugging the connection status now)
		System.out.println("asdads!");
		System.out.println("receiving...");
		byte[] receiveData = new byte[1024];
		DatagramPacket receivePacket = new DatagramPacket(receiveData, receiveData.length);
	    try {
			clientSocket.receive(receivePacket);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    System.out.println("well at least it worked...");
	    for (int i = 0; i < receiveData.length; i++)
		{
			System.out.print(receiveData[i] + " " );
		}
		
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void sendData(byte[] data) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void sendAck(int blockNumber) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public byte[] getMessage(long timeout) throws TimeoutException {
		// TODO Auto-generated method stub
		return null;
	}
	
	private byte[] opcodeToByteArray(Opcode code)
	{
		byte[] data = new byte[OPCODE_SIZE];
		for (int i = 0; i < data.length; i++)
		{
			data[i] = (byte)(code.getValue() >> (8 * (data.length - (i + 1))));
		}
		return data;
	}
}
