/*
 * Customer.h
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

#ifndef CUSTOMER_H_
#define CUSTOMER_H_

// Module includes
#include "Transaction.h"
#include "Ticket.h"
#include <vector>

// For simplicity
using namespace std;

/**
 * This class represents a passive customer in the simulation,
 * which is simply a place holder for various information
 * related to the time spent in the queue and transaction details.
 */
class Customer
{
public:

	/**
	 * Create a customer with a specified ID.
	 * This ID is used for verbose mode of operation.
	 *
	 * @param - ID - the customer's unique ID
	 */
	Customer(unsigned int ID);

	/**
	 * Default destructor for a customer that frees its memory
	 * for its internal ticket and transaction
	 */
	virtual ~Customer();

	/**
	 * Assign a transaction to a customer. Note, this was
	 * not included in the constructor to make it extensible
	 * for dynamic additions of transactions (i.e. customer
	 * changes their mind while already at the bank).
	 *
	 * @param - trans - pointer to transaction object
	 * @returns - nothing
	 */
	void assignTransaction(Transaction* trans);

	/**
	 * Assign a ticket to this customer when they arrive
	 * at the bank.
	 *
	 * @param - tick - pointer to the ticket object.
	 * @returns - nothing.
	 */
	void assignTicket(Ticket* tick);

	/**
	 * Retrieve the transaction for this customer.
	 *
	 * @param - none
	 * @returns - Pointer to this customer's transaction object.
	 */
	Transaction* getTransaction();

	/**
	 * Retrieve the ticket for this customer.
	 *
	 * @param - none
	 * @return - Pointer to this customer's ticket object.
	 */
	Ticket* getTicket();

	/**
	 * Retrieve the ID of this customer.
	 *
	 * @param - none
	 * @returns - customer ID
	 */
	unsigned int getID();

private:
	Transaction* transaction;
	Ticket* ticket;
	unsigned int id;
};

#endif /* CUSTOMER_H_ */
