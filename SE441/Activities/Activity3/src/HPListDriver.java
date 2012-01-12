import java.util.ArrayList;
import java.util.List;


public class HPListDriver 
{
	class Client extends Thread
	{
		private HPList list;
		private int count;
		public Client(HPList list, int count)
		{
			this.list = list;
		}
		
		public void run()
		{
			for (int i = 0; i < count; i++)
			{
				
			}
		}
	}
	
	private List<Client> clientList = new ArrayList<Client>();
	private HPList list;
	
	public HPListDriver(int numClients)
	{
		// create HPLlist
		list = new HPList();
		
		// create clients with access to list
		Client c1 = new Client(list, NUM_ENTRIES);
		Client c2 = new Client(list, NUM_ENTRIES);
		Client c3 = new Client(list, NUM_ENTRIES);
	}
	
	private static final int NUM_ENTRIES = 20;
	
	public static void main(String[] args)
	{
		HPListDriver driver = new HPListDriver(5);
		
		// throw stuff in list and display results
	}
}
