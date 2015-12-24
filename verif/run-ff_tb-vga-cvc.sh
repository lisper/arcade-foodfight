#!/bin/sh


RTL="../rtl/ff.v ../rtl/ff_top.v ../rtl/m68000.v ../rtl/pokey.v ../rtl/joystick.v \
     ../rtl/pal.v ../rtl/prom_2b.v \
     ../rtl/coderom16.v ../rtl/coderam.v ../rtl/rom_6lm.v \
     ../rtl/rom_136020_16.v ../rtl/nvram.v ../rtl/ram_dp256x8.v \
     ../rtl/ram_moram.v ../rtl/ram_coloram.v ../rtl/ram_pfram.v ../rtl/ram_line.v "

#../rtl/ram_93422.v 
# xilinx.v

INC="+incdir+../m68k +incdir+../rtl"

PLI=+loadvpi=../pli/vga/vga.so:vpi_compat_bootstrap

#DEBUG=+define+debug=1

#gdb --args cvc-g +define+SIMULATION=1 $PLI $DEBUG $INC $RTL ff_tb.v
#+define+no_cpu=1 
#cvc -O +compiled_sim +define+SIMULATION=1 $PLI $DEBUG $INC $RTL ff_tb.v
#gdb --args cvc-g +define+SIMULATION=1 $PLI $DEBUG $INC $RTL ff_tb.v
#cvc-g +define+SIMULATION=1 $PLI $DEBUG $INC $RTL ff_tb.v
#cvc +interp +define+SIMULATION=1 $PLI $DEBUG $INC $RTL ff_tb.v


#cvc                         +define+SIMULATION=1 $PLI $DEBUG $INC $RTL ff_tb.v $*
cvc +interp +define+debug=1 +define+SIMULATION=1 $PLI $DEBUG $INC $RTL ff_tb.v $*
#cvc         +define+debug=1 +define+SIMULATION=1 $PLI $DEBUG $INC $RTL ff_tb.v $*
