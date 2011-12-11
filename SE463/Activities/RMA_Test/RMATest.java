import java.util.ArrayList;
import java.util.Scanner;
import java.util.TreeMap;
import java.util.TreeSet;

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
	public boolean incrementalTest(ArrayList<Task> tasks, int failIndex)
	{
		boolean result = false;
		TreeMap<Integer, ArrayList<Integer>> schedulePoints = new TreeMap<Integer, ArrayList<Integer>>();
		
		// 1. calculate all schedule points
		// 2. construct inequalities for all schedule points
		// 3. check to see if one is satisfiable (if so, pass)
		
		// Determine task with the maximum period
		int maxPeriod = 0;
		for (int index = 0; index <= failIndex; index++)
		{
			if (tasks.get(index).getPeriod() > maxPeriod)
			{
				maxPeriod = tasks.get(index).getPeriod();
			}
		}
		
		// Determine schedule points for these tasks based on this lowest frequency task
		for (int index = 0; index <= failIndex; index++)
		{
			// Create the list of schedule points for this task
			ArrayList<Integer> points = new ArrayList<Integer>();
			
			// Compute all integer multiples of this task's period that are 
			// less than the maximum period for the subset of tasks
			int pointMult = 1;
			while (pointMult * tasks.get(index).getPeriod() <= maxPeriod)
			{
				points.add(tasks.get(index).getPeriod() * pointMult);
			}
			
			// Save this task's list of schedule points
			schedulePoints.put(index, points);
		}
		
		// Construct the scheduling inequalities (recursive approach)
		for (Integer base : schedulePoints.keySet())
		{
			for (int pointMult = 0; pointMult < schedulePoints.get(base).size(); pointMult++)
			{
				result = checkInequality(schedulePoints, base, pointMult);
				if (result == true)
				{
					System.out.println("one inequality satisfied!");
					break;
				}
			}
			
			// Break out of the parent loop
			if (result == true)
			{
				break;
			}
		}
		
		return result;
	}
	
	public boolean checkInequality(TreeMap<Integer, ArrayList<Integer>> points, int pointBase, int listOffset)
	{
		boolean result = false;
		int rhs = points.get(pointBase).get(listOffset);
		
		// The map that stores integer multiples of tasks when checking the inequalities
		TreeMap<Integer, Integer> multMap = new TreeMap<Integer, Integer>();
		for (Integer base : points.keySet())
		{
			multMap.put(base, 1); // give each task a multiplicity of 1 to start
		}
		
		// Compute all possible combinations of the tasks such that they are all less than the RHS
		
		
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

