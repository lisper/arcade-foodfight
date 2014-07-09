//
//
//
module rom_6lm(
	       input        clk,
	       input [12:0] a,
	       output [7:0] d,
	       input 	    ce,
	       input 	    oe
	       );

   // 111
   // 2109876543210
   // 4215216318421
   // 000152426
   // 942268
   // 684
   
   reg [7:0] rom[0:8191];
   reg [7:0] data;

`include "../roms/v3/rom_6lm.v"

   assign d = data;
   
   always @(posedge clk)
     data <= rom[a];

endmodule // rom_6lm
