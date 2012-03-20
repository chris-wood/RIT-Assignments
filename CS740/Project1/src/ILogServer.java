/*
 * LogClient.java
 * 
 * Version: 3/14/12
 */

import java.io.IOException;
import java.util.List;
import java.net.UnknownHostException;

/**
 * The API for the log service.
 *
 * @author Paul Tymann (ptt@cs.rit.edu)
 * @contributor Christopher Wood (caw4567@rit.edu)
 */
public interface ILogServer 
{
	// Message types
	
	/**
	 * A request for a new ticket.
	 */
	public static final char TKT = '0';
	
	/**
	 * Enter a message into a log.
	 */
	public static final char LOG = '1';
	
	/**
	 * Release a ticket.
	 */
	public static final char REL = '2';
	
	/**
	 * Get the messages in a log.
	 */
	public static final char GET = '3';

	/**
	 * Open a connection with a log server.
	 * 
	 * @param host name of the host to connect to
	 * @param port the port the server is listening on
	 * 
	 * @throws UnknownHostException if the hostname is invalid
	 * @throws IOException if a connection cannot be established
	 */
	public void open(String host, int port) 
		throws UnknownHostException, IOException;
	
	/**
	 * Close the connection with the server
	 */
	public void close();
	
	/**
	 * Obtain a new ticket.
	 *
	 * @return the ticket returned by the server
	 *
	 * @throws IOException if an I/O error occurs
	 */
	public String newTicket() throws IOException;
	
	/**
	 * Add an entry to the log identified by the specified ticket
	 *
	 * @param ticket the ticket of the log to be written to
	 * @param message the message to be written to the log
	 */
	public void addEntry(String ticket, String message);
	
	/**
	 * Get a list of all the entries that have been written to the log
	 * identified by the given ticket.
	 *
	 * @param ticket the ticket that identifies the log
	 *
	 * @return a list containing all of the entries written to the log
	 *
	 * @throws IOException if an I/O error occurs
	 */
	public List<String> getEntries(String ticket) throws IOException;
	
	/**
	 * Release the specified ticket.  The entries associated with the
	 * ticket will no longer be available
	 *
	 * @param ticket the ticket to be released
	 */
	public void releaseTicket(String ticket);
} // ILogClient

