#

# in order for making hex or bin file of code
CODE_ROMS_HEX = \
	136020-302.9c 136020-301.8c \
	136020-204.9d 136020-303.8d \
	136020-306.9e 136020-305.8e \
	136020-208.9f 136020-307.8f

# in order for making .v init
CODE_ROMS_V = \
	136020-301.8c 136020-303.8d 136020-305.8e 136020-307.8f \
	136020-302.9c 136020-204.9d 136020-306.9e 136020-208.9f 

PF_ROM_V = 136020-109.6lm

STAMP_ROMS_V = \
	136020-111.4d 136020-110.4e

all: rom_2p.v rom_6lm.v rom_4d4e.v rom_code.v rom_89.hex rom_89.bin Makefile

rom_2p.v: dump2p
	./dump2p <136020-112.2p >$@

rom_89.hex: dump89hex
	./dump89hex -h $(CODE_ROMS_HEX) >$@

rom_89.bin: dump89hex
	./dump89hex -b $(CODE_ROMS_HEX) >$@

rom_6lm.v: dump6lm
	./dump6lm <136020-109.6lm >$@

rom_code.v: dumpcode
	./dumpcode $(CODE_ROMS_V) >$@

rom_4d4e.v: dump4d4e
	./dump4d4e $(STAMP_ROMS_V) >$@

clean:
	rm -f dumpcode dump6lm dump2p dump89hex dump4d4e
	rm -f rom_89.hex rom_89.bin rom_2p.v rom_6lm.v rom_4d4e.v
