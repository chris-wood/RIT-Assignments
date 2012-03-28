/*
 * ITFTPclient.java
 * 
 * Version: 3/20/12
 */

import java.io.IOException;
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
	 * TODO
	 * 
	 * @param host
	 * @param port
	 * @param timeout
	 * @throws UnknownHostException
	 * @throws IOException
	 */
	public void open(String host, int port, int timeout) throws UnknownHostException,
		IOException;
	
	/**
	 * TODO
	 */
	public void close();
	
	/**
	 * TODO
	 * 
	 * @param message
	 * @throws IOException
	 * @throws UnknownHostException
	 */
	public void sendMessage(TFTPmessage message) throws IOException, UnknownHostException;
	
	/**
	 * TODO
	 * 
	 * @return
	 * @throws TimeoutException
	 * @throws MalformedMessageException
	 */
	public TFTPmessage getMessage() throws TimeoutException, MalformedMessageException;
}
