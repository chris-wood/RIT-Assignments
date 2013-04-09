/**
 * This class implements a parallel version of the Jacobi 
 * algorithm for solving a system of linear equations. 
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
import edu.rit.util.Random;

public class JacobiSmp
{
	// The data structures to hold the calculation data structures.
	private static double[] y; // static for anonymous classes
	private static double[] x; // static for anonymous classes
	
	// Shared control flow variables 
	private static boolean converged; // static for anonymous classes
	private static boolean iterSuccess; // static for anonymous classes
	private static SwapBarrierAction action; // static for anonymous classes

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
	 * java -Xmx2000m -Dpj.nt=<NT> JacobiSmp <n> <seed>
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
			error("Usage: java -Xmx2000m -Dpj.nt=<NT> JacobiSmp <n> <seed>");
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
			
			// Initialize and solve the system.
			JacobiSmp solver = new JacobiSmp();
			solver.initAndSolve(A, b, n, seed);
			
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
	 * Initialize the test data and solve the system.
	 * 
	 * @param A - coefficient matrix
	 * @param b - equation vector
	 * @param n - data dimensions
	 * @param seed - PRNG seed
	 */
	private void initAndSolve(final double[][] A, final double[] b, 
			final int n, final long seed) throws Exception
	{
		// The main parallel team executing both "tasks" 
		// (initialization and solution) in the program.
		new ParallelTeam().execute(new ParallelRegion()
		{
			/**
			 * Initialize the x[] and y[] vectors.
			 */
			public void start() 
			{
				x = new double[n];
				y = new double[n];
				
				// Create the barrier here so we don't have to
				// continually make one at runtime.
				action = new JacobiSmp.SwapBarrierAction();
			}
			
			/**
			 * Run the solver.
			 */
			public void run() throws Exception
			{
				// Populate the test matrix and equation vector.
				execute(0, n - 1, new IntegerForLoop()
				{
					/**
					 *  Use a guided schedule because some FLOPS
					 *  may take longer than others (we don't
					 *  necessarily have a balanced load).
					 */
					public IntegerSchedule schedule() 
					{
						return IntegerSchedule.guided();
					}
					
					// Set up per-thread PRNG.
					Random prng_thread = Random.getInstance(seed);

					/**
					 * Run the initialization task.
					 */
					public void run(int first, int last)
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
							x[i] = 1.0;
							y[i] = 1.0;
						}
					}
				});
				
				// Solve the system (loop until convergence).
				converged = false;
				iterSuccess = true;
				while (converged == false)
				{
					execute(0, n - 1, new IntegerForLoop() 
					{
						double[] A_i;
						double xVal, yVal, sum;
						boolean t_iterSuccess;
						
						// Padding to avoid cache interference.
						long p0, p1, p2, p3, p4, p5, p6, p7;
						long p8, p9, pa, pb, pc, pd, pe, pf;
						
						/** 
						 * Use a guided schedule because some FLOPS
						 * may take longer than others (we don't 
						 * necessarily have a balanced load).
						 */
						public IntegerSchedule schedule() 
						{
							return IntegerSchedule.guided();
						}
						
						/**
						 * Run the solution task.
						 */
						public void run(int first, int last) 
								throws Exception
						{
							t_iterSuccess = true;
							for (int i = first; i <= last; i++)
							{
								// Compute the upper and lower matrix
								// product, omitting the element at 
								// index i.
								A_i = A[i];
								xVal = x[i];
								yVal = sum = 0.0;
								for (int j = 0; j < i; j++)
								{
									sum += (A_i[j] * x[j]);
								}
								for (int j = i + 1; j < n; j++)
								{
									sum += (A_i[j] * x[j]);
								}

								// Compute the new y value
								yVal = (b[i] - sum) / A_i[i];

								// Check to see if the algorithm converged
								// for this particular row in the matrix.
								if (iterSuccess && 
									!((Math.abs((2 * (xVal - yVal))
									/ (xVal + yVal))) < epsilon))
								{
									// JVM guarantees atomic set 
									t_iterSuccess = false; 
								}
								
								// Store the y[] coordinate.
								y[i] = yVal;
							}
						}
						
						/**
						 * Copy the thread-local flag into the 
						 * shared variable.
						 */
						public void finish()
						{
							if (t_iterSuccess == false) 
							{
								iterSuccess = t_iterSuccess;
							}
						}
					}, action); // Sequential swap barrier action.
				}
			}
		});
	}
	
	/**
	 * Helper class that performs the sequential swap action at the 
	 * calculation loop barrier. A single instance of this class is 
	 * instantiated so that there's no overhead of recreating such
	 * an object at every iteration. It also doesn't need to be thread
	 * safe since it's only ever used by a single thread.
	 */
	private static class SwapBarrierAction extends BarrierAction 
	{
		/**
		 * Run the sequential swap and reset the algorithm convergence state. 
		 */
		public void run() throws Exception
		{
			double[] tmp = x;
			x = y;
			y = tmp;
			converged = iterSuccess;
			iterSuccess = true; // reset
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
