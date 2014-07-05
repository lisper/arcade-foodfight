//
//
//

`timescale 1ns/1ns

module rom(input [23:0] addr, output [15:0] data, input oe);

   reg [15:0] rom[0:8191];

   initial
     begin
	$readmemh("../asm/test3.hex", rom);
	$display("rom[0] = %x", rom[0]);
	$display("rom[1] = %x", rom[1]);
     end

   wire [12:0] a;
   assign a = addr[13:1];
   assign data = rom[a];

   always @(addr)
     if (oe & 0)
       $display("rom: rom[%x] -> %x", a, rom[a]);
endmodule

module ram(input [23:0] addr, output [15:0] dataout, input [15:0] datain, input cs, input oe, input we);

   reg [31:0] ram[0:8191];
   wire [11:0] a;
   integer    j;
   
   initial
     begin
	for (j = 0; j < 8192; j = j + 1)
	  ram[j] = 0;
     end

   assign a = addr[11:0];
   assign dataout = ram[a];
   
   always @(a or cs or oe or we)
     begin
	if (cs)
	  begin
	     if (we)
	       begin
		  ram[a] <= datain;
		  $display("ram: %x <- %x", addr, datain);
	       end
	     else
	       if (oe)
		 $display("ram: %x -> %x", addr, dataout);
	  end
     end
endmodule
	   
module m68k_tb;

   reg clk;
   reg reset_n;
   wire [15:0] data_in;
   reg 	      berr_n;
   reg 	      reset_in_n;
   reg 	      halt_in_n;
   reg 	      vpa_n;
   reg [2:0]  ipl_n;
   reg 	      br_n;
   reg 	      bgack_n;
   reg 	      dtack_n;
   reg        avec_n;
   
   wire [23:1] addr;
   wire [15:0] data_out;
   wire        reset_out_n;
   wire        halt_out_n;
   wire [2:0]  fc;

   wire        uds_n, lds_n;
   wire        e;
   wire        vma_n;
   wire        bg_n;

   
   wf68k00ip_top top(
		     .clk(clk),
		     .reset_coren(reset_n),
		     .adr(addr),
		     .datain(data_in),
		     .dataout(data_out),
		     .berrn(berr_n),
		     .resetinn(reset_in_n),
		     .resetoutn(reset_out_n),
		     .haltinn(halt_in_n),
		     .haltoutn(halt_out_n),
		     .fc(fc),
		     .avecn(avec_n),
		     .ipln(ipl_n),
		     .dtackn(dtack_n),
		     .asn(asn_n),
		     .rwn(rw_n),
		     .udsn(uds_n),
		     .ldsn(lds_n),
		     .e(e),
		     .vman(vma_n),
		     .vpan(vpa_n),
		     .brn(br_n),
		     .bgn(bg_n),
		     .bgackn(bgack_n)
		     );

   always @(posedge clk)
     begin
	if (uds_n == 0 & 0)
	  $display("%t uds_n=%b rw_n=%b data=%x", $time, uds_n, rw_n, data_in);
	if (lds_n == 0 & 0)
	  $display("%t lds_n=%b rw_n=%b data=%x", $time, lds_n, rw_n, data_in);
     end

   wire [23:0] mem_addr;
   wire [15:0] rom_out;
   wire [15:0] ram_out;
   wire [15:0] ram_in;
   wire        ram_we;
   wire        ram_cs;
   wire        steer_rom;
   wire        steer_ram;
   
   rom rom(
	   .addr(mem_addr),
	   .data(rom_out),
	   .oe(steer_rom)
	   );

   ram ram(
	   .addr(mem_addr),
	   .dataout(ram_out),
	   .datain(ram_in),
	   .cs(ram_cs),
	   .oe(steer_ram),
	   .we(ram_we)
	   );

   assign steer_ram = mem_addr >= 24'h14000;
   assign steer_rom = ~steer_ram;
   assign data_in = steer_ram ? ram_out : rom_out;
   assign ram_in = data_out;
   assign mem_addr = { addr, 1'b0 };
   assign ram_cs = ~uds_n | ~lds_n;
   assign ram_we = ~rw_n;
   
   integer short_detail;
   
   always
     begin
        clk = 1'b0;
        #10;
        clk = 1'b1;
        #10;
     end

   //
   initial
     begin
	$timeformat(-9, 0, "", 7);
	$dumpfile("m68k_tb.vcd");
	$dumpvars(0, m68k_tb);
     end

   initial
     begin
	short_detail = 0;

	reset_n = 0;
	berr_n = 1;
	reset_in_n = 1;
	halt_in_n = 1;
	vpa_n = 1;
	ipl_n = 3'b111;
	br_n = 1;
	bgack_n = 1;
	dtack_n = 0;
	avec_n = 1;

	#500 reset_n = 1;
	
//       #50000;
	#40000;
       $finish;
     end

   parameter STOP = 7'd73;

   always @(posedge clk)
     if (top.i_68k00.fc_out_i == 6 &&
	 top.i_68k00.i_ctrl.exec_state == 1)
       begin
	  if (top.i_68k00.op_i == STOP/* & top.i_68k00.op_end_i*/)
	    begin
	       $display("*** STOP %x", top.i_68k00.i_datareg.dr[0]);
   	       if (top.i_68k00.i_datareg.dr[0] != 0)
		 $display("*** FAIL %x", top.i_68k00.i_datareg.dr[0]);
	       else
		 $display("*** PASS ***");
	       $finish;
	    end
       end

   always @(posedge clk)
     if (top.i_68k00.fc_out_i == 6 &&
	 top.i_68k00.i_ctrl.exec_state == 1 &&
	 top.i_68k00.chk_pc_i)
       begin
	  if (short_detail)
	    $display("%t; pc=%x a0=%x a1=%x d0=%x d7=%x",
		     $time,
		     top.i_68k00.pc_out,
		     top.i_68k00.i_adrreg.ar[0],
		     top.i_68k00.i_adrreg.ar[1],
		     top.i_68k00.i_datareg.dr[0],
		     top.i_68k00.i_datareg.dr[7]);
	  else
	    begin
	       $display("%t; pc=%x d0=%x d1=%x d2=%x d3=%x d4=%x d5=%x d6=%x d7=%x",
			$time,
			top.i_68k00.pc_out,
			top.i_68k00.i_datareg.dr[0], top.i_68k00.i_datareg.dr[1],
			top.i_68k00.i_datareg.dr[2], top.i_68k00.i_datareg.dr[3],
			top.i_68k00.i_datareg.dr[4], top.i_68k00.i_datareg.dr[5],
			top.i_68k00.i_datareg.dr[6], top.i_68k00.i_datareg.dr[7]);
	       $display("                     a0=%x a1=%x a2=%x a3=%x a4=%x a5=%x a6=%x ssp=%x",
			top.i_68k00.i_adrreg.ar[0], top.i_68k00.i_adrreg.ar[1],
			top.i_68k00.i_adrreg.ar[2], top.i_68k00.i_adrreg.ar[3],
			top.i_68k00.i_adrreg.ar[4], top.i_68k00.i_adrreg.ar[5],
			top.i_68k00.i_adrreg.ar[6], top.i_68k00.i_adrreg.ssp);
	    end
       end
   
endmodule


