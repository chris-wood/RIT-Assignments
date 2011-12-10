import java.util.ArrayList;
import java.util.Scanner;

/**
 * This is the main class that implements the logic of all
 * three Rate Monotonic Analysis (RMA) schedulability tests.
 * 
 * @author Christopher A. Wood, caw4567@rit.edu
 */
public class RMATest
{

	/* Fixed upper bound for the first schedule test */
	final private double MAX_UPPER_BOUND = 1.0;
	
	/**
	 * TODO
	 * 
	 * @param tasks
	 * @return
	 */
	public boolean testOne(ArrayList<Task> tasks)
	{
		boolean result = false;
		
		// Compute the sum of C/P ratios among all tasks.
		double sum = sumUtilizationRatios(tasks);
		
		// Display the utilization for this task set.
		System.out.println("Test one calculated utilization: " + sum);
		
		// Now check the result 
		if (sum <= MAX_UPPER_BOUND)
		{
			result = true;
		}
		
		return result;
	}
	
	/**
	 * TODO
	 * 
	 * @param tasks
	 * @return
	 */
	public boolean testTwo(ArrayList<Task> tasks)
	{
		boolean result = false;
		
		// Compute the sum of C/P ratios and compare it to 1.0
		double sum = sumUtilizationRatios(tasks);
		
		// Display the utilization
		System.out.println("Test one calculated utilization: " + sum);
		
		// Compute the upper bound based on the number of tasks according to the following:
		// bound = n(2^(1/n) - 1)
		int n = tasks.size();
		double lowUpperBound = n * (Math.pow(2.0, (1/(double)n)) - 1);
		
		// Now check the result
		if (sum <= lowUpperBound)
		{
			result = true;
		}
		
		return result;
	}

	/**
	 * TODO
	 * 
	 * @param tasks
	 * @return
	 */
	public boolean testThree(ArrayList<Task> tasks)
	{
		boolean result = false;
		double sum = 0.0;
		int numTasks = 0;
		
		// Traverse the task set and apply Theorem 2 for each
		// task that does not pass Theorem 1
		for (Task t : tasks)
		{
			numTasks++;
			sum += t.utilizationRatio();
			double bound = numTasks * (Math.pow(2.0, (1/(double)numTasks)) - 1);
			
			// If we don't pass Theorem 1, apply Theorem 2
			if (sum < bound)
			{
				result = incrementalTest(tasks, numTasks - 1);
				if (!result)
				{
					System.out.println("Failed incremental application of Theorem 2");
					break;
				}
			}
		}
		
		return result;
	}
	
	/**
	 * Direct application of Theorem 2 from the paper.***
	 * 
	 * @param tasks
	 * @param index
	 * @return
	 */
	public boolean incrementalTest(ArrayList<Task> tasks, int i)
	{
		boolean result = true;
		
		// Compute the indices needed for the calculation
		int j = i;
		int k = i;
		
		// 
		
		return result;
	}
	
	/**
	 * Helper method that computes the sum of the utilization ratios for
	 * a given set of tasks.
	 * 
	 * @param tasks - a set of tasks
	 * @return the sum of the utilization ratios.
	 */
	public double sumUtilizationRatios(ArrayList<Task> tasks)
	{
		double sum = 0.0;
		
		// Traverse the task set and compute the ratios
		for (Task t : tasks)
		{
			sum += t.utilizationRatio();
		}
		
		return sum;
	}
	
	public static void main(String[] args)
	{
		int numTasks = 0;
		ArrayList<Task> tasks = new ArrayList<Task>();
		Scanner scin = new Scanner(System.in);
		
		// Read in the task parameters from stdin
		System.out.println("Number of tasks: ");
		try 
		{
			// Read in the number of tasks
			numTasks = scin.nextInt();
			assert(numTasks > 0);
			
			// Iteratively gather the remaining task data
			// TODO: change this to loop until EOF (ctl+d stdin)
			for (int i = 0; i < numTasks; i++)
			{
				System.out.println("Task " + i + " data (compute and period times separated by a space): ");
				int ct = scin.nextInt();
				int pt = scin.nextInt();
				
				// Verify these parameters 
				// Note: we assume compute time is strictly less than period time,
				// otherwise the schedulability would be trivially false with n>1 tasks
				assert(ct > 0 && pt > 0 && ct < pt); 
				// TODO: replace with simple check/stderr out?
				
				// Add the task to the running set
				tasks.add(new Task(ct, pt));
			}
			
			// If the task parameters were read in correctly, create the 
			// tester to run each scheduling test
			RMATest tester = new RMATest();
			
			// Perform the tests
			boolean testOnePass = tester.testOne(tasks);
			boolean testTwoPass = tester.testTwo(tasks);
			boolean testThreePass = tester.testThree(tasks);
			
			// Display the results
			System.out.println("Test one result: " + testOnePass);
			System.out.println("Test two result: " + testTwoPass);
			System.out.println("Test three result: " + testThreePass);
		}
		catch (Exception e)
		{
			System.err.println("Error parsing standard input.");
		}		
	}
}

