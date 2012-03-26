
public class RequestMessage extends TFTPmessage 
{
	public String fileName;
	public Opcode opcode;
	public TransferMode transferMode;
	
	public RequestMessage(String name, Opcode code, TransferMode mode)
	{
		fileName = name;
		opcode = code;
		transferMode = mode;
	}

	@Override
	public byte[] buildMessageData() {
		// TODO Auto-generated method stub
		return null;
	}
}
