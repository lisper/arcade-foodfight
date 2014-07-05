main()
{
	int v, n, p, pp;

	p = 8;
	pp = (0xff - p - 16) & 0xff;

	printf("p=%x pp=%x match=%d\n",
	       p, pp,( (v + p) & 0xf0) == 0xf0 ? 1 : 0);

	for (n = 0; n < 32; n++) {
//		p = -(n+1);
		p = 255 - n;
		pp = (0xff - (n&0xff) - 16) & 0xff;
		printf("n=%d p=%x pp=%x match=%d\n",
		       n, p, pp,( (n + p) & 0xf0) == 0xf0 ? 1 : 0);
	}
	
//	for (v = 0; v < 256; v++) {
//		printf("v=%x p=%x pp=%x match=%d\n",
//		       v, p, pp,( (v + p) & 0xf0) == 0xf0 ? 1 : 0);
//	}
}
