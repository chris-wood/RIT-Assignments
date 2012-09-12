import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

/**
 * A wrapper class for command sequences that are treated as data stack elements
 * used in Birch programs. The behavior for each command sequence is encapsulated here
 * so as to separate it from the main interpreter. This promotes separation of concerns
 * and allows one to easily add new commands and define their behavior.
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */
public class BirchCommandString implements BirchElement {
	private String stringForm; 
	private Birch.BirchCommand birchCommand;
	private Birch birch;
	
	// Constants for the putc command range
	private final int MIN_PRINT = 0;
	private final int MAX_PRINT = 250;

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
	 * Copy constructor.
	 * 
	 * @param copy - the copy.
	 */
	public BirchCommandString(Birch birch, BirchCommandString copy) {
		this.birch = birch;
		this.birchCommand = copy.getCommand();
		this.stringForm = copy.toString();
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
			handleIfz();
			break;
		case DUP:
			handleDup();
			break;
		case POP:
			birch.stackPop();
			break;
		case SWAP:
			handleSwap();
			break;
		case REV:
			birch.reverseStack();
			break;
		case PACK:
			handlePack();
			break;
		case EXEC:
			handleExec();
			break;
		case PUTC:
			handlePutc();
			break;
		}
		
		// null indicates this is not a BirchInteger object being evaluated.
		return null;
	}
	
	/**
	 * Determine the birch command type for special case operations (such as exec).
	 * 
	 * @return - the command string's underlying birch command ID.
	 */
	public Birch.BirchCommand getCommand() {
		return birchCommand;
	}
	
	/**
	 * Handle the 'exec' command.
	 * 
	 * @throws Exception - whenever a runtime processing exception occurs.
	 */
	private void handleExec() throws Exception {
		if (validBirchStackSize(1)) {
			BirchElement topElement = birch.stackPop();
			if (topElement instanceof BirchCommandString) {
				// Determine if the top element is now a command sequence string
				BirchCommandString commandString = (BirchCommandString)topElement;
				if (commandString.getCommand() == Birch.BirchCommand.PACK) {
					birch.sequencePush(commandString.toString());
				} else {
					errorException();
				}
			} else {
				errorException();
			}
		} else {
			errorException();
		}
	}
	
	/**
	 * Handle the 'pack' command.
	 * 
	 * @throws Exception - whenever a runtime processing exception occurs.
	 */
	private void handlePack() throws Exception {
		if (validBirchStackSize(1)) {
			BigInteger topInteger = birch.stackPop().evaluate();
			if (topInteger != null && validBirchSequenceSize(topInteger.intValue())) {
				// Form the sub-command sequence
				List<String> sequence = new ArrayList<String>();
				for (int i = 0; i < topInteger.intValue(); i++) {
					sequence.add(0, birch.sequencePop().toString());
				}
				
				StringBuilder builder = new StringBuilder();
				for (int i = 0; i < sequence.size(); i++) {
					builder.append(sequence.get(i) + " ");
				}
			
				// Push it onto the data stack as a single element
				BirchCommandString commandString = new BirchCommandString(birch, builder.toString(), Birch.BirchCommand.PACK);
				birch.stackPush(commandString);
			} else {
				errorException();
			}
		} else {
			errorException();
		}
	}
	
	/**
	 * Handle the 'putc' command.
	 * 
	 * @throws Exception - whenever a runtime processing exception occurs.
	 */
	private void handlePutc() throws Exception {
		if (validBirchStackSize(1)) {
			BigInteger topInteger = birch.stackPop().evaluate();
			if (topInteger != null && this.validPrintInteger(topInteger)) {
				System.out.print(String.valueOf(Character.toChars(topInteger.intValue())));
			} else {
				errorException();
			}
		} else {
			errorException();
		}
	}
	
	/**
	 * Handle the 'ifz' command.
	 * 
	 * @throws Exception - whenever a runtime processing exception occurs.
	 */
	private void handleIfz() throws Exception {
		if (validBirchStackSize(3))
		{
			BirchElement element1 = birch.stackPop();
			BirchElement element2 = birch.stackPop();
			BirchElement element3 = birch.stackPop();
			
			// Many conditions for the top element 
			if ((element1 != null) 
					&& (element1 instanceof BirchInteger) 
					&& (((BirchInteger)element1).evaluate().equals(BigInteger.ZERO))) {
				birch.stackPush(element2);
			} else {
				birch.stackPush(element3);
			}
		} else {
			errorException();
		}
	}
	
	/**
	 * Handle the 'dup' command.
	 * 
	 * @throws Exception - whenever a runtime processing exception occurs.
	 */
	private void handleDup() throws Exception {
		if (validBirchStackSize(1)) {
			BigInteger topInteger = birch.stackPop().evaluate();
			if (topInteger != null) {
				BirchElement nthElement = birch.stackGet(topInteger.intValue());
				if (nthElement != null) {
					if (nthElement instanceof BirchInteger) {
						birch.stackPush(new BirchInteger((BirchInteger)nthElement));
					} else {
						birch.stackPush(new BirchCommandString(birch, (BirchCommandString)nthElement));
					}
				} else {
					errorException();
				}
			} else {
				errorException();
			}
		} else {
			errorException();
		}
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
			errorException();
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
						result = BigInteger.ONE;
					} else {
						result = BigInteger.ZERO;
					}
					break;
				case GT:
					if (op1.compareTo(op2) > 0) {
						result = BigInteger.ONE;
					} else {
						result = BigInteger.ZERO;
					}
					break;
				case LT:
					if (op1.compareTo(op2) < 0) {
						result = BigInteger.ONE;
					} else {
						result = BigInteger.ZERO;
					}
					break;
				}
				
				birch.stackPush(new BirchInteger(result));
			} else {
				errorException();
			}
		} else {
			errorException();
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
				errorException();
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
				errorException();
			}
		} else {
			errorException();
		}
	}
	
	/**
	 * Helper method to verify the size of the birch stack before
	 * trying to process a command.
	 * 
	 * @param n - the number of elements needed on the stack
	 * @return true if the stack has at least n elements
	 */
	private boolean validBirchStackSize(int n) {
		return birch.stackSize() >= n;
	}
	
	/**
	 * Helper method to verify the size of the birch sequence before
	 * trying to process a command.
	 * 
	 * @param n - the number of elements needed in the sequence
	 * @return true if the sequence has at least n elements
	 */
	private boolean validBirchSequenceSize(int n) {
		return birch.sequenceSize() >= n;
	}
	
	/**
	 * Helper method to determine if the integer n is within the 
	 * valid printable ASCII range. 
	 *  
	 * @param n - the number to check
	 * @return true if within range
	 */
	private boolean validPrintInteger(BigInteger n) {
		return (n.intValue() >= MIN_PRINT && n.intValue() <= MAX_PRINT); 
	}
	
	/**
	 * Helper method that encapsulates the logic to throw a runtime exception.
	 * @throws Exception
	 */
	private void errorException() throws Exception {
		throw new Exception("error");
	}

	/**
	 * Format the command string for display
	 */
	@Override
	public String toString() {
		return stringForm;
	}
}