/**
 * This class implements a sequential version of the Jacobi 
 * algorithm for solving a system of linear equations.
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */

import java.io.IOException;
import edu.rit.pj.Comm;
import edu.rit.util.Random;

public class JacobiSeq
{
	// The convergence cutoff delta value.
	private static double epsilon = 0.00000001;

	/**
	 * The main entry point for the JacobiSeq program.
	 * 
	 * @param args
	 *            - command line arguments
	 * 
	 * Note: The command-line parameters must specify the the matrix
	 * dimension and a random seed. Also, the JVM heap size must be
	 * increased to 2000MB to support allocating such large matrices.
	 * See the usage description below for more details.
	 * 
	 * Usage:
	 * 
	 * java -Xmx2000m JacobiSeq <n> <seed>
	 */
	public static void main(String[] args)
	{
		// Start the clock.
		long startTime = System.currentTimeMillis();
		
		// Set up the communication with the job server.
		try
		{
			Comm.init(args);
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}

		// Verify the command-line arguments.
		if (args.length != 2)
		{
			error("Usage: java -Xmx2000m JacobiSeq <n> <seed>");
			System.exit(-1);
		}

		try
		{
			// Parse the command line arguments.
			final int n = Integer.parseInt(args[0]);
			if (n < 1) 
			{
				error("Error: n must be at least 1.");
				System.exit(-1);
			}
			final long seed = Long.parseLong(args[1]);

			// Allocate the data structures.
			final double[][] A = new double[n][n];
			final double[] b = new double[n];
//			
//			// Initialize the data.
//			Random prng = Random.getInstance(seed);
//			double[] A_i;
//			for (int i = 0; i < n; i++)
//			{
//				A_i = A[i];
//				for (int j = 0; j < n; j++)
//				{
//					A_i[j] = (prng.nextDouble() * 9.0) + 1.0;
//				}
//				A_i[i] += 10.0 * n;
//				b[i] = (prng.nextDouble() * 9.0) + 1.0;
//			}
			
			System.out.println("time = " + (System.currentTimeMillis() - startTime));
			
			// Create the solver, initialize the data, solve, and then 
			// print the solution
			JacobiSeq solver = new JacobiSeq();
			double[] x = solver.initAndSolve(A, b, n, seed);
			if (n <= 100)
			{
				for (int i = 0; i < n; ++i)
				{
//					System.out.printf("%d %g%n", i, x[i]);
					System.out.println(i + " " + x[i]);
				}
			}
			else
			{
				for (int i = 0; i <= 49; ++i)
				{
					System.out.printf("%d %g%n", i, x[i]);
				}
				for (int i = n - 50; i < n; ++i)
				{
					System.out.printf("%d %g%n", i, x[i]);
				}
			}	
			
			// Display the time.
			long endTime = System.currentTimeMillis();
			System.out.printf("%d msec%n", (endTime - startTime));
		}
		catch (NumberFormatException ex1)
		{
			System.err.println("Error parsing command line arguments.");
			ex1.printStackTrace();
		}
	}

	/**
	 * Initialize the test data and then solve the system.
	 * 
	 * @param A - coefficient matrix
	 * @param b - equation vector
	 * @param n - data dimensions
	 * @param seed - the PRNG seed.
	 * 
	 * @return x - solution vector
	 */
	public double[] initAndSolve(double[][] A, double[] b, int n, long seed)
	{
		// Create a random matrix.
		double[] x = new double[n];
		double[] y = new double[n];
		
		// Initialize the data.
		Random prng = Random.getInstance(seed);
		double[] A_i;
		for (int i = 0; i < n; i++)
		{
			A_i = A[i];
			for (int j = 0; j < n; j++)
			{
				A_i[j] = (prng.nextDouble() * 9.0) + 1.0;
			}
			A_i[i] += 10.0 * n;
			b[i] = (prng.nextDouble() * 9.0) + 1.0;
			x[i] = 1.0;
		}

		// Run until we converge to a solution.
		boolean converged = false;
		boolean iterSuccess = true;
		double sum;
		double tmp;
		
		// DBEUG
//		int count = 0;
////		if (rank == 0) 
////		{
//			for (int i = 0; i < n; i++)
//			{
//				for (int j = 0; j < n; j++) {
//					System.out.print(A[i][j] + " ");
//				}
////				x[i] = 1.0;
////				System.out.println();
//				System.out.println(b[i]);
//			}
////		}
		
		
		while (!converged)
		{	
//			count++;
			
//			for (int i = 0; i < n; i++)
//			{
//				for (int j = 0; j < n; j++) {
//					System.out.print(A[i][j] + " ");
//				}
//				System.out.println(" - " + x[i]);
//			}
			System.out.println("0 - " + (n-1));
			long start = System.currentTimeMillis();
//			
			for (int i = 0; i < n; i++)
			{
				// Compute the upper and lower matrix product, omitting
				// the element at index i
				A_i = A[i];
				double yVal = 0.0;
				double xVal = x[i];
				sum = 0.0;
//				long sumStart = System.currentTimeMillis();
//				System.out.println(i);
				for (int index = 0; index < i; index++)
				{
					// DEBUG
//					System.out.println("adding: " + A_i[index]);
//					System.out.println("multing: " + x[index]);
					
					
					sum += (A_i[index] * x[index]);
				}
				for (int index = i + 1; index < n; index++)
				{
					sum += (A_i[index] * x[index]);
				}
				
				
//				System.out.println("Computed sum: " + sum);

				// Compute the y[] value.
				yVal = (b[i] - sum) / A_i[i];
//				long sumEnd = System.currentTimeMillis();
//				System.out.println("sum = " + (sumEnd - sumStart));
//				System.out.println("Computed y value " + yVal);

				// Check for convergence.
				//if (iterSuccess &&
				if (
					!(Math.abs((2 * (xVal - yVal)) 
							/ (xVal + yVal)) < epsilon))
				{
					iterSuccess = false;
				}
				
				// Store the y coordinate value.
				y[i] = yVal;
			}
			
			// DBEUG
//			System.out.println("output y values..." + count);
//			for(int i = 0; i < n; i++) {
//				System.out.println(y[i]);
//			}

			// Swap the x[] and y[] vectors.
			for (int i = 0; i < n; i++)
			{
				tmp = x[i];
				x[i] = y[i];
				y[i] = tmp;
			}

			// Reset the iteration variables.
			converged = iterSuccess;
			iterSuccess = true;
			
			// DEBUG
			long end = System.currentTimeMillis();
			System.out.println(end - start);
		}
//		System.out.println(count);

		return x;
	}

	/**
	 * Display the program usage message and terminate abnormally.
	 * 
	 * @param message - the error message to display.
	 * @return void
	 */
	public static void error(String message)
	{
		System.err.println(message);
	}
}