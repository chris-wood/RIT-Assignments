import java.io.IOException;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;

/*
 * TFTPreader.java
 * 
 * Version: 3/20/12
 */

/**
 * TODO
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class TFTPreader 
{	
	private static final int DEFAULT_TIMEOUT = 2000;
	private static final int DEFAULT_PORT = 69;
	
	private Map<Integer, byte[]> dataBlocks = new HashMap<Integer, byte[]>();
	
	public boolean appendData(DataMessage message)
	{
		boolean result = false;
		if (!dataBlocks.containsKey(message.blockNumber))
		{
			dataBlocks.put(message.blockNumber, message.data);
			result = true;
		}
		return result;
	}
	
	public void readFile(TFTPmessage.TransferMode mode, String host, String fileName)
	{
		TFTPclient client = new TFTPclient();
		try {
			client.open(host, DEFAULT_PORT, DEFAULT_TIMEOUT);
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		//client.request(ITFTPclient.Opcode.RRQ, "testing123", ITFTPclient.TransferMode.NETASCII);
		client.sendMessage(new RequestMessage("testing123", TFTPmessage.Opcode.RRQ, TFTPmessage.TransferMode.NETASCII));
		try 
		{
			try 
			{
				// Continue reading data until we reach a non-full block
				boolean transferComplete = false;
				while (!transferComplete)
				{
					TFTPmessage result = client.getMessage();
					if (result instanceof DataMessage)
					{
						DataMessage data = (DataMessage)result;
						if (appendData(data) && data.size < TFTPmessage.DATA_BLOCK_SIZE)
						{
							transferComplete = true;
						}
					}
				}
			} 
			catch (MalformedMessageException e) 
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} catch (TimeoutException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		// 1. verify valid machine/server name (else print another error - add error printing as a private static method)
		// 2. connect to the TFTP server
		// 3. transfer the file using the protocol specified
	}
	
	/**
	 * The main entry point into the program.
	 * 
	 * @param args - command line arguments containing the transfer
	 *               mode to use, the name of the host on which the
	 *               TFTP server is running, and the name of the 
	 *               file to transfer.
	 */
	public static void main(String[] args)
	{
		// Verify that the correct number of parameters was provided
		/*if (args.length != 3)
		{
			displayUsage();
		}
		else*/
		{
			//readFile("glados.cs.rit.edu", 69, "testing123");
			TFTPreader reader = new TFTPreader();
			
			// TODO: add method for param validation inside TFTPclient!
			// if (client.validHost())
			//{
			//	if valid transfer mode
			//    do the read...
			//}
			
			reader.readFile(TFTPmessage.TransferMode.NETASCII, "glados.cs.rit.edu", "testing123");
		}
	}
	
	/**
	 * Simple helper method that displays the usage message that explains
	 * how to run the TFTPreader program.
	 */
	private static void displayUsage()
	{
		System.err.println("Usage: java TFTPreader [netascii|octet] tftp-host file");
	}
}

