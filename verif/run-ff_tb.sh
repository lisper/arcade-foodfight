#!/bin/sh

RTL="../rtl/ff.v ../rtl/ff_top.v ../rtl/m68000.v ../rtl/pokey.v ../rtl/pal.v ../rtl/prom_2b.v \
     ../rtl/coderom.v ../rtl/coderam.v ../rtl/ram_907036.v ../rtl/rom_6lm.v ../rtl/ram_137250.v \
     ../rtl/rom_136020.v ../rtl/ram_93422.v ../rtl/nvram.v ../rtl/ram_dp256x8.v"

INC="+incdir+../m68k +incdir+../rtl"

cver +define+debug=1 $INC $RTL ff_tb.v
