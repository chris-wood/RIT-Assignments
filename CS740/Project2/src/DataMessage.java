
public class DataMessage extends TFTPmessage 
{
	public int blockNumber;
	public int size;
	public byte[] data;
	
	public DataMessage(int number, byte[] data)
	{
		blockNumber = number;
		this.data = data;
	}
	
	public DataMessage(byte[] packet, int size)
	{
		this.size = size;
		blockNumber = (int)(packet[BLOCK_NUMBER_INDEX] << 8 | packet[BLOCK_NUMBER_INDEX + 1]);
		data = new byte[size - (OPCODE_SIZE + BLOCK_NUMBER_SIZE)];
		for (int i = OPCODE_SIZE + BLOCK_NUMBER_SIZE, index = 0; i < size; i++, index++)
		{
			System.out.println("lolol: " + packet[i]);
			data[index] = packet[i];
		}
	}

	@Override
	public byte[] rawData() 
	{
		// TODO- Auto-generated method stub
		return null;
	}
}
