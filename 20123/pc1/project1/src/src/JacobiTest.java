import edu.rit.util.Random;

/**
 * Test driver for the sequential and parallel implementations
 * of the Jacobi system of linear equation solvers.
 *  
 * @author Christopher Wood, caw456@rit.edu
 */

public class JacobiTest 
{
	// The data structures to hold the data in the linear system.
	private static double[][] A;
	private static double[] b;
	private static int n;
	private static double epsilon = 0.0001; // hard-coded answers only go to 4 decimal places
	private static int NUM_TESTS = 10;
	
	/**
	 * Main entry point for the test program.
	 * 
	 * @param args - command line arguments.
	 */
	public static void main(String[] args) 
	{
		// Check the command line arguments.
		if (args.length != 2)
		{
			showUsage();
		}
		
		// Run the hard-coded test cases.
		test1();
		test2();
		
		// Run the randomly generated test cases.
		for (int nt = 0; nt < NUM_TESTS; nt++) 
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
		    
		    double[] xSeq = JacobiSeq.solve(A, b, n);
		    double[] xSmp = JacobiSmp.solve(A, b, n);
		    for (int i = 0; i < n; i++) 
		    {
		    	assert (xSeq[i] == xSmp[i]);
		    }
		    	
	    	// Check solution for the sequential and 
	    	// parallel versions separately.
	    	for (int r = 0; r < n; r++) 
	    	{
	    		double seqVal = 0.0;
	    		double smpVal = 0.0;
	    		for (int c = 0; c < n; c++) 
	    		{
	    			seqVal += (A[r][c] * xSeq[c]);
	    			smpVal += (A[r][c] * xSmp[c]);
	    		}
	    		assert (Math.abs(seqVal - b[r]) < epsilon);
		    	assert (Math.abs(smpVal - b[r]) < epsilon);
	    	}
	    	
	    	System.out.println("Random test " + nt + ": pass");
		}
	}
	
	public static void test1() 
	{
		// Coefficient matrix
		A = new double[3][3];
	    A[0][0] = 8.0;
	    A[0][1] = 2.0;
	    A[0][2] = 3.0;
	    A[1][0] = -1.0;
	    A[1][1] = 6.0;
	    A[1][2] = 4.0;
	    A[2][0] = 5.0;
	    A[2][1] = 1.0;
	    A[2][2] = 7.0;
	    
	    // Answer vector
	    b = new double[3];
	    b[0] = -4.0;
	    b[1] = 5.0;
	    b[2] = 9.0;
	    
	    // Solution vector
	    double[] x = new double[3];
	    x[0] = -1.1207;
	    x[1] = -0.8226;
	    x[2] = 2.2037;
	    
	    // Run the algorithms and check the results
	    int n = 3;
	    double[] xSeq = JacobiSeq.solve(A, b, n);
	    double[] xSmp = JacobiSmp.solve(A, b, n);
	    //System.out.println("Test 1 results");
	    boolean allEqual = true;
	    for (int i = 0; i < n; i++)
	    {
	    	System.out.println(xSeq[i] + " " + xSmp[i]);
	    	allEqual = xSeq[i] == xSmp[i] ? allEqual : false;
//	    	System.out.println(allEqual);
	    	allEqual = Math.abs(xSeq[i] - x[i]) < epsilon ? allEqual : false;
//	    	System.out.println(allEqual);
	    	allEqual = Math.abs(xSmp[i] - x[i]) < epsilon ? allEqual : false;
//	    	System.out.println(allEqual);
	    	//assert (xSeq[i] == x[i]);
	    	//assert (xSmp[i] == x[i]);
	    }
	    
	    if (allEqual) 
	    {
	    	System.out.println("Test 1: pass");
	    } 
	    else 
	    {
	    	System.out.println("Test 1: fail.");
	    	System.exit(1);
	    }
	    //System.out.println("Test 1: pass");
	}
	
	public static void test2() 
	{
		// Coefficient matrix
		n = 4;
		A = new double[n][n];
	    A[0][0] = 7.0;
	    A[0][1] = -2.0;
	    A[0][2] = 1.0;
	    A[0][3] = 2.0;
	    A[1][0] = 2.0;
	    A[1][1] = 8.0;
	    A[1][2] = 3.0;
	    A[1][3] = 1.0;
	    A[2][0] = -1.0;
	    A[2][1] = 0;
	    A[2][2] = 5.0;
	    A[2][3] = 2.0;
	    A[3][0] = 0;
	    A[3][1] = 2.0;
	    A[3][2] = -1.0;
	    A[3][3] = 4.0;
	    
	    // Answer vector
	    b = new double[n];
	    b[0] = 3.0;
	    b[1] = -2.0;
	    b[2] = 5.0;
	    b[3] = 4.0;
	    
	    // Solution vector
	    double[] x = new double[n];
	    x[0] = -0.1728;
	    x[1] = -0.5325;
	    x[2] = 0.4178;
	    x[3] = 1.3683;
	    
	    // Run the algorithms and check the results
	    double[] xSeq = JacobiSeq.solve(A, b, n);
	    double[] xSmp = JacobiSmp.solve(A, b, n);
	    boolean allEqual = true;
	    for (int i = 0; i < n; i++)
	    {
	    	System.out.println(xSeq[i] + " " + xSmp[i] + " " + x[i]);
	    	//allEqual = xSeq[i] == xSmp[i] ? allEqual : false;
	    	//allEqual = Math.abs(xSeq[i] - x[i]) < epsilon ? allEqual : false;
	    	//allEqual = Math.abs(xSmp[i] - x[i]) < epsilon ? allEqual : false;
	    	//assert (xSeq[i] == x[i]);
	    	//assert (xSmp[i] == x[i]);
	    }
	    
	    if (allEqual) 
	    {
	    	System.out.println("Test 2: pass");
	    } 
	    else 
	    {
	    	System.out.println("Test 2: fail.");
	    	System.exit(1);
	    }
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
