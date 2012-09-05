import java.math.BigInteger;

/**
 * The common class for all command sequence elements that specifies the
 * role of every element on the stack.
 * 
 * @author Christopher Wood, caw4567@rit.edu
 *
 */
public abstract class BirchElement {
	public abstract String toString();
	public abstract BigInteger evaluate() throws Exception;
}
