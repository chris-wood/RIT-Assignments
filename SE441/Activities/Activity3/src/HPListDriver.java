import java.util.ArrayList;
import java.util.List; 
 
public class HPListDriver {
 
    private final static int NUM_WORKERS = 20;
     
     
    static class Inserter extends Thread {
         
        private int id;
        private HPList list;
        private String s;
         
        public Inserter( int id, HPList list, String s ){
            super( "Inserter " + id );
            this.id = id;
            this.list = list;
            this.s = s;
        }
         
        @Override
        public void run(){
            list.insert( s );
            System.out.println( "Inserter " + id + " inserted " + s );
        }
         
    }
     
     
    static class Finder extends Thread {
         
        private int id;
        private HPList list;
        private String s;
         
        public Finder( int id, HPList list, String s ){
            super( "Finder " + id );
            this.id = id;
            this.list = list;
            this.s = s;
        }
         
        @Override
        public void run(){
            list.find( s, true );
            System.out.println( "Finder " + id + " found " + s );
        }
         
    }
     
     
    /**
     * @param args
     */
    public static void main(String[] args) throws Exception {
         
        HPList list = new HPList();
         
        List<Inserter> inserters = new ArrayList<Inserter>();
        List<Finder> finders = new ArrayList<Finder>();
         
        for( int i = 0; i < NUM_WORKERS; i++ ){
             
            String s = "" + (char) (i + 65);
             
            finders.add( new Finder( i, list, s ) );
            finders.get( i ).start();
             
            inserters.add( new Inserter( i, list, s ) );
            inserters.get( i ).start();
             
        }
         
        for( Inserter i : inserters ){
            i.join();
        }
         
        for( Finder f : finders ){
            f.join();
        }
         
        System.out.println( list );
         
    }
 
}