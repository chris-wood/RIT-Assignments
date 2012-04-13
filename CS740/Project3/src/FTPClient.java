import java.io.IOException;
import java.net.UnknownHostException;

/**
 * TODO
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class FTPClient 
{	
	// TODO: change all to private that should be private
	
	/**
	 * The server host name and port that we connect to for file I/O.
	 */
	public String host;
	
	/**
	 * The default port for the FTP server.
	 */
	public static final int FTP_PORT = 21;
	
	public static final int FTP_DATA_PORT = 20;
	
	/**
	 * Message end flag marker for telnet protocol.
	 */
	public static final String TELNET_END = "\n";
	
	public static enum TransferType {ASCII, BINARY};
	public TransferType tType = TransferType.ASCII; // TODO make private
	
	public static enum TransferMode {ACTIVE, PASSIVE};
	public TransferMode tMode = TransferMode.PASSIVE; // TODO make private
	
	private FTPDataProcess dProcess;
	private FTPProtocolInterpreter cProcess;
	
	public FTPClient()
	{
		dProcess = new FTPDataProcess(this);
		cProcess = new FTPProtocolInterpreter(this);
	}
	
	public String connect(String host, int timeout) throws UnknownHostException, IOException
	{
		return cProcess.open(host, timeout);
	}
	
	// TODO: implement message handling routine in here (FTP.java simply parse user input and send to this client)
	
	public String sendCommand(String command) throws IOException
	{
		return cProcess.sendControl(command);
	}
	
	public String sendRequest(String command, String[] arguments) throws IOException
	{
		System.out.println("Sending request: " + command);
		
		// Handle the data connection logic first
		if (!dProcess.dataConnectionReady)
		{
		switch (tMode)
		{
		case ACTIVE:
			System.out.println("DEBUG: Establishing active connection");
			dProcess.establishConnection(FTPClient.TransferMode.ACTIVE);
			break;
		case PASSIVE:
			System.out.println("DEBUG: Establishing passive connection");
			System.out.println(cProcess.sendControl("pasv"));
			dProcess.establishConnection(FTPClient.TransferMode.PASSIVE);
			break;
		}
		}
		
		// Send the command to the FTP server
		StringBuilder builder = new StringBuilder();
		builder.append(command);
		if (arguments != null)
		{
			for (int i = 0; i < arguments.length; i++)
			{
				builder.append(" " + arguments[i]);
			}
		}
		builder.append(TELNET_END);
		
		
		return cProcess.sendControl(builder.toString());
	}
	
	public void toggleTransferMode() throws IOException
	{
		/*
		controlOut.writeBytes("pasv" + FTPClient.TELNET_END);
		
		StringBuilder builder = new StringBuilder();
		builder.append(controlIn.readLine());
		while (controlIn.ready())
		{
			builder.append(controlIn.readLine() + "\n");
		}
		System.out.println(builder.toString());
		*/
	}
	
	public void setTransferType(FTPClient.TransferType type) throws IOException
	{
		/*
		switch (type)
		{
		case ASCII:
			tType = type;
			controlOut.writeBytes("type A" + FTPClient.TELNET_END); // TODO: map for these values
			System.out.println(controlIn.readLine());
			break;
		case BINARY:
			tType = type;
			// TODO: fix byte size for this system?
			controlOut.writeBytes("type L8" + FTPClient.TELNET_END); // TODO: map for these values
			System.out.println(controlIn.readLine());
			break;
		default:
			System.err.println("Error: invalid transfer type");
			break;
		}
		*/
	}
}
