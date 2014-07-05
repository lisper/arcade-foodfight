#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <memory.h>
#include <fcntl.h>

#include "cosim.h"

extern int show_cosim_io;

extern "C" {

#include "../emu/fame/include/fame.h"

/* Far enough memory room */
#define ROM_SIZE (64*1024)
#define RAM_SIZE (32*1024)
#define NVRAM_SIZE 0x1ff

static unsigned char rom[ROM_SIZE];
static unsigned char ram[RAM_SIZE];
static unsigned char nvram[NVRAM_SIZE];
static unsigned char pf[0x800];
static unsigned char color[0x400];
static unsigned char stamp[256];


int rdrambyte(int addr)
{
	int a = addr - 0x14000;
	if (show_cosim_io) printf("sim ram: read byte @ 0x%08X\n",addr);
	return ram[a];
}

void wrrambyte(int addr, int data) 
{
	int a = addr - 0x14000;
	if (show_cosim_io) printf("sim ram: write byte 0x%02X @ 0x%08X...\n",data,addr);
	ram[a] = data;
}

int rdramword(int addr)
{
	int a = addr - 0x14000;
	unsigned short data;
	data = (ram[a] << 8) | ram[a+1];
	if (show_cosim_io) printf("sim ram: read word @ 0x%08x -> 0x%04x\n", addr, data);
	return data;
}

void wrramword(int addr, int data)
{
	int a = addr - 0x14000;
	ram[a] = data >> 8;
	ram[a+1] = data;
	if (show_cosim_io) printf("sim ram: write word 0x%08X <- 0x%04X\n", addr, data);
}

//----

int rdiobyte(int addr)
{
	int a;

	if (show_cosim_io) printf("io: read byte @ 0x%08X\n",addr);

	if (addr >= 0x1c000 && addr <= 0x1c0ff) {
		a = addr - 0x1c000;
		return stamp[a];
	}

	if (addr >= 0x800000 && addr <= 0x8007ff) {
		a = addr - 0x800000;
		return pf[a];
	}

	return 0;
}

void wriobyte(int addr, int data) 
{
	int a;

	if (show_cosim_io) printf("io: write byte 0x%02X @ 0x%08X...\n",data,addr);

	if (addr >= 0x1c000 && addr <= 0x1c0ff) {
		a = addr - 0x1c000;
		stamp[a] = data;
	}
	else
	if (addr >= 0x800000 && addr <= 0x8007ff) {
		a = addr - 0x800000;
		pf[a] = data;
	}
}

int rdioword(int addr)
{
	unsigned short data;
	int a;

	if (addr >= 0x1c000 && addr <= 0x1c0ff) {
		a = addr - 0x1c000;
		data = (stamp[a] << 8) | stamp[a+1];
	}
	else
	if (addr >= 0x800000 && addr <= 0x8007ff) {
		a = addr - 0x800000;
		data = (pf[a] << 8) | pf[a+1];
	}
	else
	if (addr >= 0x900000 && addr <= 0x9001ff) {
		a = addr - 0x900000;
		data = (nvram[a] << 8) | nvram[a+1];
	}
	else
	if (addr >= 0x950000 && addr <= 0x9503ff) {
		a = addr - 0x950000;
		data = (color[a] << 8) | color[a+1];
	}
	else
	switch(addr) {
	case 0x958000:
		return 0/*0x00ff*//*0xffff*/;
	}

	if (show_cosim_io) printf("io: read word @ 0x%08x -> 0x%04x\n", addr, data);

	return data;
}

void wrioword(int addr, int data)
{
	int a;

	if (addr >= 0x1c000 && addr <= 0x1c0ff) {
		a = addr - 0x1c000;
		stamp[a] = data >> 8;
		stamp[a+1] = data;
	}
	else
	if (addr >= 0x800000 && addr <= 0x8007ff) {
		a = addr - 0x800000;
		pf[a] = data >> 8;
		pf[a+1] = data;
	}
	else
	if (addr >= 0x900000 && addr <= 0x9001ff) {
		a = addr - 0x900000;
		nvram[a] = data >> 8;
		nvram[a+1] = data;
	}
	else
	if (addr >= 0x950000 && addr <= 0x9503ff) {
		a = addr - 0x950000;
		color[a] = data >> 8;
		color[a+1] = data;
	}
	else
	switch(addr) {
	case 0x948000:
		return;
	case 0x958000:
		return;
	}

	if (show_cosim_io) printf("io: write word 0x%08X <- 0x%04X\n", addr, data);
}

int rdpokeyword(int addr)
{
	int data = 0;
	printf("sim pokey: read word @ 0x%08x -> 0x%04x\n", addr, data);
	return data;
}

void wrpokeyword(int addr, int data)
{
	printf("sim pokey: write word 0x%08X <- 0x%04X\n", addr, data);
}

/* Memory map definition for program access */
struct M68K_PROGRAM p68ks[] = 
{
	{0x000000,0x00FFFF,(unsigned)rom - 0x000000},
	{-1,-1,(unsigned)NULL}
};

#define NO_FUNC (void *)NULL

/* Memory map definitions with memory handlers */
struct M68K_DATA d68ks_rb[] = 
{
	{0x000000,0x00FFFF,NO_FUNC,rom - 0x000000},
//	{0x014000,0x01bFFF,NO_FUNC,ram - 0x014000},
	{0x014000,0x01bFFF,(void *)rdrambyte,NULL},
	{0x01c000,0x01c0FF,(void *)rdiobyte,NULL},
	{0x800000,0x97ffff,(void *)rdiobyte,NULL},
	{-1,-1,NULL}
};

struct M68K_DATA d68ks_wb[] = 
{
	{0x000000,0x00FFFF,NO_FUNC,rom - 0x000000},
//	{0x014000,0x01bFFF,NO_FUNC,ram - 0x014000},
	{0x014000,0x01bFFF,(void *)wrrambyte,NULL},
	{0x01c000,0x01c0FF,(void *)wriobyte,NULL},
	{0x800000,0x97ffff,(void *)wriobyte,NULL},
	{-1,-1,NULL}
};

struct M68K_DATA d68ks_rw[] = 
{
	{0x000000,0x00FFFF,NO_FUNC,rom - 0x000000},
//	{0x014000,0x01bFFF,NO_FUNC,ram - 0x014000},
	{0x014000,0x01bFFF,(void *)rdramword,NULL},
	{0x01c000,0x01c0FF,(void *)rdioword,NULL},
	{0x800000,0x97ffff,(void *)rdioword,NULL},
	{0xa40000,0xacffff,(void *)rdpokeyword,NULL},
	{-1,-1,NULL}
};

struct M68K_DATA d68ks_ww[] = 
{
	{0x000000,0x00FFFF,NO_FUNC,rom - 0x000000},
//	{0x014000,0x01bFFF,NO_FUNC,ram - 0x014000},
	{0x014000,0x01bFFF,(void *)wrramword,NULL},
	{0x01c000,0x01c0FF,(void *)wrioword,NULL},
	{0x800000,0x97ffff,(void *)wrioword,NULL},
	{0xa40000,0xacffff,(void *)wrpokeyword,NULL},
	{-1,-1,NULL}
};

struct M68K_CONTEXT mc68k_contxt;

int
setup_context(void)
{
	/* Setting up memory maps in CPU context */
	memset(&mc68k_contxt,0,sizeof(mc68k_contxt));
	mc68k_contxt.sv_fetch = p68ks;
	mc68k_contxt.user_fetch = p68ks;

	mc68k_contxt.sv_read_byte  = d68ks_rb;
	mc68k_contxt.user_read_byte  = d68ks_rb;
	mc68k_contxt.sv_read_word  = d68ks_rw;
	mc68k_contxt.user_read_word  = d68ks_rw;
	mc68k_contxt.sv_write_byte = d68ks_wb;
	mc68k_contxt.user_write_byte = d68ks_wb;
	mc68k_contxt.sv_write_word = d68ks_ww;
	mc68k_contxt.user_write_word = d68ks_ww;

	/* Setting CPU context */
	m68k_set_context(&mc68k_contxt);

	return 0;
}

/* Performs byte swapping */
void byte_swapping(unsigned char *ram) 
{
	unsigned char aux;
	unsigned long i;
	unsigned long fsize;

	fsize = ROM_SIZE;
	for(i=0; i<fsize-1; i+=2)
	{
        	aux = rom[i];
        	rom[i] = rom[i+1];
        	rom[i+1] = aux;
	}
}

int
read_rom(void)
{
	int f, r;

#define FNAME "../roms/v3/rom_89.bin"
	/* Opening the object file */
	f = open(FNAME, O_RDONLY);
	if (f <= 0) {
		perror(FNAME);
		exit(1);
	}

	r = read(f, rom, 64*1024);
	if (r != 64*1024) {
		fprintf(stderr, "can't read rom file\n");
		exit(2);
	}

	close(f);
	byte_swapping(rom);

	printf("ROM: %02x%02x %02x%02x %02x%02x %02x%02x\n",
	       rom[0], rom[1], rom[2], rom[3], 
	       rom[4], rom[5], rom[6], rom[7]);

#if 1
	rom[0x4fc] = 0;
	rom[0x4fd] = 0;
	rom[0x4fe] = 0;
	rom[0x4ff] = 0;
#endif

	return 0;
}


void
check_interrupts(void)
{
}

static int has_init;

void
cosim_m68k(unsigned long long rtl_time,
	   int rtl_reset,
	   unsigned int rtl_pc,
	   unsigned int rtl_d0,
	   unsigned int rtl_d1,
	   unsigned int rtl_d2,
	   unsigned int rtl_d3,
	   unsigned int rtl_d4,
	   unsigned int rtl_d5,
	   unsigned int rtl_d6,
	   unsigned int rtl_d7,
	   unsigned int rtl_a0,
	   unsigned int rtl_a1,
	   unsigned int rtl_a2,
	   unsigned int rtl_a3,
	   unsigned int rtl_a4,
	   unsigned int rtl_a5,
	   unsigned int rtl_a6,
	   unsigned int rtl_sp)
{
	if (0) printf("cosim_m68k; time %lld; has_init=%d, rtl_reset=%d, rtl_pc=%x\n",
		      rtl_time, has_init, rtl_reset, rtl_pc);

	if (!has_init) {
		has_init = 1;
		setup_context();
		read_rom();
		m68k_init();
		m68k_reset();
		return;
	}

	if (rtl_reset == 0 && rtl_pc != 0) {
		int mismatch;
		unsigned int sr, pc, d0, d1, d2, d3, d4, d5, d6, d7;
		unsigned int a0, a1, a2, a3, a4, a5, a6, sp;

		check_interrupts();
		//printf("cosim_m68k; m68k_emulate before pc=%x\n", m68k_get_pc());
		m68k_emulate(1);
		//printf("cosim_m68k; m68k_emulate after pc=%x\n", m68k_get_pc());
		if (m68k_get_cpu_state() == M68K_OK)
			;
		else {
			printf("cosim fame error %d (0x%x)\n", m68k_get_cpu_state(), m68k_get_cpu_state());
			exit(1);
		}

		// compare_state
		sr = m68k_get_register(M68K_REG_SR);
		pc = m68k_get_pc();
		d0 = m68k_get_register(M68K_REG_D0);
		d1 = m68k_get_register(M68K_REG_D1);
		d2 = m68k_get_register(M68K_REG_D2);
		d3 = m68k_get_register(M68K_REG_D3);
		d4 = m68k_get_register(M68K_REG_D4);
		d5 = m68k_get_register(M68K_REG_D5);
		d6 = m68k_get_register(M68K_REG_D6);
		d7 = m68k_get_register(M68K_REG_D7);
		a0 = m68k_get_register(M68K_REG_A0);
		a1 = m68k_get_register(M68K_REG_A1);
		a2 = m68k_get_register(M68K_REG_A2);
		a3 = m68k_get_register(M68K_REG_A3);
		a4 = m68k_get_register(M68K_REG_A4);
		a5 = m68k_get_register(M68K_REG_A5);
		a6 = m68k_get_register(M68K_REG_A6);
		sp = m68k_get_register(M68K_REG_A7);

		mismatch = 0;
		if (rtl_pc != pc)
			mismatch |= 0x01;
		if (rtl_d0 != d0)
			mismatch |= 0x02;
		if (rtl_d1 != d1)
			mismatch |= 0x02;
		if (rtl_d2 != d2)
			mismatch |= 0x02;
		if (rtl_d3 != d3)
			mismatch |= 0x02;
		if (rtl_d4 != d4)
			mismatch |= 0x02;
		if (rtl_d5 != d5)
			mismatch |= 0x02;
		if (rtl_d6 != d6)
			mismatch |= 0x02;
		if (rtl_d7 != d7)
			mismatch |= 0x02;
		if (rtl_a0 != a0)
			mismatch |= 0x04;
		if (rtl_a1 != a1)
			mismatch |= 0x04;
		if (rtl_sp != sp && sp != 0)
			mismatch |= 0x08;

		if (mismatch & 1)
			printf("cosim mismatch: %llu: pc rtl %x, sim %x\n", rtl_time, rtl_pc, pc);
		if (mismatch & 2)
			printf("cosim mismatch: %llu: dreg\n", rtl_time);
		if (mismatch & 4)
			printf("cosim mismatch: %llu: areg\n", rtl_time);
		if (mismatch & 8)
			printf("cosim mismatch: %llu: sp rtl %x, sim %x\n", rtl_time, rtl_sp, sp);

		if (mismatch) {
			printf("rtl: pc %x, sim pc %x\n", rtl_pc, pc);
			printf("rtl: d0 %08x d1 %08x d2 %08x d3 %08x d4 %08x d5 %08x d6 %08x d7 %08x\n",
			       rtl_d0, rtl_d1, rtl_d2, rtl_d3, rtl_d4, rtl_d5, rtl_d6, rtl_d7);
			printf("sim: d0 %08x d1 %08x d2 %08x d3 %08x d4 %08x d5 %08x d6 %08x d7 %08x\n",
			       d0, d1, d2, d3, d4, d5, d6, d7);
			printf("\n");
			printf("rtl: a0 %08x a1 %08x a2 %08x a3 %08x a4 %08x a5 %08x a6 %08x a7 %08x\n",
			       rtl_a0, rtl_a1, rtl_a2, rtl_a3, rtl_a4, rtl_a5, rtl_a6, rtl_sp);
			printf("sim: a0 %08x a1 %08x a2 %08x a3 %08x a4 %08x a5 %08x a6 %08x a7 %08x\n",
			       a0, a1, a2, a3, a4, a5, a6, sp);
			printf("----\n");
			if (1) exit(2);
		}
	}
}

}
