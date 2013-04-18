/**
 * This class implements a parallel version of the Jacobi 
 * algorithm for solving a system of linear equations that
 * targets a cluster of machines. 
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */

import java.io.IOException;

import edu.rit.mp.DoubleBuf;
import edu.rit.pj.Comm;
import edu.rit.util.Random;
import edu.rit.util.Range;
import edu.rit.pj.reduction.BooleanOp;
import edu.rit.pj.reduction.IntegerOp;
import edu.rit.pj.replica.ReplicatedBoolean;
import edu.rit.pj.replica.ReplicatedInteger;

public class JacobiClu
{
	static Comm world;
	static int size;
	static int rank;

	static ReplicatedBoolean converged;
	static ReplicatedInteger iterSuccess;
	static boolean masterConverged;

	static Range[] ranges;
	static Range myrange;
	static int first;
	static int last;

	static DoubleBuf[] masterY;
	static DoubleBuf processY;

	static double A[][];
	static double b[];

	// The data structures to hold the calculation data structures.
	private static double[] y;
	private static double[] x;

	// The convergence cutoff delta value.
	private static double epsilon = 0.00000001;

	/**
	 * The main entry point for the JacobiSmp program.
	 * 
	 * @param args
	 *            - command line arguments
	 * 
	 *            Note: The command-line parameters must specify the the matrix
	 *            dimension and a random seed. Also, the JVM heap size must be
	 *            increased to 2000MB to support allocating such large matrices.
	 *            See the usage description below for more details.
	 * 
	 *            Usage:
	 * 
	 *            java -Dpj.jvmflags="-Xmx500m" -Dpj.np=<NP> JacobiClu <n>
	 *            <seed>
	 */
	public static void main(String[] args)
	{
		// Start the clock.
		long startTime = System.currentTimeMillis();

		// Set up the communication with the job server and pull
		// out the details of the cluster.
		try
		{
			Comm.init(args);
			world = Comm.world();
			size = world.size();
			rank = world.rank();
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}

		// Verify the command-line arguments.
		if (args.length != 2)
		{
			error("Usage: java -Dpj.jvmflags=\"-Xmx500m\" -Dpj.np=<NP> "
					+ "JacobiClu <n> <seed>");
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
			
			// Set up the ranges for each process.
			ranges = new Range(0, n - 1).subranges(size);
			myrange = ranges[rank];
			first = myrange.lb();
			last = myrange.ub();
			
			// Only allocate the required space for A, x, y, and b in 
			// each process.Note that each process needs ALL of A and x, 
			// and that the master process needs all of y to perform the swap.
			x = new double[n];
			b = new double[last - first + 1];
			A = new double[last - first + 1][n];
			y = new double[n];

			// Set up communication buffers for the y variable.
			masterY = DoubleBuf.sliceBuffers(y, ranges);
			processY = masterY[rank]; // fetch our version of Y and store a reference to it...

			// Set up the replicated data structures that serve as 
			// flow control flags for each process when computing the result.
			converged = new ReplicatedBoolean(BooleanOp.OR, false);
			iterSuccess = new ReplicatedInteger(IntegerOp.SUM, 0);
			
			// Set up per-process PRNG.
			Random prng_thread = Random.getInstance(seed);
			
			// Skip the PRNG ahead to the right place in the
			// sequence. Each iteration gets (n + 1) values.
			prng_thread.setSeed(seed);
			prng_thread.skip((n + 1) * first);
			for (int i = first; i <= last; ++i)
			{
				for (int j = 0; j < n; ++j)
				{
					A[i - first][j] = (prng_thread.nextDouble() * 9.0) + 1.0;
				}
				A[i - first][i] += 10.0 * n;
				b[i - first] = (prng_thread.nextDouble() * 9.0) + 1.0;
				x[i] = 1.0;
			}
			
			if (rank == 0) // master initializes x 
			{
				for (int i = 0; i < n; i++) 
				{
					x[i] = 1.0;
				}
			}
			
			// Each process loops indefinitely until converged
			// evaluates to true.
			while (true)
			{
				// Broadcast the x value to all threads!
				world.broadcast(0, DoubleBuf.buffer(x));
				
				// Check to see if we break out here.
				if (converged.get() == true) // break out if we're done...
				{
					break;
				}
				
				// Perform the swap of things...
				double xVal;
				double yVal;
				double sum;
				boolean p_iterSuccess = true;
				for (int i = first; i <= last; i++)
				{
					// Compute the upper and lower matrix product, 
					// omitting the element at index i.
					double[] A_i = A[i - first];
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
					yVal = (b[i - first] - sum) / A_i[i];

					// Check to see if the algorithm converged
					// for this particular row in the matrix.
					if (p_iterSuccess && !((Math.abs((2 * (xVal - yVal)) 
							/ (xVal + yVal))) < epsilon))
					{
						p_iterSuccess = false;
					}

					// Store the y[] coordinate.
					y[i] = yVal;

					// Reduce our convergence result with the master.
					if (p_iterSuccess)
					{
						iterSuccess.reduce(1);
					}
				}
				
				// Gather the y result and perform the sequential part...
				world.gather(0, processY, masterY);
				if (rank == 0)
				{
					double tmp;
					for (int i = 0; i < n; i++)
					{
						tmp = x[i];
						x[i] = y[i];
						y[i] = tmp;
					}
					
					// Reset the iteration variables.
					if (iterSuccess.get() >= size) 
					{
						masterConverged = true;
						converged.reduce(true); // send true to all other processes
					}
					
					// Reset the process success count to 0
					iterSuccess.reduce(iterSuccess.get() * -1); 
				}

			}
			
			// Display the solution and time (from the root process)
			if (rank == 0)
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
				long endTime = System.currentTimeMillis();
				System.out.printf("%d msec%n", (endTime - startTime));
			}
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
	 * @param msg
	 *            - message to display.
	 * @return void
	 */
	public static void error(String msg)
	{
		System.err.println(msg);
	}
}
