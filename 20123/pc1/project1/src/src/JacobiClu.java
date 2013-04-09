/**
 * This class implements a parallel version of the Jacobi 
 * algorithm for solving a system of linear equations that
 * targets a cluster of machines. 
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */

import java.io.IOException;
import edu.rit.pj.BarrierAction;
import edu.rit.pj.Comm;
import edu.rit.pj.IntegerForLoop;
import edu.rit.pj.IntegerSchedule;
import edu.rit.pj.ParallelRegion;
import edu.rit.pj.ParallelTeam;
import edu.rit.pj.WorkerIntegerForLoop;
import edu.rit.pj.WorkerLongForLoop;
import edu.rit.pj.WorkerRegion;
import edu.rit.pj.WorkerTeam;
import edu.rit.util.Random;

public class JacobiClu
{
	// The data structures to hold the calculation data structures.
	private static double[] y; // static for anonymous classes
	private static double[] x; // static for anonymous classes
	
	// Shared control flow variables 
	private static boolean converged; // static for anonymous classes
	private static boolean iterSuccess; // static for anonymous classes

	// The convergence cutoff delta value.
	private static double epsilon = 0.00000001;

	/**
	 * The main entry point for the JacobiSmp program.
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
	 * java -Dpj.jvmflags="-Xmx500m" -Dpj.np=<NP> JacobiClu <n> <seed>
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
			error("Usage: java -Dpj.jvmflags=\"-Xmx500m\" -Dpj.np=<NP> " +
					"JacobiClu <n> <seed>");
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
			
			// TODO: invoke here.
			// Try every possible combination of low-order key bits in parallel.
	        new WorkerTeam().execute (new WorkerRegion()
			{
				public void run() throws Exception
				{
					execute(0, n - 1, new WorkerIntegerForLoop()
					{
						// Set up per-thread PRNG.
						Random prng_thread = Random.getInstance(seed);
						
						public void run(int first, int last) throws Exception
						{
							// Skip the PRNG ahead to the right place in the
							// sequence. Each iteration gets (n + 1) values.
							prng_thread.setSeed(seed);
							prng_thread.skip((n + 1) * first);
							for (int i = first; i <= last; ++i)
							{
								for (int j = 0; j < n; ++j)
								{
									A[i][j] = 
										(prng_thread.nextDouble() * 9.0) + 1.0;
								}
								A[i][i] += 10.0 * n;
								b[i] = (prng_thread.nextDouble() * 9.0) + 1.0;
							}
						}
					});
				}
			});
	        
	        // TODO: if we are the root node, then do the control - see floyd for control over other things...
	        for (int i = 0; i < n; i++) {
	        	for (int j = 0; j < n; j++) {
	        		System.out.print(A[i][j] + " ");
	        	}
	        	System.out.println();
	        }
			
			// Initialize and solve the system.
//			JacobiSmp solver = new JacobiSmp();
//			solver.initAndSolve(A, b, n, seed);
			
			// Display the solution and time.
//			if (n <= 100)
//			{
//				for (int i = 0; i < n; ++i)
//				{
//					System.out.printf("%d %g%n", i, x[i]);
//				}
//			}
//			else
//			{
//				for (int i = 0; i <= 49; ++i)
//				{
//					System.out.printf("%d %g%n", i, x[i]);
//				}
//				for (int i = n - 50; i < n; ++i)
//				{
//					System.out.printf("%d %g%n", i, x[i]);
//				}
//			}
			long endTime = System.currentTimeMillis();
			System.out.printf("%d msec%n", (endTime - startTime));
		}
		catch (NumberFormatException ex1)
		{
			error("Error parsing command line argument(s).");
			ex1.printStackTrace();
		}
		catch (Exception ex1)
		{
			error("Error in the ParallelRegion run() method.");
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
