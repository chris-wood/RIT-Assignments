/*
 * BankEntrance.h
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

#ifndef BANKENTRANCE_H_
#define BANKENTRANCE_H_

// Module includes
#include "Thread.h"
#include "CustomerQueue.h"
#include "Timer.h"

// Simple structure to group together configuration
// data for the bank entrance.
typedef struct
{
	unsigned int duration;
	unsigned int minEntranceDelay;
	unsigned int maxEntranceDelay;
	unsigned int minTransaction;
	unsigned int maxTransaction;
} BankEntranceParameters;

/**
 * This class represents a customer generation thread that
 * handles the uniform random distribution generation for
 * both customer entry delays and transactions amounts. It
 * is an abstraction for the outside world that actually
 * presents customers to the bank.
 */
class BankEntrance : public Thread
{
public:

	/**
	 * Constructor the bank entrance that initializes references to the
	 * necessary objects within the system and primes the prng's for
	 * a uniform distribution during execution.
	 *
	 * @param - params - pointer to bank entrance param structure
	 * @param - timer - pointer to global timer object
	 * @param - queue - pointer to the bank's customer queue
	 */
	BankEntrance(BankEntranceParameters* params, Timer* timer, CustomerQueue* queue);

	/**
	 * Default destructor (no tear-down necessary).
	 */
	virtual ~BankEntrance();

private:

	/**
	 * This is the bank entrance's main thread routine that
	 * continuously generates customers for the bank
	 * and inserts them into the queue according to a
	 * uniform random distribution until the bank closes.
	 *
	 * @param - none
	 * @returns - nothing
	 */
	void* start_routine();

	BankEntranceParameters entranceParams;
	int customerEntranceDelay;
	int customerTransactionTime;
	bool isOpen;
	CustomerQueue* customerQueue;
	Timer* bankClock;
};

#endif /* BANKENTRANCE_H_ */
