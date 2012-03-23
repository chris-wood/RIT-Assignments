/*
 * Driver.java
 * 
 * Version: 3/14/12
 */

import java.io.IOException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;

/**
 * This class represents a simple driver for the LogService that
 * illustrates how to use the client to interact with a distributed
 * log server.
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class Driver 
{
	/**
	 * The server to connect to.
	 */
	private static final String HOST_SERVER = "viking.cs.rit.edu";
	
	/**
	 * The port that runs the log server.
	 */
	private static final int PORT_NUMBER = 6007;
	
	/**
	 * The main routine that creates a new log service, connects it to
	 * the distributed log server, performs some queries, and then
	 * closes appropriately.
	 * 
	 * @param args - the command line arguments (empty)
	 */
	public static void main(String[] args) 
	{
		// Create a new log server (client) and attempt to connect to the server
		LogServer ls = new LogServer();
		try 
		{
			ls.open(HOST_SERVER, PORT_NUMBER);	
		} 
		catch (UnknownHostException e) 
		{
			e.printStackTrace();
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
		
		// Attempt to retrieve a new ticket from the server.
		String ticket = "";
		try 
		{
			ticket = ls.newTicket();
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
		
		// Add some entries to the log for this new ticket
		if (ticket.length() > 0)
		{
			ls.addEntry(ticket, "Message 1-caw");
			ls.addEntry(ticket, "Message 2-caw");
			ls.addEntry(ticket, "Message 3-caw");
			ls.addEntry(ticket, "Message 4-caw");
			ls.addEntry(ticket, "Message 5-caw");
			ls.addEntry(ticket, "Message 6-caw");
			ls.addEntry(ticket, "Message 7-caw");
			
			// Now, retrieve the messages back and display them to stdout
			List<String> entries = new ArrayList<String>();
			try 
			{
				entries = ls.getEntries(ticket);
			} 
			catch (IOException e) 
			{
				e.printStackTrace();
			}
			for (int i = 0; i < entries.size(); i++) 
			{
				System.out.println(entries.get(i));
			}
			
			// Finally, release the ticket to void it from use
			ls.releaseTicket(ticket);
		}
	}
}
