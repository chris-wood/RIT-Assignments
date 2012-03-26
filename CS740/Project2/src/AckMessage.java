
public class AckMessage extends TFTPmessage
{
	public int blockNumber;
	
	public AckMessage(int number)
	{
		blockNumber = number;
	}

	@Override
	public byte[] buildMessageData() {
		// TODO Auto-generated method stub
		return null;
	}
}
