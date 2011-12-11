//******************************************************************************
//
// File:    RMATest.cpp
// Author:  Christopher Wood, caw4567@rit.edu
// Version: 12/9/11
//
//******************************************************************************

// File includes
#include <iostream>
#include <stdlib.h>
#include <math.h>
#include <vector>
#include <cassert>

// For simplicity
using namespace std;

// Useful constants and definitions
#define RATIO_UPPER_BOUND (1)

/**
 * The first schedule test that simply checks to see if the 
 * utilization ratio sum is less than or equal to 1. 
 *
 * @param sum - the accumulated utilization ratio sum.
 *
 * @return true if the test passed, false otherwise.
 */
inline bool testOne(float sum)
{
	return sum <= RATIO_UPPER_BOUND;
}

/**
 * The second schedule test that checks to see if the 
 * utilization ratio sum is less than or equal to the following:
 *
 * n * (2^(1/n) - 1)
 *
 * @param sum - the accumulated utilization ratio sum.
 * @param numTasks - the number of tasks for this test.
 *
 * @return true if the test passed, false otherwise.
 */
inline bool testTwo(float sum, int numTasks)
{
	return sum <= ((float)numTasks * (pow(2, (1 / (float)numTasks)) - 1));
}

/**
 * The third schedule test that checks to see if there 
 * is some task ordering such that, if scheduled, will
 * allow each task at a specific instance in time to meet
 * its required deadline. 
 *
 * This test is represented mathematically by the following expression:
 *
 * TODO: insert the expression from the paper here.
 *
 * TODO: update parameters here.
 * @param sum - the accumulated utilization ratio sum.
 * @return true if the test passed, false otherwise.
 */
bool testThree(int numTasks, vector<int> computeList, vector<int> periodList)
{
	float taskSum = 0.0;
	vector<bool> validList;
	bool result = true; // hope for the best
	
	// Traverse over the entire task set and perform the third test.
	for(int i = 1; i <= numTasks; i++)
	{
		// Assume invalid to start
		validList.push_back(false);
		
		// Calculate the k index for this run (which is used for the l index).
		for(int k = 1; k <= i; k++)
		{
			// Calculate the l index
			for (int l = 1; l <= floor((float)periodList[i] / (float)periodList[k]); l++)
			{
				// Continue on with the j index to compute the desired sum.
				taskSum = 0.0;
				for(int j = 1; j <= i; j++)
				{
					// This is the main calculation.
					taskSum += (((float)computeList[j] / (float)(l * periodList[k])) * 
								ceil((float)(l * periodList[k]) / (float)periodList[j]));
				}
			
				// Check to see if the sum is less than the upper bound, as desired.
				if (taskSum <= RATIO_UPPER_BOUND)
				{
					validList[i - 1] = true; // flag this task schedule as valid
				}
			}
		}
	}
	
	// Check to make sure there is a valid task order for each task in the list.
	for (vector<bool>::iterator itr = validList.begin(); itr != validList.end(); itr++)
	{
		if (*itr == false)
		{
			result = false;
			break;
		}
	}
	
	return result;
}

/**
 * The main entry point of the program that reads in task parameters
 * and invokes the three schedule tests.
 */
int main(int argc, char *argv[])
{	
	int numTasks = 0;
	int ct = false;
	int pt = false;
	float utilSum = 0.0;
	vector<int> computeList;
	vector<int> periodList;
	
	// Retrieve the number of tasks
	cout << "Enter the number of tasks (n > 0): ";
	cin >> numTasks;
	assert(numTasks > 0);
	
	// Retrieve the parameters for each task, validating them
	// one at a time and storing them in the list of tasks
	cout << "Enter the details of each task in the following format" 
		<< endl << "\tCOMPUTE PERIOD" << endl;
	
	// Push back some dummy data to help with test three.
	computeList.push_back(0);
	periodList.push_back(0);
	for (int counter = 0; counter < numTasks; counter++)
	{
		// Read in a task tuple
		cin >> ct;
		cin >> pt;
		
		// Verify they are a correct/possible pair
		assert(ct > 0 && pt > 0 && ct <= pt);
		
		// Accumulate the utilization ratio sum
		utilSum += ((float)ct / (float)pt);
		
		// Store the resulting times in the two appropriate lists
		computeList.push_back(ct);
		periodList.push_back(pt);
	}
	
	// The first two tests are trivial, so run them first
	cout << "---------------------------------" << endl;
	cout << "Test results (0 - fail, 1 - pass)" << endl;
	cout << "TEST 1: " << testOne(utilSum) << endl;
	cout << "TEST 2: " << testTwo(utilSum, numTasks) << endl;
	cout << "Test 3: " << testThree(numTasks, computeList, periodList) << endl;
	cout << "---------------------------------" << endl;
	
	// Terminate gracefully.
	return 0;
}
   