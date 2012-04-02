import java.net.DatagramPacket;

/*
 * ErrorMessage.java
 * 
 * Version: 3/20/12
 */

/**
 * This class represents a wrapper for the error
 * messages that are sent back and forth between the TFTP
 * client and server.
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class ErrorMessage extends TFTPmessage 
{
	/**
	 * The error number returned from the server.
	 */
	public int errorNumber;
	
	/**
	 * The error message associated with this error number.
	 */
	public String errorMessage;
	
	/**
	 * Create a new error message from the specified error code and 
	 * error message.
	 * 
	 * @param number - the error code.
	 * @param message - the error message.
	 */
	public ErrorMessage(int number, String message)
	{
		errorNumber = number;
		errorMessage = message;
	}
	
	/**
	 * Create a new error message from the raw packet data returned 
	 * from the server.
	 * 
	 * @param packet - the packet received from the server.
	 */
	public ErrorMessage(DatagramPacket packet)
	{	
		// Rebuild the block number for this file block
		errorNumber = (int)(packet.getData()[ERROR_NUMBER_INDEX] << 8 | 
				packet.getData()[ERROR_NUMBER_INDEX + 1]);
		
		// Rebuild the error message 
		StringBuilder builder = new StringBuilder();
		for (int i = OPCODE_SIZE + ERROR_NUMBER_SIZE; i < packet.getLength(); i++)
		{
			builder.append((char)packet.getData()[i]);
		}
		errorMessage = builder.toString();
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
		byte[] codeBuffer = intToByteArray(Opcode.ACK.getValue(), OPCODE_SIZE);
		char[] errorBuffer = errorMessage.toCharArray();
		byte[] numberBuffer = intToByteArray(errorNumber, ERROR_NUMBER_SIZE);
		
		// Create a dynamically sized byte buffer
		int messageSize = codeBuffer.length + errorBuffer.length 
				+ numberBuffer.length + 1;
		byte[] rawData = new byte[messageSize];
		
		// Fill the byte array with the message contents
		int offset = 0;
		for (int i = 0; i < codeBuffer.length; i++)
		{
			rawData[offset++] = codeBuffer[i];
		}
		for (int i = 0; i < numberBuffer.length; i++)
		{
			rawData[offset++] = numberBuffer[i]; 
		}
		for (int i = 0; i < errorBuffer.length; i++)
		{
			rawData[offset++] = (byte)errorBuffer[i]; 
		}
		rawData[offset++] = MESSAGE_PAD;
		
		return rawData;
	}
	
	/**
	 * Return a friendly version of the acknowledgment packet for debug purposes.
	 * 
	 * @return readable version of this acknowledgment message.
	 */
	@Override
	public String toString()
	{
		return "Error code " + errorNumber + ": " + errorMessage;
	}
}
