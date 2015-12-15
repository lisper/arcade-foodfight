//
//
//

`timescale 1ns/1ns

`define use_vga

module ff_top_tb;

   parameter CLK_frequency  = 12.0e6;
   parameter CLK_period_f   = 1.0 /*sec*/ / CLK_frequency;
   parameter CLK_period     = CLK_period_f * 1000000000;

   reg clk;
   reg reset;

   wire led1, led2, led3;
   wire hsync, vsync, blank;
   wire [7:0] rgb;
   wire [7:0] audio;
   reg [9:0]  sw;
   reg [8:1]  sw1;

   wire       clk6m;
   
   ff_top uut(
	      .clk12m(clk),
	      .reset(reset),
	      .led1(led1),
	      .led2(led2),
	      .led3(led3),
	      .hsync(hsync),
	      .vsync(vsync),
	      .blank(blank),
	      .rgb(rgb),
	      .audio(audio),
	      .clk_6mhz_o(clk6m),
	      .sw(sw),
	      .sw1(sw1)
	      );

   always
     begin
        clk = 1'b0;
        //#(CLK_period/2);
        #5;
        clk = 1'b1;
        //#(CLK_period/2);
        #5;
     end

   //
//`define waves
`ifdef waves
   initial
     begin
	$timeformat(-9, 0, "", 7);
	$dumpfile("ff_tb.vcd");
	$dumpvars(0, ff_top_tb);
     end
`endif

   integer show_pc;
   integer show_regs;
   integer loops;
   integer cycles;

   initial
     begin
	show_pc = 0;
	show_regs = 0;
	loops = 0;
	cycles = 0;

//	sw = {10{1'b1}};
	sw = 10'b11_1111_1111;
	sw1 = 8'hbf/*{8{1'b0}}*/;
	reset = 0;
	#100 reset = 1;
	#500 reset = 0;

  	#10000000; sw[2] = 0; $display("throw set");
	  #400000; sw[2] = 1; $display("throw unset");
	
//       #100000000;
//       #25000000;
//       $finish;
     end

`ifndef no_cpu

`ifdef debug_led
   always @(posedge led1) $display("led: led1 on");
   always @(negedge led1) $display("led: led1 off");
   always @(posedge led2) $display("led: led2 on");
   always @(negedge led2) $display("led: led2 off");
   always @(posedge led3) $display("led: led3 on");
   always @(negedge led3) $display("led: led3 off");
`endif
   
`ifndef __CVER__
   always @(posedge uut.ff.s_6mhz)
     begin
	cycles = cycles + 1;
	if (cycles > 10000) begin
	   cycles = 0;
	   $display("%t; pc=%x", $time, uut.ff.cpu.wf68k00ip_top.i_68k00.pc_out);
	end
     end
`endif

   always @(posedge uut.ff.s_6mhz)
     begin
	if (
`ifdef __CVER__
	    uut.ff.cpu.wf68k00ip_top.i_68k00.fc_out_i == 6 &&
	    uut.ff.cpu.wf68k00ip_top.i_68k00.i_ctrl.exec_state == 1 &&
	    uut.ff.cpu.wf68k00ip_top.i_68k00.chk_pc_i
`else
	    0
`endif
	    )
	  begin
	     loops = loops + 1;
	     if (loops >= 1000) loops = 0;
	     
	     if (show_pc || loops == 0)
	       begin
		  $display("%t; pc=%x a0=%x a1=%x d0=%x d1=%x reset=%b",
			   $time,
			   uut.ff.cpu.wf68k00ip_top.i_68k00.pc_out,
			   uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[0],
			   uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[1],
			   uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[0],
			   uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[7],
			   reset);
	       end

	     //
	     if (^uut.ff.cpu.wf68k00ip_top.i_68k00.pc_out === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[0] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[1] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[2] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[3] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[4] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[5] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[6] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[7] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[0] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[1] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[2] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[3] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[4] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[5] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[6] === 1'bX ||
		 ^uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ssp === 1'bX)
	       begin
		  show_regs = 1;
		  $display("%t; x's in data or addr regs!!!", $time);
	       end

	     //
	     if ($time > 10000 && uut.ff.cpu.wf68k00ip_top.i_68k00.pc_out == 'h8c) begin
		$display("exception");
		show_regs = 1;
	     end

	     //
	     if (show_regs /*|| uut.ff.cpu.wf68k00ip_top.i_68k00.pc_out == 'h2aa2*/)
		  begin
		     $display("%t; pc=%x d0=%x d1=%x d2=%x d3=%x d4=%x d5=%x d6=%x d7=%x",
			      $time,
			      uut.ff.cpu.wf68k00ip_top.i_68k00.pc_out,
			      uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[0],
			      uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[1],
			      uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[2],
			      uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[3],
			      uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[4],
			      uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[5],
			      uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[6],
			      uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[7]);

		       $display("                     a0=%x a1=%x a2=%x a3=%x a4=%x a5=%x a6=%x ssp=%x",
				uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[0],
				uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[1],
				uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[2],
				uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[3],
				uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[4],
				uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[5],
				uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[6],
				uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ssp);
$stop;
		  end // if (show_regs)

	  end
     end // always @ (posedge uut.ff.s_6mhz)

`endif //  `ifndef no_cpu
   
   
`ifdef use_vga
   initial
     begin
	$cv_init_vga(800, 600);
     end

   wire [7:0] xxx;
   assign xxx = rgb != 0 ? 8'hff : 8'h0;
   
   always @(posedge clk)
     begin
	$cv_clk_vga(vsync, hsync, rgb);
     end
`endif
   
endmodule // ff_tb


