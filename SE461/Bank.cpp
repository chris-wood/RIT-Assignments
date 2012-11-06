/*
 * Bank.cpp
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

#include "Bank.h"
#include "Timer.h"
#include <iostream>

// Macros for the default simulation parameters for the bank
#define DEFAULT_NUMBER_TELLERS     (3)
#define DEFAULT_DAY_DURATION       (25200)
#define DEFAULT_MIN_ENTRANCE_DELAY (60)
#define DEFAULT_MAX_ENTRANCE_DELAY (240)
#define DEFAULT_MIN_TRANSACTION    (30)
#define DEFAULT_MAX_TRANSACTION    (360)

/**
 * Default constructor for the bank that initailizes the
 * shared customer queue.
 */
Bank::Bank()
{
	customers = new CustomerQueue();
}

/**
 * Destructor for the bank that tears down all dynamic memory that
 * was allocated during the run-time of the bank.
 */
Bank::~Bank()
{
	unsigned int numTellers = tellers.size();

	// Delete each teller
	for (unsigned int index = 0; index < numTellers; index++) {
		delete tellers.at(index);
	}

	// Delete the customer queue
	delete customers;

	// Delete the bank entrance
	//delete entrance;
}

/**
 * This is the main simulation method that will handle the creation
 * and termination of all synchronization tasks.
 *
 * @param - none
 * @returns - nothing
 */
void Bank::simulate()
{
	BankEntranceParameters params;
	Records* bankRecords = new Records();

	// Get number of tellers from the user
	cout << "Number of tellers [" << DEFAULT_NUMBER_TELLERS << "]: ";
	cin >> numTellers;

	// Get duration of the day from the user
	cout << "Duration of the day [" << DEFAULT_DAY_DURATION << "]: ";
	cin >> params.duration;

	// Get customer generation delays from the user
	cout << "Minimum customer entrance delay [" << DEFAULT_MIN_ENTRANCE_DELAY << "]: ";
	cin >> params.minEntranceDelay;
	cout << "Maximum customer entrance delay [" << DEFAULT_MAX_ENTRANCE_DELAY << "]: ";
	cin >> params.maxEntranceDelay;

	// Get customer transaction durations from the user
	cout << "Minimum transaction duration [" << DEFAULT_MIN_TRANSACTION << "]: ";
	cin >> params.minTransaction;
	cout << "Maximum transaction duration [" << DEFAULT_MAX_TRANSACTION << "]: ";
	cin >> params.maxTransaction;

	// Start to spawn the simulation threads
	isOpen = true;
	Timer* timer = new Timer();
	timer->start();

	// Create and start each teller thread
	for (unsigned int count = 0; count < numTellers; count++)
	{
		tellers.push_back(new Teller(customers, bankRecords, this, timer));
		tellers.at(count)->start();
	}

	// Open the bank for business
	entrance = new BankEntrance(&params, timer, customers);
	entrance->start();

	// Run until the bank closes
	entrance->join();
	isOpen = false;

	// Now that the bank is closed, wait until the tellers are finished helping customers
	for (unsigned int count = 0; count < tellers.size(); count++)
		tellers.at(count)->join();

	// Stop the bank clock
	//if (entrance->isAlive()) // TODO: add check for teller's being alive
		timer->stopClock();

	// Report the bank metrics for the day
	reportMetrics(bankRecords);
}

/**
 * Determine if the bank is open.
 *
 * @param - none
 * @return - true if the bank is open, false otherwise.
 */
bool Bank::isBankOpen()
{
	return isOpen;
}

/**
 * Report the metrics for the bank using the specified
 * set of bank records.
 *
 * @param - bankRecords - pointer to bank records struct
 * @returns - nothing
 */
void Bank::reportMetrics(Records* bankRecords)
{
	unsigned long totalTellerWait = 0;
	unsigned long maxTellerWait = 0;
	unsigned long numberTellerWaits = 0;

	// Calculate the teller wait times for each teller
	for (unsigned int count; count < numTellers; count++)
	{
		if (tellers.at(count)->getMaxWaitTime() > maxTellerWait)
			maxTellerWait = tellers.at(count)->getMaxWaitTime();
		totalTellerWait += tellers.at(count)->getWaitTime();
		numberTellerWaits += tellers.at(count)->getNumberOfWaits();
	}

	// Finally, display the metrics
	cout << endl << "Bank metrics for the day:" << endl;
	cout << "Total number of customers during the day: " << bankRecords->getTotalCustomers() << endl;
	cout << "Average customer wait time: " << bankRecords->getAverageCustomerWaitTime() << " seconds " << endl;
	cout << "Average customer service time: " << bankRecords->getAverageCustomerServiceTime() << " seconds " << endl;
	cout << "Average teller wait: " << (totalTellerWait / numberTellerWaits) << " seconds " << endl;
	cout << "Maximum customer wait time: " << bankRecords->getMaxCustomerWaitTime() << " seconds " << endl;
	cout << "Maximum customer service time: " << bankRecords->getMaxCustomerServiceTime() << " seconds " << endl;
	cout << "Maximum teller wait: " << maxTellerWait << " seconds " << endl;
	cout << "Maximum customer queue depth: " << customers->getMaxDepth() << endl;
}
