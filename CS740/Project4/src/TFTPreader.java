import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/*
 * TFTPreader.java
 * 
 * Version: 5/7/12
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
	 * 
	 * @return true if valid, false otherwise.
	 */
	public boolean validateParameters(String host)
	{
		boolean valid = false;
		
		try 
		{
			// Attempt to resolve this host name
			InetAddress.getByName(host);
			valid = true;
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
	 */
	public void receiveFile(TFTPmessage.TransferMode mode, String host, 
			String fileName)
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
			TFTPmessage result = client.sendAndReceiveMessage(new RequestMessage(fileName, 
					TFTPmessage.Opcode.CRRQ, mode), DEFAULT_PORT, RETRY_TIMES);

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
			writeFile(fileName, dataBlocks);
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
	 */
	private void writeFile(String file, Map<Integer, byte[]> data)
	{
		try 
		{
			// Create (overwrite, if already present) the new file
			FileOutputStream fos = new FileOutputStream(file, false);
			
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
				byte[] wordData = new byte[TFTPmessage.BYTE_PER_BLOCK];
				for (int j = 0; j < TFTPmessage.BYTE_PER_BLOCK; j++)
				{
					wordData[j] = (byte)(byteData.get(i + j) & 0xFF);
				}
				
				// Swap because of network byte ordering
				int word = Integer.reverseBytes(TFTPmessage.byteArrayToInt(wordData, 0, 
						TFTPmessage.BYTE_PER_BLOCK));
				
				// Decode the word and then throw the data bits into the new list
				int decoded = decoder.correct(word);
				correctData.add(decoded);
			}
			
			// Group the 21-bit integers into valid bytes to write to the file 
			int bitIndex = 0;
			byte tempBits = 0;
			ArrayList<Byte> bytes = new ArrayList<Byte>();
			boolean overflow = false;
			for (int i = 0; i < correctData.size(); i++)
			{	
				// Swap Endianness of the data 
				int word = Integer.reverse(correctData.get(i));
				
				// Shift down by 11 bits and store the remaining words
				word = (word << BCHDecoder3121.CKSUM_BITS) & BCHDecoder3121.WORD_MASK; 
				
				// Detect overflow in bit conversion
				if (overflow)
				{
					byte tmp = (byte)((word >> (BCHDecoder3121.WORD_BITS - bitIndex)) & 
						(int)(Math.pow(2, bitIndex) - 1)); 
					tempBits = (byte)((tempBits | tmp) & 0xFF);
					bytes.add((byte)((Integer.reverse((byte) (tempBits & 0xFF)) >> 
						(BCHDecoder3121.DATA_BYTES * 8)) & 0xFF));
					overflow = false;
				}
				
				// Read as many bits as possible until we need to the next word of data
				while (bitIndex + 8 < BCHDecoder3121.DATA_BITS)
				{
					tempBits = 0;
					tempBits = (byte)((word >> (BCHDecoder3121.WORD_BITS - (bitIndex + 8))) & 0xFF);
					
					// Add the stripped out byte to a bin and update the bit index
					bytes.add((byte)((Integer.reverse((byte) (tempBits & 0xFF)) >> 
						(BCHDecoder3121.DATA_BYTES * 8)) & 0xFF));
					bitIndex = (bitIndex + 8) % BCHDecoder3121.DATA_BITS;
					tempBits = 0;
				}
				
				// Handle the overflow into the next word
				tempBits = 0;
				byte tmp = (byte)((word >> 11) & 0xFF);
				tempBits = (byte)(tmp & ((int)Math.pow(2, BCHDecoder3121.DATA_BITS - bitIndex) - 1));
				tempBits = (byte)(tempBits << (8 - (BCHDecoder3121.DATA_BITS - bitIndex)));
				overflow = true;
				bitIndex = (bitIndex + 8) % BCHDecoder3121.DATA_BITS;
			}
			
			// Write out the data
			for (Byte b : bytes)
			{
				fos.write(b);
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
		if (args.length != 2)
		{
			displayUsage();
		}
		else
		{
			TFTPreader reader = new TFTPreader();
			if (reader.validateParameters(args[0])) 
			{ 
				reader.receiveFile(TFTPmessage.TransferMode.OCTET, args[0], args[1]); 
			}
		}
	}
	
	/**
	 * Simple helper method that displays the usage message that explains
	 * how to run the TFTPreader program.
	 */
	private static void displayUsage()
	{
		System.err.println("Usage: java TFTPreader tftp-host file");
	}
}

