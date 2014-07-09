
all:
	cd roms && make
	cd emu && make
	cd verilator && ./verilator.sh

