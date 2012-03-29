/*
 * AckMessage.java
 * 
 * Version: 3/20/12
 */

/**
 * This class represents a wrapper for the acknowledgment
 * messages that are sent back and forth between the TFTP
 * client and server.
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class AckMessage extends TFTPmessage
{
	/**
	 * The block number associated with this acknowledgment
	 */
	public int blockNumber;
	
	/**
	 * Construct an acknowledgment message from the specified block number.
	 * 
	 * @param number - the block numebr to ACK.
	 */
	public AckMessage(int number)
	{
		blockNumber = number;
	}
	
	/**
	 * Construct an acknowledgment message from the specified packet data.
	 * 
	 * @param packet - raw packet data.
	 */
	public AckMessage(byte[] packet)
	{
		// TODO
	}

	/**
	 * Build and return the raw data that represents this acknowledgment message.
	 */
	@Override
	public byte[] rawData() 
	{
		// Create the partition buffers separately 
		byte[] codeBuffer = intToByteArray(Opcode.ACK.getValue(), OPCODE_SIZE);
		byte[] blockBuffer = intToByteArray(blockNumber, BLOCK_NUMBER_SIZE);
		byte[] rawData = new byte[OPCODE_SIZE + BLOCK_NUMBER_SIZE];
		
		// Copy the contents of both arrays into the raw byte array
		int offset = 0;
		for (int i = 0; i < OPCODE_SIZE; i++)
		{
			rawData[offset++] = codeBuffer[i];
		}
		for (int i = 0; i < BLOCK_NUMBER_SIZE; i++)
		{
			rawData[offset++] = blockBuffer[i];
		}
		
		return rawData;
	}
}
