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
		try {
			int n = Integer.parseInt(args[0]);
			long seed = Long.parseLong(args[1]);
			
			// Create a random matrix
		    double[][] A = new double[n][n];
		    double[] b = new double[n];
		    Random prng = Random.getInstance(seed);
		    for (int i = 0; i < n; ++ i) {
		        for (int j = 0; j < n; ++ j) {
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
	static boolean converged = false;
	public static double[] solve(final double[][] A, final double[] b, final int n) 
	{	
		// Allocate space for the solution and temporary variables
		x = new double[n];
		//final double[] localX = new double[n];
		y = new double[n];
		//int index = 0;
		
		// Initialize the x[] vector to 1
	    for (int i = 0; i < n; i++) 
	    {
	    	x[i] = 1.0;
	    	//localX[i] = 1.0;
	    }
	    
	    // Run until we converge
	    converged = false;
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
				boolean iterSuccess = true;
				
				public void run() throws Exception 
				{
					while (!converged) {
						region().barrier();
					
						if (!converged) {
					execute(0, n - 1, new IntegerForLoop()
					{
						public void run(int first, int last)
						{
							//System.out.println("asdasd");
							//iterSuccess = true;
							//while (!converged) 
							//{
							//System.out.println("running " + first + " " + last);
								for (int i = first; i <= last; i++) // TODO: parallel team integer for loop here
							    {
							    	// Compute the upper and lower matrix product, omitting
							    	// the element at index i
							    	double sum1 = 0.0;
							    	double sum2 = 0.0;
							    	// pad the variables
							    	//long p0, p1, p2, p3, p4, p5, p6, p7;
							    	//long p8, p9, pA, pB, pC, pD, pE, pF;
							    	for (int j = 0; j < i; j++) 
							    	{
							    		sum1 += (A[i][j] * x[j]);
							    	}
							    	for (int j = i + 1; j < n; j++) 
							    	{
							    		sum2 += (A[i][j] * x[j]);
							    	}
							    	
							    	// Compute and store the y[] value
							    	//y[i] = (b[i] - sum1 - sum2) / A[i][i];
							    	//double tmp = x[i];
							    	
							    	y[i] = (b[i] - sum1 - sum2) / A[i][i];
							    	
							    	// Check to see if the algorithm converged for this
							    	// particular row in the matrix.
							    	if (!(Math.abs((2 * (x[i] - y[i])) / 
							    			(x[i] + y[i])) < epsilon)) 
							    	{
							    		//System.out.println("x[i], y[i] = " + x[i] + " " + y[i]);
							    		//boolean oldVal = iterSuccess && false;
							    		iterSuccess = false; // JVM guarantees atomic set of this variable
							    	}
							   // }
								
								// Explicitly wait at the barrier.
								//System.out.println("waiting");
								
								//System.out.println("gogogo");
							
							}
							//iterSuccess = true;
						}
					},
					new BarrierAction()
					{
						public void run() throws Exception
						{
							//System.out.println("converging");
							for (int i = 0; i < n; i++) 
						    { 
						    	double tmp = x[i];
					    		x[i] = y[i];
					    		y[i] = tmp;
					    	}
							converged = iterSuccess; // set flag for continuation
							//System.out.println("converged = " + converged);
							iterSuccess = true; // reset
						}
					});
					}
					}
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
		System.err.println("Usage: java -Xmx2000m JacobiSeq <n> <seed>");
		System.exit(-1);
	}
}
