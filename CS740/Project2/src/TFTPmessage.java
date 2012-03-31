/*
 * TFTPmessage.java
 * 
 * Version: 3/20/12
 */

/**
 * This class represents a generic message interface and parent
 * class for all messages supported by the TFTP protocol.
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public abstract class TFTPmessage 
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
		 * Internal constructor for the enumeration based
		 * on a byte value.
		 * 
		 * @param value - the value for this opcode to use.
		 */
		private Opcode(byte value)
		{
			this.value = (int)value;
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
	 * A fixed array containing references to the appropriate enumeration
	 * type, which is used when reconstructing messages from the server.
	 */
	public static final Opcode[] codes = {Opcode.RRQ, Opcode.WRQ, Opcode.DATA, Opcode.ACK, Opcode.ERROR};
	
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
	
	/**
	 * The fields representing the opcode slot size and index.
	 */
	public static final int OPCODE_SIZE = 2;
	public static final int OPCODE_INDEX = 0;
	
	/**
	 * The fields representing the block number slot size and index.
	 */
	public static final int BLOCK_NUMBER_SIZE = 2;
	public static final int BLOCK_NUMBER_INDEX = 2;
	
	/**
	 * The fields representing the error number slot size and index.
	 */
	public static final int ERROR_NUMBER_SIZE = 2;
	public static final int ERROR_NUMBER_INDEX = 2;
	
	/**
	 * An aggregate of all message components that indicates the maximum size
	 * for a data packet.
	 */
	public static final int MESSAGE_SIZE = DATA_BLOCK_SIZE + OPCODE_SIZE 
			+ BLOCK_NUMBER_SIZE + 2; // at most 2 zeroes for padding
	
	/**
	 * Build and return the raw data associated with this packet that
	 * conform to the TFTP protocol.
	 * 
	 * @return - raw packet contents.
	 */
	public abstract byte[] rawData();
	
	/**
	 * Public method that converts integers to byte arrays of the specified size.
	 * Used to convert client values into raw packet contents.
	 * 	
	 * @param val - the integer value to convert.
	 * @param size - the size of the output byte array.
	 * 
	 * @return - byte array of the specified size.
	 */
	public static byte[] intToByteArray(int val, int size)
	{
		byte[] data = new byte[size];
		for (int i = 0; i < data.length; i++)
		{
			data[i] = (byte)(val >> (8 * (data.length - (i + 1))));
		}
		return data;
	}
	
	/**
	 * Build a transfer mode enum based on the string representation
	 * for the mode.
	 * 
	 * @param mode - the string representation.
	 * 
	 * @return a valid TransferMode enum object if valid, else null.
	 */
	public static TransferMode buildTransferMode(String mode)
	{
		TransferMode tMode = null;
		
		if (mode.equals("netascii"))
		{
			tMode = TransferMode.NETASCII;
		}
		else if (mode.equals("octet"))
		{
			tMode = TransferMode.OCTET;
		}
		
		return tMode;
	}
}
