/*
 * LogClient.java
 * 
 * Version: 3/14/12
 */

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;

/**
 * This class is responsible for implementing the functionality
 * defined by the ILogClient interface, and can be used by clients
 * to interact with the log server.
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class LogClient implements ILogClient 
{
	/**
	 * The single server communication socket used by this client 
	 */
	private Socket clientSocket = null;
	
	/**
	 * The I/O streams drawn from the client socket used for communication
	 */
	private DataOutputStream serverOut = null;
	private BufferedReader serverIn = null;

	/**
	 * Open a connection with a log server.
	 * 
	 * @param host
	 *            name of the host to connect to
	 * @param port
	 *            the port the server is listening on
	 * 
	 * @throws UnknownHostException
	 *             if the hostname is invalid
	 * @throws IOException
	 *             if a connection cannot be established
	 */
	public void open(String host, int port) throws UnknownHostException,
			IOException 
	{
		System.out.println("Connecting to " + host + ":" + port);
		clientSocket = new Socket(host, port);
		serverOut = new DataOutputStream(clientSocket.getOutputStream());
		serverIn = new BufferedReader(new 
				InputStreamReader(clientSocket.getInputStream()));
	}

	/**
	 * Close the connection with the server
	 */
	public void close() 
	{
		try 
		{
			// Close the I/O streams, followed by the socket itself
			serverOut.close();
			serverIn.close();
			clientSocket.close();
			
			// Set the objects to null to avoid misuse
			clientSocket = null;
			serverOut = null;
			serverIn = null;
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
	}

	/**
	 * Obtain a new ticket.
	 *
	 * @return the ticket returned by the server
	 *
	 * @throws IOException if an I/O error occurs
	 */
	public String newTicket() throws IOException 
	{
		String ticket = "";

		// Query the server for a new ticket if the socket is open
		serverOut.writeBytes(TKT + "\n");
		ticket = serverIn.readLine();

		return ticket;
	}

	/**
	 * Add an entry to the log identified by the specified ticket
	 *
	 * @param ticket the ticket of the log to be written to
	 * @param message the message to be written to the log
	 */
	public void addEntry(String ticket, String message) 
	{
		try 
		{
			serverOut.writeBytes(LOG + ticket + ":" + message + "\n");
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
	}

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
	public List<String> getEntries(String ticket) throws IOException 
	{
		List<String> entries = new ArrayList<String>();
		
		// Query for the entries for this ticket
		serverOut.writeBytes(GET + ticket + "\n");
		String response = serverIn.readLine();
		
		// Attempt to parse the count variable to control iteration
		try 
		{
			// Determine the number of messages and then read them
			int count = Integer.parseInt(response);
			for (int i = 0; i < count; i++)
			{
				entries.add(serverIn.readLine());
			}
		}
		catch (NumberFormatException e)
		{
			e.printStackTrace();
		}
		
		return entries;
	}

	/**
	 * Release the specified ticket.  The entries associated with the
	 * ticket will no longer be available
	 *
	 * @param ticket the ticket to be released
	 */
	public void releaseTicket(String ticket) 
	{
		try 
		{
			serverOut.writeBytes(REL + ticket + "\n");
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
	}
} // LogClient

