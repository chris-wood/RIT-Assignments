import java.math.BigInteger;

/**
 * The common interface for all command sequence elements that abstracts the
 * role of every element on the stack.
 * 
 * @author Christopher Wood, caw4567@rit.edu
 *
 */
public interface BirchElement {
	public String toString();
	public BigInteger evaluate() throws Exception;
}
