/**
 * The Popper class that serves as an active
 * thread trying to continuously pop strings
 * from the top of a stack shared between 
 * other Popper and Pusher objects.
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */
public class Popper extends Thread 
{
	/**
	 * The shared stack object.
	 */
	final private IStack stack;
	
	/**
	 * Constructor that initializes the parent Thread object
	 * and stores the reference to the shared stack object.
	 * 
	 * @param name - name of this Thread object
	 * @param stack - reference to the shared stack.
	 */
	public Popper(String name, final IStack stack)
	{
		super(name);
		this.stack = stack;
	}
	
	/**
	 * Run method that continuously tries to pop elements
	 * from the top of the stack. This method enters an infinite
	 * loop and does not return until the program is terminated.
	 */
	@Override
	public void run()
	{
		// Run forever until program terminated.
		while (true)
		{
			// Pop and element and then give up the CPU.
			stack.pop();
			Thread.yield();
		}
	}
}
