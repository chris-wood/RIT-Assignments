/**
 * This class implements a sequential version of the Jacobi linear
 * system solving algorithm. 
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */
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
		if (args.length != 2) {
			System.err.println("Usage: java -Xmx2000m JacobiSeq <n> <seed>");
			System.exit(-1);
		}
		
		// TODO: continue here using sample code on the website
	}
	
}
