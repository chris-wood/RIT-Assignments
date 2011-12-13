import java.util.ArrayList;

/**
 * A thread-safe implementation of the stack that conforms
 * to the IStack interface in order to provide the appropriate
 * push and pop methods.  
 * 
 * This class guarantees thread safety by encapsulating the 
 * state of the stack within the object instance and providing
 * serialized access to it using the object's own intrinsic lock
 * (i.e. the Java monitor pattern). This is accomplished
 * by providing synchronized access to the stack's state through
 * each method on its public interface (push and pop).
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */
public class TS_Stack implements IStack
{
	/**
	 * The underlying ArrayList that serves as the stack
	 * data structure.
	 * 
	 * ---STACK STATE---
	 */
	final private ArrayList<String> stack;

	/**
	 * The lower bound on the stack size that is used
	 * to determine if a thread that invokes push will
	 * wait until the stack has some elements removed.
	 */
	final private int PUSH_BOUND = 5;
	
	/**
	 * Default constructor for the stack that initializes
	 * the underlying ArrayList data structure.
	 */
	public TS_Stack()
	{
		stack = new ArrayList<String>();
	}
	
	/**
	 * Push a single string element onto the stack.
	 * 
	 * This method is synchronized as it is dependent on the
	 * underlying stack state.
	 * 
	 * @param element - the string object to push onto the stack
	 */
	@Override
	public synchronized void push(String element) 
	{
		// Wait if the stack has at least PUSH_BOUND elements.
		while (stack.size() >= PUSH_BOUND)
		{
			try 
			{
				System.out.println("Thread " + Thread.currentThread().getName() + " waits in push");
				wait();
			}
			catch (Exception ex)
			{
				ex.printStackTrace();
			}
		}
		
		// Push the new element onto the stack.
		stack.add(element);
		System.out.println("Thread " + Thread.currentThread().getName() + " pushes " + element);
		
		// Notify all threads trying to pop elements off the stack.
		notifyAll();
	}

	/**
	 * Pop a string from the top of the stack and return it
	 * to the caller.
	 * 
	 * This method is synchronized as it is dependent on the
	 * underlying stack state.
	 * 
	 * @return - the string that was previously on the top of the stack
	 */
	@Override
	public synchronized String pop() 
	{	
		// Wait if the stack is empty.
		while (stack.isEmpty())
		{
			try
			{
				System.out.println("Thread " + Thread.currentThread().getName() + " waits in pop");
				wait();
			}
			catch (Exception ex)
			{
				ex.printStackTrace();
			}
		}
		
		// Now pop an element off the stack.
		String result = stack.remove(stack.size() - 1);
		System.out.println("Thread " + Thread.currentThread().getName() + " pops " + result);
		
		// Notify all threads waiting in push.
		notifyAll();
		
		return result;
	}
}
