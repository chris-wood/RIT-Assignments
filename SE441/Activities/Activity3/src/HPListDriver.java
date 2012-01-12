import java.util.ArrayList;
import java.util.List;

public class HPListDriver 
{
	class Client extends Thread
	{
		private HPList list;
		private int count;
		private int id; 
		
		public Client(int id, HPList list, int count)
		{
			this.list = list;
			this.id = id;
			this.count = count;
		}
		
		public void run()
		{
			for (int i = 0; i < count; i++)
			{
				// TODO: insert and remove from the list right here
			}
		}
	}
	
	private List<Client> clientList = new ArrayList<Client>();
	private HPList list;
	private int numClients;
	
	public HPListDriver(int numClients)
	{
		// create HPLlist
		list = new HPList();
		this.numClients = numClients;
		
		for (int i = 0; i < numClients; i++)
		{
			clientList.add(new Client(i, list, NUM_ENTRIES));
		}
	}
	
	public void runTest()
	{
		for (int i = 0; i < numClients; i++)
		{
			System.out.println("starting!");
			clientList.get(i).start();
		}
	}
	
	private static final int NUM_ENTRIES = 20;
	
	public static void main(String[] args)
	{
		HPListDriver driver = new HPListDriver(5);
		driver.runTest();
	}
}
