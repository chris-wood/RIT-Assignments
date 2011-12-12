package edu.rit.se.se441.activity1;

import java.util.HashMap;

/**
 * Banker class that is responsible for managing the bank's 
 * resources in a concurrent environment according to the 
 * Banker's Algorithm. 
 * 
 * This class is thread safe by synchronized shared mutable design pattern.
 * Since the state of the Banker must change, we chose to follow the 
 * shared mutable state design pattern for concurrency, in which
 * synchronization mechanisms are implemented in order to serialize
 * access to the shared state by all clients. Since each of the provided
 * methods are state-dependent, they must all be guarded by the same lock.
 * For our design, we chose to use the intrinsic lock for the Banker object,
 * meaning that all areas of interest are synchronized and guarded
 * by the lock associated with "this" instance of Banker.
 * 
 * With this design, it is guaranteed that all access to the bank's
 * state (which happens to be through all public methods on its interface)
 * is serialized using the Java monitor with the same intrinsic object lock.
 * 
 * @author Derek Erdmann
 * @author Christopher Wood
 */
public class Banker 
{
	/**
	 * The total number of units the banker must manage.
	 */
	private final int TOTAL_UNITS;
	
	/**
	 * The number of available units the banker is managing.
	 * 
	 * ---BANKER STATE---
	 */
	private int availableUnits; // GuardedBy("this")
	
	/** 
	 * Thread claim and allocation maps.
	 * 
	 * Note that since these claims and allocations may refer
	 * to any arbitrary "resource", we could have created a
	 * mutable inner class to wrap the specified resource type
	 * (or object). However, since the activity specification
	 * does not explicitly state the need to support more complex
	 * requirements, this design decision was not implemented.
	 * 
	 * ---BANKER STATE---
	 */
	private final HashMap<Long, Integer> claimMap; // GuardedBy("this")
	private final HashMap<Long, Integer> allocatedMap; // GuardedBy("this")
	
	/**
	 * Construct the Banker to manage nUnits of resources.
	 * 
	 * @param nUnits - the number of resource units the banker will manage.
	 */
	public Banker(final int nUnits)
	{
		TOTAL_UNITS = nUnits;
		availableUnits = nUnits;
		claimMap = new HashMap<Long, Integer>();
		allocatedMap = new HashMap<Long, Integer>();
	}
	
	/**
	 * Checks if the Banker's state will be safe after allocated
	 * the specified number of resources to the calling thread.
	 * 
	 * This method is synchronized because it must ensure that the 
	 * values used for the safe state check are the most up-to-date 
	 * values (i.e. they have crossed the memory barrier).
	 * 
	 * ---STATE DEPENDENT---
	 * Dependency: availableUnits
	 * Dependency: claimMap
	 * Dependency: allocatedMap
	 * 
	 * @param nUnits - The number of units the thread is requesting.
	 * @return Returns true if the state is safe.
	 */
	@SuppressWarnings("unchecked")
	private synchronized boolean checkState(int nUnits)
	{
		boolean safe = true;
		boolean stateChange = true;
		long curId = Thread.currentThread().getId();
		
		// Copy the bank state.
		int tempAvailable = availableUnits;
		HashMap<Long, Integer> tempAllocatedMap = 
				(HashMap<Long, Integer>) allocatedMap.clone();
		
		// Pretend to assign the current thread the needed resources.
		tempAvailable -= nUnits;
		tempAllocatedMap.put(curId, tempAllocatedMap.get(curId) + nUnits);
		
		// Determine if this new state is safe by pretending to allocate 
		// resources to clients.
		while (stateChange)
		{
			stateChange = false;
			for (Long id : tempAllocatedMap.keySet())
			{
				// If this client can be satisfied, assume that somewhere along the
				// line we give it the resources it needs and then it returns all of 
				// its allocated resources. Or simply, return its currently allocated
				// resources to the bank.
				int remaining = claimMap.get(id) - tempAllocatedMap.get(id);
				if (remaining <= tempAvailable && remaining != claimMap.get(id))
				{
					tempAvailable += tempAllocatedMap.get(id);
					tempAllocatedMap.put(id, 0);
					stateChange = true;
				}
			}
		}
		
		// If the temporary allocation map is now empty (all 0), then all 
		// threads could be satisfied in some order.
		for (Long id : tempAllocatedMap.keySet())
		{
			if (tempAllocatedMap.get(id) > 0)
			{
				safe = false;
				break;
			}
		}
		
		return safe;
	}
	
	/**
	 * Used by Client threads to register claims for resources.
	 * 
	 * This method is synchronized because it has the opportunity
	 * to modify the internal bank state (both the allocatedMap
	 * and the claimMap). 
	 * 
	 * ---STATE DEPENDENT---
	 * Dependency: claimMap
	 * Dependency: allocatedMap
	 * 
	 * @param nUnits - the number of units of resources the thread is claiming.
	 */
	public synchronized void setClaim(int nUnits)
	{
		long id = Thread.currentThread().getId();
		String name = Thread.currentThread().getName();
		
		if (nUnits <= TOTAL_UNITS && nUnits > 0)
		{
			if (claimMap.containsKey(id))
			{
				// This thread has already registered a claim.
				System.exit(1);
			}
			else
			{
				// Save the thread's resource claim.
				claimMap.put(id, nUnits);
				allocatedMap.put(id, 0);
				System.out.println( "Thread " + name + " sets a claim for " + 
						nUnits + " units." );
			}
		}
		else
		{
			// Number of units is not strictly positive or 
			// exceeds number of resources.
			System.exit(1);
		}
	}
	
	/**
	 * Allows Clients to request more resources.
	 * 
	 * This method is synchronized because it has the opportunity
	 * to modify the internal bank state (availableUnits, allocatedMap, 
	 * and the claimMap). 
	 * 
	 * ---STATE DEPENDENT---
	 * Dependency: availableUnits
	 * Dependency: claimMap
	 * Dependency: allocatedMap
	 * 
	 * @param nUnits - the number of additional resources being requested.
	 */
	public synchronized void request(int nUnits)
	{	
		long id = Thread.currentThread().getId();
		String name = Thread.currentThread().getName();
		
		if (nUnits > 0 && nUnits <= remaining() && claimMap.containsKey(id))
		{
			boolean allocated = false;
			
			System.out.println("Thread " + name + " requests " + nUnits + " units.");
			
			// Try to satisfy this request until it is actually met 
			// (i.e. the system ends up in a safe state).
			while (!allocated)
			{	
				// Check to see if we can find land in a safe state after
				// allocating nUnits to the calling thread.
				if (checkState(nUnits))
				{
					// Update the bank's state accordingly.
					availableUnits -= nUnits;
					allocatedMap.put(id, allocatedMap.get(id) + nUnits);
					allocated = true;
					
					// Display the appropriate message.
					// Note: This output message seems like it should be displaying
					// the total amount of allocated resource for the calling thread,
					// rather than the amount it was just given. However, as the 
					// writeup lists, it simply prints out the value of nUnits.
					System.out.println("Thread " + name + " has " + nUnits + 
							" units allocated.");
				}
				else
				{
					// Wait for the bank state to change and then retry allocation.
					try 
					{
						wait(); 
						System.out.println("Thread " + name + 
								" awakened in request.");
					}
					catch (InterruptedException e)
					{
						System.err.println("Error: Thread " + name + 
								" interrupted abnormally.");
						e.printStackTrace();
					}
				}
			}
		}
		else
		{
			// This thread has no registered claim or the value 
			// of nUnits is outside the valid range.
			System.exit(1);
		}
	}
	
	/**
	 * Allows Clients to release resources.
	 * 
	 * This method is synchronized because it has the opportunity
	 * to modify the internal bank state (availableUnits, allocatedMap, 
	 * and the claimMap). 
	 * 
	 * ---STATE DEPENDENT---
	 * Dependency: availableUnits
	 * Dependency: claimMap
	 * Dependency: allocatedMap
	 * 
	 * @param nUnits - the number of resources to release.
	 */
	public synchronized void release(int nUnits)
	{	
		long id = Thread.currentThread().getId();
		String name = Thread.currentThread().getName(); 
		
		// Check the criteria for releasing resources.
		if (nUnits > 0 && nUnits <= allocated() && claimMap.containsKey(id))
		{
			System.out.println("Thread " + name + " releases " + nUnits + " units.");
			
			// Adjust the bank's resources as necessary.
			availableUnits += nUnits;
			allocatedMap.put(id, allocatedMap.get(id) - nUnits);
		}
		else
		{
			// This thread has no registered claim or the value of nUnits 
			// it outside the valid range.
			System.exit(1);
		}
		
		// Notify any and all threads waiting for allocation.
		this.notifyAll();
	}
	
	/**
	 * Gets allocated resource total for the calling thread.
	 * 
	 * This method is synchronized to ensure that any concurrent
	 * updates on allocatedMap cross the memory barrier before
	 * they are read and returned to the calling thread.
	 * 
	 * ---STATE DEPENDENT---
	 * Dependency: allocatedMap
	 * 
	 * @return Returns the number of units allocated to the current thread.
	 */
	public synchronized int allocated()
	{
		return allocatedMap.get(Thread.currentThread().getId());
	}
	
	/**
	 * Gets the number of remaining units for the calling thread.
	 * 
	 * This method is synchronized to ensure that any concurrent
	 * updates on allocatedMap cross the memory barries before
	 * they are read and returned to the calling thread.
	 * 
	 * ---STATE DEPENDENT---
	 * Dependency: claimMap
	 * Dependency: allocatedMap
	 * 
	 * @return Returns the number of remaining units of resources for the 
	 * 	current thread.
	 */
	public synchronized int remaining()
	{
		return claimMap.get(Thread.currentThread().getId()) - 
				allocatedMap.get(Thread.currentThread().getId());
	}
}
