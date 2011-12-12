import java.util.ArrayList;


public class Driver 
{

	final private static int NUM_PUSHERS = 2;
	final private static int NUM_POPPERS = 2;
	final private static long START_WAIT = 2000;
	final private static long END_WAIT = 5000;
	
	public static void main(String[] args)
	{
		TS_Stack stack = new TS_Stack();
		ArrayList<Pusher> pushers = new ArrayList<Pusher>();
		ArrayList<Popper> poppers = new ArrayList<Popper>();
		
		// Create the popper and pusher objects
		int seqNum = 1;
		for (int i = 0; i < NUM_PUSHERS; i++)
		{
			pushers.add(new Pusher("Pusher" + seqNum++, stack));
		}
		seqNum = 1;
		for (int i = 0; i < NUM_POPPERS; i++)
		{
			poppers.add(new Popper("Popper" + seqNum++, stack));
		}
		
		// Start each popper thread
		for (Popper p : poppers)
		{
			p.start();
		}
		
		// Sleep for 2s (2000ms)
		try 
		{
			Thread.sleep(START_WAIT);
		}
		catch (InterruptedException e) 
		{
			e.printStackTrace();
		}
		
		// Start each pusher thread
		for (Pusher p : pushers)
		{
			p.start();
		}
		
		// Now join on each pusher
		try 
		{
			for (Pusher p : pushers)
			{
				p.join();
			}
		} 
		catch (InterruptedException e)
		{
			e.printStackTrace();
		}
		
		// Sleep for 5s (5000ms) before terminating the application
		try 
		{
			Thread.sleep(END_WAIT);
		} 
		catch (InterruptedException e)
		{
			e.printStackTrace();
		}
		System.exit(0);
	}
	
}
