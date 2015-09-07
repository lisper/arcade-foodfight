#!/bin/sh

RTL="../rtl/ff_top_lx45.v ../rtl/ff.v ../rtl/ff_top.v \
     ../rtl/m68000.v ../rtl/pokey.v ../rtl/pal.v ../rtl/prom_2b.v \
     ../rtl/coderom16.v ../rtl/coderam.v ../rtl/ram_907036.v ../rtl/rom_6lm.v ../rtl/ram_137250.v \
     ../rtl/rom_136020_16.v ../rtl/ram_93422.v ../rtl/nvram.v ../rtl/ram_dp256x8.v ../rtl/ram_256x8.v \
     ../rtl/car_lx45.v ../rtl/scanconvert_lx45.v ../rtl/ds_dac.v"

INC="+incdir+../m68k +incdir+../rtl"

cver +define+SIMULATION=1 +define+debug=1 $INC $RTL ff_top_lx45_tb.v xilinx.v
