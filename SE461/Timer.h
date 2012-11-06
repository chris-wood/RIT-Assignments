/*
 * Timer.h
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

#ifndef TIMER_H_
#define TIMER_H_

// Module includes
#include "Thread.h"
#include <time.h>
#include <sys/siginfo.h>
#include <sys/netmgr.h>
#include <sys/neutrino.h>

/**
 * This class represents wraps the logic for a hardware timer
 * that is used to drive the bank simulation. Each thread will
 * use the value for this timer as a common source of time in
 * order to get consistency and synchronization among threads.
 */
class Timer : public Thread
{
public:

	/**
	 * Default constructor for the timer that
	 * initializes all of the appropriate settings in order
	 * for the hardware time to run.
	 */
	Timer();

	/**
	 * Default destructor for the timer (no tear-down necessary)
	 */
	virtual ~Timer();

	/**
	 * Retrieve the channel ID of this message interface
	 *
	 * @param - none
	 * @return - channel ID
	 */
	int getChannelID();

	/**
	 * Run method for the timer that loops while the
	 * thread is still marked as alive and generates simulation
	 * time events.
	 *
	 * @param - none
	 * @return - nothing
	 */
	void *start_routine();

	/**
	 * Timer message handling method that increments the simulation
	 * time count by our fixed time quantum.
	 *
	 * @param - none
	 * @return - nothing
	 */
	void timerExpired(void);

	/**
	 * Retrieve the current bank time count.
	 *
	 * @param - none
	 * @return - nothing
	 */
	unsigned long getTimeCount();

	/**
	 * Stop the timer clock for the simulation.
	 *
	 * @param - none
	 * @return - nothing
	 */
	void stopClock();

private:
	struct sigevent event;
	timer_t timerID;
	struct itimerspec timerSpec;
	int chID;
	unsigned long timeCount;
};

#endif /* TIMER_H_ */
