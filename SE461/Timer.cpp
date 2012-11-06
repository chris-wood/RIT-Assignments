/*
 * Timer.cpp
 *
 *  Created on: Oct 2, 2011
 *      Author: Christopher Wood, caw4567@rit.edu
 *              Martin Ofalt, mmo3386@rit.edu
 */

// Module includes
#include "Timer.h"
#include <iostream>
#include <stdlib.h>
#include <time.h>
#include <signal.h>
#include <errno.h>
#include <sys/siginfo.h>
#include <unistd.h>       /* for sleep() */
#include <stdint.h>       /* for uintptr_t */
#include <hw/inout.h>     /* for in*() and out*() functions */
#include <sys/neutrino.h> /* for ThreadCtl() */
#include <sys/mman.h>     /* for mmap_device_io() */

// For simplicity
using namespace std;

// Timer configuration macro
#define CODE_TIMER (1)

// 5ms for 3s in "bank" time
#define CLOCK_PERIOD_NANOSECONDS (5000000)

// The time quantum derived from the above macro
#define TIME_QUANTUM (3)

// Message structure for timer messages
typedef struct
{
	int messageType;
	int messageData;
} ClientMessageT;

// Client message data
typedef union
{
	ClientMessageT  msg;
	struct _pulse   pulse;
} MessageT;

/**
 * Default constructor for the timer that
 * initializes all of the appropriate settings in order
 * for the hardware time to run.
 */
Timer::Timer()
{
	timer_t timerid;                 // timer ID for timer
	struct sigevent event;           // event to deliver
	struct itimerspec timer;         // the timer data struct
	int coid;                        // connection back to us
	struct _clockperiod clockperiod; // the clock period of signals
	int privityErr;

	// Give this thread root permissions to access the hardware
	privityErr = ThreadCtl( _NTO_TCTL_IO, NULL );
	if ( privityErr == -1 )
	{
		fprintf( stderr, "can't get root permissions\n" );
	}

	// Create a connection back to ourselves
	chID = ChannelCreate(0);
	coid = ConnectAttach(0, 0, chID, 0, 0);
	if (coid == -1)
	{
		fprintf (stderr, "couldn't ConnectAttach to self!\n");
		perror (NULL);
		exit (EXIT_FAILURE);
	}

	// Set up the kind of event that we want -- a pulse
	SIGEV_PULSE_INIT(&event, coid, SIGEV_PULSE_PRIO_INHERIT, CODE_TIMER, 0);

	// Create the timer, binding it to the event
	if (timer_create (CLOCK_REALTIME, &event, &timerid) == -1)
	{
		fprintf (stderr, "couldn't create a timer, errno %d\n", errno);
		perror (NULL);
		exit (EXIT_FAILURE);
	}

	// Set the clock period/resolution to 500 usec
	clockperiod.nsec = CLOCK_PERIOD_NANOSECONDS;
	clockperiod.fract = 0;
	ClockPeriod(CLOCK_REALTIME, &clockperiod, NULL, 0);

	// Set up the timer
	timer.it_value.tv_sec = 0;
	timer.it_value.tv_nsec = CLOCK_PERIOD_NANOSECONDS;
	timer.it_interval.tv_sec = 0;
	timer.it_interval.tv_nsec = CLOCK_PERIOD_NANOSECONDS;

	// And start it!
	timer_settime (timerid, 0, &timer, NULL);

	// Start the timer thread now
	timeCount = 0;
}

/**
 * Default destructor for the timer (no tear-down necessary)
 */
Timer::~Timer()
{
	// Empty...
}

/**
 * Run method for the timer that loops while the
 * thread is still marked as alive and generates simulation
 * time events.
 *
 * @param - none
 * @return - nothing
 */
void *Timer::start_routine()
{
	MessageT msg;
	int rcvid;

	// Loop until the simulation no longer requires the timer
	while (isAlive())
	{
		// Wait to receive a pulse, and store the id of the sender (should be 0/none)
		rcvid = MsgReceive(chID, &msg, sizeof(msg), NULL);

		// Ensure that the "message" received had no sender and therefore was a pulse
		if (rcvid == 0)
			timerExpired();
	}

	// Terminate this thread
	kill();
}

/**
 * Retrieve the current bank time count.
 *
 * @param - none
 * @return - nothing
 */
unsigned long Timer::getTimeCount()
{
	return timeCount;
}

/**
 * Timer message handling method that increments the simulation
 * time count by our fixed time quantum.
 *
 * @param - none
 * @return - nothing
 */
void Timer::timerExpired(void)
{
	timeCount += TIME_QUANTUM;
}

/**
 * Retrieve the channel ID of this message interface
 *
 * @param - none
 * @return - channel ID
 */
int Timer::getChannelID()
{
	return chID;
}

/**
 * Stop the timer clock for the simulation.
 *
 * @param - none
 * @return - nothing
 */
void Timer::stopClock()
{
	this->alive = false;
}
