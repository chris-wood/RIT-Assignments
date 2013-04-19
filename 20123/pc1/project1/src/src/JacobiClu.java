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
import edu.rit.pj.IntegerForLoop;
import edu.rit.pj.ParallelRegion;
import edu.rit.pj.ParallelTeam;
import edu.rit.pj.WorkerIntegerForLoop;
import edu.rit.pj.WorkerRegion;
import edu.rit.pj.WorkerTeam;
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

//	static ReplicatedBoolean converged;
//	static ReplicatedInteger iterSuccess;
	static BooleanBuf iterSuccess;
	static boolean masterConverged;
	static boolean processConverged;
	
	static boolean p_iterSuccess;
	
	static int count = 0;

	static Range[] ranges;
	static Range myrange;
	static int first;
	static int last;

	static DoubleBuf[] masterY;
	static DoubleBuf processY;
	static DoubleBuf xBuf;

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
			y = new double[last - first + 1];

			Random prng_thread = Random.getInstance(seed);
			prng_thread.setSeed(seed);
			prng_thread.skip((n + 1) * first);
			for (int i = first; i <= last; ++i)
			{
				for (int j = 0; j < n; ++j)
				{
//	        		System.out.println(rank + " trying " + first + " - " + last + " for A matrix index with i = " + i);
					A[i - first][j] = (prng_thread.nextDouble() * 9.0) + 1.0;
				}
				A[i - first][i] += 10.0 * n;
				b[i - first] = (prng_thread.nextDouble() * 9.0) + 1.0;
				y[i - first] = 1.0;
			}
    		
    		// Allocated buffers for communication and whatnot
    		boolean converged = false;
    		DoubleBuf[] xBuffers = DoubleBuf.sliceBuffers(x, ranges);
    		DoubleBuf yBuffer = DoubleBuf.buffer(y);
    		double xVal;
			double yVal;
			double sum;
//			boolean p_iterSuccess;
    		while (!converged) 
    		{
    			// TODO: PULL GATHER&SWAP OUT TO THE VERY END AFTER THE LOOP CLOSES 
    			// Every process needs the -entire- x vector, so we need to do an all gather
    			// I don't see a way around this...
    			world.allGather(yBuffer, xBuffers);
    			
//    			p_iterSuccess = true;
//        				System.out.println(rank + " starting its loop.");
    			new ParallelTeam().execute(new ParallelRegion()
    			{
    			
//    				boolean p_iterSuccess = true;
    				double xVal;
    				double yVal;
    				double sum;
    				
    				/**
    				 * Run the solver.
    				 */
    				public void run() throws Exception
    				{
    					// Populate the test matrix and equation vector.
    					p_iterSuccess = true;
    					execute(first, last, new IntegerForLoop()
    					{
							public void run(int arg0, int arg1)
									throws Exception
							{
								for (int i = first; i <= last; i++)
								{
									// Compute the upper and lower matrix product, 
									// omitting the element at index i.
									double[] A_i = A[i - first];
									xVal = x[i];
//					        					xVal = xBuf.get(i);
									yVal = sum = 0.0;
									for (int j = 0; j < i; j++)
									{
//				        						System.out.println("adding: " + A_i[j]);
//				        						System.out.println("multing: " + x[j]);
										sum += (A_i[j] * x[j]);
									}
									for (int j = i + 1; j < n; j++)
									{
										sum += (A_i[j] * x[j]);
									}
//				        					System.out.println("Computed sum: " + sum);

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
//				        					System.out.println(rank + " Computed: " + yVal + " for index = " + i);
									y[i - first] = yVal;
								}
							}
    					});
    				}
    				
//    				public void finish()
//    				{
//    					
//    				}
    			});
//				for (int i = first; i <= last; i++)
//				{
//					// Compute the upper and lower matrix product, 
//					// omitting the element at index i.
//					double[] A_i = A[i - first];
//					xVal = x[i];
////	        					xVal = xBuf.get(i);
//					yVal = sum = 0.0;
//					for (int j = 0; j < i; j++)
//					{
////        						System.out.println("adding: " + A_i[j]);
////        						System.out.println("multing: " + x[j]);
//						sum += (A_i[j] * x[j]);
//					}
//					for (int j = i + 1; j < n; j++)
//					{
//						sum += (A_i[j] * x[j]);
//					}
////        					System.out.println("Computed sum: " + sum);
//
//					// Compute the new y value
//					yVal = (b[i - first] - sum) / A_i[i];
//
//					// Check to see if the algorithm converged
//					// for this particular row in the matrix.
//					if (p_iterSuccess && !((Math.abs((2 * (xVal - yVal)) 
//							/ (xVal + yVal))) < epsilon))
//					{
//						p_iterSuccess = false;
//					}
//
//					// Store the y[] coordinate.
////        					System.out.println(rank + " Computed: " + yVal + " for index = " + i);
//					y[i - first] = yVal;
//				}
				
				// Make everyone report their convergence results
//        				System.out.println(rank + " reducing...");
				BooleanBuf bBuf = BooleanBuf.buffer(p_iterSuccess);
//        				world.allReduce(bBuf, BooleanOp.AND);
//        				converged = bBuf.get(0);
				world.reduce(0, bBuf, BooleanOp.AND); // gather the result
				if (rank == 0 && bBuf.get(0) == true) 
				{
					converged = true;
				} 
				world.broadcast(0, BooleanBuf.buffer(converged)); // send it back out
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
