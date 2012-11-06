/*
 * Records.cpp
 *
 *  Created on: Oct 4, 2011
 *      Author: caw4567
 */

// Module includes
#include "Records.h"

/**
 * Default constructor for the records object that initializes all of
 * its private instance variabels and sets up the mutex for
 * multple thread access.
 */
Records::Records()
{
	maxCustomerWait = 0;
	maxTransactionTime = 0;
	totalCustomerWait = 0;
	totalTransactionTime = 0;
	totalNumberOfCustomers = 0;
	mutex = PTHREAD_MUTEX_INITIALIZER;
}

/**
 * Default destructor (no tear-down required)
 */
Records::~Records()
{
	// Empty...
}

/**
 * Place a set of customer information (ticket and transaction)
 * into the bank records to compound the metrics throughout the day.
 *
 * Note, this method is synchronized by the records mutex.
 *
 * @param - ticket - pointer to customer's ticket
 * @param - transaction - pointer to customer's transaction
 * @return - nothing
 */
void Records::submitCustomerInformation(Ticket* ticket, Transaction* transaction)
{
	pthread_mutex_lock(&mutex);

	// Handle the customer ticket for the wait time
	totalCustomerWait += ticket->waitTime();
	if (ticket->waitTime() > maxCustomerWait)
		maxCustomerWait = ticket->waitTime();

	// Handle the customer transaction for the teller's service time
	totalTransactionTime += transaction->getDuration();
	if (transaction->getDuration() > maxTransactionTime)
		maxTransactionTime = transaction->getDuration();

	// Increment the number of customers by one
	totalNumberOfCustomers++;

	pthread_mutex_unlock(&mutex);
}

/**
 * Retrieve the total number of customers serviced throughout the day.
 *
 * @param - none
 * @return - total number of customers
 */
unsigned long Records::getTotalCustomers()
{
	return totalNumberOfCustomers;
}

/**
 * Retrieve the average customer wait time for the day.
 *
 * @param - none
 * @return - total customer wait time
 */
unsigned long Records::getAverageCustomerWaitTime()
{
	return (totalCustomerWait / totalNumberOfCustomers);
}

/**
 * Retrieve the average customer service time for the day.
 *
 * @param - none
 * @return - total customer service time
 */
unsigned long Records::getAverageCustomerServiceTime()
{
	return (totalTransactionTime / totalNumberOfCustomers);
}

/**
 * Retrieve the maximum customer wait time for the day.
 *
 * @param - none
 * @return - maximum customer wait time
 */
unsigned long Records::getMaxCustomerWaitTime()
{
	return maxCustomerWait;
}

/**
 * Retrieve the maximum customer service time for the day.
 *
 * @param - none
 * @return - maximum customer service time
 */
unsigned long Records::getMaxCustomerServiceTime()
{
	return maxTransactionTime;
}

