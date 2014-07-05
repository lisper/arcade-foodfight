#include <stdio.h>
#include <stdlib.h>

unsigned char b[8192];

main()
{
	int i;
	char *bs;

	printf("initial begin\n");
	printf("\t// foodfight 136020-109.6lm\n");

	read(0, b, 8192);
	for (i = 0; i < 8192; i++) {
		printf("\trom[%d] = 8'h%02x; // 0x%04x\n", i, b[i], i);
	}

	printf("end\n");

	exit(0);
}
