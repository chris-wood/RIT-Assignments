
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
	
	public RequestMessage(byte[] packet)
	{
		// TODO
	}

	@Override
	public byte[] rawData() 
	{
		// Create the byte array message content
		byte[] codeBuffer = intToByteArray(opcode.getValue(), OPCODE_SIZE);
		char[] fileBuffer = fileName.toCharArray();
		char[] modeBuffer = transferMode.getValue().toCharArray();
		
		// Create a dynamically sized byte buffer
		int messageSize = codeBuffer.length + fileBuffer.length 
				+ modeBuffer.length + 2;
		byte[] rawData = new byte[messageSize];
		
		// Fill the byte array with the message contents
		int offset = 0;
		for (int i = 0; i < codeBuffer.length; i++)
		{
			rawData[offset++] = codeBuffer[i];
		}
		for (int i = 0; i < fileBuffer.length; i++)
		{
			rawData[offset++] = (byte)fileBuffer[i]; 
		}
		rawData[offset++] = MESSAGE_PAD;;
		for (int i = 0; i < modeBuffer.length; i++)
		{
			rawData[offset++] = (byte)modeBuffer[i]; 
		}
		rawData[offset++] = MESSAGE_PAD;
		
		return rawData;
	}
}
