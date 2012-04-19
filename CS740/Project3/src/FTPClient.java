import java.io.DataInputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.ArrayList;

/**
 * This class is responsible for driving the FTP client 
 * and managing the protocol in order to communicate
 * with the server and provide the required functionality.
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
	
	/**
	 * Message end flag marker for telnet protocol.
	 */
	public static final String TELNET_END = "\r\n";
	
	/**
	 * Enumerations for the possible transfer types available.
	 */
	public static enum TransferType {ASCII, BINARY};
	public TransferType tType = TransferType.BINARY; // TODO make private
	
	/**
	 * Enumerations for the possible transfer modes available.
	 */
	public static enum TransferMode {ACTIVE, PASSIVE};
	public TransferMode tMode = TransferMode.ACTIVE; // TODO make private
	
	/**
	 * The FTP protocol manager 
	 */
	private FTPTransmissionManager ftpMgr;
	
	/**
	 * TODO: MOVE TO FTPProtocolManager
	 */
	private Socket dataSocket = null;
	private ServerSocket activeSocket = null;
	private DataInputStream dataIn = null;
	
	/**
	 * Default timeout of 2000 seconds for connections to the server.
	 */
	public static final int DEFAULT_TIMEOUT = 2000;
	
	/**
	 * THe modulus to use when converting IP strings retrieved from the server. 
	 */
	private static final int PORT_MODULUS = 256;
	
	/**
	 * Constructor for the FTPClient that initializes the FTP protocol
	 * manager to control the communication with the server.
	 */
	public FTPClient()
	{
		ftpMgr = new FTPTransmissionManager();
	}
	
	/**
	 * Attempt to connect to the specified FTP location
	 * @param host
	 * @return
	 * @throws UnknownHostException
	 * @throws IOException
	 */
	public String connect(String host) throws UnknownHostException, IOException
	{
		this.host = host;
		return ftpMgr.open(host, DEFAULT_TIMEOUT);
	}
	
	// TODO: implement message handling routine in here (FTP.java simply parse user input and send to this client)
	
	/**
	 * Send a control command to the FTP server and read its response.
	 * 
	 * @param command - the String command to send.
	 * 
	 * @return the response from the server.
	 * 
	 * @throws IOException - when an I/O error occurs when communicating with the server.
	 */
	public String sendCommand(String command) throws IOException
	{
		System.out.println("DEBUG: sending control: " + command);
		ftpMgr.sendControl(command);
		return ftpMgr.receiveControl();
	}
	
	public String sendRequest(String command, String[] arguments) throws IOException
	{
		ArrayList<Byte> data;
		
		// Handle the data connection logic first
		switch (tMode)
		{
		case ACTIVE:
			FTP.debugPrint("Establishing active connection");
			
			// Initialize a new active socket and then send the port 
			// command to the server so it can connect.
			activeSocket = new ServerSocket(0);
			String portParam = buildPortParam(activeSocket);
			FTP.debugPrint("port param = " + portParam);
			ftpMgr.sendControl("PORT " + portParam);
			FTP.debugPrint("received " + ftpMgr.receiveControl());
			
			// Send the command to the FTP server
			// TODO: put into a separate method
			
			//builder.append(TELNET_END);
			
			// Send the request command
			ftpMgr.sendControl(buildCommand(command, arguments));
			System.out.println("Trying to accept...");
			activeSocket.setSoTimeout(2000);
			dataSocket = activeSocket.accept();
			dataIn = new DataInputStream(dataSocket.getInputStream());
			System.out.println("It accepted!");
			
			// Retrieve the data
			System.out.println("DEBUG: Data retrieved: ");
			data = readStream();
			StringBuilder builder = new StringBuilder();
			for (Byte b : data)
			{
				builder.append((char)b.byteValue());
			}
			System.out.println(builder.toString());
			
			System.out.println("DEBUG 1: " + ftpMgr.receiveControl());
			
			// TODO: this works.. just make it cleaner
			dataSocket.close();
			activeSocket.close();
			
			break;
		case PASSIVE:
			System.out.println("DEBUG: Establishing passive connection");
			int port = ftpMgr.sendPassiveCommand();
			System.out.println("DEBUG: FTP server returned with port: " + port);
			//dProcess.establishConnection(FTPClient.TransferMode.PASSIVE, port);
			
			try 
			{
				System.out.println("DEBUG: attempting to connect directly to server.");
				dataSocket = new Socket(host, port); // parse resulting stuff!
				System.out.println("DEBUG: connection returned");
				dataIn = new DataInputStream(dataSocket.getInputStream());
			} 
			catch (UnknownHostException e) 
			{
				e.printStackTrace();
			} 
			catch (IOException e) 
			{
				e.printStackTrace();
			}
			
			// Send the command to the FTP server
			// TODO: move into new function (by self)
			builder = new StringBuilder();
			builder.append(command);
			if (arguments != null)
			{
				for (int i = 0; i < arguments.length; i++)
				{
					System.out.println("current builder: " + builder.toString());
					builder.append(" " + arguments[i]);
				}
			}
			//builder.append(TELNET_END);
			System.out.println("result from builder: " + builder.toString());
			
			// Send the request command
			ftpMgr.sendControl(builder.toString());
			
			// Retrieve the data
			System.out.println("DEBUG: Data retrieved: ");
			data = readStream();
			builder = new StringBuilder();
			for (Byte b : data)
			{
				builder.append((char)b.byteValue());
			}
			System.out.println(builder.toString());
			
			System.out.println("DEBUG 1: " + ftpMgr.receiveControl());
			
			break;
		}
		
		// TODO: remove this return?
		return "";
	}
	
	/**
	 * Toggle the transfer mode that is used to retrieve data from 
	 * the FTP server.
	 */
	public void toggleTransferMode() 
	{
		switch (tMode)
		{
		case ACTIVE:
			tMode = TransferMode.PASSIVE;
			break;
		case PASSIVE:
			tMode = TransferMode.ACTIVE;
			break;
		}
	}
	
	/**
	 * Set the transfer type for the data from the FTP server.
	 *  
	 * @param type - the new data type.
	 * 
	 * @throws IOException - when an I/O exception occurs after communicating 
	 * 						 with the server.
	 */
	public void setTransferType(FTPClient.TransferType type, String cmd) throws IOException
	{
		switch (type)
		{
		case ASCII:
			tType = type;
			ftpMgr.sendControl(cmd);
			System.out.println(ftpMgr.receiveControl());
			break;
		case BINARY:
			tType = type;
			ftpMgr.sendControl(cmd);
			System.out.println(ftpMgr.receiveControl());
			break;
		default:
			System.err.println("Error: invalid transfer type");
			break;
		}
	}
	
	/**
	 * Read a stream of bytes from the data channel established with the 
	 * FTP server.
	 * 
	 * @return - a list of bytes retrieved from the FTP server.
	 * 
	 * @throws IOException - when an I/O exception occurs communicating with
	 * 						 the server.
	 */
	private ArrayList<Byte> readStream() throws IOException
	{
		ArrayList<Byte> data = new ArrayList<Byte>();
		
		// Read until the stream is end
		int dataByte = 0;
		while ((dataByte = dataIn.read()) != -1)
		{
			data.add((byte)dataByte);
		}
		
		return data;
	}
	
	private String buildPortParam(ServerSocket socket)
	{
		StringBuilder builder = new StringBuilder();
		
		try 
		{
			// Get the IP address and convert into bytes
			InetAddress addr = InetAddress.getLocalHost();
			String strAddr = addr.getHostAddress();
			strAddr = strAddr.replaceAll("\\.", ",");
			builder.append(strAddr);
			
			// Fill in the port information at the end
			int p1 = socket.getLocalPort() / PORT_MODULUS; 
			int p2 = socket.getLocalPort() % PORT_MODULUS; 
			builder.append("," + p1 + "," + p2);
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return builder.toString();
	}
	
	/**
	 * Helper method that constructs a single string object
	 * from a single command and array of command arguments.
	 * 
	 * @param command - the single command to use as the basis.
	 * 
	 * @param arguments - the arguments appended to this command.
	 * 
	 * @return a single String that represents the command with its arguments.
	 */
	private String buildCommand(String command, String[] arguments)
	{
		StringBuilder builder = new StringBuilder();
		builder.append(command);
		if (arguments != null)
		{
			for (int i = 0; i < arguments.length; i++)
			{
				builder.append(" " + arguments[i]);
			}
		}
		return builder.toString();
	}
}
