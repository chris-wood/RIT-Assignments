import java.util.ArrayList;

/**
 * This is the main driver class for the program
 * that creates the stack, pusher, and popper 
 * objects and then starts the phase of
 * pushing and popping events.
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */
public class Driver 
{
	/**
	 * The number of Pusher objects to be created
	 * by the driver. Modify this variable to adjust
	 * the number of strings that will be pushed onto
	 * the shared stack and change the contention
	 * for access to the stack by each thread.
	 * 
	 * Note: This variable must be strictly positive.
	 */
	final private static int NUM_PUSHERS = 2;
	
	/**
	 * The number of Popper objects to be created
	 * by the driver. Modify this variable to adjust
	 * the number of threads that will be available to
	 * retrieve strings from the stack and change
	 * the contention for access to the stack by each thread.
	 * 
	 * Note: This variable must be strictly positive.
	 */
	final private static int NUM_POPPERS = 2;
	
	/**
	 * The number of milliseconds to wait between
	 * starting the Popper objects and Pusher
	 * objects. 
	 * 
	 * Note: This variable must be strictly positive.
	 */
	final private static long START_WAIT = 2000;
	
	/**
	 * The number of milliseconds to wait before the 
	 * last Pusher thread terminates and terminating the 
	 * program.
	 * 
	 * Note: This variable must be strictly positive.
	 */
	final private static long END_WAIT = 5000;
	
	/**
	 * The main entry point for the program that creates the 
	 * stack, Popper, and Pusher objects, starts the Popper and
	 * Pusher threads, and then lets them complete before
	 * finishing.
	 * 
	 * @param args - command line arguments
	 */
	public static void main(String[] args)
	{
		// Keep everything within local scope.
		TS_Stack stack = new TS_Stack();
		ArrayList<Pusher> pushers = new ArrayList<Pusher>();
		ArrayList<Popper> poppers = new ArrayList<Popper>();
		
		// Create the Popper and Pusher objects.
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
		
		// Start each Popper thread.
		for (Popper p : poppers)
		{
			p.start();
		}
		
		// Sleep for START_WAIT milliseconds.
		try 
		{
			Thread.sleep(START_WAIT);
		}
		catch (InterruptedException e) 
		{
			e.printStackTrace();
		}
		
		// Start each Pusher thread.
		for (Pusher p : pushers)
		{
			p.start();
		}
		
		// Now join on each Pusher.
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
		
		// Sleep for END_WAIT before terminating the program.
		try 
		{
			Thread.sleep(END_WAIT);
		} 
		catch (InterruptedException e)
		{
			e.printStackTrace();
		}
		
		// Exit (maybe not so gracefully, but this terminates
		// the currently running Popper threads).
		System.exit(0);
	}
	
}
