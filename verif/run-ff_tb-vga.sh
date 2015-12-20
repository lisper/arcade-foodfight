#!/bin/sh

RTL="../rtl/ff.v ../rtl/ff_top.v ../rtl/m68000.v ../rtl/pokey.v ../rtl/joystick.v \
     ../rtl/pal.v ../rtl/prom_2b.v \
     ../rtl/coderom16.v ../rtl/coderam.v ../rtl/rom_6lm.v \
     ../rtl/ram_pfram.v ../rtl/ram_moram.v ../rtl/ram_coloram.v ../rtl/ram_line.v \
     ../rtl/rom_136020_16.v ../rtl/nvram.v ../rtl/ram_dp256x8.v"

INC="+incdir+../m68k +incdir+../rtl"

PLI=+loadvpi=../pli/vga/vga.so:vpi_compat_bootstrap

DEBUG=+define+debug=1

cver +define+SIMULATION=1 $PLI $DEBUG $INC $RTL ff_tb.v $*
