/**
 * TODO
 * 
 * @author Christopher Wood, caw4567@rit.edu
 */
public class Task 
{

	private final int computeTime;
	private final int periodTime;
	
	/**
	 * TODO
	 * 
	 * @param ct
	 * @param pt
	 */
	public Task(final int ct, final int pt)
	{
		computeTime = ct;
		periodTime = pt;
	}
	
	/**
	 * TODO
	 * 
	 * @return
	 */
	public int getComputeTime()
	{
		return computeTime;
	}
	
	/**
	 * TODO
	 * 
	 * @return
	 */
	public int getPeriod()
	{
		return periodTime;
	}
	
	/**
	 * TODO
	 * 
	 * @return
	 */
	public double utilizationRatio()
	{
		return (double)computeTime / (double)periodTime;
	}
}
