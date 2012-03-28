import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.UnknownHostException;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
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
	
	public boolean appendData(Map<Integer, byte[]> dataBlocks, DataMessage message)
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
		Map<Integer, byte[]> dataBlocks = new HashMap<Integer, byte[]>();
		try 
		{
			client.open(host, DEFAULT_PORT, DEFAULT_TIMEOUT);
		} 
		catch (UnknownHostException e) 
		{
			e.printStackTrace();
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
		
		// Send a request for a new file to the client
		try 
		{
			client.sendMessage(new RequestMessage(fileName, TFTPmessage.Opcode.RRQ, TFTPmessage.TransferMode.NETASCII));
			try 
			{
				// Continue reading data until we reach a non-full block
				boolean transferComplete = false;
				while (!transferComplete)
				{
					TFTPmessage result = client.getMessage();
					if (result instanceof DataMessage)
					{
						DataMessage msg = (DataMessage)result;
						
						// Attempt to append the message, which will succeed if 
						// we have not seen this block number yet
						if (appendData(dataBlocks, msg))
						{
							// Determine if we should ask for more data or 
							// end the file transfer.
							if (msg.size < TFTPmessage.DATA_BLOCK_SIZE)
							{
								transferComplete = true;
							}
							else
							{
								System.out.println("Sending ack for block " + msg.blockNumber);
								client.sendMessage(new AckMessage(msg.blockNumber));
							}
						}
					}
					else if (result instanceof ErrorMessage)
					{
						System.err.println("OH NO");
						// TODO
						return;
					}
				}
				
				System.out.println("Transfer complete.");
				writeFile(fileName, dataBlocks);
			} 
			catch (MalformedMessageException e) 
			{
				e.printStackTrace();
			}
		} 
		catch (TimeoutException e1) 
		{
			e1.printStackTrace();
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}
		// 1. verify valid machine/server name (else print another error - add error printing as a private static method)
		// 2. connect to the TFTP server
		// 3. transfer the file using the protocol specified
	}
	
	private void writeFile(String file, Map<Integer, byte[]> data)
	{
		try 
		{
			// Create (overwrite, if already present) the new file
			FileOutputStream fos = new FileOutputStream(file, false);
			
			// Iterate across the entire data set and write the bytes
			System.out.println("here we go...");
			for (int i = 1; i <= data.size(); i++)
			{
				fos.write(data.get(i));
			}
			
			// Flush and close the stream to finish
			fos.flush();
			fos.close();
		}
		catch (FileNotFoundException e)
		{
			e.printStackTrace();
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
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
		if (args.length != 3)
		{
			displayUsage();
		}
		else
		{
			//readFile("glados.cs.rit.edu", 69, "testing123");
			TFTPreader reader = new TFTPreader();
			
			// TODO: add method for param validation inside TFTPclient!
			// if (client.validHost())
			//{
			//	if valid transfer mode
			//    do the read...
			//}
			
			reader.readFile(TFTPmessage.TransferMode.NETASCII, "glados.cs.rit.edu", "test1.txt");
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

