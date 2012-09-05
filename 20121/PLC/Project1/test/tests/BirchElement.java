import java.math.BigInteger;

/**
 * The common interface for all command sequence elements that abstracts the
 * role of every element on the stack.
 * 
 * @author Christopher Wood, caw4567@rit.edu
 *
 */
public abstract class BirchElement {
	
	// Enumeration to identify the element type when interpreting
	public enum BirchElementType {
		INT,
		COMMAND
	}
	
	// Abstract methods that all subclasses must provide
	public abstract String toString();
	public abstract BigInteger evaluate() throws Exception;
}
