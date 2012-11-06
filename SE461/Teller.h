/*
 * Teller.h
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

#ifndef TELLER_H_
#define TELLER_H_

// Module includes
#include "Thread.h"
#include "CustomerQueue.h"
#include "Records.h"
#include "Timer.h"
#include "Bank.h"

// Resolve forward declarations
class Bank;
class Records;

/**
 * This class represents a single teller task that is responsible
 * for servicing customers throughout the day at the bank
 * until the bank closes.
 */
class Teller : public Thread
{
public:

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
	Teller(CustomerQueue* queue, Records* mgr, Bank* const bank, Timer* timer);

	/**
	 * Default destructor (no tear-down necessary)
	 */
	virtual ~Teller();

	/**
	 * Run method for the teller thread that continuously
	 * tries to retrieve and service customer in the queue.
	 *
	 * @param - none
	 * @returns - nothing
	 */
	void *start_routine();

	/**
	 * Service a customer by sleeping for the appropriate amount of time
	 * and storing their ticket/transaction times.
	 *
	 * @param - customer - pointer to the customer object to serve
	 * @returns - nothing.
	 */
	void serviceCustomer(Customer* customer);

	/**
	 * Retrieve the total number of times this teller waited for a customer.
	 *
	 * @param - none
	 * @returns - total number of waiting periods
	 */
	unsigned long getWaitTime();

	/**
	 * Retrieve the total wait time for this teller
	 *
	 * @param - none
	 * @returns - total wait time
	 */
	unsigned long getMaxWaitTime();

	/**
	 * Retrieve the maximum wait time this teller experienced.
	 *
	 * @param - none
	 * @returns - maximum wait time for the teller
	 */
	unsigned long getNumberOfWaits();

private:
    CustomerQueue* queue;
    Records* bankRecords;
	Bank* bank;
	unsigned long numberOfWaits;
	unsigned long totalWaitTime;
	unsigned long maxWaitTime;
    Timer* timer;
    bool isBusy;
    vector<Ticket*> customerTickets;
    vector<Transaction*> customerTransactions;
};

#endif /* TELLER_H_ */
