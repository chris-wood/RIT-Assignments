
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
		ERROR(5),
		INVALID(6);
		
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
		
		// TODO
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
	
	public static final int OPCODE_SIZE = 2;
	
	public static final int BLOCK_NUMBER_SIZE = 2;
	
	public static final int MESSAGE_SIZE = DATA_BLOCK_SIZE + OPCODE_SIZE + BLOCK_NUMBER_SIZE + 2; // at most 2 zeroes for padding
	
	public abstract byte[] rawData();
	
	/**
	 * TODO
	 * 	
	 * @param code
	 * 
	 * @return
	 */
	public byte[] intToByteArray(int val, int size)
	{
		byte[] data = new byte[size];
		for (int i = 0; i < data.length; i++)
		{
			data[i] = (byte)(val >> (8 * (data.length - (i + 1))));
		}
		return data;
	}
}
