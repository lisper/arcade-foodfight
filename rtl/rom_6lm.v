//
//
//

//`define ROM_ARRAY
`define ROM_CASE

module rom_6lm(
	       input        clk,
	       input [12:0] a,
	       output [7:0] d
	       );

   // 111
   // 2109876543210
   // 4215216318421
   // 000152426
   // 942268
   // 684

`ifdef ROM_ARRAY
   reg [7:0] rom[0:8191];
   reg [7:0] data;

`include "../roms/v3/rom_6lm.v"

   assign d = data;
   
   always @(posedge clk)
     data <= rom[a];
`endif // ROM_ARRAY

`ifdef ROM_CASE
   reg [7:0] q;

   always @(posedge clk)
 `include "../roms/v3/rom_6lm_case.v"

   assign d = q;
   
`endif
endmodule // rom_6lm
