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
import edu.rit.util.Arrays;
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
    
    static Range[] ranges;
    static Range myrange;
    static int mylb;
    static int myub;
    
    static DoubleBuf[] slices;
    static DoubleBuf myslice;
    
    static double A[][];
    static double b[];
    
    static int count = 0;
	
	
	// The data structures to hold the calculation data structures.
	private static double[] y; // static for anonymous classes
	private static double[] x; // static for anonymous classes
	
	// Shared control flow variables 
//	private static boolean converged; // static for anonymous classes
	//private static boolean iterSuccess; // static for anonymous classes

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
			
//			// Allocate the data structures.
//			final double[][] A = new double[n][n];
//			final double[] b = new double[n];
			
			x = new double[n];
//			y = new double[n];
			
			A = new double[n][n];
	        ranges = new Range (0, n-1) .subranges (size);
	        myrange = ranges[rank];
	        mylb = myrange.lb();
	        myub = myrange.ub();
	        //Arrays.allocate(A, myrange, n);
	        b = new double[myub - mylb + 1];
	        
	        if (rank == 0)
            {
	        	y = new double[n];	
            }
	        else
            {
//	        	Arrays.allocate(A, myrange, n);
	        	y = new double[myub - mylb + 1];
            }
	        //A[0][0] = 1.0;
	        //System.out.println(A[0][0]);
	        
	        // Set up communication buffers.
	        slices = DoubleBuf.sliceBuffers(y, ranges);
	        myslice = slices[rank];
	        
	        converged = new ReplicatedBoolean (BooleanOp.OR);
	        iterSuccess = new ReplicatedInteger(IntegerOp.SUM, 0);
	        converged.reduce(false);
//	        iterSuccess.reduce(0);
	        
//	        BooleanBuf iterSuccess = BooleanBuf.buffer(true);
			
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
								b[i - first] = (prng_thread.nextDouble() * 9.0) + 1.0;
								x[i] = 1.0;
							}
						}
						
						// Send row slice to master.
	                    public void sendTaskOutput
	                        (Range range, Comm comm, int mRank, int tag)
	                        throws IOException
	                        {
	                        comm.send
	                            (mRank,
	                             tag,
	                             DoubleBuf.sliceBuffer(b, range));
//	                                (A, new Range (0, range.length()-1)));
	                        }

	                    // Receive row slice from worker.
	                    public void receiveTaskOutput
	                        (Range range, Comm comm, int wRank, int tag)
	                        throws IOException
	                        {
	                        comm.receive
	                            (wRank,
	                             tag,
	                             DoubleBuf.sliceBuffer(b, range));
	                        }
					});
					
					if (rank == 0) {
						for (int i = 0; i < n; i++) {
							for (int j = 0; j < n; j++) {
								System.out.print(A[i][j] + " ");
							}
							System.out.println();
						}
					}
					
					// each process only needs its own slice of A and b, so don't send them over the network...
					
					while (true) {
						if (converged.get()) {
							break;
						}
						execute(0, n - 1, new WorkerIntegerForLoop()
						{	
							// Set up per-thread PRNG.
//							Random prng_thread = Random.getInstance(seed);
							boolean p_iterSuccess = true;
							
							public void run(int first, int last) throws Exception
							{
								// Skip the PRNG ahead to the right place in the
								// sequence. Each iteration gets (n + 1) values.
								
					        	double[] A_i;
					        	double xVal;
					        	double yVal;
					        	double sum;
					        	p_iterSuccess = true;
					        	
					        	// INSERTED FOR TEST
					        	System.out.println("NEW FOR RANK " + rank);
					        	for (int i = first; i <= last; i++) {
//					        		for (int j = 0; j < n; j++) {
//					        			System.out.print("(" + rank + ") " + A[i][j]);
//					        		}
					        		System.out.println("(" + rank + ") x[i]" + x[i]);
					        		System.out.println("(" + rank + ") b[i] = " + b[i]);
					        	}
					        	
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
									if (p_iterSuccess && 
										!((Math.abs((2 * (xVal - yVal))
										/ (xVal + yVal))) < epsilon))
									{
										// JVM guarantees atomic set 
										p_iterSuccess = false; 
										//iterSuccess.put(0, false);
									}
									
									// Store the y[] coordinate.
									y[i - first]= yVal;
								}
//								System.out.println("success? " + p_iterSuccess);
//								iterSuccess.reduce(p_iterSuccess);
								if (p_iterSuccess){
									System.out.println("we actually did something!");
									System.out.println(iterSuccess.get());
									iterSuccess.reduce(1); // bump up passed processes
									// TODO: this sets the thing to 2?...
								}
							}
							
							public void sendTaskInput(Range range, Comm comm, int mRank, int tag) throws IOException
							{
								System.out.println("rank " + rank + " sending input");
								comm.send
	                            (mRank,
	                             tag,
	                             DoubleBuf.sliceBuffer
	                                (x, range));
	                        }
							
							public void receiveTaskInput(Range range, Comm comm, int mRank, int tag) throws IOException
							{
								System.out.println("rank " + rank + " receiving input");
								comm.receive(mRank, tag, 
										DoubleBuf.sliceBuffer(x, range));
							}
							
							// Send row slice to master.
		                    public void sendTaskOutput
		                        (Range range, Comm comm, int mRank, int tag)
		                        throws IOException
		                        {
		                    	System.out.println("rank " + rank + " sending output");
		                        comm.send
		                            (mRank,
		                             tag,
		                             DoubleBuf.sliceBuffer
		                                (y, range));
		                        }
	
		                    // Receive row slice from worker.
		                    public void receiveTaskOutput
		                        (Range range, Comm comm, int wRank, int tag)
		                        throws IOException
		                        {
		                    	System.out.println("rank " + rank + " receiving output");
		                        comm.receive
		                            (wRank,
		                             tag,
		                             DoubleBuf.buffer(y));
		                        
		                        // After receiving everything, perform the sequential section.
		                        System.out.println("we're in here!");
								// Swap the x[] and y[] vectors.
								double tmp;
								for (int i = 0; i < n; i++)
								{
									tmp = x[i];
									x[i] = y[i];
									y[i] = tmp;
								}
								
								System.out.println("iterSuccess = " + iterSuccess.get());

								// Reset the iteration variables.
								converged.reduce(iterSuccess.get() >= size);
								System.out.println("size = " + size);
								count++;
								if (iterSuccess.get() >= size) {
									System.out.println("AT LEAST ITS WORKING!");
									System.out.println("count = " + count);
								}
//								iterSuccess = new ReplicatedBoolean(BooleanOp.AND);
								iterSuccess.reduce(iterSuccess.get() * -1); // bring back downto 0
		                        }
						});
					}
					
					// TODO: convert SOLVER code to use the workerteam API
				}
			});
	        
//	        // Solve now...
//	        while (true)
//	        {
//	        	world.broadcast(rootId, DoubleBuf.buffer(x));
//	        	if (converged.get() == true) {
//	        		System.out.println("BREAKING OUT");
//	        		break;
//	        	}
//	        	boolean p_iterSuccess = true;
//	        	double[] A_i;
//	        	double xVal;
//	        	double yVal;
//	        	double sum;
//				for (int i = mylb; i <= myub; i++)
//				{
//					// Compute the upper and lower matrix
//					// product, omitting the element at 
//					// index i.
//					A_i = A[i];
//					xVal = x[i];
//					yVal = sum = 0.0;
//					for (int j = 0; j < i; j++)
//					{
//						sum += (A_i[j] * x[j]);
//					}
//					for (int j = i + 1; j < n; j++)
//					{
//						sum += (A_i[j] * x[j]);
//					}
//
//					// Compute the new y value
//					yVal = (b[i] - sum) / A_i[i];
//
//					// Check to see if the algorithm converged
//					// for this particular row in the matrix.
//					if (p_iterSuccess && 
//						!((Math.abs((2 * (xVal - yVal))
//						/ (xVal + yVal))) < epsilon))
//					{
//						// JVM guarantees atomic set 
//						p_iterSuccess = false; 
//						iterSuccess.put(0, false);
//					}
//					
//					// Store the y[] coordinate.
//					myslice.put(i, yVal);
//				}
//				//iterSuccess.reduce(p_iterSuccess); // set the iterSuccess flag and then send the y values...
//				world.reduce(rootId, iterSuccess, BooleanOp.AND);
//				if (rank == rootId)
//				{
//					world.gather(0, myslice, slices);
//				}
//				else
//				{
//					world.gather(0, myslice, null);
//				}
//				
//				
//				// Only make the master perform swapping..
//				if (rank == rootId) 
//				{
//					// Swap the x[] and y[] vectors.
//					double tmp;
//					for (int i = 0; i < n; i++)
//					{
//						tmp = x[i];
//						x[i] = y[i];
//						y[i] = tmp;
//					}
//
//					// Reset the iteration variables.
//					converged.reduce(iterSuccess.get(0));
//				}
//	        }
	        
	        // TODO: write this code...
	        // while true
	        // if (root): send x, else broadcast wait (wait for process 0 to send the x vector data which is initialized above)
	        // if (converged.get()) break out of the loop...
	        // execute loop to compute y value
	        // store process-local value of the thing, reduce to shared when done
	        // send y slice to the master
	        // if (root): perform swap, update the converged flag
	        
	        // receive all x data from the master
	        // compute y, reduce boolean operator, send y slice back to master
	        // if (root 0): perform swap and update the converged flag accordingly, then send outgoing message for everyone to particiapte in the group  
	        
	        // ALGORITHM:
	        // INSIDE WORKERTEAM
	        // 1. if (root0) sends out values of x, else wait for x (SEND FROM MASTER) 
	        // 2. compute values of y given my range
	        // 3. Boolean reduce at the end of the for loop.
	        // 3. set local thread converged message, send back to y vector in master (SEND FROM WORKER)
	        
//	        if (found.get()) break; // findkeyclu2
			
			// Initialize and solve the system.
//			JacobiSmp solver = new JacobiSmp();
//			solver.initAndSolve(A, b, n, seed);
			
			// Display the solution and time.
	        int rootId = 0;
	        if (rank == rootId)
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
	 * @param msg - message to display.
	 * @return void
	 */
	public static void error(String msg)
	{
		System.err.println(msg);
	}
}
