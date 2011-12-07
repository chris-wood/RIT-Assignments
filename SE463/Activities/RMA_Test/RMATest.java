import java.util.HashSet;
import java.util.Scanner;

/**
 * This is the main class that implements the logic of all
 * three Rate Monotonic Analysis (RMA) schedulability tests.
 * 
 * @author Christopher A. Wood
 */
public class RMATest
{

	final private double maxUpperBound = 1.0;
	final private double lowUpperBound = Math.log(2.0);
	
	public boolean testOne(HashSet<Task> tasks)
	{
		boolean result = false;
		
		// Compute the sum of C/P ratios and compare it to 1.0
		double runningSum = 0.0;
		for (Task t : tasks)
		{
			runningSum += ((double)t.getComputeTime() / t.getPeriod());
		}
		
		// Now check the result
		if (runningSum <= maxUpperBound)
		{
			result = true;
		}
		
		return result;
	}
	
	public boolean testTwo(HashSet<Task> tasks)
	{
		boolean result = false;
		
		// Compute the sum of C/P ratios and compare it to 1.0
		double runningSum = 0.0;
		for (Task t : tasks)
		{
			runningSum += ((double)t.getComputeTime() / t.getPeriod());
		}
		
		// Now check the result
		if (runningSum <= lowUpperBound)
		{
			result = true;
		}
		
		return result;
	}

	public boolean testThree(HashSet<Task> tasks)
	{
		boolean result = false;
		
		// TODO: implement the third test outlined in the paper
		
		return result;
	}
	
	public static void main(String[] args)
	{
		int numTasks = 0;
		HashSet<Task> tasks = new HashSet<Task>();
		Scanner scin = new Scanner(System.in);
		
		// Read in the task parameters from stdin
		System.out.println("Number of tasks: ");
		try 
		{
			// Read in the number of tasks
			numTasks = scin.nextInt();
			assert(numTasks > 0);
			
			// Iteratively gather the remaining task data
			for (int i = 0; i < numTasks; i++)
			{
				System.out.println("Task " + i + " data (compute and period times separated by a space): ");
				int ct = scin.nextInt();
				int pt = scin.nextInt();
				
				// Verify these parameters 
				assert(ct > 0 && pt > 0 && ct <= pt); // <= or < for ct/pt?
				
				// Add the task to the running set
				tasks.add(new Task(ct, pt));
			}
			
			// If the task parameters were read in correctly, create the 
			// tester to run each scheduling test
			RMATest tester = new RMATest();
			
			boolean testOnePass = tester.testOne(tasks);
			boolean testTwoPass = tester.testTwo(tasks);
			boolean testThreePass = tester.testThree(tasks);
		}
		catch (Exception e)
		{
			System.err.println("Error parsing standard input.");
		}
		
	}
}

