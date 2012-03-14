/*
 * LogServerHandler.java
 * 
 * Version: 3/14/12
 */

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * This class represents an active thread that is responsible
 * for servicing a single client to the log server.
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class LogServerHandler extends Thread
{
	/**
	 * The socket used to connect to the client
	 */
	private Socket socket;

	/**
	 * The single, shared log server that contains the messages in memory
	 */
	private LogServer server;
	
	/**
	 * The I/O streams used to communicate with the client
	 */
	private BufferedReader clientIn;
	private DataOutputStream clientOut;
	
	/**
	 * Boolean status flag that indicates proper setup of the client I/O streams
	 */
	private boolean setup;
	
	/**
	 * Create a new LogServerHandler for the specified server object
	 * and client socket.
	 * 
	 * @param server - the parent log server
	 * @param socket - the client socket to service
	 */
	public LogServerHandler(LogServer server, Socket socket)
	{
		this.server = server;
		this.socket = socket;
		
		// Create the socket I/O streams
		try 
		{
			clientIn = new BufferedReader(new InputStreamReader(socket.getInputStream()));
			clientOut = new DataOutputStream(socket.getOutputStream());
			setup = true;
		}
		catch (IOException e) 
		{
			setup = false;
			e.printStackTrace();
		}
	}
	
	/**
	 * The main run method for the thread that continuously services
	 * the client thread until they terminate their connection from
	 * the client side. 
	 */
	public void run()
	{
		try 
		{
			// Handle the requests from this client appropriately
			while (setup && (socket.isConnected()))
			{
				// Read in the incoming request
				String request = clientIn.readLine();
				System.out.println("server thread handling: " + request);
				
				// Only have the request if it isn't null (client did not close)
				if (request != null)
				{
					switch (request.charAt(0))
					{
						case ILogClient.TKT:
							handleNewTicket();
							break;
						case ILogClient.LOG:
							handleLogMessage(request.substring(1));
							break;
						case ILogClient.REL:
							handleReleaseTicket(request.substring(1));
							break;
						case ILogClient.GET:
							handleGetMessages(request.substring(1));
							break;
					}
				}
				else
				{
					break;
				}
			}
			
			// Close the streams and the socket
			clientIn.close();
			clientOut.close();
			socket.close();
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
	}
	
	/**
	 * Handle a new ticket request by generating a random UUID, inserting into
	 * the parent server message map, and then returning this ticket to the client.
	 */
	private void handleNewTicket()
	{
		// Generate a random ticket and insert into the message map
		UUID ticket = UUID.randomUUID();
		server.getMessages().put(ticket.toString(), new ArrayList<String>());
		server.addDebugMessage("Issuing New Ticket: " + ticket.toString());
		
		// Try to send the ticket to the client
		try 
		{
			clientOut.writeBytes(ticket.toString() + "\n");
			clientOut.flush();
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
	}
	
	/**
	 * Handle a log message request by simply adding the new message to the parent
	 * server's message map and writing the message to the log file.
	 * 
	 * @param request - the request containing "ticket:message"
	 */
	private void handleLogMessage(String request)
	{
		String data[] = request.split(":"); // MAGIC NUMBER
		
		// Add the message to the server message map for the appropriate ticket
		server.getMessages().get(data[0]).add(data[1]);
		
		// Add the request information to the debug and log files
		server.addDebugMessage("Received 1");
		server.addDebugMessage(request);
		server.addLogMessage(data[0], data[1]);
	}
	
	/**
	 * Handle a release ticket request by removing the ticket from the parent 
	 * server's message map.
	 * 
	 * @param request - the request containing "ticket"
	 */
	private void handleReleaseTicket(String request)
	{
		if (server.getMessages().containsKey(request))
		{
			server.addDebugMessage("Releasing Ticket: " + request);
			server.getMessages().remove(request);
		}
	}
	
	/**
	 * Handle get message requests by traversing the list of messages for the
	 * specified key and sending them to the client (along with the list size).
	 * 
	 * @param request - the request containing "ticket"
	 */
	private void handleGetMessages(String request)
	{
		List<String> messages = server.getMessages().get(request);
		int count = messages.size();
		
		// Send the ticket to the client
		try 
		{
			// Send the size first, followed by the messages
			server.addDebugMessage("Delivering messages for: " + request);
			clientOut.writeBytes(count + "\n");
			server.addDebugMessage("Delivering " + count + " to user");
			for (int i = 0; i < count; i++)
			{
				server.addDebugMessage("Displaying message: " + messages.get(i));
				clientOut.writeBytes(messages.get(i) + "\n");
			}
			clientOut.flush();
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
	}
}
