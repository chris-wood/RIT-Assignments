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
import edu.rit.pj.reduction.SharedBoolean;
import edu.rit.util.Random;

public class JacobiSmp {

	// The data structures to hold the data in the linear system.
	//private static double[][] A;
	//private static double[] b;
	
	// The dimension of the solution (x) vector.
	//private static int n;
	
	// The convergence cutoff delta value.
	private static double epsilon = 0.00000008;

	/**
	 * The main entry point for the JacobiSmp program.
	 * 
	 * @param args - command line arguments
	 * 
	 * Note: The command-line parameters must specify the 
	 * the matrix dimension and a random seed. Also,
	 * the JVM heap size must be increased to 2000MB to
	 * support allocating such large matrices. See
	 * the usage description below for more details.
	 * 
	 * Usage:
	 * 
	 *   java -Xmx2000m JacobiSmp <n> <seed>
	 */
	public static void main(String[] args) 
	{
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
			showUsage();
		}
		
		// Parse the command line arguments
		Long start = System.currentTimeMillis();
		try 
		{
			int n = Integer.parseInt(args[0]);
			long seed = Long.parseLong(args[1]);
			
			// Create a random matrix
		    double[][] A = new double[n][n];
		    double[] b = new double[n];
		    Random prng = Random.getInstance(seed);
		    for (int i = 0; i < n; ++ i) 
		    {
		        for (int j = 0; j < n; ++ j) 
		        {
		        	A[i][j] = (prng.nextDouble() * 9.0) + 1.0;
		        }
		        A[i][i] += 10.0 * n;
		        b[i] = (prng.nextDouble() * 9.0) + 1.0;
	        }
		    
		    // Solve the system and gather the timing results.
		    double[] x = solve(A, b, n);
		    Long end = System.currentTimeMillis();
		    
		    // Display the solution.
		    printSolution(start, end, n, x);
		}
		catch (NumberFormatException ex1) 
		{
			System.err.println("Error parsing command line arguments.");
			ex1.printStackTrace();
		}
	}
	
	/**
	 * Display the solution vector and program runtime.
	 * 
	 * @param start - start time for program run
	 * @param end - end time for program run
	 * @param x[] - the solution vector
	 */
	public static void printSolution(Long start, Long end, int n, double[] x) 
	{
	    if (n <= 100)
	    {
	    	for (int i = 0; i < n; ++ i)
	    	{
	        	System.out.printf ("%d %g%n", i, x[i]);
	    	}
	    }
	    else
	    {
	    	for (int i = 0; i <= 49; ++ i)
	    	{
	        	System.out.printf ("%d %g%n", i, x[i]);
	    	}
	        for (int i = n - 50; i < n; ++ i)
	        {
	        	System.out.printf ("%d %g%n", i, x[i]);
	        }
	    }
	    System.out.printf ("%d msec%n", (end - start)); 
	}
	
	/**
	 * Attempt to solve the system of linear equations defined by Ax = b,
	 * where x is the solution vector.
	 * 
	 * @param A - the matrix of system coefficients
	 * @param b - the vector of system equation results
	 * @param n - the dimension of the solution vector
	 * 
	 * @return x[] - the solution vector
	 */
	//static boolean iterSuccess = true;
	static double[] y;
	static double[] x;
	static double[] z;
	//static boolean converged = false;
	public static double[] solve(final double[][] A, final double[] b, final int n) 
	{	
		// Allocate space for the solution and temporary variables
		x = new double[n];
		//final double[] localX = new double[n];
		y = new double[n];
		z = new double[n];
		//final boolean[] cr = new boolean[n];
		//int index = 0;
		
		// Initialize the x[] vector to 1
	    for (int i = 0; i < n; i++) 
	    {
	    	x[i] = 1.0;
	    	y[i] = 1.0;
	    	//cr[i] = false;
	    	//localX[i] = 1.0;
	    }
	    
	    // Run until we converge
	    //while (!converged)
	    	// new parallel teams will be spawned for every iteration? does PJ support the ability to handle this better?
	    	// worried that overhead of setup/teardown for every repetition will be bad
	    	// reduction for every iteration occurs when writing to the iterSucces var
	    	// three fine-grained tasks: 1) matrix sum, 2) swap, 3) check - are these really "tasks"?
	    //{
	    	//boolean iterSuccess = true;
    	try 
    	{
			new ParallelTeam().execute(new ParallelRegion() 
			{
				boolean converged = false;
				boolean iterSuccess = true;
				//boolean ping = false;
				//int itrs = 0;
				
				public void run() throws Exception 
				{
					while (!converged) {
						//region().barrier();
					
						//if (!converged) {
					execute(0, n - 1, new IntegerForLoop()
					{
//						public IntegerSchedule schedule()
//                        {
//							return IntegerSchedule.guided();
//                        }
//						
//						double[] thread_x = new double[n + 1 + 32];
//	                    long p0, p1, p2, p3, p4, p5, p6, p7;
//	                    long p8, p9, pa, pb, pc, pd, pe, pf;
////						
						public void run(int first, int last)
						{
//							
//							for (int i = 0; i < n; i++)
//								thread_x[i] = x[i];
							
							//System.out.println("asdasd");
							//iterSuccess = true;
							//while (!converged) 
							//{
							//System.out.println("running " + first + " " + last);
//							double sum1;
//							double sum2;
							//long p0, p1, p2, p3, p4, p5, p6, p7;
		                    //long p8, p9, pa, pb, pc, pd, pe, pf;
								for (int i = first; i <= last; i++) // TODO: parallel team integer for loop here
							    {
							    	// Compute the upper and lower matrix product, omitting
							    	// the element at index i
									double[] A_i = A[i];
									double xVal = x[i];
									double yVal = b[i];
							    	//sum1 = 0.0;
							    	//sum2 = 0.0;
							    	// pad the variables
							    	//long p0, p1, p2, p3, p4, p5, p6, p7;
							    	//long p8, p9, pA, pB, pC, pD, pE, pF;
							    	for (int j = 0; j < i; j++) 
							    	{
							    		yVal -= (A_i[j] * x[j]);
							    	}
							    	for (int j = i + 1; j < n; j++) 
							    	{
							    		yVal -= (A_i[j] * x[j]);
							    	}
							    	
							    	// Compute and the y[] coordinate value.
							    	yVal /= A_i[i];  
							    	
							    	// Check to see if the algorithm converged for this
							    	// particular row in the matrix.
							    	if (!((Math.abs((2 * (xVal - yVal)) / (xVal + yVal))) < epsilon)) 
							    	{
							    		//System.out.println("x[i], y[i] = " + x[i] + " " + y[i]);
							    		//boolean oldVal = iterSuccess && false;
							    		//System.out.println("didn't converge");
							    		
							    		//iterSuccess.set(false); // JVM guarantees atomic set of this variable
							    		iterSuccess = false;
							    		
							    		//cr[i] = false;
							    	}
							    	
							    	// Save the y coordinate value.
							    	//y[i * 4] = yVal; - or go back to the old swapping routine...
							    	y[i] = yVal; // xVal
							    	z[i] = xVal; // yVal
							   // }
								
								// Explicitly wait at the barrier.
								//System.out.println("waiting");
								
								//System.out.println("gogogo");
							
							}
							//iterSuccess = true;
						}
						
						// Reduce per-thread histogram into global histogram.
//	                    public void finish() throws Exception
//	                    {
//	                    	
//	                    }
					},
					new BarrierAction()
					{
						public void run() throws Exception
						{
//							for (int i = 0; i < n; i++) {
//							System.out.println("x = " + x[i]);
//							
//							}
//							for (int i = 0; i < n; i++)
//							{
//								System.out.println("y = " + y[i]);
//							}
//							for (int i = 0; i < n; i++)
//							{
//								System.out.println("z = " + z[i]);
//							}
							//if (ping)
							if (iterSuccess == false)
							{
								//x = newX;
								double[] tmpX = x;
								double[] tmpY = y;
								double[] tmpZ = z;
								y = tmpZ;
								x = tmpY;
								z = tmpX;
								//itrs++;
								//ping = true; // pong
							}
							
//							System.out.println("AFTERF SWAP");
//							for (int i = 0; i < n; i++) {
//								System.out.println("x = " + x[i]);
//								
//								}
//								for (int i = 0; i < n; i++)
//								{
//									System.out.println("y = " + y[i]);
//								}
//								for (int i = 0; i < n; i++)
//								{
//									System.out.println("z = " + z[i]);
//								}
//							else
//							{
//								x = y;
//								y = z;
//								ping = false; // ping
//							}
//							for (int i = 0; i < n; i++) 
//						    { 
//						    	double tmp = x[i];
//					    		x[i] = y[i];
//					    		y[i] = tmp;
//					    	}
							//converged = new SharedBoolean(iterSuccess.get()); // set flag for continuation
							converged = iterSuccess;
							//System.out.println("converged = " + converged);
							//iterSuccess.set(true); // reset
							iterSuccess = true; // reset
							//System.out.println(itrs);
						}
					});
					}
					//}
					
					region().barrier();
				}
				/**public void finish() // swap here after all threads have computed their values
				{
					for (int i = 0; i < n; i++) 
				    { 
				    	double tmp = x[i];
			    		x[i] = y[i];
			    		y[i] = tmp;
			    	}
					converged = iterSuccess;
				}*/
			});
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
		    // Swap x[] and y[]
//			    for (int i = 0; i < n; i++) 
//			    { 
//			    	double tmp = x[i];
//		    		x[i] = y[i];
//		    		y[i] = tmp;
//		    	}
//			    index = 0;
//			    for (index = 0; index < n; index++) 
//			    {
//			    	if (!(Math.abs((2 * (x[index] - y[index])) / 
//			    			(x[index] + y[index])) < epsilon)) 
//			    	{
//			    		break;
//			    	}
//			    }
//			    
//			    converged = index < n ? false : true;
	    //}
		
		return x;
	}
	
	/**
	 * Display the program usage message and terminate abnormally.
	 * 
	 * @param none
	 * @return void
	 */
	public static void showUsage() 
	{
		System.err.println("Usage: java -Xmx2000m JacobiSmp <n> <seed>");
		System.exit(-1);
	}
}
