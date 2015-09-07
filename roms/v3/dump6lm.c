#include <stdio.h>
#include <stdlib.h>

unsigned char b[8192];

main(int argc, char *argv[])
{
	int i;
	char *bs;

	if (argc > 1 && argv[1][0] == '-' && argv[1][1] == 'c') {
		// case
		read(0, b, 8192);

		printf("  // foodfight 136020-109.6lm\n");
		printf("  case (a)\n");
		for (i = 0; i < 8192; i++) {
			printf("\t13'h%04x: q = 8'h%02x; // 0x%04x\n", i, b[i], i);
		}
		printf("  endcase\n");
	} else {
		// initial block
		printf("initial begin\n");
		printf("\t// foodfight 136020-109.6lm\n");

		read(0, b, 8192);
		for (i = 0; i < 8192; i++) {
			printf("\trom[%d] = 8'h%02x; // 0x%04x\n", i, b[i], i);
		}
		
		printf("end\n");
	}

	exit(0);
}
