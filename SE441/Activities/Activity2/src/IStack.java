/**
 * This is the interface that all stacks
 * must conform to. It provides a set of
 * public methods that are used to push and
 * pop string elements onto the underlying stack.
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */
public interface IStack 
{
	/**
	 * Push a single string element onto the stack.
	 * 
	 * @param element - the string object to push onto the stack
	 */
	public void push(String element);
	
	/**
	 * Pop a string from the top of the stack and return it
	 * to the caller.
	 * 
	 * @return - the string that was previously on the top of the stack
	 */
    public String pop();
}
