import java.util.ArrayList;


public class TS_Stack implements IStack
{
	
	final private ArrayList<String> stack;

	final private int PUSH_BOUND = 5;
	
	public TS_Stack()
	{
		stack = new ArrayList<String>();
	}
	
	@Override
	public synchronized void push(String element) 
	{
		// Wait if the stack has at least PUSH_BOUND elements
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
		
		// Push the new element onto the stack
		stack.add(element);
		System.out.println("Thread " + Thread.currentThread().getName() + " pushes " + element);
		
		// Notify all threads trying to pop elements off the stack
		notifyAll();
	}

	@Override
	public synchronized String pop() 
	{
		String result = "";	
		
		// Wait if the stack is empty
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
		
		// Now pop an element off the stack
		result = stack.remove(stack.size() - 1);
		System.out.println("Thread " + Thread.currentThread().getName() + " pops " + result);
		
		// Notify all threads waiting in push
		notifyAll();
		
		return result;
	}
}
