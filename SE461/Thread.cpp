/*
 * Thread.cpp
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

// Module includes
#include "Thread.h"
#include <stdexcept>
#include <unistd.h>

/**
 * Default constructor for a thread (does nothing until user starts the thread manually)
 */
Thread::Thread()
{
	// Empty constructor
}

/**
 * Default destructor for the thread (no tear-down required)
 */
Thread::~Thread()
{
	// Empty...
}

/**
 * Start the thread by invoking its start routine.
 *
 * @param - none
 * @returns - nothing
 */
void Thread::start()
{
	// Flag the thread as being alive
	alive = true;

	if (pthread_create(&m_id, NULL, &(this->start_routine_trampoline), this) != 0)
	{
		alive = false;
		throw std::runtime_error("Thread was not created");
	}
}

/**
 * Perform a timed microsecond sleep on this thread
 *
 * @param - ms - microsecond count for sleep
 * @return - nothing
 */
void Thread::sleep(unsigned long ms)
{
	usleep(ms); // ms is milliseconds
}

/**
 * Kill this thread by flagging it as not alive and invoking
 * the pthread exit routine.
 *
 * @param - none
 * @return - nothing
 */
void Thread::kill()
{
	alive = false;
	pthread_exit(NULL);
}

/**
 * Join this thread on the calling thread context.
 *
 * @param - none
 * @return - nothing
 */
void Thread::join()
{
	pthread_join(m_id, NULL);
}

/**
 * Determine if this thread is alive or not.
 *
 * @param - none
 * @return - nothing
 */
bool Thread::isAlive()
{
	return alive;
}
