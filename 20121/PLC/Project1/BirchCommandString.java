import java.math.BigInteger;

/**
 * A wrapper class for command sequences that are treated as data stack elements
 * used in Birch programs.
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */
public class BirchCommandString implements BirchElement {
	private String stringForm; 
	private Birch.BirchCommand birchCommand;
	private Birch birch;

	/**
	 * Constructor to initialize the underlying list for the command sequence.
	 * 
	 * @param newString
	 *            - the string form of the sequence, whitespace separated.
	 */
	public BirchCommandString(Birch birch, String newString, Birch.BirchCommand command) {
		stringForm = newString;
		birchCommand = command;
		this.birch = birch;
	}

	/**
	 * Forward the evaluation to the appropriate handler, or handle in-line.
	 */
	@Override
	public BigInteger evaluate() throws Exception {
		
		switch (birchCommand) {
		case ADD:
			handleMath(Birch.BirchCommand.ADD);
			break;
		case SUB:
			handleMath(Birch.BirchCommand.SUB);
			break;
		case MUL:
			handleMath(Birch.BirchCommand.MUL);
			break;
		case DIV:
			handleMath(Birch.BirchCommand.DIV);
			break;
		case REM:
			handleMath(Birch.BirchCommand.REM);
			break;
		case EQ:
			handleLogic(Birch.BirchCommand.EQ);
			break;
		case GT:
			handleLogic(Birch.BirchCommand.GT);
			break;
		case LT:
			handleLogic(Birch.BirchCommand.LT);
			break;
		case IFZ:
			break;
		case DUP:
			break;
		case POP:
			birch.stackPop();
			break;
		case SWAP:
			handleSwap();
			break;
		}
		
		return null;
	}
	
	private void handleIfz() {
		
	}
	
	private void handleDup() {
		
	}
	
	/**
	 * Handle the 'swap' command.
	 * 
	 * @throws Exception - whenever a runtime processing exception occurs.
	 */
	private void handleSwap() throws Exception {
		if (validBirchStackSize(2))
		{
			BirchElement element1 = birch.stackPop();
			BirchElement element2 = birch.stackPop();
			birch.stackPush(element1);
			birch.stackPush(element2);
		} else {
			throw new Exception("error");
		}
	}
	
	/**
	 * Handle common logic operations.
	 * 
	 * @param cmd - the math operation to perform.
	 * @throws Exception - whenever a runtime processing exception occurs.
	 */
	private void handleLogic(Birch.BirchCommand cmd) throws Exception {
		if (validBirchStackSize(2))
		{
			BigInteger op1 = birch.stackPop().evaluate();
			BigInteger op2 = birch.stackPop().evaluate();
			
			// Special case the division and remainder operations
			if (op1 != null && op2 != null) {
				BigInteger result = null;
				
				switch (cmd) {
				case EQ:
					if (op1.equals(op2)) {
						result = BigInteger.valueOf(1);
					} else {
						result = BigInteger.valueOf(0);
					}
					break;
				case GT:
					if (op1.longValue() > op2.longValue()) {
						result = BigInteger.valueOf(1);
					} else {
						result = BigInteger.valueOf(0);
					}
					break;
				case LT:
					if (op1.longValue() < op2.longValue()) {
						result = BigInteger.valueOf(1);
					} else {
						result = BigInteger.valueOf(0);
					}
					break;
				}
				
				birch.stackPush(new BirchInteger(result));
			} else {
				throw new Exception("error");
			}
		} else {
			throw new Exception("error");
		}
	}
	
	/**
	 * Handle common math operations.
	 * 
	 * @param cmd - the math operation to perform.
	 * @throws Exception - whenever a runtime processing exception occurs.
	 */
	private void handleMath(Birch.BirchCommand cmd) throws Exception {
		if (validBirchStackSize(2))
		{
			BigInteger op1 = birch.stackPop().evaluate();
			BigInteger op2 = birch.stackPop().evaluate();
			
			// Special case the division and remainder operations
			if ((cmd == Birch.BirchCommand.DIV || cmd == Birch.BirchCommand.REM) && 
					(op2.intValue() == 0)) {
				throw new Exception("error");
			}
			else if (op1 != null && op2 != null) {
				BigInteger result = null;
				
				switch (cmd) {
				case ADD:
					result = op1.add(op2);
					break;
				case SUB:
					result = op1.subtract(op2);
					break;
				case MUL:
					result = op1.multiply(op2);
					break;
				case DIV:
					result = op1.divide(op2);
					break;
				case REM:
					result = op1.remainder(op2);
					break;
				}
				
				birch.stackPush(new BirchInteger(result));
			} else {
				throw new Exception("error");
			}
		} else {
			throw new Exception("error");
		}
	}
	
	/**
	 * Helper method to verify the size of the birch stack before
	 * trying to process a command.
	 * 
	 * @param n - the number of elements needed on the stack
	 * @return
	 */
	private boolean validBirchStackSize(int n) {
		return birch.stackSize() >= n;
	}

	/**
	 * Format the command string for display
	 */
	@Override
	public String toString() {
		return "[" + stringForm + "]";
	}
}