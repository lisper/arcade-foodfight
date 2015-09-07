#!/bin/sh

perl -pi \
-e s.	13'h0027e: q0 = 16'h51c9; // 0x04fc\n	13'h0027f: q0 = 16'hfff8; // 0x04fe.\
`ifdef SIMULATION\
 13'h0027e: q0 = 16'h4e71;\
 13'h0027f: q0 = 16'h4e71;\
`else\
	13'h0027e: q0 = 16'h51c9; // 0x04fc\
	13'h0027f: q0 = 16'hfff8; // 0x04fe\
`endif\
.

`ifdef SIMULATION
 13'h0028a: q0 = 16'h4ef9; // 0x0514
 13'h0028b: q0 = 16'h0000; // 0x0516
 13'h0028c: q0 = 16'h0664; // 0x0518
`else
	13'h0028a: q0 = 16'h6000; // 0x0514
	13'h0028b: q0 = 16'h008e; // 0x0516
	13'h0028c: q0 = 16'h286a; // 0x0518
`endif

`ifdef SIMULATION
	13'h002ef: q0 = 16'h4e71; // 0x05de
	13'h002f0: q0 = 16'h4e71; // 0x05e0
`else
	13'h002ef: q0 = 16'h51c8; // 0x05de
	13'h002f0: q0 = 16'hfff8; // 0x05e0
`endif

`ifdef SIMULATION
	13'h002fb: q0 = 16'h4e71; // 0x05f6
	13'h002fc: q0 = 16'h4e71; // 0x05f8
`else
	13'h002fb: q0 = 16'h51c8; // 0x05f6
	13'h002fc: q0 = 16'hfff8; // 0x05f8
`endif

`ifdef SIMULATION
	13'h00305: q0 = 16'h4e71; // 0x060a
	13'h00306: q0 = 16'h4e71; // 0x060c
`else
	13'h00305: q0 = 16'h51c8; // 0x060a
	13'h00306: q0 = 16'hfff8; // 0x060c
`endif

`ifdef SIMULATION
 13'h00344: q0 = 16'h4241; // 0x0688
 13'h00345: q0 = 16'h4e71; // 0x068a
 13'h00346: q0 = 16'h4e71; // 0x068c
`else
	13'h00344: q0 = 16'hb279; // 0x0688
	13'h00345: q0 = 16'h0000; // 0x068a
	13'h00346: q0 = 16'h04d6; // 0x068c
`endif

`ifdef SIMULATION
 13'h00383: q0 = 16'h4240; // 0x0706
`else
	13'h00383: q0 = 16'h4a40; // 0x0706
`endif
