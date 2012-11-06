/*
 * Transaction.cpp
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

#include "Transaction.h"

/**
 * Default constructor for a customer transaction
 *
 * @param duration - duration of the transaction
 */
Transaction::Transaction(unsigned long duration)
{
	 eventDuration = duration;
}

/**
 * Default destructor for a customer transaction.
 */
Transaction::~Transaction()
{
	// Empty destructor
}

/**
 * Get the duration for a given customer transaction.
 *
 * @param - none
 * @return - transaction duration
 */
unsigned long Transaction::getDuration()
{
	return eventDuration;
}
