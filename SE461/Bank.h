/*
 * Bank.h
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

#ifndef BANK_H_
#define BANK_H_

// Module includes
#include "CustomerQueue.h"
#include "Teller.h"
#include "BankEntrance.h"
#include "Records.h"
#include <vector>

// For simplicity
using namespace std;

// Resolve forward-declarations
class BankEntrance;
class Teller;
class Records;

/**
 * This class is responsible for storing most of the objects/actors
 * that are used during the simulation. It also provides the main
 * simulation method that actually runs the bank simulation based
 * on the parameters entered by the user.
 */
class Bank
{
public:

	/**
	 * Default constructor for the bank that initailizes the
	 * shared customer queue.
	 */
	Bank();

	/**
	 * Destructor for the bank that tears down all dynamic memory that
	 * was allocated during the run-time of the bank.
	 */
	virtual ~Bank();

	/**
	 * This is the main simulation method that will handle the creation
	 * and termination of all synchronization tasks.
	 *
	 * @param - none
	 * @returns - nothing
	 */
	void simulate();

	/**
	 * Determine if the bank is open.
	 *
	 * @param - none
	 * @return - true if the bank is open, false otherwise.
	 */
	bool isBankOpen();

	/**
	 * Report the metrics for the bank using the specified
	 * set of bank records.
	 *
	 * @param - bankRecords - pointer to bank records struct
	 * @returns - nothing
	 */
	void reportMetrics(Records* bankRecords);

private:
	unsigned int numTellers;
	CustomerQueue* customers;
	vector<Teller*> tellers;
	BankEntrance* entrance;
	bool isOpen;
};

#endif /* BANK_H_ */
