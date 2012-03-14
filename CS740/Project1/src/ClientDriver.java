import java.io.IOException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;

public class ClientDriver {
	public static void main(String[] args) {
		LogClient ls = new LogClient();
		try {
			ls.open("viking.cs.rit.edu", 6007);
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String ticket = "";
		try {
			ticket = ls.newTicket();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("adding entries now...");
		ls.addEntry(ticket, "Message 1");
		ls.addEntry(ticket, "Message 2");
		ls.addEntry(ticket, "Message 3");
		ls.addEntry(ticket, "Message 4");
		ls.addEntry(ticket, "Message 5");
		ls.addEntry(ticket, "Message 6");
		ls.addEntry(ticket, "Message 7");
		List<String> entries = new ArrayList<String>();
		try {
			entries = ls.getEntries(ticket);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		for (int i = 0; i < entries.size(); i++) {
			System.out.println(entries.get(i));
		}
		ls.releaseTicket(ticket);
	}
}
