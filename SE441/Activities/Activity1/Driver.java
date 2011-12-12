package edu.rit.se.se441.activity1;

import java.util.ArrayList;

/**
 * Driver for the Banker's algorithm that maintains
 * the configuration parameters for the simulation and 
 * the logic necessary to kick off a simulation using
 * such parameters. 
 * 
 * @author Derek Erdmann
 * @author Christopher Wood
 */
public class Driver 
{
	/**
	 * The number of units the banker is managing. Modifying 
	 * this variable will change the total number of resources managed
	 * by the Banker. Therefore, lowering this value will increase competition
	 * and cause the clients to experience longer periods of starvation
	 * while waiting to be allocated a set of resources. Conversely,
	 * raising this value will decrease wait times by clients (almost
	 * entirely if raised high enough).
	 *
	 * This variable must be strictly positive.
	 */
	final private static int NUM_UNITS = 10;
	
	/**
	 * The number of clients that will be requesting resources.
	 * Increasing this variable will increase the amount of 
	 * competition for banker resources, while decreasing this
	 * variable will decrease the amount of competition for
	 * banker resources.
	 *
	 * This variable must be strictly positive in order for
	 * the simulation to run.
	 */
	final private static int NUM_CLIENTS = 50;
	
	/**
	 * The number of requests for each client. This variable
	 * should be modified to proportionally change the length 
	 * of the simulation, as each client thread remains alive 
	 * until it completes NUM_REQUESTS release/request events.
	 *
	 * This value must be strictly positive in order for 
	 * any bank transactions to occur.
	 */
	final private static int NUM_REQUESTS = 10;
	
	/**
	 * The minimum sleep time for client threads. Modifying this
	 * variable will impact the length of the simulation
	 * time and can potentially impact the amount of competition
	 * for the banker's resources (if it is decreased to a small
	 * enough millisecond value).
	 *
	 * This value must be strictly positive and less than or
	 * equal to MAX_SLEEP_TIME.
	 */
	final private static long MIN_SLEEP_TIME = 5;
	
	/**
	 * The maximum sleep time for client threads. Modifying this
	 * variable will impact the length of the simulation time and 
	 * can potentially impact the amount of competition for the banker's
	 * resources (if it is decreased to a value closer to MIN_SLEEP_TIME
	 * then the frequency of request/release events might increase).
	 *
	 * This value must be strictly positive and greater than or
	 * equal to MIN_SLEEP_TIME.
	 */
	final private static long MAX_SLEEP_TIME = 10;
	
	/**
	 * A constant pre-pended name for each client.
	 */
	final private static String CLIENT_NAME = "Client-";

	/**
	 * Main method for driving the Banker's Algorithm.
	 * 
	 * @param args - command line arguments.
	 */
	public static void main(String[] args) 
	{
		// Print start banner.
		System.out.println("Banker Simulation Starting");
		System.out.println("--------------------------");
		
		// Create the simulation objects (Banker and clients)
		Banker banker = new Banker(NUM_UNITS);
		ArrayList<Client> clients = new ArrayList<Client>();
		for (int i = 0; i < NUM_CLIENTS; i++)
		{
			Client client = new Client(CLIENT_NAME + i, banker, NUM_UNITS, 
					NUM_REQUESTS, MIN_SLEEP_TIME, MAX_SLEEP_TIME);
			clients.add(client);
		}
		
		// To increase competition, start all clients at the "same" time.
		for (int i = 0; i < NUM_CLIENTS; i++)
		{
			clients.get(i).start();
		}
		
		// Wait for all clients to complete.
		for (int i = 0; i < NUM_CLIENTS; i++)
		{
			try
			{
				clients.get(i).join();
			}
			catch (Exception e)
			{
				System.err.println("Error: Failure joining on Thread " + 
						clients.get(i).getName());
				e.printStackTrace();
				return;
			}
		}
		
		// Print closing banner.
		System.out.println("--------------------------");
		System.out.println("Banker Simulation Complete");
	}
}
