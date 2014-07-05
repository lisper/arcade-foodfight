#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

unsigned char roms[8][8192];

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
	int i, j, a;
	int hex, bin;

	hex = 1;
	bin = 0;

	if (argv[1][0] == '-') {
		if (argv[1][1] == 'h') {
			hex = 1;
			bin = 0;
		}
		if (argv[1][1] == 'b') {
			hex = 0;
			bin = 1;
		}
		argv++;
	}

	for (i = 0; i < 8; i++) {
		read_rom(i, argv[1+i]);
	}

	if (hex) {
		a = 0;
		for (i = 0; i < 8; i += 2) {
			for (j = 0; j < 8192; j++) {
				printf("%08x: %02x%02x\n",
				       a, roms[i][j], roms[i+1][j]);
				a++;
			}
		}
	}

	if (bin) {
		for (i = 0; i < 8; i += 2) {
			for (j = 0; j < 8192; j++) {
				unsigned char bb[2];
				bb[0] = roms[i][j];
				bb[1] = roms[i+1][j];
				write(1, bb, 2);
			}
		}
	}

	exit(0);
}
