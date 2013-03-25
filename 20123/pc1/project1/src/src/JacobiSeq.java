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
	private static double epsilon = 0.00000008;

	/**
	 * The main entry point for the JacobiSeq program.
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
	 *   java -Xmx2000m JacobiSeq <n> <seed>
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
		    
		    // Display the solution.
		    printSolution(start, n, x);
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
	 * @param n - the length of the solution vector.
	 * @param x[] - the solution vector
	 */
	public static void printSolution(Long start, int n, double[] x) 
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
	    Long end = System.currentTimeMillis();
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
	public static double[] solve(double[][] A, double[] b, int n) 
	{	
		// Allocate space for the solution and temporary variables
		double[] x = new double[n];
		double[] y = new double[n];
		
		// Initialize the x[] vector to 1
	    for (int i = 0; i < n; i++) 
	    {
	    	x[i] = 1.0;
	    }
	    
	    // Run until we converge
	    boolean converged = false;
	    while (!converged) 
	    {
	    	boolean iterSuccess = true;
		    for (int i = 0; i < n; i++) 
		    {
		    	// Compute the upper and lower matrix product, omitting
		    	// the element at index i
		    	double yVal = b[i];
		    	double xVal = x[i];
		    	for (int j = 0; j < i; j++) 
		    	{
		    		yVal-= (A[i][j] * x[j]);
		    	}
		    	for (int j = i + 1; j < n; j++) 
		    	{
		    		yVal -= (A[i][j] * x[j]);
		    	}
		    	
		    	// Compute and store the y[] value
		    	yVal = yVal / A[i][i];
		    	
		    	// Check for convergence.
		    	if (!(Math.abs((2 * (xVal - yVal)) / 
		    			(xVal + yVal)) < epsilon)) 
		    	{
		    		iterSuccess = false;
		    	}
		    	
		    	// Store the new y[] coordinate
		    	y[i] = yVal;
		    }
		    
		    // Swap the x[] and y[] vectors.
		    for (int i = 0; i < n; i++) 
		    { 
		    	double tmp = x[i];
	    		x[i] = y[i];
	    		y[i] = tmp;
	    	}
		    
		    // Reset the iteration variables.
		    converged = iterSuccess;
		    iterSuccess = true;
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
		System.err.println("Usage: java -Xmx2000m JacobiSeq <n> <seed>");
		System.exit(-1);
	}
}
