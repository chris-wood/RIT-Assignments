
public class Popper extends Thread 
{
	private final IStack stack;
	
	public Popper(String name, final IStack stack)
	{
		super(name);
		this.stack = stack;
	}
	
	public void run()
	{
		while (true)
		{
			String top = stack.pop();
			Thread.yield();
		}
	}
}
