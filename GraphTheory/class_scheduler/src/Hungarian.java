import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.DecimalFormat;
import java.util.Arrays;
import java.util.Random;

public class Hungarian {
	double[][] matrix;
	int[] rCov;
	int[] cCov;
	int[][] stars;
	int rows;
	int cols;
	int dim;
	int solutions;
	Random rand = new Random();
	static int FORBIDDEN_VALUE = 9999;

	public Hungarian(int rows, int columns) 
	{
		this.rows = rows;
		this.cols = columns;
		dim = Math.max(rows, columns);
		// solutions = Math.min(rows,columns);
		solutions = dim;
		matrix = new double[dim][dim];
		stars = new int[dim][dim];
		rCov = new int[dim];
		cCov = new int[dim];
		init(rows, columns);
	}

	/**
	 * converts x,y to one dimension
	 */
	public int two2one(int x, int y) {
		return (x * dim) + y;
	}

	public int one2col(int n) {
		return (n % dim);
	}

	public int one2row(int n) {
		return (int) (n / dim);
	}

	// step 0 transform the matrix from maximization to minimization
	public void max2min() {

		double maxVal = Double.MIN_VALUE;
		for (int i = 0; i < rows; i++) {
			for (int j = 0; j < cols; j++) {
				if (matrix[i][j] > maxVal)
					maxVal = matrix[i][j];
			}
		}
		for (int i = 0; i < rows; i++)
			for (int j = 0; j < cols; j++) {
				matrix[i][j] = maxVal - matrix[i][j];
			}

		// System.out.println ("after max2min");
		// printIt();
	}

	// step1 find the minimum in each row and subtract it

	public void rowMin() {

		for (int i = 0; i < dim; i++) {
			double minVal = matrix[i][0];
			for (int j = 1; j < dim; j++) {
				if (minVal > matrix[i][j])
					minVal = matrix[i][j];
			}
			for (int j = 0; j < dim; j++)
				matrix[i][j] -= minVal;
		}
		// printIt();
		// printStars();
	}

	public void colMin() {

		for (int j = 0; j < dim; j++) {
			double minVal = matrix[0][j];
			for (int i = 1; i < dim; i++) {
				if (minVal > matrix[i][j])
					minVal = matrix[i][j];
			}
			for (int i = 0; i < dim; i++)
				matrix[i][j] -= minVal;
		}
		// printIt();
		// printStars();
	}

	public void printStars() {

		for (int i = 0; i < dim; i++) {
			for (int j = 0; j < dim; j++)
				System.out.print(stars[i][j] + " ");
			System.out.println(rCov[i]);
		}
		for (int j = 0; j < dim; j++)
			System.out.print(cCov[j] + " ");
		System.out.println();
	}

	// step2 star the zeros

	public void starZeros() {

		for (int i = 0; i < dim; i++)
			for (int j = 0; j < dim; j++) {
				if (matrix[i][j] == 0 && cCov[j] == 0 && rCov[i] == 0) {
					stars[i][j] = 1;
					cCov[j] = 1;
					rCov[i] = 1;
				}
			}
		clearCovers();
		// printIt();
		// printStars();
	}

	/**
	 * step 3 -- check for solutions
	 */
	public int coveredColumns() {

		int k = 0;
		for (int i = 0; i < dim; i++)
			for (int j = 0; j < dim; j++) {
				if (stars[i][j] == 1) {
					cCov[j] = 1;
				}
			}
		for (int j = 0; j < dim; j++)
			k += cCov[j];
		// printIt();
		// printStars();
		return k;
	}

	/**
	 * returns -1 if no uncovered zero is found a zero whose row or column is
	 * not covered
	 */
	public int findUncoveredZero() {
		for (int i = 0; i < dim; i++)
			for (int j = 0; j < dim; j++) {
				if (matrix[i][j] == 0 && rCov[i] == 0 && cCov[j] == 0) {

					return two2one(i, j);
				}
			}

		return -1;
	}

	/**
	 * returns -1 if not found returns the column if found
	 */
	public int foundStarInRow(int zeroY) {
		for (int j = 0; j < dim; j++) {
			if (stars[zeroY][j] == 1)
				return j;
		}
		return -1;
	}

	/**
	 * returns -1 if not found returns the row if found
	 */

	public int foundStarInCol(int zeroX) {
		for (int i = 0; i < dim; i++) {
			if (stars[i][zeroX] == 1)
				return i;
		}
		return -1;
	}

	/**
	 * step 4 Cover all the uncovered zeros one by one until no more cover the
	 * row and uncover the column
	 */

	public boolean coverZeros() {

		int zero = findUncoveredZero();
		while (zero >= 0) {
			int zeroCol = one2col(zero);
			int zeroRow = one2row(zero);
			stars[zeroRow][zeroCol] = 2; // prime it
			int starCol = foundStarInRow(zeroRow);

			if (starCol >= 0) {
				rCov[zeroRow] = 1;
				cCov[starCol] = 0;
			} else {
				// printStars();
				starZeroInRow(zero); // step 5
				return false;
			}
			zero = findUncoveredZero();
		}
		// printIt();
		// printStars();
		return true;
	}

	public int findStarInCol(int col) {
		if (col < 0) {
			System.err.println("Invalid column index " + col);
		}
		for (int i = 0; i < dim; i++) {
			if (stars[i][col] == 1)
				return i;
		}
		return -1;
	}

	public void clearCovers() {
		for (int i = 0; i < dim; i++) {
			rCov[i] = 0;
			cCov[i] = 0;
		}
	}

	/**
	 * unstar stars star primes
	 */

	public void erasePrimes() {
		for (int i = 0; i < dim; i++)
			for (int j = 0; j < dim; j++) {
				if (stars[i][j] == 2)
					// stars[i][j] = 1;
					stars[i][j] = 0;
			}
	}

	public void convertPath(int[][] path, int kount) {
		// printStars();
		for (int i = 0; i <= kount; i++) {
			int x = path[i][0];
			int y = path[i][1];
			if (stars[x][y] == 1)
				stars[x][y] = 0;
			else if (stars[x][y] == 2)
				stars[x][y] = 1;
		}
		// printStars();
	}

	/**
	 * returns the column where a prime was found for a given row
	 */

	public int findPrimeInRow(int row) {
		for (int j = 0; j < dim; j++)
			if (stars[row][j] == 2)
				return j;
		System.err.println("No prime in row " + row + " found");
		forcePrint();
		return -1;
	}

	/**
	 * step 5 augmenting path algorithm go back to step 3
	 */
	public void starZeroInRow(int zero) {
		boolean done = false;
		int zeroRow = one2row(zero); // row
		int zeroCol = one2col(zero); // column

		int kount = 0;
		int[][] path = new int[100][2]; // how to dimension that?
		path[kount][0] = zeroRow;
		path[kount][1] = zeroCol;
		while (!done) {
			int r = findStarInCol(path[kount][1]);
			if (r >= 0) {
				kount++;
				path[kount][0] = r;
				path[kount][1] = path[kount - 1][1];
			} else {
				done = true;
				break;
			}
			int c = findPrimeInRow(path[kount][0]);

			kount++;
			path[kount][0] = path[kount - 1][0];
			path[kount][1] = c;
		}
		convertPath(path, kount);
		clearCovers();
		erasePrimes();
		// printIt();
		// printStars();
		// go to step 3
	}

	public void solve() {
		// System.out.println ("in solve");
		// forcePrint();
		// printIt();
		max2min();
		rowMin(); // step 1
		colMin();
		starZeros(); // step 2
		boolean done = false;
		while (!done) {
			int covCols = coveredColumns();// step 3
			// if (covCols == dim) {
			if (covCols >= solutions) {
				// printStarZeros();
				break;
			}

			done = coverZeros(); // step 4 (calls step 5)
			while (done) {
				double smallest = findSmallestUncoveredVal();
				uncoverSmallest(smallest); // step 6
				done = coverZeros();
			}
			// System.out.println ("Continue(y/n)?");
			// System.out.flush();
			// char response = human.readChar();
			// if (response == 'n')
			// break;

		}
	}

	boolean freeRow(int row, int col) {
		for (int i = 0; i < dim; i++)
			if (i != row && stars[i][col] == 1)
				return false;
		return true;
	}

	boolean freeCol(int row, int col) {
		for (int j = 0; j < dim; j++)
			if (j != col && stars[row][j] == 1)
				return false;
		return true;
	}

	// read from left to right:
	// Role i is assigned to agent j
	public void printStarZeros() {
		for (int i = 0; i < rows; i++)
			for (int j = 0; j < cols; j++) {
				// check for independence
				if (stars[i][j] == 1 && (freeRow(i, j) || freeCol(i, j)))
					System.out.println(i + " assigned to " + j
							+ " is a solution");
			}
	}

	// get the assignments for the agents
	// the matrix is roles x agents
	public int[] getSolutions() {
		int[] solutions = new int[cols];
		for (int j = 0; j < cols; j++) {
			solutions[j] = -1;
			for (int i = 0; i < rows; i++) {
				// test for independence
				// should not be necessary
				if (stars[i][j] == 1 && (freeRow(i, j) || freeCol(i, j)))
					solutions[j] = i;
			}
		}
		return solutions;
	}

	public double findSmallestUncoveredVal() {
		double minVal = Double.MAX_VALUE;
		for (int i = 0; i < dim; i++)
			for (int j = 0; j < dim; j++) {
				if (rCov[i] == 0 && cCov[j] == 0) {
					if (minVal > matrix[i][j])
						minVal = matrix[i][j];
				}
			}
		return minVal;
	}

	/**
	 * step 6 modify the matrix if the row is covered, add the smallest value if
	 * the column is not covered, subtract the smallest value
	 */
	public void uncoverSmallest(double smallest) {
		for (int i = 0; i < dim; i++)
			for (int j = 0; j < dim; j++) {
				if (rCov[i] == 1)
					matrix[i][j] += smallest;
				if (cCov[j] == 0)
					matrix[i][j] -= smallest;
			}
		// printIt();
		// printStars();
	}

	public void init(int rows, int cols) {
		for (int i = 0; i < dim; i++)
			for (int j = 0; j < dim; j++) {
				if (i < rows && j < cols) // feasible solutions
					matrix[i][j] = rand.nextDouble();
				else
					matrix[i][j] = FORBIDDEN_VALUE;
			}
		// matrix[0][0] = 0.0;
		// matrix[0][1] = 0.5;
		// matrix[0][2] = 0.0;
		// matrix[0][3] = 0.0;
		// // matrix[0][4] = 0.17;
		// // matrix[0][5] = 0.25;
		// // matrix[0][6] = 0.12;
		// // matrix[0][7] = 0.25;
		// matrix[1][0] = 0.5;
		// matrix[1][1] = 0.0;
		// matrix[1][2] = 0.0;
		// matrix[1][3] = 0.0;
		// // matrix[1][4] = 0.17;
		// // matrix[1][5] = 0.25;
		// // matrix[1][6] = 0.10;
		// // matrix[1][7] = 0.25;
		// matrix[2][0] = 0.0;
		// matrix[2][1] = 0.0;
		// matrix[2][2] = 0.2;
		// matrix[2][3] = 0.3;
		// // matrix[2][4] = 0.12;
		// // matrix[2][5] = 0.17;
		// // matrix[2][6] = 0.10;
		// // matrix[2][7] = 0.25;

	}

	public void forcePrint() {
		DecimalFormat form = new DecimalFormat("0.00");
		for (int i = 0; i < dim; i++) {
			for (int j = 0; j < dim; j++)
				System.out.print(form.format(matrix[i][j]) + " ");
			System.out.println();
		}
	}

	public void printIt() {
		DecimalFormat form = new DecimalFormat("0.00");
		for (int i = 0; i < dim; i++) {
			for (int j = 0; j < dim; j++)
				System.out.print(form.format(matrix[i][j]) + " ");
			System.out.println();
		}
	}

	public void addColumn(int index, double[] preferences) {
		for (int i = 0; i < preferences.length; i++) {
			matrix[i][index] = preferences[i];
		}
	}

	public void addRow(int index, double[] preferences) {
		for (int i = 0; i < preferences.length; i++) {
			matrix[index][i] = preferences[i];
		}
	}

	public void readMatrix(String filename) throws IOException {
		FileInputStream in = new FileInputStream(filename);
		BufferedReader br = new BufferedReader(new InputStreamReader(in));
		String line, token;
		line = br.readLine();
		int i = 0;
		while (line != null) {
			String[] vals = line.split("\\s");
			double[] v = new double[vals.length];
			int k = 0;
			for (String val : vals)
				v[k++] = Double.parseDouble(val);
			System.out.println(i + " " + Arrays.toString(v));
			addRow(i++, v);
			line = br.readLine();
		}
	}

	public static void printUsage() {
		System.out.println("Required parameters are: rows cols matrixfile");
	}

	/**
	 * Main entry point of program
	 * 
	 * @param args
	 */
	public static void main(String[] args) {
		// Check the command line arguments
		if (args.length != 1) {
			System.err.println("usage: java CKLabel file");
			return;
		}

		// Try to create a buffer reader to parse the adjacency matrix
		try {
			BufferedReader reader = new BufferedReader(new FileReader(args[0]));

			// Now, read in the matrix dimensions
			int dimensions = Integer.parseInt(reader.readLine());
			int matrix[][] = new int[dimensions][dimensions];

			// Continue parsing in the rest of the data
			for (int i = 0; i < dimensions; i++) {
				String line = reader.readLine();
				String[] elements = line.split(" ");
				for (int j = 0; j < dimensions; j++) {
					matrix[i][j] = Integer.parseInt(elements[j]);
				}
			}
			
			// TODO: the matrix is the cost matrix, not the adjacency matrix

			// Run the property checkers here
			// TreeChecker checker = new TreeChecker(matrix, dimensions);
			// System.out.println(checker.testForSubdividedP3());
			// System.out.println(checker.testMajorP3());
		} catch (IndexOutOfBoundsException ex1) {
			System.err.println("Error parsing adjacency matrix file.");
			ex1.printStackTrace();
		} catch (NumberFormatException ex2) {
			System.err.println("Error parsing adjacency matrix file.");
			ex2.printStackTrace();
		} catch (IOException ex3) {
			System.err.println("Error parsing adjacency matrix file.");
			ex3.printStackTrace();
		}
	}
}
