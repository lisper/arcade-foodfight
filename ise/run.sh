#!/bin/sh -x

export PATH=$PATH:/opt/Xilinx/14.4/ISE_DS/ISE/bin/lin

UCF=pipistrello_v2.01.ucf

xst -intstyle ise -ifn "/files/code/foodfight/ise/ff_top_lx45.xst" -ofn "/files/code/foodfight/ise/ff_top_lx45.syr" && \
ngdbuild -intstyle ise -dd _ngo -sd ipcore_dir -nt timestamp -uc $UCF -p xc6slx45-csg324-3 ff_top_lx45.ngc ff_top_lx45.ngd && \
map -intstyle ise -p xc6slx45-csg324-3 -w -logic_opt off -ol high -t 1 -xt 0 -register_duplication off -r 4 -global_opt off -mt off -ir off -pr off -lc off -power off -o ff_top_lx45_map.ncd ff_top_lx45.ngd ff_top_lx45.pcf && \
par -w -intstyle ise -ol high -mt off ff_top_lx45_map.ncd ff_top_lx45.ncd ff_top_lx45.pcf && \
trce -intstyle ise -v 3 -s 3 -n 3 -fastpaths -xml ff_top_lx45.twx ff_top_lx45.ncd -o ff_top_lx45.twr ff_top_lx45.pcf -ucf pipistrello_v2.01.ucf && \
bitgen -intstyle ise -f ff_top_lx45.ut ff_top_lx45.ncd

