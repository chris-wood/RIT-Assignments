import java.util.concurrent.locks.*;

/**
 * High performance, thread safe, singly linked list of Strings. The list
 * comprises Nodes, and as few nodes as possible are locked by any thread so as
 * to permit the greatest possible concurrency.
 * 
 * @author Thomas Yearke
 * @author Stephen Yingling
 * @author Kyle Mullins 
 * @author Christopher Wood
 */
public class HPList 
{
	/**
	 * Private inner class that wraps the data held by a single
	 * node in the HPList.
	 */
	class Node 
	{
		final String value; // String in this node; a null string ("") is a
							// dummy node.
		Node next; // The node following this one.
		final Lock lock; // Guards this node ;
		final Condition nextChanged; // Signaled when the next link for this
										// node changes.

		/**
		 * Constructor for a Node that initializes this node's value
		 * and the reference to its successor node in the list.
		 * 
		 * @param value - String value for this node.
		 * @param next - Successor of this node in the list.
		 */
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
		// Preemptive check to see if the node already exists in the list
		if (find(s, false))
		{
			return;
		}
		
		// Grab a lock on the head node to start the safe traversal
		Node currentNode = head;
		currentNode.lock.lock();
		try
		{
			// Find the correct spot in the list to insert the new node
			while (!isBeforeInsertLocation(currentNode, s))
			{
				currentNode = advance(currentNode);
			}
			
			// Insert the new node at this position
			currentNode.next.lock.lock();
			Node newNode = new Node(s, currentNode.next);
			currentNode.next = newNode;
			newNode.next.lock.unlock();
			currentNode.nextChanged.signalAll();
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			currentNode.lock.unlock();
		}
	}

	/**
	 * Returns true if String s is in the HPList, otherwise returns false. If
	 * block is true, will wait until s is inserted and unconditionally return
	 * true.
	 * 
	 * @param s - String value that is being searched for.
	 * @param block - Boolean flag indicating if the calling thread
	 *                should wait indefinitely until a node with the 
	 *                value s is inserted into the list at the correct 
	 *                position.
	 */
	public boolean find(String s, boolean block) 
	{
		boolean found = false;
		Node currentNode = head;
		
		// Grab a lock on the head node to begin the traversal
		currentNode.lock.lock();
		try
		{
			// Traverse the list until we find the location where the 
			// specified node should be
			while(!isBeforeInsertLocation(currentNode, s)) 
			{
				currentNode = advance(currentNode);
			}
	
			// Check to see where we are in the list and 
			// determine what to do next based on the value
			// for block.
			if (currentNode.next.value.isEmpty() && !block) 
			{
				return false;
			} 
			else if (currentNode.next.value.equals(s)) 
			{
				return true;
			} 
			else if (block) 
			{
				while(currentNode.next.value.compareTo(s) != 0) 
				{
					// Wait until the next node changes, at which point
					// we traverse farther into the list until we are
					// at the appropriate spot to check again.
					currentNode.nextChanged.await();
					while (!isBeforeInsertLocation(currentNode, s))
					{
						currentNode = advance(currentNode);
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
			currentNode.lock.unlock();
		}
		
		return found;
	}
	
	/**
	 * Helper method to perform the hand-over-hand locking traversal
	 * necessary to proceed further into the list.
	 * 
	 * @param currentNode - the node currently locked in the list.
	 * @return the new current node (currentNode's successor).
	 */
	private Node advance(Node currentNode)
	{
		Node nextNode = currentNode.next;
		nextNode.lock.lock();
		currentNode.lock.unlock();
		return nextNode;
	}
	
	/**
	 * Helper method to determine if we are at the position in
	 * the list where we can insert the desired string s.
	 * 
	 * @param currentNode - the current node pointer in the list.
	 * @param s - string that we are looking to insert into the list.
	 * @return true if we can insert a string at this next position,
	 *         false otherwise.
	 */
	private boolean isBeforeInsertLocation(Node currentNode, String s)
	{
    	return currentNode.next.value.isEmpty() || 
    			(currentNode.next.value.compareTo(s) >= 0);
    }
}
