#!/bin/sh

BASE=/opt/Xilinx/14.4/ISE_DS
#BASE=/opt/Xilinx/14.5/ISE_DS

export PATH=$PATH:$BASE/ISE/bin/lin

. $BASE/settings32.sh

#-intstyle "ise" -incremental 
#-d NO_ROM_INIT=1 
#-mt off -v 1 
fuse -mt off -v 1 -d debug=1 -d SIMULATION=1 -d ISIM=1 -lib "unisims_ver" -lib "unimacro_ver" -lib "xilinxcorelib_ver" -lib "secureip" -o "/files/code/foodfight/ise/ff_top_lx45_tb_isim_beh.exe" -prj "/files/code/foodfight/ise/ff_top_lx45_tb_beh.prj" "work.ff_top_lx45_tb" "work.glbl" && \
LD_PRELOAD=./preload.so ./ff_top_lx45_tb_isim_beh.exe -intstyle ise -gui -tclbatch isim.cmd -wdb ./ff_top_lx45_tb_isim_beh.wdb  -view ./isim.wcfg
