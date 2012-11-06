#include <cstdlib>
#include <iostream>

#include "Timer.h"
#include "Bank.h"
#include "BankEntrance.h"

using namespace std;

#define DEFAULT_NUM_TELLERS 3

int main(int argc, char *argv[])
{
	cout << "QNX Bank Simulation Program" << endl;

	// 1. Run any initial tests
	// TODO

	// Start the simulation
	cout << "Launching the bank simulation." << endl;
	Bank* bank = new Bank();
	bank->simulate(); // TODO: handle error code from simulate function

	return EXIT_SUCCESS;
}
