/**
 * The Pusher class that serves as an active
 * thread trying to push a finite number of
 * strings onto the stack before terminating.
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */
public class Pusher extends Thread
{
	/**
	 * The shared stack object.
	 */
	final private IStack stack;
	
	/**
	 * The number of strings to push onto the stack.
	 */
	final private int PUSH_COUNT = 15; 
	
	/**
	 * Constructor that initializes the parent Thread object
	 * and stores the reference to the shared stack object.
	 * 
	 * @param name - name of this Thread object
	 * @param stack - reference to the shared stack.
	 */
	public Pusher(String name, final IStack stack)
	{
		super(name);
		this.stack = stack;
	}
	
	/**
	 * Run method that attempts to push a finite number of
	 * strings onto the stack before returning (terminating
	 * the thread).
	 */
	@Override
	public void run()
	{
		// Iterate PUSH_COUNT times and attempt to
		// push a new string onto the stack.
		for (int i = 1; i <= PUSH_COUNT; i++)
		{
			// Push a new element and then give up the CPU.
			stack.push(super.getName() + "-" + i);
			Thread.yield();
		}
	}
}
