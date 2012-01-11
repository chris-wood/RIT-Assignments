
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
	
	public static void main(String[] args)
	{
		// create HPLlist
		// create clients with access to list
		// throw stuff in list and display results
	}
}
