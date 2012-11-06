/*
 * CustomerQueue.h
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

#ifndef CUSTOMERQUEUE_H_
#define CUSTOMERQUEUE_H_

// Module includes
#include <queue>
#include <pthread.h>
#include "semaphore.h"
#include "Customer.h"

// For simplicity
using namespace std;

/**
 * This class is a wrapper for a standard C++ STL queue
 * structure that provides thread-safe access from
 * multiple producers and (TIMED) consumers.
 */
class CustomerQueue
{
public:

	/**
	 * Default constructor for the customer queue object that
	 * initializes the mutex used to protect the internal queue resource.
	 */
	CustomerQueue();

	/**
	 * Default destructor (no tear-down necessary)
	 */
	virtual ~CustomerQueue();

	/**
	 * Enqueue a customer into the customer queue.
	 *
	 * @param - customer - pointer to the customer object to enqueue
	 * @return - true if successful, false otherwise
	 */
	bool enqueue(Customer* customer); // TODO: name to insertCustomer

	/**
	 * Attempt to dequeue a customer from the queue. If the size
	 * of the queue is zero, then a blank (NULL) pointer is returned.
	 * Otherwise, the teller attempts to grab a lock on the queue
	 * to fetch a customer from the queue.
	 *
	 * @param - none
	 * @returns - pointer to the customer dequeued, if one exists, NULL otherwise
	 */
	Customer* dequeue(); // TODO: rename to getCustomer

	/**
	 * Retrieve the maximum depth of the queue.
	 *
	 * @param - none
	 * @returns - maximum queue depth observed during its lifetime.
	 */
	int getMaxDepth();

private:
	queue<Customer*> customerQueue;
	int maxQueueDepth;
	pthread_mutex_t mutex;
};

#endif /* CUSTOMERQUEUE_H_ */
