
public class AckMessage extends TFTPmessage
{
	public int blockNumber;
	
	public AckMessage(int number)
	{
		blockNumber = number;
	}
	
	public AckMessage(byte[] packet)
	{
		// TODO
	}

	@Override
	public byte[] rawData() 
	{
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
