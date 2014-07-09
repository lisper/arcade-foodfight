#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>

unsigned char b[8192];
unsigned char roms[8][8192];
char *fnames[8];

main(int argc, char *argv[])
{
	int i, fn, f, r;
	char *name;
	char what[256];

	if (argc > 1 && argv[1][0] == '-' && argv[1][1] == 'a') {
		// for xst
		for (fn = 0; fn < 8; fn++) {
			name = argv[2+fn];
			fnames[fn] = strdup(name);
			f = open(name, O_RDONLY);
			if (f <= 0) {
				perror(name);
				exit(2);
			}

			r = read(f, roms[fn], 8192);
			if (r != 8192) {
				perror(name);
				exit(3);
			}
			close(f);
		}

		printf("initial begin\n");

		for (r = 0; r < 4; r++) {
			printf("\t// foodfight code %s\n", fnames[r]);
			sprintf(what, "rom%dl", r);
			for (i = 0; i < 8192; i++) {
				printf("\t%s[%d] = 8'h%02x; // 0x%04x\n", what, i, roms[r][i], i);
			}
		}

		for (r = 4; r < 8; r++) {
			printf("\t// foodfight code %s\n", fnames[r]);
			sprintf(what, "rom%dh", r-4);
			for (i = 0; i < 8192; i++) {
				printf("\t%s[%d] = 8'h%02x; // 0x%04x\n", what, i, roms[r][i], i);
			}
		}

		printf("end\n");
	} else {
		// this works in sim, but xst barfs
		printf("initial begin\n");
		for (fn = 0; fn < 8; fn++) {
			name = argv[1+fn];
			f = open(name, O_RDONLY);
			if (f <= 0) {
				perror(name);
				exit(2);
			}

			r = read(f, b, 8192);
			if (r != 8192) {
				perror(name);
				exit(3);
			}
			close(f);

			printf("\t// foodfight code %s\n", name);
			if (fn < 4)
				sprintf(what, "coderom_l.rom%d", fn);
			else
				sprintf(what, "coderom_h.rom%d", fn-4);

			for (i = 0; i < 8192; i++) {
				printf("\t%s[%d] = 8'h%02x; // 0x%04x\n", what, i, b[i], i);
			}
		}

		printf("end\n");
	}

	exit(0);
}
