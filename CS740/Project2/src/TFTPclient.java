import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
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
	
	private DatagramSocket clientSocket;
	private String host;
	private int port;
	
	@Override
	public void open(String host, int port) throws UnknownHostException,
			IOException {
		clientSocket = new DatagramSocket();
	}

	@Override
	public void close() {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public byte[] request(Opcode code, String fileName, TransferMode mode)
	{
		int messageSize = MESSAGE_SIZE;
		byte[] sendData = new byte[messageSize];
		
		// TODO: form the message, and then send it out
		
		//DatagramPacket packet = new DatagramPacket();
		
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
}
