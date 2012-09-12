import java.math.BigInteger;

/**
 * The common class for all command sequence elements that specifies the
 * role of every element on the stack.
 * 
 * @author Christopher Wood, caw4567@rit.edu
 *
 */
public abstract class BirchElement {
	
	// Available types 
	public enum BirchType {
		INTEGER,
		COMMANDSTRING,
		INVALID
	}
	
	// Protected element type (replaces nasty instanceof checks)
	protected BirchType elementType;
	
	/**
	 * Default constructor that initializes the type.
	 * 
	 * @param type - the type.
	 */
	public BirchElement(BirchType type) {
		elementType = type;
	}
	
	/**
	 * Determine the element type.
	 * 
	 * @return - the element type.
	 */
	public BirchType getType() {
		return elementType;
	}
	
	// Abstract methods that must be overridden.
	public abstract String toString();
	public abstract BigInteger evaluate() throws Exception;
}
