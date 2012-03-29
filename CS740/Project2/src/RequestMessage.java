/*
 * RequestMessage.java
 * 
 * Version: 3/20/12
 */

/**
 * This class represents a wrapper for the request
 * messages that are sent back and forth between the TFTP
 * client and server.
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class RequestMessage extends TFTPmessage 
{
	/**
	 * The file name associated with this request.
	 */
	public String fileName;
	
	/**
	 * The opcode for this request (read or write).
	 */
	public Opcode opcode;
	
	/**
	 * The transfer mode for this request.
	 */
	public TransferMode transferMode;
	
	/**
	 * Create a new request message with the specified file name, request
	 * type, and transfer mode. 
	 * 
	 * @param name - name of the file for this request.
	 * @param code - type of request (read or write).
	 * @param mode - transfer mode (netascci or octet).
	 */
	public RequestMessage(String name, Opcode code, TransferMode mode)
	{
		fileName = name;
		opcode = code;
		transferMode = mode;
	}

	/**
	 * Create a new request message from the raw packet data received 
	 * from the server.
	 * 
	 * @param packet - raw packet data.
	 */
	public RequestMessage(byte[] packet)
	{
		// TODO
	}

	/**
	 * Build and return the raw data that represents this acknowledgment message.
	 */
	@Override
	public byte[] rawData() 
	{
		// Create the byte array message content
		byte[] codeBuffer = intToByteArray(opcode.getValue(), OPCODE_SIZE);
		char[] fileBuffer = fileName.toCharArray();
		char[] modeBuffer = transferMode.getValue().toCharArray();
		
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
		
		return rawData;
	}
}

