/*
 * Transaction.h
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

#ifndef TRANSACTION_H_
#define TRANSACTION_H_

/**
 * This class holds the information related to a specific
 * transaction for a customer.
 */
class Transaction
{
public:

	/**
	 * Default constructor for a customer transaction
	 *
	 * @param duration - duration of the transaction
	 */
	Transaction(unsigned long duration);

	/**
	 * Default destructor for a customer transaction.
	 */
	virtual ~Transaction();

	/**
	 * Get the duration for a given customer transaction.
	 *
	 * @param - none
	 * @return - transaction duration
	 */
	unsigned long getDuration();

private:

	/*
	 * Transaction duration.
	 */
	unsigned long eventDuration;
};

#endif /* TRANSACTION_H_ */
