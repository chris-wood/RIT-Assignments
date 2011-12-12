
public class Pusher extends Thread
{
	final private IStack stack;
	final private int PUSH_COUNT = 15; 
	
	public Pusher(String name, final IStack stack)
	{
		super(name);
		this.stack = stack;
	}
	
	public void run()
	{
		for (int i = 1; i <= PUSH_COUNT; i++)
		{
			stack.push(super.getName() + "-" + i);
			Thread.yield();
		}
	}
}
