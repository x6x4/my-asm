int main() {

	int d = 1;
	int e = 1;
	int b = 3;
	int c = 4;
	int a = 8;
	
	//        8 * (1-3)*4 / (1+1) - (1+3)/1
	int res = a * (e-b)*c / (e+d) - (d+b)/e;
	return res;
}
