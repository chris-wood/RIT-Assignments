import java.io.IOException;
import java.net.UnknownHostException;

/*
 * ITFTPclient.java
 * 
 * Version: 3/20/12
 */

/**
 * TODO
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public interface ITFTPclient 
{	
	/**
	 * The pad string used to separate blocks of data in TFTP messages. 
	 */
	public static final byte MESSAGE_PAD = 0;
	
	/**
	 * This enumeration defines the different opcodes (message types)
	 * supported by the TFTP protocol.
	 */
	public static enum Opcode 
	{
		RRQ(1), 
		WRQ(2), 
		DATA(3), 
		ACK(4), 
		ERROR(5);
		
		/**
		 * The value associated with this opcode
		 */
		private int value;    

		/**
		 * Internal constructor for the enumeration.
		 * 
		 * @param value - the value for the opcode to use.
		 */
		private Opcode(int value) 
		{
			this.value = value;
		}

		/**
		 * Retrieve the opcode value.
		 * 
		 * @return opcode value.
		 */
		public int getValue() 
		{
			return value;
		}
	};
	
	/**
	 * This enumeration defines the different transfer modes supported
	 * by the TFTP protocol.
	 */
	public static enum TransferMode 
	{
		OCTET("octet"), 
		NETASCII("netascii");
		
		/**
		 * The value associated with this opcode
		 */
		private String value;    

		/**
		 * Internal constructor for the enumeration.
		 * 
		 * @param value - the value for the opcode to use.
		 */
		private TransferMode(String value) 
		{
			this.value = value;
		}

		/**
		 * Retrieve the opcode value.
		 * 
		 * @return opcode value.
		 */
		public String getValue() 
		{
			return value;
		}
	}; 
	
	/**
	 * The specified data block size for each data packet.
	 */
	public static final int DATA_BLOCK_SIZE = 512;
	
	public static final int OPCODE_SIZE = 2;
	
	public static final int BLOCK_NUMBER_SIZE = 2;
	
	public static final int MESSAGE_SIZE = DATA_BLOCK_SIZE + OPCODE_SIZE + BLOCK_NUMBER_SIZE + 2; // at most 2 zeroes for padding
	
	public void open(String host, int port) throws UnknownHostException,
		IOException;
	
	public void close();
	
	/**
	 * Initialize a read request from the server to start the transfer 
	 * of a specified file on the server machine.
	 * 
	 * @param code - the type of request.
	 * @param fileName - the name of the file to receive.
	 * @param mode - the transfer mode.
	 * 
	 * @return the first 512 bytes of the specific file that is being read,
	 *         with the block number implicitly set to 1.
	 */
	public byte[] request(Opcode code, String fileName, TransferMode mode);
	
	public void sendData(byte[] data);
	
	public void sendAck(int blockNumber);
	
	public byte[] getMessage(long timeout) throws TimeoutException;
}
