
public class DataMessage extends TFTPmessage 
{
	public int blockNumber;
	public byte[] data;
	
	public DataMessage(int number, byte[] data)
	{
		blockNumber = number;
		this.data = data;
	}
	
	public DataMessage(byte[] packet)
	{
		// TODO
	}

	@Override
	public byte[] rawData() 
	{
		// TODO Auto-generated method stub
		return null;
	}
}
