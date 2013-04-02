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

	// Global timing variables.
	private static long startTime = 0;
	private static long endTime = 0;
	
	/**
	 * The main entry point for the JacobiSeq program. To avoid the overhead
	 * of object construction and destruction, an instance of the JacobiSeq
	 * class is not made. While keeping the code for the Jacobi algorithm
	 * inside the main method may violate OO design, since this program
	 * is not meant to be extensible or modifiable in any way (i.e. it serves
	 * one very particular purpose), I feel that this is an acceptable
	 * tradeoff for performance.
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

			// Create a random matrix.
			final double[][] A = new double[n][n];
			final double[] b = new double[n];
			Random prng = Random.getInstance(seed);
			for (int i = 0; i < n; i++)
			{
				for (int j = 0; j < n; j++)
				{
					A[i][j] = (prng.nextDouble() * 9.0) + 1.0;
				}
				A[i][i] += 10.0 * n;
				b[i] = (prng.nextDouble() * 9.0) + 1.0;
			}

			// Allocate space for the solution and temporary variables.
			double[] x = new double[n];
			double[] y = new double[n];

			// Initialize the x[] vector to 1.
			for (int i = 0; i < n; i++)
			{
				x[i] = 1.0;
			}

			// Run until we converge to a solution.
			boolean converged = false;
			boolean iterSuccess = true;
			double sum;
			while (!converged)
			{
				for (int i = 0; i < n; i++)
				{
					// Compute the upper and lower matrix product, omitting
					// the element at index i
					double[] A_i = A[i];
					double yVal = 0.0;
					double xVal = x[i];
					sum = 0.0;
					for (int j = 0; j < i; j++)
					{
						sum += (A_i[j] * x[j]);
					}
					for (int j = i + 1; j < n; j++)
					{
						sum += (A_i[j] * x[j]);
					}

					// Compute and store the y[] value.
					yVal = (b[i] - sum) / A_i[i];
					y[i] = yVal;

					// Check for convergence.
					if (iterSuccess && 
						!(Math.abs((2 * (xVal - yVal)) 
								/ (xVal + yVal)) < epsilon))
					{
						iterSuccess = false;
					}
				}

				// Swap the x[] and y[] vectors.
				double[] tmp = x;
				x = y;
				y = tmp;

				// Reset the iteration variables.
				converged = iterSuccess;
				iterSuccess = true;
			}
			
			// Display the solution and time.
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
