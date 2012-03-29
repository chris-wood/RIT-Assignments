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
	 * @param size - size of the packet data.
	 */
	public DataMessage(DatagramPacket packet)
	{
		size = packet.getLength();
		port = packet.getPort(); 
		blockNumber = (int)(packet.getData()[BLOCK_NUMBER_INDEX] << 8 | packet.getData()[BLOCK_NUMBER_INDEX + 1]);
		
		// Copy the data from the packet into this data buffer.
		data = new byte[size - (OPCODE_SIZE + BLOCK_NUMBER_SIZE)];
		for (int i = OPCODE_SIZE + BLOCK_NUMBER_SIZE, index = 0; i < size; i++, index++)
		{
			data[index] = packet.getData()[i];
		}
	}

	/**
	 * Build and return the raw data that represents this data message.
	 */
	@Override
	public byte[] rawData() 
	{
		// TODO
		return null;
	}
}
