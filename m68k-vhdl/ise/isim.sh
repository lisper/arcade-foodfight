#!/bin/sh

BASE=/opt/Xilinx/14.4/ISE_DS
export PATH=$PATH:$BASE/ISE/bin/lin

. $BASE/settings32.sh

#fuse -intstyle ise -incremental -lib unisims_ver -lib unimacro_ver -lib xilinxcorelib_ver -lib secureip -o /files/code/foodfight/m68k-vhdl/ise/m68k_tb_isim_beh.exe -prj /files/code/foodfight/m68k-vhdl/ise/m68k_tb_beh.prj work.m68k_tb work.glbl && \

#LD_PRELOAD=./preload.so 
./m68k_tb_isim_beh.exe -intstyle ise -gui -tclbatch isim.cmd -wdb /files/code/foodfight/m68k-vhdl/ise/m68k_tb_isim_beh.wdb -view ./isim.wcfg

