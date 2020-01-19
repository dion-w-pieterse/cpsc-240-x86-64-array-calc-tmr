#include <stdio.h>
#include <stdint.h>
#include <ctime>
#include <cstring>
using namespace std;

extern "C" double control();

int main(int argc, const char* argv[]) {
	printf("Welcome\n");
	double return_code = -99;

	return_code = control();
	printf("\n%s %lf", "Driver received this number:", return_code);

	printf("\n\nProgram is Complete. Driver will return 0 to OS. Bye.\n");

	return 0;

}
