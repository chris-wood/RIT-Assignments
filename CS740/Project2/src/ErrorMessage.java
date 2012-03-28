
public class ErrorMessage extends TFTPmessage 
{
	public int errorNumber;
	public String errorMessage;
	
	public ErrorMessage(int number, String message)
	{
		errorNumber = number;
		errorMessage = message;
	}
	
	public ErrorMessage(byte[] packet, int size)
	{
		// TODO
	}

	@Override
	public byte[] rawData() {
		// TODO Auto-generated method stub
		return null;
	}
}
