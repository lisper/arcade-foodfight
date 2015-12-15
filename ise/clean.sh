#!/bin/sh

echo "cleaning..."
rm -f _xmsgs/*

# ff_top_lx45.twr ff_top_lx45.twx 

rm -f ff_top_lx45.bgn ff_top_lx45.bit ff_top_lx45_bitgen.xwbt ff_top_lx45.drc ff_top_lx45.xdl
rm -f ff_top_lx45.par 
rm -f ff_top_lx45.xpi ff_top_lx45.ncd ff_top_lx45.unroutes
rm -f ff_top_lx45.syr ff_top_lx45.ngc ff_top_lx45.ngr ff_top_lx45.lso ff_top_lx45.pad 
rm -f ff_top_lx45.cmd_log ff_top_lx45.ut ff_top_lx45.stx
rm -f ff_top_lx45.ptwx ff_top_lx45.pcf ff_top_lx45.bld ff_top_lx45.ngd

rm -f ff_top_lx45_pad.txt ff_top_lx45_pad.csv
rm -f ff_top_lx45_par.xrpt 
rm -f ff_top_lx45_map.xrpt ff_top_lx45_map.map ff_top_lx45_map.mrp ff_top_lx45_map.ncd ff_top_lx45_map.ngm 
rm -f ff_top_lx45_ngdbuild.xrpt

rm -f xlnx_auto_0_xdb/*
rm -f _ngo/*

rm -f ff_top_lx45_guide.ncd ff_top_lx45_xst.xrpt 

rm -rf xst/*
mkdir xst/projnav.tmp/

rm -f ff_top_lx45_summary.xml ff_top_lx45_usage.xml
rm -f ff_top_lx45_envsettings.html ff_top_lx45_summary.html par_usage_statistics.html
rm -f webtalk*

echo "done."
