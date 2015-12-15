transcript on
if {[file exists ff_rtl_work]} {
  vdel -lib ff_rtl_work -all
}
vlib ff_rtl_work
vmap work ff_rtl_work

#
transcript file "log"

set defs +define+SIMULATION=1
set incs +incdir+../m68k

#vlog -work work top.v
vlog $defs ../rtl/ff.v
vlog $defs ../rtl/ff_top.v
vlog $defs $incs ../rtl/m68000.v
vlog $defs ../rtl/pokey.v
vlog $defs ../rtl/pal.v
vlog $defs ../rtl/prom_2b.v
vlog $defs ../rtl/coderom16.v
vlog $defs ../rtl/coderam.v
vlog $defs ../rtl/ram_907036.v
vlog $defs ../rtl/rom_6lm.v
vlog $defs ../rtl/ram_137250.v
vlog $defs ../rtl/rom_136020_16.v
vlog $defs ../rtl/ram_93422.v
vlog $defs ../rtl/nvram.v
vlog $defs ../rtl/ram_dp256x8.v
vlog $defs ../rtl/ram_256x8.v
vlog $defs xilinx.v
vlog $defs ff_tb.v

vsim -pli ../win32/vga.dll ff_top_tb

#vsim -novopt -pli ../win32/vga.dll ff_top_tb
#source wave.do

#vsim -novopt ff_top_tb
#vsim -voptargs="+acc=rnp" test
#add wave -r /*
#source wave.do

run 1000000000

