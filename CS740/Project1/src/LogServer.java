
public class LogServer extends Thread 
{

	// log variable names - have private const default names 
	
	private LogServer()
	{
		// set up log file names
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
	
	/**
	 * 
	 */
	public void run()
	{
		
	}
	
}
