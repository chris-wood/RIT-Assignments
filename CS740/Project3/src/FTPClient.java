import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.ArrayList;

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
	public static final String TELNET_END = "\r\n";
	
	public static enum TransferType {ASCII, BINARY};
	public TransferType tType = TransferType.ASCII; // TODO make private
	
	public static enum TransferMode {ACTIVE, PASSIVE};
	public TransferMode tMode = TransferMode.PASSIVE; // TODO make private
	
	private FTPController cProcess;
	
	private Socket passiveSocket = null;
	private ServerSocket activeSocket = null;
	private DataOutputStream dataOut = null;
	private DataInputStream dataIn = null;
	
	public FTPClient()
	{
		cProcess = new FTPController(this);
		
		// trying it out
		try {
			activeSocket = new ServerSocket(0);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public String connect(String host, int timeout) throws UnknownHostException, IOException
	{
		return cProcess.open(host, timeout);
	}
	
	// TODO: implement message handling routine in here (FTP.java simply parse user input and send to this client)
	
	public String sendCommand(String command) throws IOException
	{
		System.out.println("DEBUG: sending control: " + command);
		cProcess.sendControl(command);
		return cProcess.receiveControl();
	}
	
	private String buildPortParam(int port)
	{
		StringBuilder builder = new StringBuilder();
		//builder.append("(");
		
		// Get the IP address and convert into bytes
		InetAddress addr = null;
		try 
		{
			addr = InetAddress.getLocalHost();
			String strAddr = addr.getHostAddress().toString();
			System.out.println("IP address = " + strAddr);
			strAddr = strAddr.replaceAll("\\.", ",");
			System.out.println("IP address = " + strAddr);
			builder.append(strAddr);
			
			// Fill in the port information now
			int p1 = port / 256; // TODO: MAGIC NUMBER
			int p2 = port % 256; // TODO: MAGIC NUMBER
			builder.append("," + p1 + "," + p2);
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return builder.toString();
	}
	
	public String sendRequest(String command, String[] arguments) throws IOException
	{
		// Handle the data connection logic first
		switch (tMode)
		{
		case ACTIVE:
			System.out.println("DEBUG: Establishing active connection");
			//dProcess.establishConnection(FTPClient.TransferMode.ACTIVE, 0);
			
			String portParam = buildPortParam(activeSocket.getLocalPort());
			System.out.println("port param = " + portParam);
			cProcess.sendControl("PORT " + portParam);
			System.out.println("DEBUG: received: " + cProcess.receiveControl());
			
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
			
			// Send the request command
			cProcess.sendControl(builder.toString());
			System.out.println("Trying to accept...");
			activeSocket.setSoTimeout(2000);
			activeSocket.accept();
			System.out.println("It accepted!");
			
			// Retrieve the data
			/*
			System.out.println("DEBUG: Data retrieved: ");
			ArrayList<Byte> data = dProcess.readStream();
			builder = new StringBuilder();
			for (Byte b : data)
			{
				builder.append((char)b.byteValue());
			}
			System.out.println(builder.toString());
			
			System.out.println("DEBUG 1: " + cProcess.receiveControl());
			System.out.println("DEBUG 2: " + cProcess.receiveControl());
			*/
			
			break;
		case PASSIVE:
			System.out.println("DEBUG: Establishing passive connection");
			int port = cProcess.sendPassiveCommand();
			System.out.println("DEBUG: FTP server returned with port: " + port);
			//dProcess.establishConnection(FTPClient.TransferMode.PASSIVE, port);
			
			try 
			{
				System.out.println("DEBUG: attempting to connect directly to server.");
				passiveSocket = new Socket(host, port); // parse resulting stuff!
				System.out.println("DEBUG: connection returned");
				dataOut = new DataOutputStream(passiveSocket.getOutputStream());
				dataIn = new DataInputStream(passiveSocket.getInputStream());
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
			cProcess.sendControl(builder.toString());
			
			// Retrieve the data
			System.out.println("DEBUG: Data retrieved: ");
			ArrayList<Byte> data = readStream();
			builder = new StringBuilder();
			for (Byte b : data)
			{
				builder.append((char)b.byteValue());
			}
			System.out.println(builder.toString());
			
			System.out.println("DEBUG 1: " + cProcess.receiveControl());
			//System.out.println("DEBUG 2: " + cProcess.receiveControl());
			
			break;
		}
		
		// TODO: remove this return?
		return "";
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
	
	private ArrayList<Byte> readStream() throws IOException
	{
		ArrayList<Byte> data = new ArrayList<Byte>();
		
		int dataByte = 0;
		while ((dataByte = dataIn.read()) != -1)
		{
			data.add((byte)dataByte);
		}
		
		return data;
	}
}
