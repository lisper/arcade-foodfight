#
#
#

#V = verilator
V = /usr/local/bin/verilator

TOP = --top-module ff_verilator
RTL = ../rtl
CPU = ../m68k
ROM = ../roms/v3
INC = +incdir+$(RTL) +incdir+$(CPU) +incdir+$(ROM)

DEFINE = +define+debug=1
LDFLAGS = "-L../../emu/fame/x86/linux -lSDL -lpthread -lfame"
EXE = ./tmp/Vff_verilator

SRC = \
	ff_verilator.v \
	$(RTL)/ff.v $(RTL)/ff_top.v $(RTL)/m68000.v $(RTL)/pokey.v $(RTL)/pal.v $(RTL)/prom_2b.v \
	$(RTL)/coderom16.v $(RTL)/coderam.v $(RTL)/ram_907036.v $(RTL)/rom_6lm.v $(RTL)/ram_137250.v \
	$(RTL)/nvram.v $(RTL)/rom_136020_16.v $(RTL)/ram_93422.v \
	ff_verilator.cpp cosim.cpp vga.cpp

VOUT = tmp/Vff_verilator.cpp

all: $(EXE)

$(VOUT): $(SRC)
	$V -cc -LDFLAGS $(LDFLAGS) -exe --trace --Mdir ./tmp $(DEFINE) $(INC) $(TOP) -CFLAGS -DCOSIM=1 $(SRC)

$(EXE): $(VOUT)
	(cd tmp; make OPT="-fauto-inc-dec -fdce -fdefer-pop -fdse -ftree-ccp -ftree-ch -ftree-fre -ftree-dce -ftree-dse" -f Vff_verilator.mk)

fast:
	(cd tmp; rm -f *.o ; make OPT="-fcompare-elim -fcprop-registers -fguess-branch-probability -fauto-inc-dec -fif-conversion2 -fif-conversion -fipa-pure-const -fdce -fipa-profile -fipa-reference -fmerge-constants -fsplit-wide-types -fdefer-pop -fdse -ftree-ccp -ftree-ch -ftree-fre -ftree-dce -ftree-dse -ftree-builtin-call-dce -ftree-copyrename -ftree-dominator-opts -ftree-forwprop -ftree-phiprop -ftree-sra -ftree-pta -ftree-ter -funit-at-a-time -ftree-bit-ccp -falign-functions  -falign-jumps -falign-loops  -falign-labels -fcaller-saves -fcrossjumping -fcse-follow-jumps -fcse-skip-blocks -fdelete-null-pointer-checks -fdevirtualize -fexpensive-optimizations -fgcse  -fgcse-lm -finline-small-functions -findirect-inlining -fipa-sra -foptimize-sibling-calls -fpartial-inlining -fpeephole2 -fregmove -freorder-blocks  -freorder-functions -frerun-cse-after-loop -fsched-interblock  -fsched-spec -fschedule-insns -fschedule-insns2 -fstrict-aliasing -fstrict-overflow -ftree-switch-conversion -ftree-pre -ftree-vrp" -f Vff_verilator.mk)

clean:
	rm -f tmp/*
