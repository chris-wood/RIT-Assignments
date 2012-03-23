/*
 * HostLogServer.java
 * 
 * Version: 3/14/12
 */

import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * This class represents the main server thread for the log server
 * that handles incoming client connections by spawning handler threads
 * that service them appropriately (and concurrently).
 *  
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class HostLogServer extends Thread 
{
	/**
	 * The main port number for this server 
	 */
	private static final int PORT_NUMBER = 6007;
	
	/**
	 * The main message map for this server
	 */
	private Map<String, List<String>> logMessages;
	
	/**
	 * Log and debug file name constants
	 */
	private static final String LOG_NAME = "LogServer.log";
	private static final String DEBUG_NAME = "LogServer.debug";
	
	/**
	 * Private constructor that creates the message map and initializes 
	 * the debug and log files for the server
	 */
	private HostLogServer()
	{
		logMessages = new ConcurrentHashMap<String, List<String>>();
	}
	
	/**
	 * Public factory method to create and return new log server instances 
	 * to ensure that each one is safely constructed.
	 * 
	 * @return a new LogServer instance.
	 */
	public static HostLogServer CreateLogServer()
	{
		HostLogServer server = new HostLogServer();
		return server;
	}
	
	/**
	 * Retrieve the message map for this server.
	 * 
	 * @return message map
	 */
	public Map<String, List<String>> getMessages()
	{	
		return logMessages;
	}
	
	/**
	 * The main run method that binds the server socket to the correct port
	 * and starts listening for incoming client connections and spawning
	 * handler threads to service them.
	 */
	public void run()
	{
	    try 
	    {
	    	// Attempt to bind to the port number
	    	ServerSocket serverSocket = new ServerSocket(PORT_NUMBER);
	    	appendDebugMessage("Starting server on port: " + PORT_NUMBER);
			
			// Continuously spawn new handler threads for each incoming client
	    	while (!serverSocket.isClosed() && serverSocket.isBound())
	    	{
	    		try 
	    		{
	    			Socket clientSocket = serverSocket.accept();
					HostLogServerHandler handler = new HostLogServerHandler(this, clientSocket);
		    		handler.start();
				} 
	    		catch (IOException e) 
	    		{
					e.printStackTrace();
				}
	    	}
		} 
	    catch (IOException e) 
	    {
			e.printStackTrace();
		}
	}
	
	/**
	 * Add the specified message to the log file.
	 * 
	 * @param ticket - the ticket that is used to log this message.
	 * @param message - the message to add to the file
	 */
	public synchronized void appendLogMessage(String ticket, String message)
	{
		try 
		{
			// Create the output stream and write the data
			PrintWriter out = new PrintWriter(new 
					BufferedOutputStream(new FileOutputStream(LOG_NAME, true)));
			out.println(ticket + " - " + message);
			
			// Flush and close the stream
			out.flush();
			out.close();
		} 
		catch (FileNotFoundException e) 
		{
			e.printStackTrace();
		}
	}
	
	/**
	 * Add the specified string to stdout and the debug file.
	 * 
	 * @param message - the string to add to the file
	 */
	public synchronized void appendDebugMessage(String message)
	{
		try 
		{
			// Send to stdout first
			System.out.println(message);
			
			// Then send to the debug file
			PrintWriter out = new PrintWriter(new 
					BufferedOutputStream(new FileOutputStream(DEBUG_NAME, true)));
			out.println(message);
			out.flush();
			out.close();
		} 
		catch (FileNotFoundException e) 
		{
			e.printStackTrace();
		}
	}
	
	/**
	 * Main entry point that constructs and starts a new LogServer thread.
	 * 
	 * @param args - command line arguments.
	 */
	public static void main(String[] args)
	{
		HostLogServer server = HostLogServer.CreateLogServer();
		server.start();
	}
} // HostLogServer

