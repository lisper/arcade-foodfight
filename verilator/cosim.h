
extern "C" {

	void cosim_m68k(Vff_verilator *top, unsigned long long _time,
		int reset, unsigned int pc, unsigned int sr,
		unsigned int d0, unsigned int d1, unsigned int d2, unsigned int d3,
		unsigned int d4, unsigned int d5, unsigned int d6, unsigned int d7,
		unsigned int a0, unsigned int a1, unsigned int a2, unsigned int a3,
		unsigned int a4, unsigned int a5, unsigned int a6, unsigned int ssp, unsigned int usp);

	void cosim_int_event(unsigned int pc, int vector);

}

