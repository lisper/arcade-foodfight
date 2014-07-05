/******************************************************************************/
/* Simple example program to illustrate FAME usage                            */
/* Oscar Orallo Pelaez                                                        */
/* Date: 02/23/2003                                                           */
/* Updated: 03/14/2006                                                        */
/******************************************************************************/

#ifdef _arch_dreamcast
	#include <kos.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include "fame.h"


/* Custom memory handling */
#define MEM_HANDLING

/* Far enough memory room */
#define RAM_SIZE 2000

unsigned char ram[RAM_SIZE];
unsigned long fsize;

#ifdef _arch_dreamcast
	extern uint8 romdisk[];
	KOS_INIT_FLAGS(INIT_DEFAULT|INIT_MALLOCSTATS);
	KOS_INIT_ROMDISK(romdisk);
#endif

/* Calculates file size */
long filesize(FILE *stream) 
{
	long curpos, length;

	curpos = ftell(stream);
	fseek(stream, 0L, SEEK_END);
	length = ftell(stream);
	fseek(stream, curpos, SEEK_SET);
	return length;
}

/* Performs byte swapping */
void byte_swapping(unsigned char *ram) 
{
	unsigned char aux;
	unsigned long i;

	for(i=0; i<fsize-1; i+=2)
	{
        	aux = ram[i];
        	ram[i] = ram[i+1];
        	ram[i+1] = aux;
	}
}

/* Shows the CPU internal state */
void show_cpu_state(void) 
{
	int sr;

	printf("PC:%08X\n",m68k_get_pc());
	printf("D0:%08X ",m68k_get_register(M68K_REG_D0));
	printf("D1:%08X ",m68k_get_register(M68K_REG_D1));
	printf("D2:%08X ",m68k_get_register(M68K_REG_D2));
	printf("D3:%08X\n",m68k_get_register(M68K_REG_D3));
	printf("D4:%08X ",m68k_get_register(M68K_REG_D4));
	printf("D5:%08X ",m68k_get_register(M68K_REG_D5));
	printf("D6:%08X ",m68k_get_register(M68K_REG_D6));
	printf("D7:%08X\n",m68k_get_register(M68K_REG_D7));
	printf("A0:%08X ",m68k_get_register(M68K_REG_A0));
	printf("A1:%08X ",m68k_get_register(M68K_REG_A1));
	printf("A2:%08X ",m68k_get_register(M68K_REG_A2));
	printf("A3:%08X\n",m68k_get_register(M68K_REG_A3));
	printf("A4:%08X ",m68k_get_register(M68K_REG_A4));
	printf("A5:%08X ",m68k_get_register(M68K_REG_A5));
	printf("A6:%08X ",m68k_get_register(M68K_REG_A6));
	printf("A7:%08X\n",m68k_get_register(M68K_REG_A7));
	printf("SR:%04X  ",(sr = m68k_get_register(M68K_REG_SR)));
	printf("Flags: %c%c%c%c%c\n",
		(sr >> 4) & 1 ? 'X' : '-',
		(sr >> 3) & 1 ? 'N' : '-',
		(sr >> 2) & 1 ? 'Z' : '-',
		(sr >> 1) & 1 ? 'V' : '-',
		(sr     ) & 1 ? 'C' : '-'
	);
}

#ifdef MEM_HANDLING

int read_byte(int addr)
{
	printf("\nReading byte 0x%02X from 0x%08X...\n",ram[addr],addr);
	return ram[addr^1];
}

int read_word(int addr)
{
	printf("\nReading word 0x%04X from 0x%08X...\n",((unsigned short *)ram)[addr<<1],addr);
	return ((unsigned short *)ram)[addr>>1];
}

void write_byte(int addr, int data) 
{
	printf("\nWritting byte 0x%02X at 0x%08X...\n",data,addr);
	ram[addr^1] = data;
}

void write_word(int addr, int data)
{
	printf("\nWritting word 0x%04X at 0x%08X\n",data,addr);
	((unsigned short *)ram)[addr>>1] = data;
}

#endif



/* Entry point */
int main() 
{
	struct M68K_CONTEXT mc68k_contxt;
	FILE *fp;

	printf("-------------------------\n");
	printf("FAME demostration program\n");
	printf("-------------------------\n");

	/* Memory map definition for program access */
	struct M68K_PROGRAM p68ks[] = 
	{
		{0x000000,0x03FFFF,(unsigned)ram - 0x000000},
		{-1,-1,(unsigned)NULL}
	};


	/* Memory map definition for data access */
#ifdef MEM_HANDLING

	printf("Initializing custom memory handlers...\n");

	/* Memory map definitions with memory handlers */
	struct M68K_DATA d68ks_rb[] = 
	{
		{0x000000,0x03FFFF,read_byte,NULL},
		{-1,-1,NULL}
	};

	struct M68K_DATA d68ks_rw[] = 
	{
		{0x000000,0x03FFFF,read_word,NULL},
		{-1,-1,NULL}
	};
	struct M68K_DATA d68ks_wb[] = 
	{
		{0x000000,0x03FFFF,write_byte,NULL},
		{-1,-1,NULL}
	};
	struct M68K_DATA d68ks_ww[] = 
	{
		{0x000000,0x03FFFF,write_word,NULL},
		{-1,-1,NULL}
	};

#else

	printf("Initializing built-in memory handlers...\n");

	/* Memory map definition with built-in memory handlers */
	struct M68K_DATA d68ks[] = 
	{
		{0x000000,0x03FFFF,NULL,(void *)ram - 0x000000},
		{-1,-1,NULL}
	};

#endif

	/* Setting up memory maps in CPU context */
	memset(&mc68k_contxt,0,sizeof(mc68k_contxt));
	mc68k_contxt.sv_fetch = p68ks;
	mc68k_contxt.user_fetch = p68ks;

#ifdef MEM_HANDLING
	mc68k_contxt.sv_read_byte  = d68ks_rb;
	mc68k_contxt.user_read_byte  = d68ks_rb;
	mc68k_contxt.sv_read_word  = d68ks_rw;
	mc68k_contxt.user_read_word  = d68ks_rw;
	mc68k_contxt.sv_write_byte = d68ks_wb;
	mc68k_contxt.user_write_byte = d68ks_wb;
	mc68k_contxt.sv_write_word = d68ks_ww;
	mc68k_contxt.user_write_word = d68ks_ww;
#else
	mc68k_contxt.sv_read_byte  = d68ks;
	mc68k_contxt.user_read_byte  = d68ks;
	mc68k_contxt.sv_read_word  = d68ks;
	mc68k_contxt.user_read_word  = d68ks;
	mc68k_contxt.sv_write_byte = d68ks;
	mc68k_contxt.user_write_byte = d68ks;
	mc68k_contxt.sv_write_word = d68ks;
	mc68k_contxt.user_write_word = d68ks;
#endif

	/* Opening the object file */
#ifdef _arch_dreamcast
	fp = fopen("/rd/bubble.bin","rb");
#else
	fp = fopen("./romdisk/bubble.bin","rb");
#endif
	if (fp == NULL) 
	{
		fprintf(stderr,"ERROR: Unable to open input file\n");
		exit(EXIT_FAILURE);
	}

	fsize = filesize(fp);
	fread(ram,1,fsize,fp);
	fclose(fp);
	byte_swapping(ram);

	/* Setting CPU context */
	m68k_set_context(&mc68k_contxt);

	printf("Initializing FAME and resetting processor... ");

	/* Initializing FAME */
	m68k_init();
    
	/* Resetting the CPU */
	if (m68k_reset() == M68K_OK)
		printf("OK\n");
	else
	{
		printf("ERROR!\n");
		exit(EXIT_FAILURE);
	}

	/* Executing and printing information */
	do
	{
		printf("\nExecuting one CPU instruction... ");
		m68k_emulate(1);
		
		if (m68k_get_cpu_state() == M68K_OK)
			printf("OK\n");
		else
		{
			printf("ERROR!\n");
			exit(EXIT_FAILURE);
		}
		show_cpu_state();
		puts("");
		puts("Press 'q' to exit, any other key to continue");
	} while(getchar() != 'q');

	return 0;
}

