/*
 * MalformedMessageException.java
 * 
 * Version: 3/20/12
 */

/**
 * This class represents a basic exception that is to be thrown
 * when the client receives an invalid or malformed message
 * from the TFTP server.
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class MalformedMessageException extends Exception
{
	/**
	 * The UID for this message
	 */
	private static final long serialVersionUID = 2L;

	/**
	 * Create a new exception with the fixed string, and include
	 * the server that caused the error.
	 * 
	 * @param server - the host server name.
	 */
	public MalformedMessageException(String server)
	{
		super("Malformed message received from the server: " + server);
	}
}
