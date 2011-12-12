package edu.rit.se.se441.activity1;

import java.util.Random;

/**
 * Client thread class that is responsible for 
 * periodically attempting to either request or release
 * resources from the banker until it has reached its
 * specified transaction count (nRequests). 
 * 
 * @author Derek Erdmann
 * @author Christopher Wood
 */
public class Client extends Thread 
{
	/**
	 * The single, shared banker resource.
	 */
	private Banker banker;
	
	/**
	 *  Client fields that control its requests to the banker.
	 */
	private int nUnits;
	private int nRequests;
	private long minSleepMillis;
	private long maxSleepMillis;
	
	/**
	 * Construct a Client thread.
	 * 
	 * @param name - the name of the thread.
	 * @param banker - the Banker object for acquiring resources.
	 * @param nUnits - the number of units to claim.
	 * @param nRequests - the number of requests to make.
	 * @param minSleepMillis - the minimum time the thread should sleep.
	 * @param maxSleepMillis - the maximum time the thread should sleep.
	 */
	public Client(String name, Banker banker, int nUnits, int nRequests, 
					long minSleepMillis, long maxSleepMillis)
	{
		super(name);
		
		// Store the private fields.
		this.banker = banker;
		this.nUnits = nUnits;
		this.nRequests = nRequests;
		this.minSleepMillis = minSleepMillis;
		this.maxSleepMillis = maxSleepMillis;
		
	}
	
	/**
	 * Registers a claim for nUnits of resources, then makes a finite
	 * number of transaction requests to the shared Banker object.
	 */
	@Override
	public void run()
	{
		// Choose a different random seed every time.
		Random prng = new Random(System.currentTimeMillis());
		
		// Claim a number of resources with the banker.
		if (nUnits <= 0)
		{
			// This should not occur if the configuration parameters are
			// set appropriately. But just in case, we force the claim value
			// to be 0 (since it's the only possible value), which will cause
			// banker.setClaim() to invoke System.exit(1).
			banker.setClaim(0);
		}
		else
		{
			// We can generate a valid claim of up to nUnits that is
			// strictly positive.
			banker.setClaim(prng.nextInt(nUnits) + 1); // [1,nUnits]
		}
		
		// Loop through the number of transactions for this client.
		for (int i = 0; i < nRequests; i++)
		{
			if (banker.remaining() == 0)
			{
				banker.release(prng.nextInt(banker.allocated()) + 1); // [1,allocated()]
			}
			else if (banker.allocated() == 0)
			{
				banker.request(prng.nextInt(banker.remaining()) + 1); // [1,remaining()]
			}
			else
			{
				// Randomly decide to release/request resources.
				int choice = prng.nextInt(2);
				if (choice < 1) // 50/50 chance
				{
					int amount = prng.nextInt(banker.allocated()) + 1;
					banker.release(amount); // [1,allocated()]
				}
				else
				{
					int amount = prng.nextInt(banker.remaining()) + 1;
					banker.request(amount); // [1,remaining()]
				}
			}
			
			// Sleep for a little bit to let the other clients work.
			try 
			{
				Thread.sleep((long)(prng.nextInt((int)(maxSleepMillis - minSleepMillis)) 
						+ minSleepMillis));
			}
			catch (InterruptedException e)
			{
				System.err.println("Error: Thread " + Thread.currentThread().getName() + 
						" interrupted abnormally.");
				e.printStackTrace();
			}
		}
		
		// Release all units still allocated (if any) and return 
		// (terminate the thread).
		if (banker.allocated() > 0)
		{
			banker.release(banker.allocated());
		}
	}
}
