#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

#include <signal.h>
#include <SDL/SDL.h>

extern unsigned char nvram[];
extern unsigned char pf[0x800];
extern unsigned char color[0x400];
extern unsigned char stamp[256];
extern unsigned char sctrl;
extern unsigned char stamp_rom[2][8192];
extern unsigned char pf_rom[8192];

static SDL_Surface *screen;

int screen_rows;
int screen_cols;

int screen_delta;

void poke_color(void)
{
	screen_delta |= 4;
}

int pf_pokes;
void poke_pf(void)
{
	pf_pokes++;
	if (pf_pokes > 1000) {
		screen_delta |= 2;
	}
}

void poke_stamp(void)
{
	screen_delta |= 1;
}

int video_init(void)
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
}

static void
video_clear(void)
{
	unsigned char *ps;
	ps = (unsigned char *)screen->pixels;
	memset(ps, 0, screen_cols*screen_rows);
        SDL_UpdateRect(screen, 0, 0, screen_cols, screen_rows);
}

static void inline
set_pixel_nu(int h, int v, int rgb8)
{
	unsigned char *ps;
	int offset;

	ps = (unsigned char *)screen->pixels;

	offset = (v * screen_cols) + h;
        ps[offset] = (unsigned char)rgb8;
}

static void
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

void
display_stamp(int s, int h, int v, int pri)
{
	int hh, vv, offset, base, rgb8, c;
	unsigned char b0, b1, p;

	h *= 2;
	v *= 2;

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
			if (pri & 0) {
				set_pixel_nu(h+(hh*2),   v+(vv*2),   rgb8);
				set_pixel_nu(h+(hh*2),   v+(vv*2)+1, rgb8);
				set_pixel_nu(h+(hh*2)+1, v+(vv*2),   rgb8);
				set_pixel_nu(h+(hh*2)+1, v+(vv*2)+1, rgb8);
			} else {
				if (rgb8) set_pixel_nu(h+(hh*2),   v+(vv*2),   rgb8);
				if (rgb8) set_pixel_nu(h+(hh*2),   v+(vv*2)+1, rgb8);
				if (rgb8) set_pixel_nu(h+(hh*2)+1, v+(vv*2),   rgb8);
				if (rgb8) set_pixel_nu(h+(hh*2)+1, v+(vv*2)+1, rgb8);
			}
		}
	}

        SDL_UpdateRect(screen, h, v, 32, 32);
}

int
display_stamps(void)
{
	int v, h, s, c;
	int roff, coff;

	roff = 3;
	coff = 3;

	v = roff;
	h = coff;
	c = 0;
	for (s = 0; s < 256; s++) {
		display_stamp(s, h, v, 1);
		h += 16*2 + 1;
		if (++c >= 16) {
			c = 0;
			h = coff;
			v += 16*2 + 1;
		}
	}

	return 0;
}

void video_update_stamps(void)
{
	int i, rvpos, rhpos;
	unsigned char b0, b1, b2, b3;
	unsigned char stampnum, hflip, vflip, prio, color, vpos, hpos;

	if (0) printf("-----\n");

	/* format of stamp sram */
	for (i = 63; i >= 0; i--) {
		b0 = stamp[i*4 + 0];
		b1 = stamp[i*4 + 1];
		b2 = stamp[i*4 + 2];
		b3 = stamp[i*4 + 3];

		hflip    = (b0 & 0x80) ? 1 : 0;
		vflip    = (b0 & 0x40) ? 1 : 0;
		prio     = (b0 & 0x20) ? 1 : 0;
		color    = b0 & 0x1f;
		stampnum = b1;
		hpos     = b2;
		vpos     = b3;

		rvpos = (0xff - vpos - 16) & 0xff;
		rhpos = hpos;

		if (stampnum != 0) {
			if (0) printf("stamp %d: %02x%02x%02x%02x stamp=%d flip=%d%d c=%d (%d,%d)\n",
				      i, b0, b1, b2, b3,
				      stampnum, hflip, vflip, color, hpos, vpos);

			display_stamp(stampnum, rhpos, rvpos, prio);
		}

	}
}

void display_pf_tile(int tile, int color, int h, int v, int hflip, int vflip)
{
	int hh, vv, offset, base, rgb8, c;
	unsigned char b, p;

	h *= 2;
	v *= 2;

	// 0,0 8,8
	base = tile * 16;
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

			set_pixel_nu(h+(hh*2),   v+(vv*2),   rgb8);
			set_pixel_nu(h+(hh*2),   v+(vv*2)+1, rgb8);
			set_pixel_nu(h+(hh*2)+1, v+(vv*2),   rgb8);
			set_pixel_nu(h+(hh*2)+1, v+(vv*2)+1, rgb8);
		}
	}

        SDL_UpdateRect(screen, h, v, 16, 16);
}

void video_update_pf(void)
{
	int h, v;
	unsigned char b0, b1;
	int tile, color, offset;
	for (v = 0; v < 32; v++) {
		for (h = 0; h < 32; h++) {
			// 1    1
			// 2631 2631
			// 8426884268
			// hhhhhvvvvv
			offset = (h*32+(v&0x1f))*2;
if (offset > 0x800) { printf("pf: offset %x\n", offset); exit(1); }
			b0 = pf[offset+0];
			b1 = pf[offset+1];

			tile = b1 | ((b0 & 0x80) ? 0x100 : 0);
			color = b0 & 0x7f;

			display_pf_tile(tile, color, h*8, v*8, 0, 0);
		}
	}
}

void video_update_color(void)
{
}

static unsigned long long d;

void video_poll(void)
{
	d++;
	if (d < 1000000) return;
	d = 0;

	if (screen_delta) {
		video_clear();
		video_update_color();
		video_update_pf();
		video_update_stamps();

		screen_delta = 0;
	}
}
