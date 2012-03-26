
public class ErrorMessage extends TFTPmessage 
{
	public int errorNumber;
	public String errorMessage;
	
	public ErrorMessage(int number, String message)
	{
		errorNumber = number;
		errorMessage = message;
	}

	@Override
	public byte[] buildMessageData() {
		// TODO Auto-generated method stub
		return null;
	}
}
