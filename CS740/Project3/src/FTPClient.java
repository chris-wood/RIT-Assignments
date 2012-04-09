import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;

/**
 * TODO
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public class FTPClient 
{	
	/**
	 * TODO
	 */
	private Socket controlSocket = null;
	
	/**
	 * TODO
	 */
	private Socket dataSocket = null;
	
	/**
	 * The server host name and port that we connect to for file I/O.
	 */
	private String host;
	
	/**
	 * TODO
	 */
	private static final int FTP_PORT = 21;
	
	/**
	 * Open a connection to the host TFTP server to begin a file
	 * read or write operation.
	 * 
	 * @precondition - server connection not already established.
	 * @postcondition - server connection open and established.
	 * 
	 * @param host - name of the host server.
	 * @param timeout - timeout value associated with socket transmissions.
	 * 
	 * @throws UnknownHostException - when the specified host does not exist.
	 * @throws IOException - when an I/O error occurs during socket transmission.
	 */
	public void open(String host, int timeout) throws UnknownHostException, 
		IOException 
	{
		controlSocket = new Socket(host, FTP_PORT);
		dataSocket = new Socket(host, FTP_PORT);
		this.host = host;
	}

	/**
	 * Close the connection to the host TFTP server.
	 * 
	 * @precondition - server connection established.
	 * @postcondition - server connection terminated.
	 * 
	 * @throws IOException - when the sockets are unable to close
	 */
	public void close() throws IOException 
	{
		if (controlSocket != null && dataSocket != null && 
				controlSocket.isConnected() && dataSocket.isConnected())
		{
			controlSocket.close();
			dataSocket.close();
			controlSocket = null;
			dataSocket = null;
		}
	}
}
