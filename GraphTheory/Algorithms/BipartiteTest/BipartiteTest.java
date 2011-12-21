import java.util.*;
import java.io.*;

public class BipartiteTest
{

	public BipartiteTest()
	{
	}

	public boolean isBipartite(int[][] matrix, int size)
	{
		return visitNode(0, -1, 0, matrix, size, new HashMap<Integer, Integer>(), new ArrayList<Integer>());
	}

	public boolean visitNode(int vertex, int parentVertex, int depth, int[][] matrix, int size, HashMap<Integer, Integer> depthMap, ArrayList<Integer> visited)
	{
		boolean bipartite = true;

		if (visited.contains(vertex))
		{
			// Check the parity of the current depth against the visited depth
			if (Math.abs(depth - depthMap.get(vertex)) % 2 == 1)
			{
				bipartite = false;
			}
		}
		else
		{
			depthMap.put(vertex, depth);
			visited.add(vertex);

			for (int i = 0; i < size; i++)
			{
				// Continue DSF on neighbors
				if (matrix[vertex][i] == 1)
				{
					// Go deeper into the stack
					boolean result = visitNode(i, vertex, depth + 1, matrix, size, depthMap, visited);
					if (result == false)
					{
						bipartite = false;
						break;
					}
				}
			}
		}

		return bipartite;
	}

	public static void main(String[] args)
	{
		// Check the command line arguments 		
		if (args.length != 1)
		{
			System.err.println("usage: java BipartiteTest file");
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

			// Run this matrix through the bipartite tester
			BipartiteTest test = new BipartiteTest();
			boolean isBipartite = test.isBipartite(matrix, dimensions);
			System.out.println("Bipartite: " + isBipartite);
		}
		catch (IndexOutOfBoundsException ex1)
		{
			System.err.println("Error parsing adjacency matrix file.");
		}
		catch (NumberFormatException ex2)
		{
			System.err.println("Error parsing adjacency matrix file.");
		}
		catch (IOException ex3)
		{
			System.err.println("Error parsing adjacency matrix file.");
		}
	}
	
}
