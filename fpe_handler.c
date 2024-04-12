#include <signal.h>

void signal_handler (int signo) {
	abort();
}

int main (void) {
	signal(SIGFPE,signal_handler);
	int t = 8/0;
  	return 0;
}

