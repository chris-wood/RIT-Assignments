/**
 * This class implements a parallel version of the Jacobi 
 * algorithm for solving a system of linear equations that
 * targets a cluster of machines. 
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */

import java.io.IOException;

import edu.rit.mp.BooleanBuf;
import edu.rit.mp.DoubleBuf;
import edu.rit.pj.Comm;
import edu.rit.util.Random;
import edu.rit.util.Range;
import edu.rit.pj.reduction.BooleanOp;

public class JacobiClu
{
	static Comm world;
	static int size;
	static int rank;

//	static BooleanBuf iterSuccess;
//	static boolean masterConverged;
//	static boolean p_iterSuccess;
	
	static int count = 0;

//	static Range[] ranges;
//	static Range myrange;
//	static int first;
//	static int last;

//	static DoubleBuf[] masterY;
//	static DoubleBuf processY;
//	static DoubleBuf xBuf;
	
	static DoubleBuf[] xBuffers;
	static DoubleBuf yBuffer;

	static double A[][];
	static double b[];

	// The data structures to hold the calculation data structures.
	static double[] y;
	static double[] x;

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
		
//		Comm world = null;
//		int size = 0;
//		int rank = 0;

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
			int first, last;
			final int n = Integer.parseInt(args[0]);
			if (n < 1)
			{
				error("Error: n must be at least 1.");
				System.exit(-1);
			}
			final long seed = Long.parseLong(args[1]);
			
			// Set up the ranges for each process.
			Range[] ranges = new Range(0, n - 1).subranges(size);
			Range myrange = ranges[rank];
			first = myrange.lb();
			last = myrange.ub() + 1;
			
			// Only allocate the required space for A, x, y, and b in 
			// each process.
			x = new double[n];
			b = new double[last - first];
			A = new double[last - first][];
			y = new double[last - first];
			
			double[] A_i;

			Random prng_thread = Random.getInstance(seed);
			prng_thread.setSeed(seed);
			prng_thread.skip((n + 1) * first);
			for (int i = first; i < last; i++)
			{
				A[i - first] = new double[n];
				A_i = A[i - first]; 
				for (int j = 0; j < n; j++)
				{
//	        		System.out.println(rank + " trying " + first + " - " + last + " for A matrix index with i = " + i);
					A_i[j] = (prng_thread.nextDouble() * 9.0) + 1.0;
				}
				A_i[i] += 10.0 * n;
				b[i - first] = (prng_thread.nextDouble() * 9.0) + 1.0;
				y[i - first] = 1.0;
			}
    		
    		// Allocated buffers for communication and whatnot
    		boolean converged = false;
    		xBuffers = DoubleBuf.sliceBuffers(x, ranges);
    		yBuffer = DoubleBuf.buffer(y);
    		double xVal;
			double yVal;
			double sum;
			int offset;
			boolean p_iterSuccess;
			
			long end1 = System.currentTimeMillis();
			System.out.println("time = " + (end1 - startTime));
			
    		while (!converged) 
    		{
    			// Every process needs the -entire- x vector, so we need 
    			// to do an "all gather"
    			world.allGather(yBuffer, xBuffers); // good
    			p_iterSuccess = true;
    			long commEnd = System.currentTimeMillis();
//    			int offset;
//    			System.out.println((n-1) + " " + first + " " + last);
    			for (int i = first; i < last; i++) // first - last ---- ACCESS TO LAST IS ADDING 100MS
    			{
    				// Compute the upper and lower matrix product, omitting
    				// the element at index i
    				offset = i - first;
    				A_i = A[offset];
//    				A_i = A[i];
    				yVal = sum = 0.0;
    				xVal = x[i];
    				for (int index = 0; index < i; index++)
    				{
    					sum += (A_i[index] * x[index]);
    				}
    				for (int index = i + 1; index < n; index++)
    				{
    					sum += (A_i[index] * x[index]);
    				}
    				
    				// Compute the y[] value.
    				yVal = (b[i] - sum) / A_i[i]; // b[offset]

    				// Check for convergence.
    				if (!(Math.abs((2 * (xVal - yVal)) 
    							/ (xVal + yVal)) < epsilon))
    				{
    					p_iterSuccess = false;
    				}
    				
    				// Store the y coordinate value.
//    				y[offset] = yVal;
    				y[i] = yVal;
    			}
    			long compEnd = System.currentTimeMillis();
				
				// Make everyone report their convergence results
				BooleanBuf bBuf = BooleanBuf.buffer(p_iterSuccess);
				world.allReduce(bBuf, BooleanOp.AND); // ARK does this.
				converged = bBuf.get(0);

//				long end = System.currentTimeMillis();
//				System.out.println("---");
//				System.out.println(commEnd - start);
				System.out.println(compEnd - commEnd);
//				System.out.println(end - compEnd);
//				System.out.println(end - start);
    		}
			
			// Display the solution and time (from the root process)
			if (rank == 0)
			{
				if (n <= 100)
				{
					for (int i = 0; i < n; ++i)
					{
						System.out.printf("%d %g%n", i, x[i]);
//						System.out.println(i + " " + x[i]);
					}
				}
				else
				{
					for (int i = 0; i <= 49; ++i)
					{
						System.out.printf("%d %g%n", i, x[i]);
//						System.out.println(i + " " + x[i]);
					}
					for (int i = n - 50; i < n; ++i)
					{
						System.out.printf("%d %g%n", i, x[i]);
//						System.out.println(i + " " + x[i]);
					}
				}
				long endTime = System.currentTimeMillis();
				System.out.printf("%d msec%n", (endTime - startTime));
//				System.out.println(count);
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
