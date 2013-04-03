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
	// Global timing variables.
	private static long startTime = 0;
	private static long endTime = 0;
	
	// The data structures to hold the calculation data structures.
	private static double[] y;
	private static double[] x;
	private static double[][] A;
	private static double[] b;
	
	// Dimension and seed.
	private static int n;
	private static long seed;

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
		// Set up the communication with the job server.
		try
		{
			startTime = System.currentTimeMillis();
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

			// Initialize, solve, and display the solution
			JacobiSeq solver = new JacobiSeq();
			
			// Create a random matrix.
			double[][] A = new double[n][n];
			double[] b = new double[n];
			double[] x = new double[n];
			double[] y = new double[n];
			
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
			double[] tmp;
			while (!converged)
			{
				for (int i = 0; i < n; i++)
				{
					// Compute the upper and lower matrix product, omitting
					// the element at index i
					A_i = A[i];
					double yVal = 0.0;
					double xVal = x[i];
					sum = 0.0;
					for (int index = 0; index < i; index++)
					{
						sum += (A_i[index] * x[index]);
					}
					for (int index = i + 1; index < n; index++)
					{
						sum += (A_i[index] * x[index]);
					}

					// Compute the y[] value.
					yVal = (b[i] - sum) / A_i[i];

					// Check for convergence.
					if (iterSuccess && 
						!(Math.abs((2 * (xVal - yVal)) 
								/ (xVal + yVal)) < epsilon))
					{
						iterSuccess = false;
					}
					
					// Store the y coordinate value.
					y[i] = yVal;
				}

				// Swap the x[] and y[] vectors.
				tmp = x;
				x = y;
				y = tmp;

				// Reset the iteration variables.
				converged = iterSuccess;
				iterSuccess = true;
			}
			
			//solver.initAndSolve();
			//solver.printSolution();
			if (n <= 100)
			{
				for (int i = 0; i < n; ++i)
				{
					System.out.printf("%d %g%n", i, x[i]);
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
			endTime = System.currentTimeMillis();
			System.out.printf("%d msec%n", (endTime - startTime));
		}
		catch (NumberFormatException ex1)
		{
			error("Error parsing command line argument(s).");
			ex1.printStackTrace();
		}
	}
	
	/**
	 * Initialize the test data and then solve the system.
	 */
	public void initAndSolve()
	{
		// Create a random matrix.
		A = new double[n][n];
		b = new double[n];
		x = new double[n];
		y = new double[n];
		
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
		double[] tmp;
		while (!converged)
		{
			for (int i = 0; i < n; i++)
			{
				// Compute the upper and lower matrix product, omitting
				// the element at index i
				A_i = A[i];
				double yVal = 0.0;
				double xVal = x[i];
				sum = 0.0;
				for (int index = 0; index < i; index++)
				{
					sum += (A_i[index] * x[index]);
				}
				for (int index = i + 1; index < n; index++)
				{
					sum += (A_i[index] * x[index]);
				}

				// Compute the y[] value.
				yVal = (b[i] - sum) / A_i[i];

				// Check for convergence.
				if (iterSuccess && 
					!(Math.abs((2 * (xVal - yVal)) 
							/ (xVal + yVal)) < epsilon))
				{
					iterSuccess = false;
				}
				
				// Store the y coordinate value.
				y[i] = yVal;
			}

			// Swap the x[] and y[] vectors.
			tmp = x;
			x = y;
			y = tmp;

			// Reset the iteration variables.
			converged = iterSuccess;
			iterSuccess = true;
		}
	}
	
	/**
	 * Display the resulting solution.
	 */
	public void printSolution() 
	{
		if (n <= 100)
		{
			for (int i = 0; i < n; ++i)
			{
				System.out.printf("%d %g%n", i, x[i]);
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
	}
	
	/**
	 * Display an error message.
	 * 
	 * @param msg - message to display.
	 * @return void
	 */
	public static void error(String msg)
	{
		System.err.println(msg);
	}
}
