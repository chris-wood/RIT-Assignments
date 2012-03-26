
public class DataMessage extends TFTPmessage 
{
	public int blockNumber;
	public byte[] data;
	
	public DataMessage(int number, byte[] data)
	{
		blockNumber = number;
		this.data = data;
	}

	@Override
	public byte[] buildMessageData() {
		// TODO Auto-generated method stub
		return null;
	}
}
