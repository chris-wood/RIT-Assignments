/**
 * This class implements a sequential version of the Jacobi linear
 * system solving algorithm. 
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */

import edu.rit.util.Random;

public class JacobiSeq {

	/**
	 * The main entry point for the JacobiSeq program.
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
	public static void main(String[] args) {
		// Before anything, verify the correct number of arguments
		// were passed into the program. 
		/*if (args.length != 2) {
			System.err.println("Usage: java -Xmx2000m JacobiSeq <n> <seed>");
			System.exit(-1);
		}*/
		
		// Parse the command line arguments
		try {
			/*int n = Integer.parseInt(args[0]);
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
	        }*/
		    
			Long start = System.currentTimeMillis();
			
		    double[][] A = new double[3][3];
		    A[0][0] = 8.0;
		    A[0][1] = 2.0;
		    A[0][2] = 3.0;
		    A[1][0] = -1.0;
		    A[1][1] = 6.0;
		    A[1][2] = 4.0;
		    A[2][0] = 5.0;
		    A[2][1] = 1.0;
		    A[2][2] = 7.0;
		    
		    double[] b = new double[3];
		    b[0] = -4.0;
		    b[1] = 5.0;
		    b[2] = 9.0;
		    
		    // algorithm implementation
		    int n = 3;
		    double epsilon = 0.00000008;
		    double[] x = new double[n];
		    for (int i = 0; i < n; i++) {
		    	x[i] = 1.0;
		    }
		    double[] y = new double[n];
		    boolean converged = false;
		    int rounds = 0;
		    while (!converged) {
			    for (int i = 0; i < n; i++) {
			    	double sum1 = 0.0;
			    	double sum2 = 0.0;
			    	for (int j = 0; j < i; j++) {
			    		sum1 += (A[i][j] * x[j]);
			    	}
			    	for (int j = i + 1; j < n; j++) {
			    		sum2 += (A[i][j] * x[j]);
			    	}
			    	double num = b[i] - sum1 - sum2;
			    	double den = A[i][i];
			    	y[i] = num / den;
			    }
			    for (int i = 0; i < n; i++) { // swap
			    	double tmp = x[i];
		    		x[i] = y[i];
		    		y[i] = tmp;
		    	}
			    
			    int index = 0;
			    for (index = 0; index < n; index++) {
			    	if (!(Math.abs((2 * (x[index] - y[index])) / (x[index] + y[index])) < epsilon)) {
			    		break;
			    	}
			    }
			    rounds++;
			    converged = index < n ? false : true;
		    }
		    System.out.println("rounds = " + rounds);
		    
		    Long end = System.currentTimeMillis();
		    
		    // int n = Matrix dimension
		    // double[] x = Array containing solution vector
		    // long t = Running time in milliseconds
		    if (n <= 100)
		        for (int i = 0; i < n; ++ i)
		            System.out.printf ("%d %g%n", i, x[i]);
		    else
		        {
		        for (int i = 0; i <= 49; ++ i)
		            System.out.printf ("%d %g%n", i, x[i]);
		        for (int i = n - 50; i < n; ++ i)
		            System.out.printf ("%d %g%n", i, x[i]);
		        }
		    System.out.printf ("%d msec%n", (end - start)); 
		    
		} catch (NumberFormatException ex1) {
			System.err.println("Error parsing command line arguments.");
			ex1.printStackTrace();
		}
	}
	
}
