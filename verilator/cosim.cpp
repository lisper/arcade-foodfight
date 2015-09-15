#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <memory.h>
#include <fcntl.h>

#include "Vff_verilator.h"
#include "cosim.h"

extern int show_cosim_io;

extern "C" {

#include "fame.h"

/* Far enough memory room */
#define ROM_SIZE (64*1024)
#define RAM_SIZE (32*1024)
#define NVRAM_SIZE 0x200

static unsigned char rom[ROM_SIZE];
static unsigned char ram[RAM_SIZE];
static unsigned char nvram[NVRAM_SIZE];
static unsigned char pf[0x800];
static unsigned char color[0x400];
static unsigned char stamp[256];

static Vff_verilator *_top;

static unsigned int digital_out;
static unsigned int old_control;

int rdromword(int addr)
{
	unsigned short data;
	data = (rom[addr] << 8) | rom[addr+1];
	if (show_cosim_io) printf("sim rom: read word @ 0x%08x -> 0x%04x\n", addr, data);
	return data;
}

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
	else
	if (addr >= 0x800000 && addr <= 0x8007ff) {
		a = addr - 0x800000;
		return pf[a];
	}
	else
	if (addr >= 0x900000 && addr <= 0x9001ff) {
		a = addr - 0x900000;
		if (show_cosim_io) printf("io: read nvram @ 0x%08x -> 0x%02x\n", addr, nvram[a]);
		return nvram[a];
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
	else
	if (addr >= 0x900000 && addr <= 0x9001ff) {
		a = addr - 0x900000;
		if (show_cosim_io) printf("io: write nvram @ 0x%08x <- 0x%02x\n", addr, data);
		nvram[a] = data;
	}
	else
	if (addr >= 0x950000 && addr <= 0x9503ff) {
		a = addr - 0x950000;
		color[a] = data;
	} else {
		if (show_cosim_io) printf("io: write word 0x%08X <- 0x%04X (b) ??\n", addr, data);
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
//		data = (nvram[a] << 8) | nvram[a+1];
		data = nvram[a];
		if (show_cosim_io) printf("io: read nvram @ 0x%08x -> 0x%04x\n", addr, data);
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
		digital_out =
			(0x80 & ((_top->v__DOT__sw) << 7)) |
			(0x40 & ((_top->v__DOT__sw) << 5)) |
			(0x20 & ((_top->v__DOT__sw) << 3)) |
			(0x10 & ((_top->v__DOT__sw) << 1)) | 
			(0x08 & ((_top->v__DOT__sw) >> 1)) |
			(0x04 & ((_top->v__DOT__sw) >> 3)) |
			(0x02 & ((_top->v__DOT__sw) >> 5)) |
			(0x01 & ((_top->v__DOT__sw) >> 7));

		data = digital_out;

		if (0) printf("io: read control 0x%02x\n", data);
		if (data != old_control) {
			printf("io: read control 0x%02x (sw 0x%02x)\n", data, _top->v__DOT__sw);
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
		if (show_cosim_io) printf("io: read word @ 0x%08x ???\n", addr);
		return 0;
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
		if (show_cosim_io) printf("io: write nvram @ 0x%08x <- 0x%04x\n", addr, data);
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

typedef volatile unsigned int vuint32;

int rdpokeyword(int addr)
{
	int data = 0;
	unsigned int adr;

	printf("sim pokey: read word @ 0x%08x -> 0x%04x\n", addr, data);

	if ((addr & 0xff0000) != 0xa80000)
		return data;

	adr = addr;
	data =
		(0xff & ((8 & adr) ?
			 ((4 & adr) ?
			  ((2 & adr) ?
			   ((1 & adr) ?
			    0xff : (~ ((vuint32)(_top->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__irqst) 
				       & (vuint32)(_top->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__irqen))))
			   : ((1 & adr) ? 0 :
			      0xff)) :
			  ((2 & adr) ?
			   ((1 & adr) ?
			    0xff : (_top->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__u_poly17__DOT__shift >> 9)) :
			   ((1 & adr) ? 0 :
			    (vuint32)(_top->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_done)))) :
			 (vuint32)(_top->v__DOT__uut__DOT__ff__DOT__pokey_0__DOT__pokey__DOT__pot_cntr) [(7 & adr)]));

	return data;
}

void wrpokeyword(int addr, int data)
{
	printf("sim pokey: write word 0x%08X <- 0x%04X\n", addr, data);
}

/* Memory map definition for program access */
/*struct */M68K_PROGRAM p68ks[] = 
{
	{0x000000,0x00FFFF,(unsigned)rom - 0x000000},
	{-1,-1,(unsigned)NULL}
};

#define NO_FUNC (void *)NULL

/* Memory map definitions with memory handlers */
/*struct */M68K_DATA d68ks_rb[] = 
{
	{0x000000,0x00FFFF,NO_FUNC,rom - 0x000000},
//	{0x014000,0x01bFFF,NO_FUNC,ram - 0x014000},
	{0x014000,0x01bFFF,(void *)rdrambyte,NULL},
	{0x01c000,0x01c0FF,(void *)rdiobyte,NULL},
	{0x800000,0x97ffff,(void *)rdiobyte,NULL},
	{-1,-1,NULL}
};

/*struct */M68K_DATA d68ks_wb[] = 
{
	{0x000000,0x00FFFF,NO_FUNC,rom - 0x000000},
//	{0x014000,0x01bFFF,NO_FUNC,ram - 0x014000},
	{0x014000,0x01bFFF,(void *)wrrambyte,NULL},
	{0x01c000,0x01c0FF,(void *)wriobyte,NULL},
	{0x800000,0x97ffff,(void *)wriobyte,NULL},
	{-1,-1,NULL}
};

/*struct */M68K_DATA d68ks_rw[] = 
{
	{0x000000,0x00FFFF,NO_FUNC,rom - 0x000000},
//	{0x014000,0x01bFFF,NO_FUNC,ram - 0x014000},
	{0x014000,0x01bFFF,(void *)rdramword,NULL},
	{0x01c000,0x01c0FF,(void *)rdioword,NULL},
	{0x800000,0x97ffff,(void *)rdioword,NULL},
	{0xa40000,0xacffff,(void *)rdpokeyword,NULL},
	{-1,-1,NULL}
};

/*struct */M68K_DATA d68ks_ww[] = 
{
	{0x000000,0x00FFFF,NO_FUNC,rom - 0x000000},
//	{0x014000,0x01bFFF,NO_FUNC,ram - 0x014000},
	{0x014000,0x01bFFF,(void *)wrramword,NULL},
	{0x01c000,0x01c0FF,(void *)wrioword,NULL},
	{0x800000,0x97ffff,(void *)wrioword,NULL},
	{0xa40000,0xacffff,(void *)wrpokeyword,NULL},
	{-1,-1,NULL}
};

/*struct */M68K_CONTEXT mc68k_contxt;

int
setup_context(void)
{
	/* Setting up memory maps in CPU context */
	memset(&mc68k_contxt,0,sizeof(mc68k_contxt));
	mc68k_contxt.fetch = p68ks;
	mc68k_contxt.sv_fetch = p68ks;
	mc68k_contxt.user_fetch = p68ks;

//	mc68k_contxt.read_byte  = d68ks_rb;
//	mc68k_contxt.read_word  = d68ks_rw;
//	mc68k_contxt.write_byte = d68ks_wb;
//	mc68k_contxt.write_word = d68ks_ww;

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

int
copy_rom(void)
{
	int i;
	unsigned short w;

	for (i = 0; i < 8192; i++) {
		w = _top->__Vtable6_v__DOT__uut__DOT__ff__DOT__coderom__DOT__q0[i];
		rom[i*2+0] = w >> 8;
		rom[i*2+1] = w & 0xff;
	}

	for (i = 0; i < 8192; i++) {
		w = _top->__Vtable7_v__DOT__uut__DOT__ff__DOT__coderom__DOT__q1[i];
		rom[i*2+16384*1+0] = w >> 8;
		rom[i*2+16384*1+1] = w & 0xff;
	}

	for (i = 0; i < 8192; i++) {
		w = _top->__Vtable8_v__DOT__uut__DOT__ff__DOT__coderom__DOT__q2[i];
		rom[i*2+16384*2+0] = w >> 8;
		rom[i*2+16384*2+1] = w & 0xff;
	}

	for (i = 0; i < 8192; i++) {
		w = _top->__Vtable9_v__DOT__uut__DOT__ff__DOT__coderom__DOT__q3[i];
		rom[i*2+16384*3+0] = w >> 8;
		rom[i*2+16384*3+1] = w & 0xff;
	}

	byte_swapping(rom);

	printf("ROM: 00000000 %02x%02x %02x%02x %02x%02x %02x%02x\n",
	       rom[0], rom[1], rom[2], rom[3], 
	       rom[4], rom[5], rom[6], rom[7]);

	printf("ROM: 00007468 %02x%02x %02x%02x %02x%02x %02x%02x\n",
	       rom[0x7468+0], rom[0x7468+1], rom[0x7468+2], rom[0x7468+3], 
	       rom[0x7468+4], rom[0x7468+5], rom[0x7468+6], rom[0x7468+7]);

	printf("ROM: 0000897a %02x%02x %02x%02x %02x%02x %02x%02x\n",
	       rom[0x897a+0], rom[0x897a+1], rom[0x897a+2], rom[0x897a+3], 
	       rom[0x897a+4], rom[0x897a+5], rom[0x897a+6], rom[0x897a+7]);

	return 0;
}

int
init_nvram(void)
{
	int i;

	for (i = 0; i < NVRAM_SIZE; i++)
		nvram[i] = 0x0f;

	return 0;
}

static int old_il4n = -1;
static int old_il3n = -1;
static int irq1_asserted;
static int irq2_asserted;
static int irq3_asserted;
static int post_irq;
static int post_irq_delay;
static int rtl_irq_event;
static int rtl_irq_vector;
static unsigned int rtl_irq_pc;

void
cosim_int_event(unsigned int pc, int vector)
{
	rtl_irq_pc = pc;
	rtl_irq_vector = vector;
	rtl_irq_event++;
	printf("sim: irq event %d, vector %x @ %x\n", rtl_irq_event, rtl_irq_vector, pc);
}

void
check_interrupts(void)
{
	int il3n, il4n;
	int set_irq1, set_irq2, set_irq3;
	int clr_irq1, clr_irq2, clr_irq3;
	int reprio;

	if (rtl_irq_event) {
		printf("sim: irq wait; rtl pc %x, sim pc %x\n",
		       rtl_irq_pc, m68k_get_pc());
	}

	if (rtl_irq_event && rtl_irq_pc == m68k_get_pc()) {
		switch (rtl_irq_vector) {
		case 27:
			printf("io: irq3 raise\n");
			m68k_raise_irq(3, M68K_AUTOVECTORED_IRQ);
			irq3_asserted = 1;
			break;
		case 26:
			printf("io: irq2 raise\n");
			m68k_raise_irq(2, M68K_AUTOVECTORED_IRQ);
			irq2_asserted = 1;
			break;
		case 25:
			printf("io: irq1 raise\n");
			m68k_raise_irq(1, M68K_AUTOVECTORED_IRQ);
			irq1_asserted = 1;
			break;
		}
		rtl_irq_event = 0;
	}

//	if (set_irq3) {
////		printf("io: irq3 raise\n");
////		m68k_raise_irq(3, M68K_AUTOVECTORED_IRQ);
//		post_irq |= 4;
//		post_irq_delay = 2;
//		irq3_asserted = 1;
//	}

#if 0
	if (post_irq_delay > 0) {
		if (0) printf("XXX delay %d @ %x\n", post_irq_delay, m68k_get_pc());

		if (rtl_irq_event && rtl_irq_pc != m68k_get_pc()) {
			while (rtl_irq_pc != m68k_get_pc()) {
				printf("XXX delay @ rtl %x sim %x\n", rtl_irq_pc, m68k_get_pc());
				m68k_emulate(1);
			}
		}

		if (rtl_irq_event && rtl_irq_pc == m68k_get_pc()) {
			rtl_irq_event = 0;
			post_irq_delay = 0;
		}

		if (post_irq_delay == 0) {
			printf("XXX fire @ %x\n", m68k_get_pc());
			if (post_irq & 4) {
				printf("io: irq3 raise\n");
				m68k_raise_irq(3, M68K_AUTOVECTORED_IRQ);
			}
			if (post_irq & 2) {
				printf("io: irq2 raise\n");
				m68k_raise_irq(2, M68K_AUTOVECTORED_IRQ);
			}
			if (post_irq & 1) {
				printf("io: irq1 raise\n");
				m68k_raise_irq(1, M68K_AUTOVECTORED_IRQ);
			}
			post_irq = 0;
		}
	}
#endif

	il3n = _top->v__DOT__uut__DOT__ff__DOT__il3_n;
	il4n = _top->v__DOT__uut__DOT__ff__DOT__il4_n;

	set_irq1 = set_irq2 = set_irq3 = 0;
	clr_irq1 = clr_irq2 = clr_irq3 = 0;
	reprio = 0;

	if (il4n != old_il4n) {
		reprio = 1;
		old_il4n = il4n;
	}

	if (il3n != old_il3n) {
		reprio = 1;
		old_il3n = il3n;
	}

	/* priority encoder */
	if (reprio) {
		if (irq3_asserted && (il4n == 1 || il3n == 1)) {
			printf("io: il4n+il3n deassert\n");
			clr_irq3 = 1;
		}
		if (irq2_asserted && il4n == 1) {
			printf("io: il4n deasserts\n");
			clr_irq2 = 1;
		}
		if (irq1_asserted && il3n == 1) {
			printf("io: il3n deasserts\n");
			clr_irq1 = 1;
		}

		if (!irq3_asserted && (il4n == 0 && il3n == 0)) {
			printf("io: il4n+il3n assert\n");
			set_irq3 = 1;
			if (irq2_asserted)
				clr_irq2 = 1;
			if (irq1_asserted)
				clr_irq1 = 1;
		} else
			if (!irq2_asserted && il4n == 0) {
				printf("io: il4n asserts\n");
				set_irq2 = 1;
				if (irq3_asserted)
					clr_irq3 = 1;
			} else
				if (!irq1_asserted && il3n == 0) {
					printf("io: il3n asserts\n");
					set_irq1 = 1;
					if (irq3_asserted)
						clr_irq3 = 1;
				}

	}

	/* implement */
	if (clr_irq3) {
		if (irq3_asserted) {
			printf("io: irq3 lower\n");
			m68k_lower_irq(3);
			irq3_asserted = 0;
		}
	}

	if (clr_irq1) {
		if (irq1_asserted) {
			printf("io: irq1 lower\n");
			m68k_lower_irq(1);
			irq1_asserted = 0;
		}
	}

	if (clr_irq2) {
		if (irq2_asserted) {
			printf("io: irq2 lower\n");
			m68k_lower_irq(2);
			irq2_asserted = 0;
		}
	}


//	if (set_irq3) {
////		printf("io: irq3 raise\n");
////		m68k_raise_irq(3, M68K_AUTOVECTORED_IRQ);
//		post_irq |= 4;
//		post_irq_delay = 2;
//		irq3_asserted = 1;
//	}
//	if (set_irq2) {
////		printf("io: irq2 raise\n");
////		m68k_raise_irq(2, M68K_AUTOVECTORED_IRQ);
//		post_irq |= 2;
//		post_irq_delay = 2;
//		irq2_asserted = 1;
//	}
//	if (set_irq1) {
////		printf("io: irq1 raise\n");
////		m68k_raise_irq(1, M68K_AUTOVECTORED_IRQ);
//		post_irq |= 1;
//		post_irq_delay = 2;
//		irq1_asserted = 1;
//	}
}

#define MAX_HISTORY 20
static int h;
static struct {
	unsigned long long t;
	unsigned int pc;
	unsigned int s_sr;
	unsigned int r_sr;
	unsigned int s_a0, s_a6, s_a7;
	unsigned int r_a0, r_a6, r_a7;
} history[MAX_HISTORY];

void dump_pc_history(void)
{
	int i, n;
	n = h;
	printf("pc history:\n");
	for (i = 0; i < MAX_HISTORY; i++) {
		printf("[%d] pc=%08x sim: sr=%04x a0=%08x a6=%08x a7=%08x rtl: sr=%04x a0=%08x a6=%08x a7=%08x; t=%lld\n",
		       n, history[n].pc,
		       history[n].s_sr, history[n].s_a0, history[n].s_a6, history[n].s_a7,
		       history[n].r_sr, history[n].r_a0, history[n].r_a6, history[n].r_a7,
		       history[n].t);
		n++;
		if (n >= MAX_HISTORY) n = 0;
	}

}

void save_pc_history(unsigned int pc,
		     unsigned int s_sr,
		     unsigned int s_a0, unsigned int s_a6, unsigned int s_a7,
		     unsigned int r_sr,
		     unsigned int r_a0, unsigned int r_a6, unsigned int r_a7,
		     unsigned long long t)
{
	history[h].pc = pc;
	history[h].s_sr = s_sr;
	history[h].s_a0 = s_a0;
	history[h].s_a6 = s_a6;
	history[h].s_a7 = s_a7;
	history[h].r_sr = r_sr;
	history[h].r_a0 = r_a0;
	history[h].r_a6 = r_a6;
	history[h].r_a7 = r_a7;
	history[h].t = t;
	h++;
	if (h >= MAX_HISTORY) h = 0;
}

volatile int _xxx;
void stoppoint(void)
{
	_xxx = 1;
}

static int has_init;
static int mismatch_count;
//static int rerun_count;
static int skip_sim;
static int old_sr;

void
cosim_m68k(Vff_verilator *top,
	   unsigned long long rtl_time,
	   int rtl_reset,
	   unsigned int rtl_pc,
	   unsigned int rtl_sr,
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
	   unsigned int rtl_ssp,
	   unsigned int rtl_usp)
{
	if (0) printf("cosim_m68k; time %lld; has_init=%d, rtl_reset=%d, rtl_pc=%x\n",
		      rtl_time, has_init, rtl_reset, rtl_pc);

	if (!has_init) {
		has_init = 1;
		_top = top;
		setup_context();
//		read_rom();
		copy_rom();
		init_nvram();
		m68k_init();
		m68k_reset();
		return;
	}

	if (rtl_reset == 0 && rtl_pc != 0) {
		int mismatch, trace;
		unsigned int sr, pc, d0, d1, d2, d3, d4, d5, d6, d7;
		unsigned int a0, a1, a2, a3, a4, a5, a6, a7, asp;

//		rerun_count = 0;
		check_interrupts();
//	rerun:
		if (!skip_sim) {
			if (0) printf("cosim_m68k; m68k_emulate before pc=%x\n", m68k_get_pc());
			m68k_emulate(1);
			if (0) printf("cosim_m68k; m68k_emulate after pc=%x\n", m68k_get_pc());
			if (m68k_get_cpu_state() == M68K_OK)
				;
			else {
				printf("cosim fame error %d (0x%x)\n",
				       m68k_get_cpu_state(), m68k_get_cpu_state());
				exit(1);
			}
		}
		skip_sim = 0;

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
		a7 = m68k_get_register(M68K_REG_A7);
		asp = m68k_get_register(M68K_REG_ASP);

//		if (rtl_pc != pc && rtl_sr != sr && rerun_count == 0) {
//			printf("sim: rerun (pc rtl %x sim %x, sr rtl %x sim %x)\n",
//			       rtl_pc, pc, rtl_sr, sr);
//			rerun_count++;
//			goto rerun;
//		}

		if (rtl_pc != pc && rtl_sr == sr && skip_sim == 0) {
			printf("sim: skip sim cycle (pc rtl %x sim %x, sr rtl %x sim %x)\n",
			       rtl_pc, pc, rtl_sr, sr);
			skip_sim = 1;
		}

		trace = 0;
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
		if (rtl_a2 != a2)
			mismatch |= 0x04;
		if (rtl_a3 != a3)
			mismatch |= 0x04;
		if (rtl_a4 != a4)
			mismatch |= 0x04;
		if (rtl_a5 != a5)
			mismatch |= 0x04;

/* sim timing on move to sr is off */
if (rtl_sr != 0x2000) {
	a6 = rtl_a6;
	a7 = rtl_ssp;
}

		if (rtl_a6 != a6)
			mismatch |= 0x04;

		if (rtl_sr & 0x2000) {
			if (rtl_ssp != a7)
				mismatch &= ~0x08;
		} else {
			if (rtl_usp != a7)
				mismatch &= ~0x08;
		}

		if (rtl_sr != sr)
			mismatch |= 0x10;

		if (rtl_sr == old_sr)
			mismatch &= ~0x10;
		old_sr = sr;

		if (mismatch & 1)
			printf("cosim mismatch: %llu: pc rtl %x, sim %x\n", rtl_time, rtl_pc, pc);
		if (mismatch & 2)
			printf("cosim mismatch: %llu: dreg\n", rtl_time);
		if (mismatch & 4)
			printf("cosim mismatch: %llu: areg\n", rtl_time);
		if (mismatch & 8)
			printf("cosim mismatch: %llu: ssp rtl %x, usp rtl %x, sim a7 %x sim asp %x\n",
			       rtl_time, rtl_ssp, rtl_usp, a7, asp);
		if (mismatch & 16)
			printf("cosim mismatch: %llu: sr rtl %x, sr sim %x (pc %x %x)\n",
			       rtl_time, rtl_sr, sr, rtl_pc, pc);

		/* */
		if (mismatch || trace) {
			printf("rtl: pc %x, sim pc %x\n", rtl_pc, pc);
			printf("rtl: sr %x, sim sr %x\n", rtl_sr, sr);
			printf("rtl: d0 %08x d1 %08x d2 %08x d3 %08x d4 %08x d5 %08x d6 %08x d7 %08x\n",
			       rtl_d0, rtl_d1, rtl_d2, rtl_d3, rtl_d4, rtl_d5, rtl_d6, rtl_d7);
			printf("sim: d0 %08x d1 %08x d2 %08x d3 %08x d4 %08x d5 %08x d6 %08x d7 %08x\n",
			       d0, d1, d2, d3, d4, d5, d6, d7);
			printf("\n");
			printf("rtl: a0 %08x a1 %08x a2 %08x a3 %08x a4 %08x a5 %08x a6 %08x ssp %08x usp %08x\n",
			       rtl_a0, rtl_a1, rtl_a2, rtl_a3, rtl_a4, rtl_a5, rtl_a6, rtl_ssp, rtl_usp);
			printf("sim: a0 %08x a1 %08x a2 %08x a3 %08x a4 %08x a5 %08x a6 %08x a7 %08x asp %08x\n",
			       a0, a1, a2, a3, a4, a5, a6, a7, asp);
			printf("----\n");
		}

		/* */
		if ((mismatch & 16) &&
		    (rtl_sr & 0x2700) == (sr & 0x2700))
			mismatch &= ~0x10;

		if (mismatch) {
			mismatch_count++;
			if (mismatch_count > 3) {
				dump_pc_history();
				exit(2);
			}
		} else
			mismatch_count = 0;

		save_pc_history(pc,
				sr, a0, a6, a7,
				rtl_sr, rtl_a0, rtl_a6, rtl_ssp,
				rtl_time);

		if (pc == 0xf6) stoppoint();
	}
}

}
