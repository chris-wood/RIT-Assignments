/*
 * Teller.cpp
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

// Module includes
#include "Teller.h"
#include <iostream>

/**
 * Create a new teller object with references to the appropriate
 * customer queue, bank records for filing storage, and bank
 * and timer for timing/synchronization purposes.
 *
 * @param - queue - pointer to the customer queue
 * @param - records - points to the records object
 * @param - bank - pointer to the bank object
 * @param - time - pointer to the global timer object
 */
Teller::Teller(CustomerQueue* queue, Records* records, Bank* const bank, Timer* time)
{
	this->queue = queue;
	this->bankRecords = records;
	this->bank = bank;
	this->timer = time;
	isBusy = false;
	numberOfWaits = 0;
	maxWaitTime = 0;
	totalWaitTime = 0;
}

/**
 * Default destructor (no tear-down necessary)
 */
Teller::~Teller()
{
	// Empty...
}

/**
 * Run method for the teller thread that continuously
 * tries to retrieve and service customer in the queue.
 *
 * @param - none
 * @returns - nothing
 */
void *Teller::start_routine()
{
	cout << "Teller has started the work day." << endl;

	unsigned long startTime = timer->getTimeCount();
	unsigned long endTime;
	numberOfWaits++;

	bool working = true;
	Customer* servee;

	// Poll the customer queue until it is empty and the bank is closed
	while (working || bank->isBankOpen())
	{
		// Attempt to grab a customer from the queue
		servee = queue->dequeue();

		// Check to see if we have a valid customer (and if we're  still open)
		bool open = bank->isBankOpen();
		if (!open && servee == NULL)
		{
			working = false;
		}
		else if (servee != NULL)
		{
			// Save the wait time
			endTime = timer->getTimeCount();
			totalWaitTime += (endTime - startTime);
			if ((endTime - startTime) > maxWaitTime)
				maxWaitTime = endTime - startTime;

			// Serve the customer and restart the wait time
			serviceCustomer(servee);
			startTime = timer->getTimeCount();
			numberOfWaits++;
		}

		// Give up CPU resources for a brief moment (don't starve everything else)!
		sleep(1);
	}

	// Save the final wait time
	endTime = timer->getTimeCount();
	totalWaitTime += (endTime - startTime);
	if ((endTime - startTime) > maxWaitTime)
		maxWaitTime = endTime - startTime;

	// Kill the thread
	kill();
}

/**
 * Service a customer by sleeping for the appropriate amount of time
 * and storing their ticket/transaction times.
 *
 * @param - customer - pointer to the customer object to serve
 * @returns - nothing.
 */
void Teller::serviceCustomer(Customer* customer)
{
	// Calculate the start and end time for the customer transaction
	unsigned long start = timer->getTimeCount();
	unsigned long end = start + (customer->getTransaction())->getDuration();

	// Timestamp the customer's ticket to end the wait time
	(customer->getTicket())->markEndTime(start);

	// Simulate the customer transaction by waiting for the appropriate amount of time
	while (timer->getTimeCount() <= end)
	{
		this->sleep(10); // Allow context switch
	}

	// Save the customer's ticket and transaction in our storage, and then delete the customer
	bankRecords->submitCustomerInformation(customer->getTicket(), customer->getTransaction());

	// Free up allocated resources
	delete customer;
}

/**
 * Retrieve the total number of times this teller waited for a customer.
 *
 * @param - none
 * @returns - total number of waiting periods
 */
unsigned long Teller::getNumberOfWaits()
{
	return numberOfWaits;
}

/**
 * Retrieve the total wait time for this teller
 *
 * @param - none
 * @returns - total wait time
 */
unsigned long Teller::getWaitTime()
{
	return totalWaitTime;
}

/**
 * Retrieve the maximum wait time this teller experienced.
 *
 * @param - none
 * @returns - maximum wait time for the teller
 */
unsigned long Teller::getMaxWaitTime()
{
	return maxWaitTime;
}
