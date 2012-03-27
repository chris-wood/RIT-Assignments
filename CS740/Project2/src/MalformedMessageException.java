
public class MalformedMessageException extends Exception
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public MalformedMessageException(String server)
	{
		super("Malformed message received from the server: " + server);
	}
}
