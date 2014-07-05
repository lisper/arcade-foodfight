main()
{
	int i;
	int v1, v2;
	v1 = 0x39;
	v2 = 0x40;
	for (i = 0; i < 1024; i++) {
		v2 = i & 255;
		printf("pf %x %x %x\n", i, v1, v2);
	}
}
