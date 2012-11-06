/*
 * Ticket.cpp
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

// Module includes
#include "Ticket.h"

/**
 * Default constructor for a ticket that timestamps
 * the start wait time.
 *
 * @param - time - start wait time
 */
Ticket::Ticket(unsigned long time)
{
	startTime = time;
}

/**
 * Default destructor for the ticket (no tear-down necessary)
 */
Ticket::~Ticket()
{
	// Empty...
}

/**
 * Mark the end wait time on this ticket.
 *
 * @param - time - end wait time
 * @return - nothing
 */
void Ticket::markEndTime(unsigned long time)
{
	endTime = time;
}

/**
 * Retrieve the total wait time for the ticket.
 *
 * @param - none
 * @return - customer's total wait time
 */
unsigned long Ticket::waitTime()
{
	return endTime - startTime;
}
