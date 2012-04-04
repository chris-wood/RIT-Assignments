import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;
import java.util.HashMap;
import java.util.Map;

/*
 * TFTPreader.java
 * 
 * Version: 3/20/12
 */

/**
 * This class is responsible for driving the TFTP protocol
 * behavior in order to download a file specified by the user.
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class TFTPreader 
{	
	/**
	 * The default timeout value for network transmissions.
	 */
	private static final int DEFAULT_TIMEOUT = 2000;
	
	/**
	 * The default number of packet retries before failure.
	 */
	private static final int RETRY_TIMES = 5;
	
	/**
	 * The default TFTP port.
	 */
	private static final int DEFAULT_PORT = 69;
	
	/**
	 * Validate the parameters used to retrieve the file from the TFTP server.
	 * 
	 * @param host - the specified host server.
	 * @param mode - the specified transfer mode.
	 * 
	 * @return true if valid, false otherwise.
	 */
	public boolean validateParameters(String host, String mode)
	{
		boolean valid = false;
		
		try 
		{
			// Attempt to resolve this host name
			InetAddress.getByName(host);
			
			// Attempt to resolve the transfer mode to a fixed type
			if (TFTPmessage.buildTransferMode(mode) != null)
			{
				valid = true;
			}
		} 
		catch (UnknownHostException e) 
		{
			System.err.println("Error: " + host + " is an invalid machine name.");
		}
		
		return valid;
	}
	
	/**
	 * Attempt to read a file from the TFTP server and write it to the disk.
	 * 
	 * @param mode - the transfer mode to use for the file reception.
	 * @param host - the host server name where the TFTP program is located.
	 * @param fileName - the file to receive.
	 */
	public void receiveFile(TFTPmessage.TransferMode mode, String host, String fileName)
	{
		TFTPclient client = new TFTPclient();
		Map<Integer, byte[]> dataBlocks = new HashMap<Integer, byte[]>();
		try 
		{
			client.open(host, DEFAULT_TIMEOUT);
		} 
		catch (UnknownHostException e) 
		{
			System.err.println("Error: " + host + " is an invalid machine name.");
			return;
		} 
		catch (IOException e) 
		{
			System.err.println("Error: " + e.getMessage());
			return;
		}
		
		// If we got here then no errors have occurred when communicating with
		// the TFTP server, so proceed as usual
		try 
		{
			// Send a request for a new file to the client
			TFTPmessage result = client.sendAndReceiveMessage(new 
					RequestMessage(fileName, TFTPmessage.Opcode.RRQ, mode), 
					DEFAULT_PORT, RETRY_TIMES);

			// Continue reading data until we reach a non-full block
			boolean transferComplete = false;
			while (!transferComplete)
			{
				if (result instanceof DataMessage)
				{
					DataMessage msg = (DataMessage)result;
					
					// Attempt to append the message, which will succeed if 
					// we have not seen this block number yet
					if (appendData(dataBlocks, msg))
					{
						// Determine if we should ask for more data or 
						// end the file transfer.
						if (msg.getSize() < TFTPmessage.DATA_BLOCK_SIZE)
						{
							transferComplete = true;
						}
						else
						{
							result = client.sendAndReceiveMessage(new 
									AckMessage(msg.getBlockNumber()), msg.getPort(), 
									RETRY_TIMES);
						}
					}
				}
				else if (result instanceof ErrorMessage)
				{
					ErrorMessage msg = (ErrorMessage)result;
					System.err.println(msg.toString());
					return;
				}
				else
				{
					System.out.println("WTF");
				}
			}
			
			// Finally, write the file contents to the disk.
			writeFile(fileName, dataBlocks);
		} 
		catch (SocketTimeoutException e)
		{
			System.err.println("TFTPreader: " + e.getMessage());
		}
		catch (MalformedMessageException e)
		{
			System.err.println("TFTPreader: " + e.getMessage());
		}
		catch (IOException e)
		{
			System.err.println("TFTPreader: " + e.getMessage());
		}
	}
	
	/**
	 * Append a block of data to the file buffer that is in memory
	 * so that it can be written to the disk once the file 
	 * transmission is complete.
	 * 
	 * @param dataBlocks - the file buffer that maps file blocks to raw data.
	 * @param message - the data message that conains the bytes to add to the buffer.
	 * 
	 * @return true if successful (block number not present), false otherwise.
	 */
	private boolean appendData(Map<Integer, byte[]> dataBlocks, DataMessage message)
	{
		boolean result = false;
		if (!dataBlocks.containsKey(message.getBlockNumber()))
		{
			dataBlocks.put(message.getBlockNumber(), message.getData());
			result = true;
		}
		return result;
	}
	
	/**
	 * Write the data provided to disk under the file name specified.
	 * 
	 * @param file - the file to store the data.
	 * @param data - the file data, partitioned by block number.
	 */
	private void writeFile(String file, Map<Integer, byte[]> data)
	{
		try 
		{
			// Create (overwrite, if already present) the new file
			FileOutputStream fos = new FileOutputStream(file, false);
			
			// Iterate across the entire data set and write the bytes
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
			TFTPreader reader = new TFTPreader();
			if (reader.validateParameters(args[1], args[0]))
			{
				TFTPmessage.TransferMode mode = TFTPmessage.buildTransferMode(args[0]);
				reader.receiveFile(mode, args[1], args[2]);
			}		
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

