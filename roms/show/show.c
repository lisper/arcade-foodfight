#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

#include <signal.h>
#include <SDL/SDL.h>

extern char *optarg;

static SDL_Surface *screen;
char *stamp_rom_filename[2];
char *pf_rom_filename;
char *pf_map_filename;

int screen_rows;
int screen_cols;

int debug;

unsigned char stamp_rom[2][8192];
unsigned char pf_rom[8192];

int
read_stamp_rom(int index, char *fn)
{
	int f, r;
	f = open(fn, O_RDONLY);
	if (f <= 0) {
		perror(fn);
		exit(2);
	}

	r = read(f, stamp_rom[index], 8192);
	if (r != 8192) {
		perror(fn);
		exit(1);
	}
	close(f);
	return 0;
}

int
read_pf_rom(char *fn)
{
	int f, r;

	f = open(fn, O_RDONLY);
	if (f <= 0) {
		perror(fn);
		exit(2);
	}

	r = read(f, pf_rom, 8192);
	if (r != 8192) {
		perror(fn);
		exit(1);
	}
	close(f);
	return 0;
}

int
read_roms(void)
{
	if (read_stamp_rom(0, stamp_rom_filename[0]))
		return -1;

	if (read_stamp_rom(1, stamp_rom_filename[1]))
		return -1;

	if (read_pf_rom(pf_rom_filename))
		return -1;

	return 0;
}

int
init_display(void)
{
	int flags;

	screen_rows = 20 + 16*16*2 /*256*2*/;
	screen_cols = 20 + 16*16*2 /*256*2*/;

	flags = SDL_INIT_VIDEO | SDL_INIT_NOPARACHUTE;
	if (SDL_Init(flags)) {
		printf("SDL initialization failed\n");
		return -1;
	}

	/* NOTE: we still want Ctrl-C to work - undo the SDL redirections*/
	signal(SIGINT, SIG_DFL);
	signal(SIGQUIT, SIG_DFL);

	flags = SDL_HWSURFACE|SDL_ASYNCBLIT|SDL_HWACCEL;
	screen = SDL_SetVideoMode(screen_cols, screen_rows, 8, flags);

	if (!screen) {
		printf("Could not open SDL display\n");
		return -1;
	}

	SDL_WM_SetCaption("Stamps/PF", "Stamps/PF");

	printf("sdl: bpp %d, R <<%d,%x G <<%d,%x B <<%d,%x; pitch %d\n",
	       screen->format->BitsPerPixel,
	       screen->format->Rshift,
	       screen->format->Rmask,
	       screen->format->Gshift,
	       screen->format->Gmask,
	       screen->format->Bshift,
	       screen->format->Bmask,
	       screen->pitch);

	return 0;
}

void
set_pixel(int h, int v, int rgb8)
{
	unsigned char *ps;
	int offset;

	ps = (unsigned char *)screen->pixels;

	offset = (v * screen_cols) + h;
        ps[offset] = (unsigned char)rgb8;
        SDL_UpdateRect(screen, h, v, 1, 1);
}

int
rgb(int r, int g, int b)
{
	return
		((r & 7) << 5) |
		((g & 7) << 2) |
		((b & 3) << 0) |
		0;
}

int
rgb256(int r, int g, int b)
{
	return SDL_MapRGB(screen->format, r, g, b);
}

void
color_bars(void)
{
	int h, v, rgb8;

	v = 0;
	rgb8 = rgb(7, 0, 0);
//rgb8 = rgb256(255, 0, 0);
	if (debug) printf("rgb8 %x\n", rgb8);
	for (h = 0; h < screen_cols; h++) {
		set_pixel(h, v, rgb8);
		set_pixel(h, v+1, rgb8);
		set_pixel(h, v+2, rgb8);
	}

	v = 3;
	rgb8 = rgb(0, 7, 0);
//rgb8 = rgb256(0, 255, 0);
	if (debug) printf("rgb8 %x\n", rgb8);
	for (h = 0; h < screen_cols; h++) {
		set_pixel(h, v, rgb8);
		set_pixel(h, v+1, rgb8);
		set_pixel(h, v+2, rgb8);
	}

	v = 6;
	rgb8 = rgb(0, 0, 7);
//rgb8 = rgb256(0, 0, 255);
	if (debug) printf("rgb8 %x\n", rgb8);
	for (h = 0; h < screen_cols; h++) {
		set_pixel(h, v, rgb8);
		set_pixel(h, v+1, rgb8);
		set_pixel(h, v+2, rgb8);
	}

	SDL_UpdateRect(screen, 0, 0, screen_cols, screen_rows);
}

void
display_stamp(int s, int h, int v)
{
	int hh, vv, offset, base, rgb8, c;
	unsigned char b0, b1, p;


	// 0,0 16,16
	base = s * 32;
	for (vv = 0; vv < 16; vv++) {

		for (hh = 0; hh < 16; hh++) {
			if (hh == 0) {
				offset = base + vv + 16;
				b0 = stamp_rom[0][offset];
				b1 = stamp_rom[1][offset];
			}
			if (hh == 8) {
				offset = base + vv;
				b0 = stamp_rom[0][offset];
				b1 = stamp_rom[1][offset];
			}

			if (0) {
				p = ((b0 & 1) << 1) | (b1 & 1);
				b0 >>= 1;
				b1 >>= 1;
			} else {
				p = (((b0 & 0x80) ? 1 : 0) << 1) | ((b1 & 0x80) ? 1 : 0);
				b0 <<= 1;
				b1 <<= 1;
			}

			c = p * 2;
			rgb8 = rgb(c, c, c);
			set_pixel(h+(hh*2),   v+(vv*2),   rgb8);
			set_pixel(h+(hh*2),   v+(vv*2)+1, rgb8);
			set_pixel(h+(hh*2)+1, v+(vv*2),   rgb8);
			set_pixel(h+(hh*2)+1, v+(vv*2)+1, rgb8);
		}
	}
}

void
grid(void)
{
	int h, v, c;
	int rows, cols, roff, coff;

	rows = 17+16*16*2;
	cols = 17+16*16*2;

	roff = 2;
	coff = 2;

	c = rgb(7, 7, 7);
	for (v = roff; v < rows+roff; v += 16*2+1) {
		for (h = coff; h < cols+coff; h++) {
			set_pixel(h, v, c);
		}
	}

	for (h = coff; h < cols+coff; h += 16*2+1) {
		for (v = roff; v < rows+roff; v++) {
			set_pixel(h, v, c);
		}
	}
}


int
display_stamps(void)
{
	int v, h, s, c;
	int roff, coff;

	color_bars();
	grid();
//while (1) sleep(1);

	roff = 3;
	coff = 3;

	v = roff;
	h = coff;
	c = 0;
	for (s = 0; s < 256; s++) {
		display_stamp(s, h, v);
		h += 16*2 + 1;
		if (++c >= 16) {
			c = 0;
			h = coff;
			v += 16*2 + 1;
		}
	}

	return 0;
}


void display_pf_tile(int tile, int color, int h, int v, int hflip, int vflip)
{
	int hh, vv, offset, base, rgb8, c;
	unsigned char b, p;

	h *= 2;
	v *= 2;

	// 0,0 8,8
	base = (tile * 16);
	for (vv = 0; vv < 8; vv++) {

		offset = base + vv;
		for (hh = 0; hh < 8; hh++) {
			if ((hh == 0 && hflip) || (hh == 4 && !hflip)) {
				b = pf_rom[offset];
			}
			if ((hh == 4 && hflip) || (hh == 0 && !hflip)) {
				b = pf_rom[offset+8];
			}

			// 76543210
			if (hflip == 0) {
				p = ((b & 0x80) >> 6) | ((b & 0x08) >> 3);
				b <<= 1;
			} else {
				p = ((b & 0x10) >> 3) | (b & 1);
				b >>= 1;
			}

			c = p * 2;
			rgb8 = rgb(c, c, c);

			set_pixel(h+(hh*2),   v+(vv*2),   rgb8);
			set_pixel(h+(hh*2),   v+(vv*2)+1, rgb8);
			set_pixel(h+(hh*2)+1, v+(vv*2),   rgb8);
			set_pixel(h+(hh*2)+1, v+(vv*2)+1, rgb8);
		}
	}
}

int
display_pf(void)
{
	int h, v;
	unsigned char b0, b1;
	int tile, color, offset;
	tile = 0;
	for (v = 0; v < 32; v++) {
tile = 0x40;
		for (h = 0; h < 64; h++) {
			color = 1;
			display_pf_tile(tile, color, h*8, v*8, v & 1, 0);

			tile++;
			if (tile > 511)
				tile = 0;
		}
//		if (v == 1) break;
	}
}

void
fatal(void)
{
	exit(1);
}

main(int argc, char *arv[])
{
	int c;

	stamp_rom_filename[0] = "../v3/136020-111.4d";
	stamp_rom_filename[1] = "../v3/136020-110.4e";
	pf_rom_filename = "../v3/136020-109.6lm";
	pf_map_filename = "pfmap.txt";

	while ((c = getopt(argc, argc)) != -1) {
		switch (c) {
		case 'd':
			debug++;
			break;
		case 's':
			break;

		}
	}

	if (read_roms())
		fatal();

	if (init_display())
		fatal();

	if (0)
	if (display_stamps())
		fatal();

	if (display_pf())
		fatal;

	while (1) {
		sleep(1);
	}

	exit(0);
}
