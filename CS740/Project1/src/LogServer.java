import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;


public class LogServer extends Thread 
{
	// log variable names - have private const default names 
	private static final int PORT_NUMBER = 6007;
	
	private Map<String, List<String>> logMessages;
	
	private LogServer()
	{
		// set up log file names
		logMessages = new ConcurrentHashMap<String, List<String>>();
	}
	
	/**
	 * 
	 * @return
	 */
	public static LogServer CreateLogServer()
	{
		LogServer server = new LogServer();
		server.start();
		return server;
	}
	
	public Map<String, List<String>> getMessages()
	{
		return logMessages;
	}
	
	/**
	 * 
	 */
	public void run()
	{
		Socket clientSocket = null;
	    ServerSocket serverSocket = null;
		
	    // Attempt to bind to the port number
	    try 
	    {
			serverSocket = new ServerSocket(PORT_NUMBER);
		} 
	    catch (IOException e) 
	    {
			e.printStackTrace();
		}
	    
	    if (serverSocket.isBound())
	    {
	    	while (!serverSocket.isClosed())
	    	{
	    		try 
	    		{
					clientSocket = serverSocket.accept();
					System.out.println("Accepted a new client!");
					LogServerHandler handler = new LogServerHandler(this, clientSocket);
		    		handler.start();
				} 
	    		catch (IOException e) 
	    		{
					e.printStackTrace();
				}
	    	}
	    }
	}
	
	public static void main(String[] args)
	{
		LogServer server = new LogServer();
		server.start();
	}
}
