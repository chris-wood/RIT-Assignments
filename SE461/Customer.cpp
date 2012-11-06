/*
 * Customer.cpp
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

// Module includes
#include "Customer.h"

/**
 * Create a customer with a specified ID.
 * This ID is used for verbose mode of operation.
 *
 * @param - ID - the customer's unique ID
 */
Customer::Customer(unsigned int ID)
{
	id = ID;
}

/**
 * Default destructor for a customer that frees its memory
 * for its internal ticket and transaction
 */
Customer::~Customer() {
	delete ticket;
	delete transaction;
}

/**
 * Assign a transaction to a customer. Note, this was
 * not included in the constructor to make it extensible
 * for dynamic additions of transactions (i.e. customer
 * changes their mind while already at the bank).
 *
 * @param - trans - pointer to transaction object
 * @returns - nothing
 */
void Customer::assignTransaction(Transaction* trans)
{
	transaction = trans;
}

/**
 * Assign a ticket to this customer when they arrive
 * at the bank.
 *
 * @param - tick - pointer to the ticket object.
 * @returns - nothing.
 */
void Customer::assignTicket(Ticket* tick)
{
	ticket = tick;
}

/**
 * Retrieve the transaction for this customer.
 *
 * @param - none
 * @returns - Pointer to this customer's transaction object.
 */
Transaction* Customer::getTransaction()
{
	return transaction;
}

/**
 * Retrieve the ticket for this customer.
 *
 * @param - none
 * @return - Pointer to this customer's ticket object.
 */
Ticket* Customer::getTicket()
{
	return ticket;
}

/**
 * Retrieve the ID of this customer.
 *
 * @param - none
 * @returns - customer ID
 */
unsigned int Customer::getID()
{
	return id;
}
