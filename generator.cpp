#include <fmt/core.h>
#include <fstream>
#include <random>
#include <iostream>
#include <limits>

using d8 = std::uniform_int_distribution<int8_t>;
using d16 = std::uniform_int_distribution<int16_t>;
using d32 = std::uniform_int_distribution<int32_t>;
using d64 = std::uniform_int_distribution<int64_t>;

int main() {

	std::random_device rd;
	std::mt19937 gen(rd());

	int8_t BYTE = std::numeric_limits<int8_t>::max();
	int16_t WORD = std::numeric_limits<int16_t>::max();
	int32_t DWORD = std::numeric_limits<int32_t>::max();	
	int64_t QWORD = std::numeric_limits<int64_t>::max();

	d8  d(-BYTE-1, BYTE);
	d16 e(-WORD-1, WORD);
	d32 b(-DWORD-1, DWORD);
	d32 c(-DWORD-1, DWORD);
	d64 a(-QWORD-1, QWORD);

	std::string data_section =
		fmt::format("d:			db {}\n", d(gen)) +
		fmt::format("e:			dw {}\n", e(gen)) +
		fmt::format("b:			dd {}\n", b(gen)) +
		fmt::format("c:			dd {}\n", c(gen)) +
		fmt::format("a:			dq {}\n", a(gen));

	system("cat my_prog_base.asm > my_prog.asm");	
	std::ofstream outfile;
  	outfile.open("my_prog.asm", std::ios_base::app); 
	outfile << data_section;
}
