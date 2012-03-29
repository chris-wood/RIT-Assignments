/*
 * ITFTPclient.java
 * 
 * Version: 3/20/12
 */

import java.io.IOException;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;

/**
 * This is the API interface for communicating with the 
 * TFTP server using TFTP messages.
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public interface ITFTPclient 
{	
	/**
	 * Open a connection to the host TFTP server to begin a file
	 * read or write operation.
	 * 
	 * @precondition - server connection not already established.
	 * @postcondition - server connection open and established.
	 * 
	 * @param host - name of the host server.
	 * @param timeout - timeout value associated with socket transmissions.
	 * 
	 * @throws UnknownHostException - when the specified host does not exist.
	 * @throws IOException - when an I/O error occurs during socket transmission.
	 */
	public void open(String host, int timeout) throws UnknownHostException,
		IOException;
	
	/**
	 * Close the connection to the host TFTP server.
	 * 
	 * @precondition - server connection established.
	 * @postcondition - server connection terminated.
	 */
	public void close();
	
	/**
	 * Send a generic TFTP message to the host server.
	 * 
	 * @precondition - server connection established.
	 * @postcondition - none.
	 * 
	 * @param message - the message to send.
	 * @param port - the port to send the message to.
	 * 
	 * @throws IOException - when an I/O error occurs during socket transmission.
	 */
	public void sendMessage(TFTPmessage message, int port) throws IOException;
	
	/**
	 * Receive a generic TFTP message from the host server.
	 * 
	 * @precondition - server connection establish.
	 * @postcondition - none.
	 * 
	 * @return - a generic TFTP message object instance. 
	 * 
	 * @throws TimeoutException - when the socket I/O times out.
	 * @throws MalformedMessageException - when the message received is not valid. 
	 */
	public TFTPmessage getMessage() throws SocketTimeoutException, 
		MalformedMessageException;
}
