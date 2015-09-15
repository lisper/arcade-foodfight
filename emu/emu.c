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
int do_video;
int do_patch;
int do_switches;

/* Far enough memory room */
#define ROM_SIZE (64*1024)
#define RAM_SIZE (32*1024)
#define NVRAM_SIZE 0x200

unsigned char rom[ROM_SIZE];
unsigned char ram[RAM_SIZE];
unsigned char nvram[NVRAM_SIZE];
unsigned char pf[0x800];
unsigned char color[0x400];
unsigned char stamp[256];
unsigned char sctrl;

unsigned char stamp_rom[2][8192];
unsigned char pf_rom[8192];
char *stamp_rom_filename[2];
char *pf_rom_filename;

char irq3_enabled;
char irq4_enabled;

int do_32v_irq;
int do_vblank_irq;

int count_vblank;
int count_32v;

int digital_out;

unsigned short old_control;

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
	unsigned short data = 0;
	int a;

	if (do_iotrace) printf("io: read byte @ 0x%08X\n",addr);

	if (addr >= 0x1c000 && addr <= 0x1c0ff) {
		a = addr - 0x1c000;
		return stamp[a];
	}
	else
	if (addr >= 0x800000 && addr <= 0x8007ff) {
		a = addr - 0x800000;
		return pf[a];
	}
	else
	if (addr >= 0x900000 && addr <= 0x9001ff) {
		a = addr - 0x900000;
		data = nvram[a];
		if (do_iotrace) printf("io: read nvram @ 0x%08x -> 0x%02x (b)\n", addr, data);
		return data;
	}
	else
	if (addr >= 0x950000 && addr <= 0x9503ff) {
		a = addr - 0x950000;
		return color[a];
	}

	return 0;
}

void wriobyte(int addr, int data) 
{
	int a;

	if (do_iotrace) printf("io: write byte 0x%02X @ 0x%08X...\n",data,addr);

	if (addr >= 0x1c000 && addr <= 0x1c0ff) {
		a = addr - 0x1c000;
if (data != 0)
		if (do_iotrace||1) printf("io: write stamp @ 0x%08x <- 0x%02x (b)\n", addr, data);
		stamp[a] = data;
		poke_stamp();
	}
	else
	if (addr >= 0x800000 && addr <= 0x8007ff) {
		a = addr - 0x800000;
		if (do_iotrace) printf("io: write pf @ 0x%08x <- 0x%02x (b)\n", addr, data);
		pf[a] = data;
		poke_pf();
	}
	if (addr >= 0x900000 && addr <= 0x9001ff) {
		a = addr - 0x900000;
		if (do_iotrace) printf("io: write nvram @ 0x%08x <- 0x%02x (b)\n", addr, data);
		nvram[a] = data;
	}
	else
	if (addr >= 0x950000 && addr <= 0x9503ff) {
		a = addr - 0x950000;
		if (do_iotrace) printf("io: write color @ 0x%08x <- 0x%02x (b)\n", addr, data);
		color[a] = data;
		poke_color();
	} else {
		if (do_iotrace) printf("io: write word 0x%08X <- 0x%04X (b) ??\n", addr, data);
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
		if (do_iotrace) printf("io: read nvram @ 0x%08x -> 0x%04x\n", addr, data);
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
		data = digital_out;
data = ((digital_out & 0xff) << 8) | (digital_out & 0xff);
data = 0xff00 | (digital_out & 0xff);

		if (0) printf("io: read control 0x%02x\n", data);
		if (data != old_control) {
			printf("io: read control 0x%02x\n", data);
			old_control = data;
		}
		break;
	case 0x954000:
		data = 0;
		break;
	case 0x958000:
		data = 0;
		break;
	default:
		if (do_iotrace) printf("io: read word @ 0x%08x ???\n", addr);
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
if (data != 0)
		if (do_iotrace) printf("io: write stamp @ 0x%08x <- 0x%04x\n", addr, data);
		stamp[a] = data >> 8;
		stamp[a+1] = data;
		poke_stamp();
	}
	else
	if (addr >= 0x800000 && addr <= 0x8007ff) {
		a = addr - 0x800000;
		if (do_iotrace) printf("io: write pf @ 0x%08x <- 0x%04x\n", addr, data);
		pf[a] = data >> 8;
		pf[a+1] = data;
		poke_pf();
	}
	else
	if (addr >= 0x900000 && addr <= 0x9001ff) {
		a = addr - 0x900000;
		if (do_iotrace) printf("io: write nvram @ 0x%08x <- 0x%04x\n", addr, data);
		nvram[a] = data >> 8;
		nvram[a+1] = data;
	}
	else
	if (addr >= 0x950000 && addr <= 0x9503ff) {
		a = addr - 0x950000;
		if (do_iotrace) printf("io: write color @ 0x%08x <- 0x%04x\n", addr, data);
		color[a] = data >> 8;
		color[a+1] = data;
		poke_color();
	}
	else {
		switch(addr) {
		case 0x948000:
			if (do_iotrace)
				printf("control: %x; cycles %llu, pc %x\n", data, cycles, m68k_get_pc());
			sctrl = data;
			irq4_enabled = (sctrl & 8) ? 1 : 0;
			irq3_enabled = (sctrl & 4) ? 1 : 0;
			return;
		case 0x958000:
			return;
		default:
			if (do_iotrace) printf("io: write word 0x%08X <- 0x%04X ??\n", addr, data);
			return;
		}
	}
}

int rdpokeybyte(int addr)
{
	int data = 0;
	int r = (addr & 0x1f) >> 1;
	printf("pokey: read byte @ 0x%08x; reg %x -> 0x%04x\n", addr, r, data);
	return data;
}

int _s;

int rdpokeyword(int addr)
{
	int data = 0;
	int r = (addr & 0x1f) >> 1;
	int p = -1;
	if (((addr >> 16) & 0xff) == 0xac) p = 2;
	if (((addr >> 16) & 0xff) == 0xa8) p = 0;
	if (((addr >> 16) & 0xff) == 0xa4) p = 1;

        switch (r) {
	case 8:
		if (_s) {
			_s = 0;
			data = 0xff;
		} else {
			_s = 1;
			data = 0x00;
		}
		break;
	case 6:
	case 9:
	case 0xa:
	case 0xd:
		data = 0;
		break;

	default:
		data = 0xff;
		break;
	}

data = ((data & 0xff) << 8) | data;
	if (do_iotrace) printf("pokey: read word @ 0x%08x; reg %x -> 0x%04x\n", addr, r, data);
	return data;
}

void wrpokeybyte(int addr, int data)
{
	printf("pokey: write byte 0x%08X <- 0x%04X\n", addr, data);
}

void wrpokeyword(int addr, int data)
{
	if (do_iotrace) printf("pokey: write word 0x%08X <- 0x%04X\n", addr, data);
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
	{0xa40000,0xacffff,rdpokeybyte,NULL},
	{-1,-1,NULL}
};

struct M68K_DATA d68ks_wb[] = 
{
	{0x000000,0x00FFFF,NULL,rom - 0x000000},
	{0x014000,0x01bFFF,NULL,ram - 0x014000},
	{0x01c000,0x01c0FF,wriobyte,NULL},
	{0x800000,0x97ffff,wriobyte,NULL},
	{0xa40000,0xacffff,wrpokeybyte,NULL},
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
read_code_rom(void)
{
	int f, r;

#define CODE_ROM_FNAME "../roms/v3/rom_89.bin"
	/* Opening the object file */
	f = open(CODE_ROM_FNAME, O_RDONLY);
	if (f <= 0) {
		perror(CODE_ROM_FNAME);
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

struct {
	int pc, old, new;
} rom_patch_table[] = {
	{ 0x0514, 0x6000, 0x4ef9 },
	{ 0x0516, 0x008e, 0x0000 },
	{ 0x0518, 0x286a, 0x0664 },

	{ 0x05de, 0x51c8, 0x4e71 },
	{ 0x05e0, 0xfff8, 0x4e71 },

	{ 0x05f6, 0x51c8, 0x4e71 },
	{ 0x05f8, 0xfff8, 0x4e71 },

	{ 0x060a, 0x51c8, 0x4e71 },
	{ 0x060c, 0xfff8, 0x4e71 },

	{ 0x0688, 0xb279, 0x4241 },
	{ 0x068a, 0x0000, 0x4e71 },
	{ 0x068c, 0x04d6, 0x4e71 },

	{ 0x0706, 0x4a40, 0x4240 },

	{ 0, 0, 0 }
};

int
patch_code_rom(void)
{
	int i;
	printf("Patching rom...\n");
	for (i = 0; rom_patch_table[i].pc; i++) {
		int pc, old, new;
		unsigned char b1, b2;
		pc = rom_patch_table[i].pc;
		old = rom_patch_table[i].old;
		new = rom_patch_table[i].new;
		b2 = old >> 8;
		b1 = old & 0xff;
		if (0) printf("pc %x, rom %x %04x -> %04x ", pc, rom[pc], old, new);
		if (rom[pc] == b1 && rom[pc+1] == b2) {
			if (0) printf("ok\n");
			b2 = new >> 8;
			b1 = new & 0xff;
			rom[pc] = b1;
			rom[pc+1] = b2;
		} else {
			int j;
			printf(" bad\n");
			for (j = pc-5; j < pc+5; j++)
				printf("rom[%x] = %x\n", j, rom[j]);
			break;
		}
	}
}

int
read_stamp_rom(int index, char *fn)
{
	int f, r;
	f = open(fn, O_RDONLY);
	if (f <= 0) {
		perror(fn);
		exit(2);
	}

	r = read(f, stamp_rom[index], 8192);
	if (r != 8192) {
		perror(fn);
		exit(1);
	}
	close(f);
	return 0;
}

int
read_stamp_roms(void)
{
	if (read_stamp_rom(0, stamp_rom_filename[0]))
		return -1;

	if (read_stamp_rom(1, stamp_rom_filename[1]))
		return -1;

	return 0;
}

int
read_pf_rom(void)
{
	int f, r;
	f = open(pf_rom_filename, O_RDONLY);
	if (f <= 0) {
		perror(pf_rom_filename);
		exit(2);
	}

	r = read(f, pf_rom, 8192);
	if (r != 8192) {
		perror(pf_rom_filename);
		exit(1);
	}
	close(f);
	return 0;
}


unsigned short _sr;

void
check_interrupts(unsigned long long cycles)
{
	unsigned short new_sr = m68k_get_register(M68K_REG_SR);

	if ((_sr & 0x700) != (new_sr & 0x700)) {
		if (0) printf("cpu: sr %x; cycles %llu, pc %x\n", new_sr, cycles, m68k_get_pc());
	}
	_sr = new_sr;

//#define VBLANK_COUNT	40000
//#define V32_COUNT	12000
#define VBLANK_COUNT	400000
#define V32_COUNT	120000
//#define VBLANK_COUNT	20000
//#define V32_COUNT	6000
	count_vblank++;
	if (count_vblank > VBLANK_COUNT) {
		do_vblank_irq = 1;
		count_vblank = 0;
	}

	count_32v++;
	if (count_32v > V32_COUNT) {
		do_32v_irq = 1;
		count_32v = 0;
	}

	switch (do_32v_irq) {
	case 1:
		if (irq3_enabled) {
			m68k_raise_irq(3, M68K_AUTOVECTORED_IRQ);
			if (do_irqtrace) {
				printf("irq: level 3\n");
				fflush(stdout);
			}
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
			if (do_irqtrace) {
				printf("irq: level 4\n");
				fflush(stdout);
			}
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

//
//    assign digital_out = { test, throw2, throw1, coinaux, start2, start1, coin2, coin1 };
//

void
set_switches(unsigned long long cycles)
{
	digital_out = 0xff;

//digital_out = 0x00;
	if (cycles == 0) {
		return;
	}

#if 1
	if (cycles >= 50000000 && cycles < 55000000) {
		digital_out = 0xdf;
		return;
	}
#endif

#if 1
	if (cycles >= 60000000 && cycles < 62000000) {
//		digital_out = 0xff & ~0x10;
		digital_out = 0xff & ~0x01;
		digital_out = 0xff & ~0x80;
		return;
	}
#endif

#if 1
	if (cycles >= 100000000 && cycles < 100200000) {
		digital_out = 0xff & ~0x04;
		return;
	}
#endif

#if 0
	if (cycles >= 305000 && cycles < 306000) {

printf("two\n");
//digital_out = 0xff & ~0x04;
digital_out = 0xff & ~0x01;
digital_out = 0x01;
		return;
	}
#endif

#if 0
	if (cycles >= 180000 && cycles < 180200) {
digital_out = 0x40;
		return;
	}
#endif

#if 0
	if (cycles >= 300200 && cycles < 300250) {
printf("xxx %lld\n", cycles);
//		digital_out = 0xff & ~0x04;
//		digital_out = 0xff & ~0x80;
//		digital_out = 0xff & ~0x40;
		digital_out = 0x40;
		return;
	}
#endif

}

extern char *optarg;
int main(int argc, char *argv) 
{
	int c;

	max_cycles = 0;
	do_trace = 0;
	do_iotrace = 0;
	do_irqtrace = 0;
	do_switches = 1;
	do_patch = 0;
	do_video = 0;

	while ((c = getopt(argc, argv, "iqtm:npv")) != -1) {
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
	       case 'n':
		       do_switches = 0;
		       break;
	       case 'p':
		       do_patch = 1;
		       break;
	       case 't':
		       do_trace++;
		       break;
	       case 'v':
		       do_video++;
		       break;
	       }
	}
	
	setup_context();
	read_code_rom();

	if (do_patch) {
		patch_code_rom();
	}

	{
		int i;
		for (i = 0; i < NVRAM_SIZE; i++)
			nvram[i] = 0xff;
	}

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

	if (do_video) {
		stamp_rom_filename[0] = "../roms/v3/136020-111.4d";
		stamp_rom_filename[1] = "../roms/v3/136020-110.4e";
		pf_rom_filename = "../roms/v3/136020-109.6lm";

		read_stamp_roms();
		read_pf_rom();
		video_init();
	}

	cycles = 0;
	while (1) {
		int ret;

		if (do_switches) {
			set_switches(cycles);
		}
		check_interrupts(cycles);

#if 0
		if (cycles == 2977513) {
			do_trace = 2;
		}
#endif

#if 0
		if (m68k_get_pc() == 0xf4) {
			do_trace = 2;
		}
#endif

		m68k_emulate(1);
		
		ret = m68k_get_cpu_state();
		if (ret != M68K_OK) {
			printf("ERROR! ret=%d, cpu_state %d 0x%x\n", ret, m68k_get_cpu_state(), m68k_get_cpu_state());
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

		if (do_video) {
			video_poll();
		}
	}

	show_cpu_state();

	return 0;
}

