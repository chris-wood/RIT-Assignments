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
	 * erorr message.
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
	 * @param packet - raw packet data.
	 * @param size - size of the packet data.
	 */
	public ErrorMessage(byte[] packet, int size)
	{
		// TODO
	}

	/**
	 * Build and return the raw data that represents this error message.
	 */
	@Override
	public byte[] rawData() 
	{
		// TODO 
		return null;
	}
}
