/*
 * BankEntrance.cpp
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

// Module includes
#include "BankEntrance.h"
#include "Ticket.h"
#include <stdlib.h>
#include <iostream>

// Helper macro to make sure we give somewhat different seeds to
// our customer generation and transaction generation prng's
#define RANDOM_DELTA (1000)

/**
 * Constructor the bank entrance that initializes references to the
 * necessary objects within the system and primes the prng's for
 * a uniform distribution during execution.
 *
 * @param - params - pointer to bank entrance param structure
 * @param - timer - pointer to global timer object
 * @param - queue - pointer to the bank's customer queue
 */
BankEntrance::BankEntrance(BankEntranceParameters* params, Timer* timer, CustomerQueue* queue)
{
	// Initialize the variables for this object
	entranceParams = *params;
	bankClock = timer;
	customerQueue = queue;

	// Prime the random number generator for customers and transactions
	srand(time(NULL));
	customerEntranceDelay = (rand() %
			(params->maxEntranceDelay - params->minEntranceDelay))
			+ params->minEntranceDelay;
	srand(time(NULL) + RANDOM_DELTA);
	customerTransactionTime = (rand() %
			(params->maxTransaction - params->minTransaction))
			+ params->minTransaction;
}

/**
 * Default destructor (no tear-down necessary).
 */
BankEntrance::~BankEntrance()
{
	// Empty
}

/**
 * This is the bank entrance's main thread routine that
 * continuously generates customers for the bank
 * and inserts them into the queue according to a
 * uniform random distribution until the bank closes.
 *
 * @param - none
 * @returns - nothing
 */
void* BankEntrance::start_routine()
{
	cout << "BankEntrance thread initialized (open for business)." << endl;

	unsigned long openTime = bankClock->getTimeCount();
	unsigned long closeTime = openTime + entranceParams.duration;
	unsigned long startTime;
	unsigned int customerID = 0; // debug

	// Loop until the bank is open
	while (bankClock->getTimeCount() < closeTime)
	{
		// Generate a wait time before creating a new customer
		srand(customerEntranceDelay);
		customerEntranceDelay = (rand() %
				(entranceParams.maxEntranceDelay - entranceParams.minEntranceDelay))
				+ entranceParams.minEntranceDelay;
		startTime = bankClock->getTimeCount();
		while ((startTime + customerEntranceDelay) >= bankClock->getTimeCount())
		{
			// Busy wait...
		}

		// Generate a transaction time for the new customer
		srand(customerTransactionTime);
		customerTransactionTime = (rand() %
				(entranceParams.maxTransaction - entranceParams.minTransaction))
				+ entranceParams.minTransaction;
		Transaction* transaction = new Transaction(customerTransactionTime); // TODO: is this the right transaction time?

		// Create the new customer and push them into the queue
		Customer* customer = new Customer(customerID++);
		customer->assignTransaction(transaction);

		// Assign the ticket to the customer
		Ticket* ticket = new Ticket(bankClock->getTimeCount());
		customer->assignTicket(ticket);

		// Final sanity check to make sure we don't insert a customer when the bank should be closed.
		if (bankClock->getTimeCount() < closeTime)
			customerQueue->enqueue(customer);
	}

	// Terminate this thread
	cout << "Closing the bank." << endl;
	kill();
}
