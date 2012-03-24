import java.io.IOException;
import java.net.UnknownHostException;

/*
 * ITFTPclient.java
 * 
 * Version: 3/20/12
 */

/**
 * TODO
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public interface ITFTPclient 
{	
	/**
	 * This enumeration defines the different opcodes (message types)
	 * supported by the TFTP protocol.
	 */
	public static enum Opcode {RRQ, WRQ, DATA, ACK, ERROR};
	
	/**
	 * This enumeration defines the different transfer modes supported
	 * by the TFTP protocol.
	 */
	public static enum TransferMode {OCTET, NETASCII};
	
	/**
	 * The specified data block size for each data packet.
	 */
	public static final int DATA_BLOCK_SIZE = 512;
	
	public static final int OPCODE_SIZE = 2;
	
	public static final int BLOCK_NUMBER_SIZE = 2;
	
	public static final int MESSAGE_SIZE = DATA_BLOCK_SIZE + OPCODE_SIZE + BLOCK_NUMBER_SIZE + 2; // at most 2 zeroes for padding
	
	public void open(String host, int port) throws UnknownHostException,
		IOException;
	
	public void close();
	
	/**
	 * Initialize a read request from the server to start the transfer 
	 * of a specified file on the server machine.
	 * 
	 * @param code - the type of request.
	 * @param fileName - the name of the file to receive.
	 * @param mode - the transfer mode.
	 * 
	 * @return the first 512 bytes of the specific file that is being read,
	 *         with the block number implicitly set to 1.
	 */
	public byte[] request(Opcode code, String fileName, TransferMode mode);
	
	public void sendData(byte[] data);
	
	public void sendAck(int blockNumber);
	
	public byte[] getMessage(long timeout) throws TimeoutException;
}
