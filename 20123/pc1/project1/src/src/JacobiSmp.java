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
import edu.rit.pj.ParallelRegion;
import edu.rit.pj.ParallelTeam;
import edu.rit.util.Random;

public class JacobiSmp 
{
	// The data structures to hold the calculation data structures.
	static double[] y;
	static double[] x;
	
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
		
		// Parse the command line arguments.
		long start = System.currentTimeMillis();
		try 
		{
			final int n = Integer.parseInt(args[0]);
			final long seed = Long.parseLong(args[1]);
			
			// Create a random matrix.
		    final double[][] A = new double[n][n];
		    final double[] b = new double[n];
		    
		    // Generate the matrix data in parallel using multiple threads.
		    // Otherwise this becomes a significant part of the seq. fraction.
		    new ParallelTeam().execute(new ParallelRegion() 
			{	
				public void run() throws Exception 
				{
					execute(0, n - 1, new IntegerForLoop()
					{
						// Set up per-thread PRNG.
	                    Random prng_thread = Random.getInstance(seed);
	                    
						public void run(int first, int last)
						{
							// Skip the PRNG ahead to the right place in the sequence.
							// Each iteration gets (n + 1) values 
							prng_thread.setSeed(seed); 
	                        prng_thread.skip ((n + 1) * first);
	                        for (int i = first; i <= last; ++ i) 
	                        {
								for (int j = 0; j < n; ++ j)
						        {
						        	A[i][j] = (prng_thread.nextDouble() * 9.0) + 1.0;
						        }
						        A[i][i] += 10.0 * n;
						        b[i] = (prng_thread.nextDouble() * 9.0) + 1.0;
	                        }
						}
					});
				}
			});
		    
		    // Solve the system and display the solution.
		    double[] x = solve(A, b, n);
		    printSolution(start, x, n);
		}
		catch (NumberFormatException ex1) 
		{
			System.err.println("Error parsing command line arguments.");
			ex1.printStackTrace();
		}
		catch (Exception ex1) 
		{
			System.err.println("Error in the ParallelRegion run() method.");
			ex1.printStackTrace();
		}
	}
	
	/**
	 * Display the solution vector and program runtime.
	 * 
	 * @param start - start time for program run
	 * @param x[] - the solution vector
	 * @param n - the number of entries in the vector x[]
	 */
	public static void printSolution(long start, double[] x, int n) 
	{
	    if (n <= 100)
	    {
	    	for (int i = 0; i < n; ++ i)
	    	{
	        	System.out.printf("%d %g%n", i, x[i]);
	    	}
	    }
	    else
	    {
	    	for (int i = 0; i <= 49; ++ i)
	    	{
	        	System.out.printf("%d %g%n", i, x[i]);
	    	}
	        for (int i = n - 50; i < n; ++ i)
	        {
	        	System.out.printf("%d %g%n", i, x[i]);
	        }
	    }
	    long end = System.currentTimeMillis();
	    System.out.printf("%d msec%n", (end - start)); 
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
	public static double[] solve(final double[][] A, final double[] b, final int n) 
	{	
		// Allocate space for the solution and temporary variables.
		x = new double[n];
		y = new double[n];
		
		// Initialize the x[] and y[] vectors to 1
	    for (int i = 0; i < n; i++) 
	    {
	    	x[i] = y[i] = 1.0;
	    }
	    
    	try 
    	{
			new ParallelTeam().execute(new ParallelRegion() 
			{
				// Boolean variables to control the algorithm iterations.
				boolean converged = false;
				boolean iterSuccess = true;
				
				public void run() throws Exception 
				{
					while (!converged) 
					{
						execute(0, n - 1, new IntegerForLoop()
						{
							public void run(int first, int last)
							{
								for (int i = first; i <= last; i++) 
							    {
							    	// Compute the upper and lower matrix product, omitting
							    	// the element at index i.
									double[] A_i = A[i];
									double xVal = x[i];
									double yVal = 0.0;
									double sum1 = 0.0;
									double sum2 = 0.0;
							    	for (int j = 0; j < i; j++) 
							    	{
							    		sum1 += (A_i[j] * x[j]);
							    	}
							    	for (int j = i + 1; j < n; j++) 
							    	{
							    		sum2 += (A_i[j] * x[j]);
							    	}
							    	
							    	// Compute and store the y[] coordinate value.
							    	yVal = (b[i] - sum1 - sum2) / A_i[i];
							    	y[i] = yVal;
							    	
							    	// Check to see if the algorithm converged for this
							    	// particular row in the matrix.
							    	if (iterSuccess && 
							    		!((Math.abs((2 * (xVal - yVal)) / (xVal + yVal))) < epsilon)) 
							    	{
							    		iterSuccess = false; // JVM guarantees atomic set of this variable
							    	}
								}
							}
						},
						new BarrierAction() // perform the sequential swap at the end of the for loop
						{
							public void run() throws Exception
							{
								if (iterSuccess == false)
								{
									double[] tmp = x;
									x = y;
									y = tmp;
								}
								converged = iterSuccess;
								iterSuccess = true; // reset
							}
						});
					}
				}
			});
		} 
    	catch (Exception e) 
    	{
			e.printStackTrace();
		}
    	
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
