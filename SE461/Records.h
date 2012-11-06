/*
 * Records.h
 *
 *  Created on: Oct 4, 2011
 *      Author: caw4567
 */

#ifndef RECORDS_H_
#define RECORDS_H_

// Module includes
#include "Ticket.h"
#include "Transaction.h"
#include "Teller.h"
#include <vector>
#include <pthread.h>

// For simplicity
using namespace std;

/**
 * This class represents a storage medium for the bank metrics
 * as they are compounded throughout the entire day.
 */
class Records
{
public:

	/**
	 * Default constructor for the records object that initializes all of
	 * its private instance variabels and sets up the mutex for
	 * multple thread access.
	 */
	Records();

	/**
	 * Default destructor (no tear-down required)
	 */
	virtual ~Records();

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
	void submitCustomerInformation(Ticket* ticket, Transaction* transacton);

	/**
	 * Retrieve the total number of customers serviced throughout the day.
	 *
	 * @param - none
	 * @return - total number of customers
	 */
	unsigned long getTotalCustomers();

	/**
	 * Retrieve the average customer wait time for the day.
	 *
	 * @param - none
	 * @return - total customer wait time
	 */
	unsigned long getAverageCustomerWaitTime();

	/**
	 * Retrieve the average customer service time for the day.
	 *
	 * @param - none
	 * @return - total customer service time
	 */
	unsigned long getAverageCustomerServiceTime();

	/**
	 * Retrieve the maximum customer wait time for the day.
	 *
	 * @param - none
	 * @return - maximum customer wait time
	 */
	unsigned long getMaxCustomerWaitTime();

	/**
	 * Retrieve the maximum customer service time for the day.
	 *
	 * @param - none
	 * @return - maximum customer service time
	 */
	unsigned long getMaxCustomerServiceTime();

private:
	pthread_mutex_t mutex;
	unsigned long totalCustomerWait;
	unsigned long maxCustomerWait;
	unsigned long totalTransactionTime;
	unsigned long maxTransactionTime;
	unsigned long totalNumberOfCustomers;
};

#endif /* RECORDS_H_ */
