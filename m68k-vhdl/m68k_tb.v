//
//
//

module rom(input [23:0] addr, output reg [15:0] data);
  always @(addr)
    begin
       case (addr)
	 16'h0000: data = 16'h0000;
	 16'h0002: data = 16'h2000;
	 16'h0004: data = 16'h0000;
	 16'h0006: data = 16'h1000;
	 16'h1000: data = 16'h3038;
	 16'h1002: data = 16'h2000;
	 16'h1004: data = 16'hd078;
	 16'h1006: data = 16'h2002;
	 16'h1008: data = 16'hd078;
	 16'h100a: data = 16'h2004;
	 16'h100c: data = 16'h907c;
	 16'h100e: data = 16'h01f0;
	 16'h1010: data = 16'h31c0;
	 16'h1012: data = 16'h2006;
	 16'h1014: data = 16'h4e72;
	 16'h1016: data = 16'h2700;
	 default: data = 0;
       endcase // case (addr)

       $display("rom: %x -> %x", addr, data);
    end
endmodule

module ram(input [23:0] addr, output reg [15:0] dataout, input [15:0] datain, input we);
endmodule
	   
module m68k_tb;

   reg clk;
   reg 	      berr_n;
   reg 	      vpa_n;
   reg [2:0]  ipl_n;
   reg 	      br_n;
   reg 	      bgack_n;
   reg 	      dtackn;
   
   wire	      reset_n;
   wire [15:0] data;
   wire [23:1] addr;
   wire        halt_n;
   wire [2:0]  fc;

   wire        uds_n, lds_n;
   wire        e;
   wire        vma_n;
   wire        bg_n;
   
   wf68k00ip_top top(
		     .CLK(clk),
		     .RESET_COREn(reset_n),
		     .ADR(addr),
		     .DATA(data),
		     .BERRn(berr_n),
		     .RESETn(reset_n),
		     .HALTn(halt_n),
		     .FC(fc),
		     .AVECn(avec_n),
		     .IPLn(ipl_n),
		     .DTACKn(dtack_n),
		     .ASn(asn_n),
		     .RWn(rw_n),
		     .UDSn(uds_n),
		     .LDSn(lds_n),
		     .E(e),
		     .VMAn(vma_n),
		     .VPAn(vpa_n),
		     .BRn(br_n),
		     .BGn(bg_n),
		     .BGACKn(bgack_n)
		     );

   always @(posedge clk)
     begin
	if (uds_n == 0)
	  $display("%t uds_n=%b rw_n=%b data=%x", $time, uds_n, rw_n, data);
	if (lds_n == 0)
	  $display("%t lds_n=%b rw_n=%b data=%x", $time, lds_n, rw_n, data);
     end

   wire [23:0] mem_addr;
   wire [15:0] rom_out;
   wire [15:0] ram_out;
   wire [15:0] ram_in;
   wire        ram_we;
   wire        steer_rom;
   wire        steer_ram;
   
   rom rom(
	   .addr(mem_addr),
	   .data(rom_out)
	   );

   ram ram(
	   .addr(mem_addr),
	   .dataout(ram_out),
	   .datain(ram_in),
	   .we(ram_we)
	   );

   assign steer_ram = mem_addr >= 24'h002000;
   assign steer_rom = mem_addr < 24'h002000;

   assign data = steer_ram ? ram_out :
		 steer_rom ? rom_out :
		 16'bz;
   
   assign ram_in = data;
   assign mem_addr = { addr, 1'b0 };
   
   always
     begin
        clk = 1'b0;
        #10;
        clk = 1'b1;
        #10;
     end

   //
//   initial
//     begin
//	//$timeformat(-9, 0, "ns", 7);
//	$dumpfile("m68k_tb.vcd");
//	$dumpvars(0, m68k_tb);
//     end

   reg drive_reset;
   reg reset;
   
   assign halt_n = 1;
   assign reset_n = drive_reset ? reset : 1'bz;

   initial
     begin
	drive_reset = 1;
	reset = 1;
	berr_n = 1;
	vpa_n = 1;
	ipl_n = 3'b111;
	br_n = 1;
	bgack_n = 1;
	dtackn = 0;	

	#5000;
	reset = 0;
	drive_reset = 0;
	
//       #50000;
	#10000;
       $finish;
     end
	  
   
endmodule


