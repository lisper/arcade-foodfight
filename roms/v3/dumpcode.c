#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

unsigned char b[8192];

main(int argc, char *argv[])
{
	int i, fn, f, r;
	char *name;
	char what[256];

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

	exit(0);
}
