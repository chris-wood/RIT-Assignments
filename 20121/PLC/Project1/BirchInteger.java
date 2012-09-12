import java.math.BigInteger;

/**
 * A wrapper class for arbitrary precision integers that are used in Birch
 * programs.
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */
public class BirchInteger extends BirchElement {
	private BigInteger integer; 

	/**
	 * Constructor to initialize the underlying integer.
	 * 
	 * @param stringForm
	 *			- string representation of the integer.
	 */
	public BirchInteger(String stringForm) {
		super(BirchElement.BirchType.INTEGER);
		integer = new BigInteger(stringForm);
	}
	
	/**
	 * Constructor to initialize the underlying integer.
	 * 
	 * @param copy
	 * 			- a copy of another integer for initialization.
	 */
	public BirchInteger(BigInteger copy) {
		super(BirchElement.BirchType.INTEGER);
		integer = new BigInteger(copy.toString());
	}
	
	/**
	 * Copy constructor.
	 * 
	 * @param copy - the copy object.
	 */
	public BirchInteger(BirchInteger copy) {
		super(BirchElement.BirchType.INTEGER);
		this.integer = new BigInteger(copy.toString());
	}
	
	/**
	 * Evaluate this integer by simply returning the instance.
	 * @return the integer instance
	 */
	public BigInteger evaluate() throws Exception {
		return integer;
	}

	/**
	 * Format the integer for display
	 */
	public String toString() {
		return integer.toString();
	}
}