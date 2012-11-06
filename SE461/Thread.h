/*
 * Thread.h
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

#ifndef THREAD_H_
#define THREAD_H_

// Module includes
#include "pthread.h"

/**
 * This class represents a wrapper for the POSIX thread implementation
 * provided by QNX. It is intended to simplify thread construction
 * and operation by other modules in the system.
 *
 * NOTE: THIS IS AN ABSTRACT CLASS
 */
class Thread
{
public:

	/**
	 * Default constructor for a thread (does nothing until user starts the thread manually)
	 */
	Thread();

	/**
	 * Default destructor for the thread (no tear-down required)
	 */
	virtual ~Thread();

	/**
	 * Start the thread by invoking its start routine.
	 *
	 * @param - none
	 * @returns - nothing
	 */
	void start();

	/**
	 * Perform a timed microsecond sleep on this thread
	 *
	 * @param - ms - microsecond count for sleep
	 * @return - nothing
	 */
	void sleep(unsigned long ms);

	/**
	 * Kill this thread by flagging it as not alive and invoking
	 * the pthread exit routine.
	 *
	 * @param - none
	 * @return - nothing
	 */
	void kill();

	/**
	 * Join this thread on the calling thread context.
	 *
	 * @param - none
	 * @return - nothing
	 */
	void join();

	/**
	 * Determine if this thread is alive or not.
	 *
	 * @param - none
	 * @return - nothing
	 */
	bool isAlive();

protected:
	bool alive;

	/**
	 * Pure virtual method that subclasses must override.
	 */
    virtual void *start_routine() = 0;

private:
    pthread_t m_id;

	/**
	 * In-line function implementation due to its simplicity.
	 */
    static void *start_routine_trampoline(void *p)
    {
        Thread *pThis = (Thread*)p;
        return pThis->start_routine();
    }
};

#endif /* THREAD_H_ */
