import java.io.IOException;
import java.net.UnknownHostException;

/*
 * ITFTPclient.java
 * 
 * Version: 3/20/12
 */

/**
 * TODO
 * 
 * @author Christopher Wood (caw4567@rit.edu)
 */
public interface ITFTPclient 
{	
	
	public void open(String host, int port, int timeout) throws UnknownHostException,
		IOException;
	
	public void close();
	
	public void sendMessage(TFTPmessage message);
	
	public TFTPmessage getMessage() throws TimeoutException;
}
