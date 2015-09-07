/*
 * simple m68k disassembler
 * main for executable version
 */

#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <stdlib.h>
#include "dis2.h"


unsigned char buffer[64*1024];

unsigned get16(u16 *p)
{
	unsigned v;
	unsigned char *pp = (unsigned char *)p;
	v = (pp[0] << 8) | pp[1];
	return v;
}

unsigned get32(void *p)
{
	unsigned v;
	unsigned char *pp = (unsigned char *)p;
	v = (pp[0] << 24) | (pp[1] << 16) | (pp[2] << 8) | pp[3];
	return v;
}

main(int argc, char *argv[])
{
	char code[80];
	void *p;
	int f, r;
	long adr, max_addr;

	if (argc != 2)
		exit(1);

	max_addr = 0x10e00;

	/* read binary 68k code from 1st arg */
	f = open(argv[1], O_RDONLY);
	if (f <= 0) {
		perror(argv[1]);
		exit(1);
	}
	r = read(f, buffer, sizeof(buffer));
	close(f);

	dis2_init();

	p = (void *)buffer;
	adr = 0;
	do {
		adr = (char *)p - (char *)buffer;

		printf("[%08lx %08x] ", adr, get32(p));
		if (adr < 0x8c) {
			printf("%08lx .short 0x%04x\n", adr, get16(p));
			p = (void *)( (char *)p + 2 );
			continue;
		}

		code[0] = 0;
		p = dis2(p,adr,code);
		
		/* print out code */
		printf("%s\n",code);
	} while (p != NULL && adr < max_addr);
}

