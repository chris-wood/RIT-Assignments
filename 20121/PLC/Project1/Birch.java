import java.io.*;
import java.util.*;
import java.math.BigInteger;

/**
 * The interpreter program for the small and simple Birch programming language.
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */
public class Birch {
	// The main data stack (containing BirchElement objects).
	private List<BirchElement> stack;

	// The main executable command sequence.
	private List<BirchElement> commandSequence;
	
	// The string-to-command translation map.
	private Map<String, BirchCommand> commandMap = new HashMap<String, BirchCommand>();
	
	// The supported commands by this Birch interpreter.
	public static enum BirchCommand {
		ADD, SUB, MUL, DIV, REM, EQ, GT, LT, IFZ, DUP, POP, SWAP, REV, INVALID
	}

	/**
	 * Default constructor for our Birch interpreter.
	 */
	public Birch() {
		// Initialize the data structures
		stack = new ArrayList<BirchElement>();
		commandSequence = new ArrayList<BirchElement>();
		
		// Initialize the command translation map
		commandMap.put("add", BirchCommand.ADD);
		commandMap.put("sub", BirchCommand.SUB);
		commandMap.put("mul", BirchCommand.MUL);
		commandMap.put("div", BirchCommand.DIV);
		commandMap.put("rem", BirchCommand.REM);
		commandMap.put("eq", BirchCommand.EQ);
		commandMap.put("gt", BirchCommand.GT);
		commandMap.put("lt", BirchCommand.LT);
		commandMap.put("ifz", BirchCommand.IFZ);
		commandMap.put("dup", BirchCommand.DUP);
		commandMap.put("pop", BirchCommand.POP);
		commandMap.put("swap", BirchCommand.SWAP);
		commandMap.put("rev", BirchCommand.REV);
	}

	/**
	 * Public method to initialize the interpretation of the Birch program
	 * stored in the file specified.
	 * 
	 * @param fileName
	 *            - the location of the Birch program to run.
	 * @return the BigInteger result
	 * 
	 * @throws FileNotFoundException
	 *             - invalid Birch program file
	 * @throws Exception
	 *             - Any other runtime exceptions that are caused by Birch
	 *             syntax errors
	 */
	public BigInteger interpret(String fileName) throws FileNotFoundException, Exception {
		BigInteger result = null;

		// Process the input by reading from the file and building up the command sequence.
		Scanner fileStream = new Scanner(new File(fileName));
		while (fileStream.hasNext()) {
			// Try to handle the integers first
			if (fileStream.hasNextBigInteger()) {
				commandSequence.add(new BirchInteger(fileStream.next()));
			} else {
				String element = fileStream.next();
				if (isValidCommand(element)) {
					commandSequence.add(new BirchCommandString(this, element, commandMap.get(element)));
				} else {
					throw new Exception("Syntax error in program file.");
				}
			} 
		}

		// Interpret the command sequence to get the result of the Birch program.
		while (commandSequence.size() > 0) {
			BirchElement element = commandSequence.get(0);
			commandSequence.remove(0);
			handleElement(element);
		}

		// Fetch the result from the stack
		if ((stack.size() > 0) && (stack.get(0) instanceof BirchInteger)) {
			BirchInteger resultElement = (BirchInteger)stack.get(0);
			result = resultElement.evaluate();
		}

		return result;
	}
	
	/**
	 * Reverse the elements on the data stack.
	 */
	public void reverseStack() {
		Collections.reverse(stack);
	}
	
	/**
	 * Push a new element onto the data stack.
	 * 
	 * @param element - the element to push.
	 */
	public void stackPush(BirchElement element) {
		stack.add(0, element);
	}
	
	/**
	 * Pop the top element off the data stack.
	 * @return - the old top element on the stack.
	 */
	public BirchElement stackPop() {
		BirchElement topElement = stack.get(0);
		stack.remove(0);
		return topElement;
	}
	
	/**
	 * Determine the size of the data stack.
	 * @return - the data stack size.
	 */
	public int stackSize() {
		return stack.size();
	}
	
	/**
	 * Internal validation command.
	 * 
	 * @param inputCommand
	 * @return
	 */
	private boolean isValidCommand(String inputCommand)
	{
		boolean validCommand = false;
		
		for (String command : commandMap.keySet()) {
			if (command.equalsIgnoreCase(inputCommand)) {
				validCommand = true;
				break;
			}
		}
		
		return validCommand;
	}

	/**
	 * The main method that runs the Birch interpreter.
	 * 
	 * @param args
	 *            - command line arguments.
	 */
	public static void main(String args[]) {
		if (args.length != 1) {
			System.err.println("usage: java Birch progName.bir");
		} else {
			try {
				Birch birch = new Birch();
				BigInteger result = birch.interpret(args[0]);
				if (result == null) {
					error("error");
				} else {
					System.out.println(result);
				}
			} catch (FileNotFoundException ex1) {
				error("File " + args[0] + " not found.");
			} catch (Exception ex2) {
				error(ex2.getMessage());
			}
		}
	}

	/**
	 * Helper method that displays errors from Birch runtime exceptions.
	 * 
	 * @param message 
	 * 			- message associated with the error.
	 */
	private static void error(String message) {
		System.err.println(message);
	}

	/**
	 * Hand off the Birch element to the appropriate handler
	 * 
	 * @param element
	 * @throws Exception
	 */
	private void handleElement(BirchElement element) throws Exception {
		if (element instanceof BirchInteger) {
			stackPush(element);
		} else {
			element.evaluate();
		}
	}
}