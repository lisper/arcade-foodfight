#!/bin/sh

BASE=/opt/Xilinx/14.4/ISE_DS
#BASE=/opt/Xilinx/14.5/ISE_DS

export PATH=$PATH:$BASE/ISE/bin/lin

. $BASE/settings32.sh

LD_PRELOAD=./preload.so ./ff_top_lx45_tb_isim_beh.exe -intstyle ise -gui -tclbatch isim.cmd -wdb ./ff_top_lx45_tb_isim_beh.wdb  -view ./isim.wcfg
