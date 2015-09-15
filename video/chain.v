`timescale 1ns/1ns

`include "prom_2b.v"

module m74ls163a (clk, clr_n, ld, ep, et, d, q, rc);


   input clk, clr_n, ld, ep, et;
   input [3:0] d;
   output      rc;
   output [3:0] q;
   reg [3:0] 	q;
   reg 		rc;

   always @(posedge clk)
     if (clr_n == 0) q <= 4'b0000;
     else if (ld == 0) q <= d;
     else if (et & ep) q <= q + 1;

   always @(q or et)
     if (q == 15 && et == 1) rc = 1;
     else rc = 0;

endmodule


module m74ls163b(clk, clr_n, et, ep, ld, d, q, rc);

   parameter WID=4;

   input clk;
   input clr_n;   // clear active low
   input et;   // clock enable
   input ep;   // clock enable
   input ld;   // load active low
   input [WID:1] d;
   output [WID:1] q;
   reg [WID:1] 	  q;
   output 	  rc;

   assign rc = &{q[WID:1],et};

   always @(posedge clk)
     begin
	if (!clr_n)
	  q <= {WID{1'b0}};

	else if (!ld)
	  q <= d;

	else if (ep & et)
	  q <= q + {{WID-1{1'b0}},1'b1};

     end

endmodule

module tb;

   reg clk;
   reg reset_n;

   wire [11:0] h;
   wire        rc0;
   wire        rc1;
   wire        rc2, rc2_n;

   wire        clk_12mhz;
   assign clk_12mhz = clk;
   
   m74ls163b clk0(.clk(clk), .clr_n(reset_n), .et(1'b1), .ep(1'b1), .ld(1'b1),
		 .d(4'b0000), .q(h[3:0]), .rc(rc0));

   m74ls163b clk1(.clk(clk), .clr_n(reset_n), .et(rc0), .ep(rc0), .ld(1'b1),
		 .d(4'b0000), .q(h[7:4]), .rc(rc1));

   m74ls163b clk2(.clk(clk), .clr_n(reset_n), .et(rc1), .ep(rc0), .ld(rc2_n),
		 .d(4'b1101), .q(h[11:8]), .rc(rc2));

   assign rc2_n = ~rc2;

   wire       ss_6mhz, ss_1h, ss_2h, ss_4h, ss_8h, ss_16h, ss_32h, ss_64h, ss_128h, ss_256h;
   
   assign ss_6mhz  = h[0];
   assign ss_1h    = h[1];
   assign ss_2h    = h[2];
   assign ss_4h    = h[3];
   assign ss_8h    = h[4];
   assign ss_16h   = h[5];
   assign ss_32h   = h[6];
   assign ss_64h   = h[7];
   assign ss_128h  = h[8];
   assign ss_256h  = h[9];
   
   //
   reg [11:0]  counter_h;
   
   always @(posedge clk_12mhz)
     if (~reset_n)
//       counter_h <= 12'b1101_0000_0000;
       counter_h <= 12'b0;
     else
       begin
	  if (counter_h == 12'b1111_1111_1111)
	    counter_h <= 12'b1101_0000_0000;
	  else
	    counter_h <= counter_h + 12'd1;
       end

   //
   wire       s_6mhz, s_1h, s_2h, s_4h, s_8h, s_16h, s_32h, s_64h, s_128h, s_256h;
   
   assign s_6mhz  = counter_h[0];
   assign s_1h    = counter_h[1];
   assign s_2h    = counter_h[2];
   assign s_4h    = counter_h[3];
   assign s_8h    = counter_h[4];
   assign s_16h   = counter_h[5];
   assign s_32h   = counter_h[6];
   assign s_64h   = counter_h[7];
   assign s_128h  = counter_h[8];
   assign s_256h  = counter_h[9];

   // debug
   wire [8:0] offset_h;
   assign offset_h = { s_256h, s_128h, s_64h, s_32h, s_16h, s_8h, s_4h, s_2h, s_1h };

   reg hsync;
   reg hsync_clr_n;
   wire hsync_clr;

   //
   //  256h ~256h hsync_clr hsync_clr_n
   //    0    1       0         1
   //    1    0       1         0

   reg 	s_8h_d, s_32h_d, s_256h_n_d;
   wire s_8h_rise, s_32h_rise, s_256h_n_rise;
   
   always @(posedge s_6mhz)
     if (~reset_n)
       begin
	  s_8h_d <= 0;
	  s_32h_d <= 0;
	  s_256h_n_d <= 0;
       end
     else
       begin
	  s_8h_d <= s_8h;
	  s_32h_d <= s_32h;
	  s_256h_n_d <= s_256h_n;
       end
   
   assign s_8h_rise = ~s_8h_d & s_8h;
   assign s_32h_rise = ~s_32h_d & s_32h;
   assign s_256h_n_rise = ~s_256h_n_d & s_256h_n;
   
   always @(posedge s_6mhz/*clk_12mhz*/)
     if (~reset_n)
       hsync_clr_n <= 1'b1;
     else
       if (s_256h)
	 hsync_clr_n <= 1'b0;
       else
	 if (s_32h_rise)
	   hsync_clr_n <= ~s_64h;

   assign hsync_clr = ~hsync_clr_n;

   always @(posedge s_6mhz/*clk_12mhz*/)
     if (hsync_clr)
       hsync <= 1'b0;
     else
       if (s_8h_rise)
	 hsync <= s_32h;

   //----------------

   wire s_256h_n;
   assign s_256h_n = 1'b1 ^ s_256h;   

   //
   reg [7:0]  counter_v;
   
   always @(negedge clk_12mhz)
//   always @(posedge s_256h_n or negedge reset_n)
     if (~reset_n)
	 counter_v <= 0;
     else
       if (~vpreset_n)
	 counter_v <= /*8'hdc*/8'hdf;
       else
	 if (s_256h_n_rise)
	   counter_v <= counter_v + 8'd1;

   wire       s_1v, s_2v, s_4v, s_8v, s_16v, s_32v, s_64v, s_128v;

   assign s_1v    = counter_v[0];
   assign s_2v    = counter_v[1];
   assign s_4v    = counter_v[2];
   assign s_8v    = counter_v[3];
   assign s_16v   = counter_v[4];
   assign s_32v   = counter_v[5];
   assign s_64v   = counter_v[6];
   assign s_128v  = counter_v[7];

   reg vblank, vblank_n;
   reg vsync, vsync_n;
   reg vpreset, vpreset_n;

   wire [7:0] prom_2b_addr;
   wire [3:0] prom_out;
   
   assign prom_2b_addr = { vblank, s_64v, s_32v, s_16v, s_8v, s_4v, s_2v, s_1v };
   
   prom_2b prom_2b(
		   .clk(clk_12mhz),
		   .a(prom_2b_addr),
		   .d(prom_out),
		   .e1(1'b0),
		   .e2(1'b0)
		   );

   always @(negedge /*s_6mhz*/clk_12mhz)
     if (~s_128v)
       begin
	  vblank <= 1'b0;
	  vblank_n <= 1'b1;
	  vsync <= 1'b0;
	  vsync_n <= 1'b1;
	  vpreset <= 1'b0;
	  vpreset_n <= 1'b1;
       end
     else
       if (s_256h_n/*_rise*/)
       begin
	  vblank    <=  prom_out[2];
	  vblank_n  <= ~prom_out[2];
	  vsync     <=  prom_out[1];
	  vsync_n   <= ~prom_out[1];
	  vpreset   <=  prom_out[0];
	  vpreset_n <= ~prom_out[0];
       end
   
   //
   initial
     begin
	$timeformat(-9, 0, "", 7);
	$dumpfile("chain.vcd");
	$dumpvars(0, tb);
     end

   always
     begin
        clk = 1'b0; #41;
        clk = 1'b1; #41;
     end

   initial
     begin
	reset_n = 0;
	#500;
	reset_n = 1;
	
	#64000000;
	$finish;
     end
   
endmodule // tb
