import java.util.concurrent.locks.*;

/**
 * High performance, thread safe, singly linked list of Strings. The list
 * comprises Nodes, and as few nodes as possible are locked by any thread so as
 * to permit the greatest possible concurrency.
 */
public class HPList 
{
	class Node 
	{
		final String value; // String in this node; a null string ("") is a
							// dummy node.
		Node next; // The node following this one.
		final Lock lock; // Guards this node ;
		final Condition nextChanged; // Signaled when the next link for this
										// node changes.

		Node(String value, Node next) 
		{
			this.value = value;
			this.next = next;
			this.lock = new ReentrantLock();
			this.nextChanged = lock.newCondition();
		}
	}

	private Node head; // Head of list - always points to something

	/**
	 * An HP list always contains at least two nodes - a dummy head and a dummy
	 * tail.
	 */
	public HPList() 
	{
		head = new Node("", new Node("", null));
	}

	/**
	 * Insert string s into the HPList. Simply returns if s is already in the
	 * list, otherwise inserts it so as to keep the list in ascending order of
	 * strings.
	 */
	public void insert(String s)
	{
		Node cur = head;
		cur.lock.lock();
		cur.next.lock.lock();
		try
		{
			if (cur.next.value == "") 
			{
				Node newNode = new Node(s, cur.next);
				cur.next = newNode;
			}
			else
			{
				while (cur.next.value != "") 
				{
					if (s.compareTo(cur.next.value) < 0) 
					{
						Node newNode = new Node(s, cur.next);
						cur.next = newNode;
						cur.lock.unlock();
						cur.nextChanged.signalAll();
						cur.next.lock.unlock();
						return;
					} 
					else if (s.compareTo(cur.next.value) == 0) 
					{
						cur.lock.unlock();
						cur.next.lock.unlock();
						return;
					}
					else 
					{
						cur.lock.unlock();
						cur = cur.next;
						cur.next.lock.lock();
					}
				}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			cur.lock.unlock();
			cur.next.lock.unlock();
		}
	}

	/**
	 * Returns true if String s is in the HPList, otherwise returns false. If
	 * block is true, will wait until s is inserted and unconditionally return
	 * true.
	 */
	public boolean find(String s, boolean block) 
	{
		boolean found = false;
		Node cur = head;
		
		// Acquire locks to the first two elements in the list in order
		// to begin the list traversal
		cur.lock.lock();
		cur.next.lock.lock();
		try
		{
			// Traverse the list until we find the element we are looking for
			// or reach the spot where it should be located
			while(cur.next.value.compareTo(s) < 0) 
			{
				cur.lock.unlock();
				cur = cur.next;
				cur.next.lock.lock();
			}
	
			if (cur.next.value.equals("") && !block) 
			{
				return false;
			} 
			else if (cur.next.value.equals(s)) 
			{
				return true;
			} 
			else if (block) 
			{
				while(cur.next.value.compareTo(s) != 0) 
				{
					if(cur.next.value.compareTo(s) < 0) 
					{
						cur.lock.unlock();
						cur = cur.next;
						cur.next.lock.lock();
					}
					else
					{
						// Release the locks and await on a change signal
						cur.lock.unlock();
						cur.next.lock.unlock();
						try 
						{
							cur.nextChanged.await();
						}
						catch (InterruptedException e) 
						{
							e.printStackTrace();
						}
						
						// Re-acquire the lock to perform another check
						cur.lock.lock();
						cur.next.lock.lock();
					}
				}
				return true;
			}
		} 
		catch (Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			cur.lock.unlock();
			cur.next.lock.unlock();
		}
		
		return found;
	}
}