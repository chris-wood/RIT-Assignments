import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.concurrent.Semaphore;


public class FTPDataProcess extends Thread
{

	/**
	 * Socket and data streams for the data channel.
	 */
	private Socket passiveSocket = null;
	private ServerSocket activeSocket = null;
	private DataOutputStream dataOut = null;
	private DataInputStream dataIn = null;
	
	public boolean dataConnectionReady = false;
	
	private FTPClient.TransferMode tMode;

	private FTPClient client;
	
	public FTPDataProcess(FTPClient client)
	{
		this.client = client;
	}
	
	private Semaphore semaphore;
	
	public void run()
	{
		semaphore = new Semaphore(1);
		try {
			semaphore.acquire(); // acquire one to start
		} catch (InterruptedException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		while (!Thread.currentThread().isInterrupted())
		{
			try {
				semaphore.acquire();
			} catch (InterruptedException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
			System.out.println("Semaphore bumped.");
			if (!dataConnectionReady)
			{
				try 
				{
					System.out.println("DP is trying to accept a connection");
					activeSocket.accept();
					System.out.println("DP accepted a connection");
				} 
				catch (IOException e) 
				{
					e.printStackTrace();
				}
			}
		}
	}

	// IF PASSIVE, WE LISTENS AND SERVER ESTABLISH, IF ACTIVE, ESTABLISH
	
	public void establishConnection(FTPClient.TransferMode mode, int port)
	{
		switch (mode)
		{
		case ACTIVE:
			System.err.println("DEBUG: Releasing semaphore to start listening.");
			semaphore.release();
			break;
		case PASSIVE:
			try 
			{
				System.out.println("DEBUG: attempting to connect directly to server.");
				passiveSocket = new Socket(client.host, port); // parse resulting stuff!
				System.out.println("DEBUG: connection returned");
				dataOut = new DataOutputStream(passiveSocket.getOutputStream());
				dataIn = new DataInputStream(passiveSocket.getInputStream());
				dataConnectionReady = true;
			} 
			catch (UnknownHostException e) 
			{
				e.printStackTrace();
			} 
			catch (IOException e) 
			{
				e.printStackTrace();
			}
			break;
		}
	}
	
	public ArrayList<Byte> readStream() throws IOException
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
