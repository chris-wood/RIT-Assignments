import java.net.DatagramPacket;

/*
 * DataMessage.java
 * 
 * Version: 3/20/12
 */

/**
 * This class represents a wrapper for the data
 * messages that are sent back and forth between the TFTP
 * client and server.
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class DataMessage extends TFTPmessage 
{
	/**
	 * The block number of the file that this data represents.
	 */
	public int blockNumber;
	
	/**
	 * The size of this data block.
	 */
	public int size;
	
	/**
	 * The raw file data itself.
	 */
	public byte[] data;
	
	/**
	 * The new port to handle the data communication.
	 */
	public int port;
	
	/**
	 * Create a data message from the block number and data associated with it.
	 * 
	 * @param number - block number.
	 * @param data - data for this file block.
	 * @param port - the port for communication with the server.
	 */
	public DataMessage(int number, byte[] data, int port)
	{
		blockNumber = number;
		this.data = data;
		this.port = port;
	}
	
	/**
	 * Create a data message from the raw packet data and its size.
	 * 
	 * @param packet - raw packet data.
	 */
	public DataMessage(DatagramPacket packet)
	{
		// Fetch and store the packet transfer port and payload size
		size = packet.getLength();
		port = packet.getPort(); 
		
		// Rebuild the block number for this file block
		blockNumber = (int)(packet.getData()[BLOCK_NUMBER_INDEX] << 8 | 
				packet.getData()[BLOCK_NUMBER_INDEX + 1]);
		
		// Rebuild the raw data 
		data = new byte[size - (OPCODE_SIZE + BLOCK_NUMBER_SIZE)];
		for (int i = OPCODE_SIZE + BLOCK_NUMBER_SIZE, index = 0; i < size; i++, index++)
		{
			data[index] = packet.getData()[i];
		}
	}

	/**
	 * Build and return the raw data associated with this packet that
	 * conform to the TFTP protocol.
	 * 
	 * @return - raw packet contents.
	 */
	@Override
	public byte[] rawData() 
	{
		// Create the byte array message content
		byte[] codeBuffer = intToByteArray(Opcode.DATA.getValue(), OPCODE_SIZE);
		byte[] blockBuffer = intToByteArray(blockNumber, OPCODE_SIZE);
		
		// Create a dynamically sized byte buffer
		int messageSize = codeBuffer.length + blockBuffer.length 
				+ data.length;
		byte[] rawData = new byte[messageSize];
		
		// Fill the byte array with the message contents
		int offset = 0;
		for (int i = 0; i < codeBuffer.length; i++)
		{
			rawData[offset++] = codeBuffer[i];
		}
		for (int i = 0; i < blockBuffer.length; i++)
		{
			rawData[offset++] = blockBuffer[i]; 
		}
		for (int i = 0; i < data.length; i++)
		{
			rawData[offset++] = data[i]; 
		}
		
		return rawData;
	}
	
	/**
	 * Return a friendly version of the data packet for debug purposes.
	 * 
	 * @return readable version of this data message.
	 */
	@Override
	public String toString()
	{
		StringBuilder builder = new StringBuilder("DATA[" + blockNumber + ": ");
		for (int i = 0; i < data.length; i++)
		{
			builder.append(data[i] + " ");
		}
		builder.append("\n");
		return builder.toString();
	}
}
