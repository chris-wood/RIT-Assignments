import java.io.IOException;
import java.net.Socket;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;

public class Driver {
	public static void main(String[] args) {
		LogService ls = new LogService();
		try {
			ls.open("viking.cs.rit.edu", 6007);
			//Socket socket = new Socket("viking.cs.rit.edu", 6007);
			
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
		ls.addEntry(ticket, "Message 1-caw");
		ls.addEntry(ticket, "Message 2-caw");
		ls.addEntry(ticket, "Message 3-caw");
		ls.addEntry(ticket, "Message 4-caw");
		ls.addEntry(ticket, "Message 5-caw");
		ls.addEntry(ticket, "Message 6-caw");
		ls.addEntry(ticket, "Message 7-caw");
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
