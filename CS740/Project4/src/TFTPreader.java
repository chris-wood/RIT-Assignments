import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;
import java.nio.ByteBuffer;
import java.util.ArrayList;
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
	private static final int DEFAULT_PORT = 7001;
	
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
			else
			{
				System.err.println("TFTPreader: Error: Invalid transfer mode.");
			}
		} 
		catch (UnknownHostException e) 
		{
			System.err.println("TFTPreader: Error: " + host + 
					" is an invalid machine name.");
		}
		
		return valid;
	}
	
	/**
	 * Attempt to read a file from the TFTP server and write it to the disk.
	 * 
	 * @param mode - the transfer mode to use for the file reception.
	 * @param host - the host server name where the TFTP program is located.
	 * @param fileName - the file to receive.
	 * @param corrupt - boolean flag indicating whether or not we are dealing 
	 * 					with corrpt data
	 */
	public void receiveFile(TFTPmessage.TransferMode mode, String host, 
			String fileName, boolean corrupt)
	{
		TFTPclient client = new TFTPclient();
		Map<Integer, byte[]> dataBlocks = new HashMap<Integer, byte[]>();
		
		try 
		{
			// Open the client to begin the transfer
			client.open(host, DEFAULT_TIMEOUT);
		} 
		catch (UnknownHostException e) 
		{
			System.err.println("TFTPreader: Error: " + host + 
					" is an invalid machine name.");
			return;
		} 
		catch (IOException e) 
		{
			System.err.println("TFTPreader: Error: " + e.getMessage());
			return;
		}
		
		try 
		{
			// Send the appropriate request
			TFTPmessage result = null;
			if (!corrupt)
			{
				// Send a request for a new file to the client
				result = client.sendAndReceiveMessage(new RequestMessage(fileName, TFTPmessage.Opcode.RRQ, mode), 
						DEFAULT_PORT, RETRY_TIMES);
			}
			else
			{
				result = client.sendAndReceiveMessage(new RequestMessage(fileName, TFTPmessage.Opcode.CRRQ, mode), 
						DEFAULT_PORT, RETRY_TIMES);
			}

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
					else
					{
						// Relay another ack message to get the next data block
						System.err.println("TFTPreader: Error: duplicate data block " +
								"received. Retransmitting last ACK message.");
						result = client.sendAndReceiveMessage(new 
								AckMessage(msg.getBlockNumber()), msg.getPort(), 
								RETRY_TIMES);
					}
				}
				else if (result instanceof ErrorMessage)
				{
					ErrorMessage msg = (ErrorMessage)result;
					System.err.println("TFTPreader: " + msg.toString());
					return;
				}
			}
			
			// Finally, write the file contents to the disk and clean up.
			writeFile(fileName, dataBlocks, corrupt);
			client.close();
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
	 * transmission is complete. Data blocks are only appended
	 * if they are "new" (i.e. not received already).
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
			if (message.getData() != null)
			{
				dataBlocks.put(message.getBlockNumber(), message.getData());
			}
			result = true;
		}
		return result;
	}
	
	/**
	 * Write the data provided to disk under the file name specified.
	 * 
	 * @param file - the file to store the data.
	 * @param data - the file data, partitioned by block number.
	 * @param corrupt - boolean flag indicating if the data is potentially corrupt
	 */
	private void writeFile(String file, Map<Integer, byte[]> data, boolean corrupt)
	{
		try 
		{
			// Create (overwrite, if already present) the new file
			FileOutputStream fos = new FileOutputStream(file, false);
			
			// Decode the data if it is corrupt
			//if (corrupt)
			{
				// Initialize the decoder and storage for the file data
				BCHDecoder3121 decoder = new BCHDecoder3121();
				ArrayList<Byte> byteData = new ArrayList<Byte>();
				ArrayList<Integer> correctData = new ArrayList<Integer>();
				
				// Break up the 512 blocks into one contiguous list
				for (int i = 1; i <= data.size(); i++)
				{
					for (int j = 0; j < data.get(i).length; j++)
					{
						byteData.add(data.get(i)[j]);
					}
				}
				
				// Iterate over each block 32 bits at a time, correct the words,
				// and then throw them in the corrected list
				for (int i = 0; i < byteData.size(); i += TFTPmessage.BYTE_PER_BLOCK)
				{
					/*
					int word = 0;
					for (int j = 0; j < TFTPmessage.BYTE_PER_BLOCK; j++)
					{
						word |= ((byteData.get(i + j)) << ((TFTPmessage.BYTE_PER_BLOCK - (j + 1)) * 8));
						System.out.print(Integer.toHexString(byteData.get(i + j)) + " (" + Integer.toHexString(word) + ") ");
					}
					System.out.println("\nResulting word = " + Integer.toHexString(word) + "\n");
					*/
					byte[] wordData = new byte[TFTPmessage.BYTE_PER_BLOCK];
					for (int j = 0; j < TFTPmessage.BYTE_PER_BLOCK; j++)
					{
						System.out.print(Integer.toBinaryString((byteData.get(i + j) & 0xFF)) + " ");
						//System.out.print(Integer.toBinaryString(byteData.get(i + j)) + " ");
						wordData[j] = (byte)(byteData.get(i + j) & 0xFF);
					}
					//int word = toInt(wordData, 0);
					//int word = ByteBuffer.wrap(wordData).getInt();
					int word = TFTPmessage.byteArrayToInt(wordData, 0, TFTPmessage.BYTE_PER_BLOCK);
					System.out.println("\nWord = " + Integer.toHexString(word));
					
					// Decode the word and then throw the data bits into the new list
					int decoded = decoder.correct(word);
					correctData.add(decoded);
					// TODO: this is a 21-bit data value
					/*
					for (int j = 0; j < decoded.length; j++)
					{
						correctData.add(decoded[j]);
					}
					*/
				}
				
				// todo
			}
			/*else
			{
				// Iterate across the entire data set and write the bytes (start at block 1)
				for (int i = 1; i <= data.size(); i++)
				{
					fos.write(data.get(i));
				}
			}*/
			
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
		//if (args.length != 3)
		//{
		//	displayUsage();
		//}
		//else
		{
			TFTPreader reader = new TFTPreader();
			if (reader.validateParameters("viking.cs.rit.edu", "octet")) //args[1], args[0]
			{
				TFTPmessage.TransferMode mode = TFTPmessage.buildTransferMode("octet"); //args[0]
				reader.receiveFile(mode, "viking.cs.rit.edu", "motd", false); //args[1], args[2]
			}
			
			/*
			BCHDecoder3121 dec2 = new BCHDecoder3121();
			BCHDecoder3116.InitializeDecoder();
			
			System.out.println("Test 1496973312 (1) - should be 0");
			int code1 = 1073741824;
			int code2 = 1342177280;
			int code3 = 1476395008;
			System.out.println("3116: " + BCHDecoder3116.correct(code1));
			System.out.println("3121: " + dec2.correct(code1));
			
			System.out.println("Test 1342177280 (2) - should be 0");
			System.out.println("3116: " + BCHDecoder3116.correct(code2));
			System.out.println("3121: " + dec2.correct(code2));
			
			System.out.println("Test: 1476395008 (3) - should be 0");
			System.out.println("3116: " + BCHDecoder3116.correct(code3));
			System.out.println("3121: " + dec2.correct(code3));
			
			int test2 = 0x96b34929;
			System.out.println("3121: " + dec2.correct(test2));*/
			
			/*
			int test = 7340032; // 2^20 + 2^21 + 2^22
			ArrayList<Integer> correctData = new ArrayList<Integer>();
			for (int i = 0; i < 100; i++)
			{
				correctData.add(test);
			}
			
			// Finally, write the data to a file
			int bitIndex = 0;
			int maxIndices = 21;
			byte tempBits = 0;
			ArrayList<Byte> bytes = new ArrayList<Byte>();
			boolean overflow = false;
			for (int i = 0; i < correctData.size(); i++)
			{
				// Detect overflow in bit conversion
				if (overflow)
				{
					byte tmp = (byte)((correctData.get(i) >> (32 - bitIndex)) & 0xFF);
					tempBits = (byte)(tempBits | tmp);
					bytes.add((byte)(tempBits & 0xFF));
					System.out.println("adding new overflow byte - block " + i + ", " + Integer.toBinaryString(tempBits));
					overflow = false;
					//bitIndex = (bitIndex + 8) % maxIndices;
				}
				
				while (bitIndex + 8 < 21)
				{
					System.out.println(Integer.toBinaryString((correctData.get(i) >> (32 - (bitIndex + 8))) & 0xFF));
					tempBits = 0;
					tempBits = (byte)((correctData.get(i) >> (32 - (bitIndex + 8))) & 0xFF);
					//System.out.println(Integer.toBinaryString(tempBits & 0xFF));
					System.out.println(Integer.toBinaryString(tempBits & 0xFF));
					bytes.add((byte)(tempBits & 0xFF));
					System.out.println(Integer.toBinaryString(bytes.get(bytes.size() - 1)));
					System.out.println("adding new byte - block " + i + ", " + Integer.toBinaryString(tempBits));
					bitIndex = (bitIndex + 8) % maxIndices;
					tempBits = 0;
				}
				
				// Handle the overflow
				tempBits = 0;
				byte tmp = (byte)((correctData.get(i) >> 11) & 0xFF);
				tempBits = (byte)(tmp & (2^(21 - bitIndex) - 1));
				tempBits = (byte)(tempBits << (8 - (21 - bitIndex)));
				overflow = true;
				bitIndex = (bitIndex + 8) % maxIndices;
				//System.out.println("overflow on block " + i + " is " + tempBits);
			}
			
			System.out.println("Converted to the following:");
			byte[] finalData = new byte[bytes.size()];
			int index = 0;
			for (Byte b : bytes)
			{
				System.out.println((byte)((int)b & 0x000000FF));
				//finalData[index++] = (byte) (b & 0xFF);
			}
			*/
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

