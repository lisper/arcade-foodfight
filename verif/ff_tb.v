//
//
//

`timescale 1ns/1ns

`define use_vga

module ff_top_tb;

   parameter CLK_frequency  = 12.0e6;
   parameter CLK_period_f   = 1.0 /*sec*/ / CLK_frequency;
   parameter CLK_period     = CLK_period_f * 1000000000;

   reg clk_12m;
   reg clk_6m;
   reg reset;

   wire led1, led2, led3;
   wire hsync, vsync, blank;
   wire [7:0] rgb;
   wire [7:0] audio;
   reg [11:0] sw;
   reg [8:1]  sw1;

   wire       clk_6m_o;
   
   ff_top uut(
	      .clk12m(clk_12m),
	      .clk6m(clk_6m),
	      .reset(reset),
	      .led1(led1),
	      .led2(led2),
	      .led3(led3),
	      .hsync(hsync),
	      .vsync(vsync),
	      .blank(blank),
	      .rgb(rgb),
	      .audio(audio),
	      .clk_6mhz_o(clk_6m_o),
	      .sw(sw),
	      .sw1(sw1)
	      );

   always
     begin
        clk_12m = 1'b0;
        //#(CLK_period/2);
        #5;
        clk_12m = 1'b1;
        //#(CLK_period/2);
        #5;
     end

   //
   always @(posedge clk_12m)
     if (reset)
       clk_6m <= 0;
     else
       clk_6m <= ~clk_6m;
   
`define waves
`ifdef waves
   initial
     begin
	$timeformat(-9, 0, "", 7);
	$dumpfile("ff_tb.vcd");
	$dumpvars(0, ff_top_tb);
     end
`endif

   integer halt;
   integer teststamps;
   integer testpf;

   
   initial
     begin
//`ifdef __CVER__
	halt = 0;
	if ($test$plusargs("halt")) begin
	   halt = 1;
	end

	teststamps = 0;
	if ($test$plusargs("teststamps")) begin
	   teststamps = 1;
	end
	
	testpf = 0;
	if ($test$plusargs("testpf")) begin
	   testpf = 1;
	end
//`endif
     end

   integer show_pc;
   integer show_regs;
   integer loops;
   integer cycles;

   task write_stamp;
      input [7:0] a;
      input [3:0] s7, s6, s5, s4, s3, s2, s1, s0;
      begin
	 ff_top_tb.uut.ff.moram.ramh.ram[a+0] = { s7, s6 };
	 ff_top_tb.uut.ff.moram.raml.ram[a+0] = { s5, s4 };
	 ff_top_tb.uut.ff.moram.ramh.ram[a+1] = { s3, s2 };
	 ff_top_tb.uut.ff.moram.raml.ram[a+1] = { s1, s0 };
      end
   endtask

   task write_color;
      input [7:0] a, c3, c2, c1, c0;
      begin
	 ff_top_tb.uut.ff.coloram.ram[a+0] = c3;
 	 ff_top_tb.uut.ff.coloram.ram[a+1] = c2;
 	 ff_top_tb.uut.ff.coloram.ram[a+2] = c1;
 	 ff_top_tb.uut.ff.coloram.ram[a+3] = c0;
      end
   endtask

   task write_pf;
      integer i;
      begin
	 for (i = 0; i < 1024; i = i + 1)
	   begin
	      ff_top_tb.uut.ff.pfram.ramh[i] = 'h00;
//	      ff_top_tb.uut.ff.pfram.raml[i] = 'h41 + i;
	      ff_top_tb.uut.ff.pfram.raml[i] = 'h23;
	   end
      end
   endtask

   task halt_cpu;
      begin
	 force ff_top_tb.uut.ff.cpu.wf68k00ip_top.i_68k00.halt_in = 0;
	 force ff_top_tb.uut.ff.pfflip = 0;
      end
   endtask

   initial
     begin
	show_pc = 0;
	show_regs = 0;
	loops = 0;
	cycles = 0;

//	sw = {10{1'b1}};
	sw = 12'b0011_1111_1111;
	sw1 = 8'hbf/*{8{1'b0}}*/;
	reset = 0;
	#100 reset = 1;

	if (halt) begin
	   halt_cpu;
	end

	// stamp test
	if (teststamps)
	  begin
	     write_color('h00, 'h00, 'h00, 'h00, 'h00);
	     write_color('h3c, 'h00, 'h17, 'h15, 'h6f);
	     write_color('h48, 'h00, 'hff, 'h13, 'h0a);
	     write_color('hfc, 'h00, 'h48, 'h49, 'h52);

	     write_stamp('h40, 'h0, 'hf, 'h0, 'h3, 'h9, 'h0, 'he, 'h0);
	     write_stamp('h42, 'h9, 'h2, 'hf, 'hf, 'h3, 'h0, 'hb, 'h0); // hf --
	     write_stamp('h44, 'h5, 'h2, 'hf, 'hf, 'h1, 'h0, 'hb, 'h0); // -- vf
//	     write_stamp('h46, 'h1, 'h2, 'hf, 'hf, 'h1, 'h0, 'hd, 'h0); // -- --
//	     write_stamp('h46, 'h1, 'h7, 'h3, 'hb, 'hc, 'h7, 'h2, 'h4); // -- --
	     write_stamp('h46, 'h0, 'hf, 'h0, 'h3, 'hc, 'h7, 'h2, 'h4); // -- --
	     write_stamp('h48, 'hd, 'h2, 'hf, 'hf, 'h3, 'h0, 'hd, 'h0); // hf vf
	  end // if (0)

	// pf test
	if (testpf)
	  begin
	     halt_cpu;
	     write_color('h00, 'h00, 'h17, 'h15, 'h6f);
	     write_color('hfc, 'h00, 'h48, 'h49, 'h52);
	     write_pf;
	  end // if (0)
	
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

//   wire [7:0] xxx;
//   assign xxx = rgb != 0 ? 8'hff : 8'h0;
   
   always @(posedge clk_12m)
     begin
	$cv_clk_vga(vsync, hsync, rgb);
     end
`endif
   
endmodule // ff_tb


