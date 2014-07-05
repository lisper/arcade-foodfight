//
//
//

`timescale 1ns/1ns

module ff_top_tb;

   parameter CLK_frequency  = 12.0e6;
   parameter CLK_period_f   = 1.0 /*sec*/ / CLK_frequency;
   parameter CLK_period     = CLK_period_f * 1000000000;

   reg clk;
   reg reset;

   wire led1, led2;
   wire hsync, vsync;
   wire [7:0] rgb;
   reg [9:0]  sw;
   reg [8:1]  sw1;
   
   ff_top uut(
	      .clk12m(clk),
	      .reset(reset),
	      .led1(led1),
	      .led2(led2),
	      .hsync(hsync),
	      .vsync(vsync),
	      .rgb(rgb),
	      .sw(sw),
	      .sw1(sw1)
	      );

   always
     begin
        clk = 1'b0;
        #(CLK_period/2);
        //#10;
        clk = 1'b1;
        #(CLK_period/2);
        //#10;
     end

   //
`define waves
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

   initial
     begin
	show_pc = 0;
	show_regs = 0;
	
	sw = {10{1'b1}};
	sw1 = {8{1'b0}};
	reset = 0;
	#1 reset = 1;
	#1000 reset = 0;
	
//       #100000000;
       #25000000;
       $finish;
     end

   always @(posedge uut.ff.s_6mhz)
     begin
	if (uut.ff.cpu.wf68k00ip_top.i_68k00.fc_out_i == 6 &&
	    uut.ff.cpu.wf68k00ip_top.i_68k00.i_ctrl.exec_state == 1 &&
	    uut.ff.cpu.wf68k00ip_top.i_68k00.chk_pc_i)
	  begin
		if (show_pc)
		  $display("%t; pc=%04x a0=x a1=x d0=x d1=x reset=%b",
			   $time,
			   uut.ff.cpu.wf68k00ip_top.i_68k00.pc_out,
			   uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[0],
			   uut.ff.cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[1],
			   uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[0],
			   uut.ff.cpu.wf68k00ip_top.i_68k00.i_datareg.dr[7],
			   reset);

		if (show_regs)
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
		  end // if (show_regs)
	  end
     end
   
   
endmodule // ff_tb


