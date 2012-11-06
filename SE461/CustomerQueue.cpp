/*
 * CustomerQueue.cpp
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

// Module includes
#include "CustomerQueue.h"
#include <iostream>
#include <errno.h>
#include <sys/neutrino.h> /* for ThreadCtl() */

/**
 * Default constructor for the customer queue object that
 * initializes the mutex used to protect the internal queue resource.
 */
CustomerQueue::CustomerQueue()
{
	maxQueueDepth = 0;
	mutex = PTHREAD_MUTEX_INITIALIZER;
}

/**
 * Default destructor (no tear-down necessary)
 */
CustomerQueue::~CustomerQueue()
{
	// Empty...
}

/**
 * Enqueue a customer into the customer queue.
 *
 * @param - customer - pointer to the customer object to enqueue
 * @return - true if successful, false otherwise
 */
bool CustomerQueue::enqueue(Customer* customer)
{
	// Acquire a lock to the queue mutex
	pthread_mutex_lock(&mutex);

	// Push the new customer into the back of the line
	customerQueue.push(customer);

	// Log the current size of the queue if it's the max
	if (customerQueue.size() > maxQueueDepth)
		maxQueueDepth = customerQueue.size();

	// Release the mutex lock so the teller's can gain access to the customers
	pthread_mutex_unlock(&mutex);

	return true;
}

/**
 * Attempt to dequeue a customer from the queue. If the size
 * of the queue is zero, then a blank (NULL) pointer is returned.
 * Otherwise, the teller attempts to grab a lock on the queue
 * to fetch a customer from the queue.
 *
 * @param - none
 * @returns - pointer to the customer dequeued, if one exists, NULL otherwise
 */
Customer* CustomerQueue::dequeue()
{
	Customer* customer = NULL;
	if (customerQueue.size() > 0) // TODO: ideally, move this outside of the dequeue method into a isCustomerAvailable() method
	{
		// Try to acquire a lock into the queue to get the customer, but don't block in case someone already grabbed it
		if (pthread_mutex_trylock(&mutex) == EOK)
		{
			customer = customerQueue.front();
			customerQueue.pop();
			pthread_mutex_unlock(&mutex);
		}
	}

	return customer;
}

/**
 * Retrieve the maximum depth of the queue.
 *
 * @param - none
 * @returns - maximum queue depth observed during its lifetime.
 */
int CustomerQueue::getMaxDepth()
{
	return maxQueueDepth;
}
