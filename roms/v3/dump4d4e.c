#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

unsigned char roms[2][8192];

int
read_rom(int index, char *fn)
{
	int f, r;
	f = open(fn, O_RDONLY);
	if (f <= 0) {
		perror(fn);
		exit(2);
	}

	r = read(f, roms[index], 8192);
	if (r != 8192) {
		perror(fn);
		exit(1);
	}
	close(f);
	return 0;
}

main(int argc, char *argv[])
{
	int i;
	char *bs;

	if (argc > 1 && argv[1][0] == '-' && argv[1][1] == 'a') {
		// for xst
		for (i = 0; i < 2; i++) {
			read_rom(i, argv[2+i]);
		}
		printf("initial begin\n");

		printf("\t// foodfight %s\n", argv[2]);
		for (i = 0; i < 8192; i++) {
			printf("\tromh[%d] = 8'h%02x; // 0x%04x\n", i, roms[1][i], i);
		}

		printf("\t// foodfight %s\n", argv[3]);
		for (i = 0; i < 8192; i++) {
			printf("\troml[%d] = 8'h%02x; // 0x%04x\n", i, roms[0][i], i);
		}

		printf("end\n");
	} else {
		// this works in sim, but xst barfs
		printf("initial begin\n");
		printf("\t// foodfight %s %s\n", argv[1], argv[2]);

		for (i = 0; i < 2; i++) {
			read_rom(i, argv[1+i]);
		}

		for (i = 0; i < 8192; i++) {
			printf("\tchip_4d.rom[%d] = 8'h%02x; // 0x%04x\n", i, roms[0][i], i);
		}

		for (i = 0; i < 8192; i++) {
			printf("\tchip_4e.rom[%d] = 8'h%02x; // 0x%04x\n", i, roms[1][i], i);
		}

		printf("end\n");
	}

	exit(0);
}
