/*
 * a very simple framework for running "foodfight" rom code using the fame 68k emulator library
 * brad@heeltoe.com 6/2014
 */

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <fcntl.h>
#include "fame.h"

unsigned long long cycles;
unsigned long long max_cycles;
int do_trace;
int do_iotrace;
int do_irqtrace;

/* Far enough memory room */
#define ROM_SIZE (64*1024)
#define RAM_SIZE (32*1024)
#define NVRAM_SIZE 0x1ff

unsigned char rom[ROM_SIZE];
unsigned char ram[RAM_SIZE];
unsigned char nvram[NVRAM_SIZE];
unsigned char pf[0x800];
unsigned char color[0x400];
unsigned char stamp[256];
unsigned char sctrl;

char irq3_enabled;
char irq4_enabled;

int do_32v_irq;
int do_vblank_irq;

int count_vblank;
int count_32v;

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

void show_cpu_trace(void)
{
	int sr;
	sr = m68k_get_register(M68K_REG_SR);
	printf("PC:%08X SR:%04X ",m68k_get_pc(), sr);
	printf("D0:%08X ",m68k_get_register(M68K_REG_D0));
	printf("D1:%08X ",m68k_get_register(M68K_REG_D1));
	printf("\n");
}

void show_cpu_state(void) 
{
	int sr;

	printf("PC:%08X ",m68k_get_pc());
	printf("SR:%04X  ",(sr = m68k_get_register(M68K_REG_SR)));
	printf("Flags: %c%c%c%c%c\n",
		(sr >> 4) & 1 ? 'X' : '-',
		(sr >> 3) & 1 ? 'N' : '-',
		(sr >> 2) & 1 ? 'Z' : '-',
		(sr >> 1) & 1 ? 'V' : '-',
		(sr     ) & 1 ? 'C' : '-'
	);
	printf("D0:%08X ",m68k_get_register(M68K_REG_D0));
	printf("D1:%08X ",m68k_get_register(M68K_REG_D1));
	printf("D2:%08X ",m68k_get_register(M68K_REG_D2));
	printf("D3:%08X ",m68k_get_register(M68K_REG_D3));
	printf("D4:%08X ",m68k_get_register(M68K_REG_D4));
	printf("D5:%08X ",m68k_get_register(M68K_REG_D5));
	printf("D6:%08X ",m68k_get_register(M68K_REG_D6));
	printf("D7:%08X\n",m68k_get_register(M68K_REG_D7));
	printf("A0:%08X ",m68k_get_register(M68K_REG_A0));
	printf("A1:%08X ",m68k_get_register(M68K_REG_A1));
	printf("A2:%08X ",m68k_get_register(M68K_REG_A2));
	printf("A3:%08X ",m68k_get_register(M68K_REG_A3));
	printf("A4:%08X ",m68k_get_register(M68K_REG_A4));
	printf("A5:%08X ",m68k_get_register(M68K_REG_A5));
	printf("A6:%08X ",m68k_get_register(M68K_REG_A6));
	printf("A7:%08X\n",m68k_get_register(M68K_REG_A7));
}

int rdiobyte(int addr)
{
	int a;

	if (do_iotrace) printf("io: read byte @ 0x%08X\n",addr);

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

	if (do_iotrace) printf("io: write byte 0x%02X @ 0x%08X...\n",data,addr);

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
	unsigned short data = 0;
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
	case 0x940000:
		data = 0x0;
		break;
	case 0x948000:
//		data = 0x3ff;
		data = 0x0;
		break;
	case 0x954000:
		data = 0;
		break;
	case 0x958000:
		data = 0;
		break;
	default:
		printf("io: read word @ 0x%08x ???\n", addr);
		return 0;
	}

	if (do_iotrace) printf("io: read word @ 0x%08x -> 0x%04x\n", addr, data);

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
		printf("control: %x; cycles %llu, pc %x\n", data, cycles, m68k_get_pc());
		sctrl = data;
		irq4_enabled = (sctrl & 8) ? 1 : 0;
		irq3_enabled = (sctrl & 4) ? 1 : 0;
		return;
	case 0x958000:
		return;
	}

	if (do_iotrace) printf("io: write word 0x%08X <- 0x%04X\n", addr, data);
}

int rdpokeyword(int addr)
{
	int data = 0;
	printf("pokey: read word @ 0x%08x -> 0x%04x\n", addr, data);
	return data;
}

void wrpokeyword(int addr, int data)
{
	printf("pokey: write word 0x%08X <- 0x%04X\n", addr, data);
}

/* Memory map definition for program access */
struct M68K_PROGRAM p68ks[] = 
{
	{0x000000,0x00FFFF,(unsigned)rom - 0x000000},
	{-1,-1,(unsigned)NULL}
};


/* Memory map definitions with memory handlers */
struct M68K_DATA d68ks_rb[] = 
{
	{0x000000,0x00FFFF,NULL,rom - 0x000000},
	{0x014000,0x01bFFF,NULL,ram - 0x014000},
	{0x01c000,0x01c0FF,rdiobyte,NULL},
	{0x800000,0x97ffff,rdiobyte,NULL},
	{-1,-1,NULL}
};

struct M68K_DATA d68ks_wb[] = 
{
	{0x000000,0x00FFFF,NULL,rom - 0x000000},
	{0x014000,0x01bFFF,NULL,ram - 0x014000},
	{0x01c000,0x01c0FF,wriobyte,NULL},
	{0x800000,0x97ffff,wriobyte,NULL},
	{-1,-1,NULL}
};

struct M68K_DATA d68ks_rw[] = 
{
	{0x000000,0x00FFFF,NULL,rom - 0x000000},
	{0x014000,0x01bFFF,NULL,ram - 0x014000},
	{0x01c000,0x01c0FF,rdioword,NULL},
	{0x800000,0x97ffff,rdioword,NULL},
	{0xa40000,0xacffff,rdpokeyword,NULL},
	{-1,-1,NULL}
};

struct M68K_DATA d68ks_ww[] = 
{
	{0x000000,0x00FFFF,NULL,rom - 0x000000},
	{0x014000,0x01bFFF,NULL,ram - 0x014000},
	{0x01c000,0x01c0FF,wrioword,NULL},
	{0x800000,0x97ffff,wrioword,NULL},
	{0xa40000,0xacffff,wrpokeyword,NULL},
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

	return 0;
}

unsigned short _sr;

void
check_interrupts(unsigned long long cycles)
{
	unsigned short new_sr = m68k_get_register(M68K_REG_SR);

	if ((_sr & 0x700) != (new_sr & 0x700)) {
		printf("cpu: sr %x; cycles %llu, pc %x\n", new_sr, cycles, m68k_get_pc());
	}
	_sr = new_sr;

	count_vblank++;
	if (count_vblank > 10000) {
		do_vblank_irq = 1;
		count_vblank = 0;
	}

	count_32v++;
	if (count_32v > 3000) {
		do_32v_irq = 1;
		count_32v = 0;
	}

	switch (do_32v_irq) {
	case 1:
		if (irq3_enabled) {
			m68k_raise_irq(3, M68K_AUTOVECTORED_IRQ);
			if (do_irqtrace) printf("irq: level 3\n");
		}
		do_32v_irq++;
		break;
	case 2:
		if (irq3_enabled) {
			m68k_lower_irq(3);
		}
		do_32v_irq = 0;
		break;
	}

	switch (do_vblank_irq) {
	case 1:
		if (irq4_enabled) {
			m68k_raise_irq(4, M68K_AUTOVECTORED_IRQ);
			if (do_irqtrace) printf("irq: level 4\n");
fflush(stdout);
		}
		do_vblank_irq++;
		break;
	case 2:
		if (irq4_enabled) {
			m68k_lower_irq(4);
		}
		do_vblank_irq = 0;
		break;
	}
}

extern char *optarg;
int main(int argc, char *argv) 
{
	int c;

	max_cycles = 0;
	do_trace = 0;
	do_iotrace = 0;
	do_irqtrace = 0;

	while ((c = getopt(argc, argv, "iqtm:")) != -1) {
               switch (c) {
	       case 'i':
		       do_iotrace++;
		       break;
	       case 'q':
		       do_irqtrace++;
		       break;
               case 'm':
		       max_cycles = atoll(optarg);
		       break;
	       case 't':
		       do_trace++;
		       break;
	       }
	}
	
	setup_context();
	read_rom();

	/* Initializing FAME */
	printf("Init...\n");
	m68k_init();

	/* Resetting the CPU */
	printf("Reset...\n");
	if (m68k_reset() == M68K_OK)
		printf("OK\n");
	else {
		printf("ERROR!\n");
		exit(1);
	}

	cycles = 0;
	while (1) {
		check_interrupts(cycles);

		m68k_emulate(1);
		
		if (m68k_get_cpu_state() == M68K_OK)
			;
		else {
			printf("ERROR! %d 0x%x\n", m68k_get_cpu_state(), m68k_get_cpu_state());
			break;
		}

		if (do_trace == 1) {
			show_cpu_trace();
		}
		else
		if (do_trace == 2) {
			show_cpu_state();
		}

		cycles++;
		if (max_cycles && cycles > max_cycles) {
			printf("MAX cycles reached\n");
			break;
		}
	}

	show_cpu_state();

	return 0;
}

