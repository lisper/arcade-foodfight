//
// foodfight
// code eeprom
// Brad Parker <brad@heeltoe.com> 5/2014
//

module coderom(
	       input        clk,
	       input [12:0] a,
	       output [7:0] out,
	       input 	    ce0,
	       input 	    ce1,
	       input 	    ce2,
	       input 	    ce3
	       );

   parameter hi = 0;
   
   reg [7:0] rom0[0:8191];
   reg [7:0] rom1[0:8191];
   reg [7:0] rom2[0:8191];
   reg [7:0] rom3[0:8191];
   reg [7:0] d;

`include "../roms/v3/rom_code_alt.v"
   
   assign out = d;
   
   always @(posedge clk)
     d <= ~ce0 ? rom0[a] :
	  ~ce1 ? rom1[a] :
	  ~ce2 ? rom2[a] :
	  ~ce3 ? rom3[a] :
	  8'b0;

`ifdef debug_rom
   always @(negedge ce0 or negedge ce1 or negedge ce2 or negedge ce3 or a)
     begin
	if (~ce0) $display("rom: read0 %x -> %x", a, rom0[a]);
	if (~ce1) $display("rom: read1 %x -> %x", a, rom1[a]);
	if (~ce2) $display("rom: read2 %x -> %x", a, rom2[a]);
	if (~ce3) $display("rom: read3 %x -> %x", a, rom3[a]);
     end
`endif
   
endmodule // coderom
