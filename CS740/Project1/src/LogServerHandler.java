import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class LogServerHandler extends Thread
{
	private Socket socket;
	private LogServer server;
	private BufferedReader clientIn;
	private DataOutputStream clientOut;
	private boolean setup;
	
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
	
	public void run()
	{
		try 
		{
				// Handle the requests from this client appropriately
				while (setup && (socket.isConnected()))
				{
					String request = clientIn.readLine();
					System.out.println("server thread handling: " + request);
					
					if (request != null)
					{
						switch (request.charAt(0))
						{
							case ILogClient.TKT:
								handleNewTicket();
								break;
							case ILogClient.LOG:
								handleLogMessage(request.substring(1)); // magic
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
				
				// Clost the streams and the socket!
				clientIn.close();
				clientOut.close();
				socket.close();
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
	}
	
	private void handleNewTicket()
	{
		UUID ticket = UUID.randomUUID();
		server.getMessages().put(ticket.toString(), new ArrayList<String>());
		
		// Send the ticket to the client
		try 
		{
			clientOut.writeBytes(ticket.toString() + "\n");
			clientOut.flush();
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
		finally
		{
			// try to really close the client now...
		}
	}
	
	private void handleLogMessage(String request)
	{
		String data[] = request.split(":"); // magic number
		server.getMessages().get(data[0]).add(data[1]);
	}
	
	private void handleReleaseTicket(String request)
	{
		if (server.getMessages().containsKey(request))
		{
			// TODO: write the file contents to blah
			
			server.getMessages().remove(request);
		}
	}
	
	private void handleGetMessages(String request)
	{
		List<String> messages = server.getMessages().get(request);
		int count = messages.size();
		
		// Send the ticket to the client
		try 
		{
			// Send the size first
			clientOut.writeBytes(count + "\n");
			
			// Now send the messages
			for (int i = 0; i < count; i++)
			{
				clientOut.writeBytes(messages.get(i) + "\n");
			}
			
			// Flush and close the stream
			clientOut.flush();
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}
		finally
		{
			// try to really close the client now...
		}
	}
}
