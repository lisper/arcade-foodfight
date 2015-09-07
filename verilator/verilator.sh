#!/bin/sh -x

#V=verilator
V=/usr/local/bin/verilator

TOP="--top-module ff_verilator"
RTL=../rtl
CPU=../m68k
ROM=../roms/v3
INC="+incdir+$RTL +incdir+$CPU +incdir+$ROM"

$V -cc -LDFLAGS "-L../../emu/fame/x86/linux -lSDL -lpthread -lfame" -exe --trace --Mdir ./tmp +define+debug=1 +define+SIMULATION=1 $INC $TOP -CFLAGS -DCOSIM=1 \
    ff_verilator.v \
    $RTL/ff.v $RTL/ff_top.v $RTL/m68000.v $RTL/pokey.v $RTL/pal.v $RTL/prom_2b.v \
    $RTL/coderom16.v $RTL/coderam.v $RTL/ram_907036.v $RTL/rom_6lm.v $RTL/ram_137250.v $RTL/nvram.v \
    $RTL/rom_136020_16.v $RTL/ram_93422.v $RTL/ram_dp256x8.v $RTL/ram_256x8.v $RTL/scanconvert_lx45.v \
    ff_verilator.cpp cosim.cpp vga.cpp &&
(cd tmp; make OPT="-fauto-inc-dec -fdce -fdefer-pop -fdse -ftree-ccp -ftree-ch -ftree-fre -ftree-dce -ftree-dse" -f Vff_verilator.mk)

#(cd tmp; make OPT="-O -fno-builtin" -f Vff_verilator.mk)


#(cd tmp; make OPT="-O -fno-auto-inc-dec -fno-compare-elim -fno-cprop-registers -fno-dce -fno-defer-pop -fno-delayed-branch -fno-dse -fno-guess-branch-probability -fno-if-conversion2 -fno-if-conversion -fno-ipa-pure-const -fno-ipa-profile -fno-ipa-reference -fno-merge-constants -fno-split-wide-types -fno-tree-bit-ccp -fno-tree-builtin-call-dce -fno-tree-ccp -fno-tree-ch -fno-tree-copyrename -fno-tree-dce -fno-tree-dominator-opts -fno-tree-dse -fno-tree-forwprop -fno-tree-fre -fno-tree-phiprop -fno-tree-sra -fno-tree-pta -fno-tree-ter -fno-unit-at-a-time -fno-builtin" -f Vff_verilator.mk)

#(cd tmp; make OPT="-O2 -fno-builtin" -f Vff_verilator.mk)



