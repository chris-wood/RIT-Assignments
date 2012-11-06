/*
 * Ticket.h
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

#ifndef TICKET_H_
#define TICKET_H_

/**
 * This class represents a data holder (and possibly extensible superclass)
 * for all transactions in the system.
 */
class Ticket
{
public:

	/**
	 * Default constructor for a ticket that timestamps
	 * the start wait time.
	 *
	 * @param - time - start wait time
	 */
	Ticket(unsigned long time);

	/**
	 * Default destructor for the ticket (no tear-down necessary)
	 */
	virtual ~Ticket();

	/**
	 * Mark the end wait time on this ticket.
	 *
	 * @param - time - end wait time
	 * @return - nothing
	 */
	void markEndTime(unsigned long time);

	/**
	 * Retrieve the total wait time for the ticket.
	 *
	 * @param - none
	 * @return - customer's total wait time
	 */
	unsigned long waitTime();

private:
	unsigned long startTime;
	unsigned long endTime;
};

#endif /* TICKET_H_ */
