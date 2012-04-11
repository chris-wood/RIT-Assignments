import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;


public class StackDFS {
	
	public int[][] matrix;
	public int size;
	public int[] d;
	public int[] f;
	public int[] pi;
	public int[] color;
	public int time;
	
	public int WHITE = 0;
	public int GRAY = 1;
	public int BLACK = 2;
	
	public StackDFS(int[][] matrix, int size)
	{
		this.matrix = matrix;
		this.size = size;
		
		color = new int[size];
		d = new int[size];
		f = new int[size];
		pi = new int[size];
		time = 0;
	}
	
	public void DFS()
	{
		for (int i = 0; i < size; i++)
		{
			color[i] = WHITE;
			pi[i] = -1;
		}
		
		time = 0;
		ArrayList<Integer> SD = new ArrayList<Integer>();
		ArrayList<Integer> SF = new ArrayList<Integer>();
		ArrayList<Integer> TS = new ArrayList<Integer>();
		
		for (int i = 0; i < size; i++)
		{
			//System.out.println("trying " + i);
			if (color[i] == WHITE)
			{
				SD.add(i);
				//System.out.println("Starting with " + i);
				while (!SD.isEmpty())
				{
					int v = SD.get(SD.size() - 1);
					//System.out.println("visiting " + v);
					SD.remove(SD.size() - 1);
					if (color[v] == WHITE)
					{
						time++;
						d[v] = time;
						color[v] = GRAY;
						int vCount = 0;
						
						for (int j = size - 1; j >= 0; j--)
						{
							if (matrix[v][j] == 1)
							{
								if (color[j] == WHITE)
								{
									//System.out.println("for vertex " + v + ", adding " + j);
									SD.add(j);
									pi[j] = v;
									vCount++;
								}
							}
						}
						
						if (vCount == 0)
						{
							//SF.add(v);
							
							int v1 = v; //SF.get(SF.size() - 1);
							//SF.remove(SF.size() - 1);
							/*if (SF.size() == 0)
							{
								System.out.println("bottom out with v1 = " + v1);
								time++;
								f[v] = time;
								color[v] = BLACK;
							}
							else*/
							{
								boolean done = SF.size() == 0;
								while (!done)
								{
									int v2 = SF.get(SF.size() - 1);
									
									if (v1 != v2)
									{
										time++;
										f[v1] = time;
										color[v1] = BLACK;
										v1 = v2;
										SF.remove(SF.size() - 1);
										if (SF.size() == 0)
										{
											done = true;
										}
										else
										{
											v2 = SF.get(SF.size() - 1);
										}
										/*if (SF.size() == 1)
										{
											//System.out.println("size = 1");
											//v2 = SF.get(SF.size() - 1);
											time++;
											f[v1] = time;
											color[v1] = BLACK;
											done = true;
										}*/
										/*System.out.println("v1 = " + v1 + ", v2 = " + v2);*/
										System.out.print("SF: ");
										for (Integer j : SF)
										{
											System.out.print(j + " ");
										}
										System.out.println();
									}
									else
									{
										done = true;
									}
									System.out.print("SF: ");
									for (Integer j : SF)
									{
										System.out.print(j + " ");
									}
									System.out.println();
								}
								
								//System.out.println("v2 = " + v2);
								//boolean done = SF.size() == 0;
							}
						}
						else{
							for (int j = 0; j < vCount; j++)
							{
								SF.add(v);
							}
						}
						System.out.print("SF(" + v + "): ");
						for (Integer j : SF)
						{
							System.out.print(j + " ");
						}
						System.out.println();
					}
				}
				time++;
				f[i] = time;
				color[i] = BLACK;
				
			}
		}
	}

	/**
	 * Main entry point of program
	 * @param args
	 */
	public static void main(String[] args)
	{
		// Check the command line arguments
		if (args.length != 1)
		{
			System.err.println("usage: java CKLabel file");
			return;
		}
        
		// Try to create a buffer reader to parse the adjacency matrix
		try
		{
			BufferedReader reader = new BufferedReader(new FileReader(args[0]));
            
			// Now, read in the matrix dimensions
			int dimensions = Integer.parseInt(reader.readLine());
			int matrix[][] = new int[dimensions][dimensions];
			
			// Continue parsing in the rest of the data
			for (int i = 0; i < dimensions; i++)
			{
				String line = reader.readLine();
				String[] elements = line.split(" ");
				for (int j = 0; j < dimensions; j++)
				{
					matrix[i][j] = Integer.parseInt(elements[j]);
				}
			}
		
			// Run the property checkers here
			StackDFS checker = new StackDFS(matrix, dimensions);
			checker.DFS();
			
			for (int i = 0; i < dimensions; i++)
			{
				System.out.print("i = " + i + ", color = " + checker.color[i] + ", d = " + checker.d[i] + ", f = " + checker.f[i] + ", pi = " + checker.pi[i]);
				System.out.println();
			}
			
			System.out.println("done.");
		}
		catch (IndexOutOfBoundsException ex1)
		{
			System.err.println("Error parsing adjacency matrix file.");
			ex1.printStackTrace();
		}
		catch (NumberFormatException ex2)
		{
			System.err.println("Error parsing adjacency matrix file.");
			ex2.printStackTrace();
		}
		catch (IOException ex3)
		{
			System.err.println("Error parsing adjacency matrix file.");
			ex3.printStackTrace();
		}
	}
	
}
