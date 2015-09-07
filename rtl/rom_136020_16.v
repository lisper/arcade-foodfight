//
//
//

//`define ROM_ARRAY
`define ROM_CASE

module rom_136020_16(
		     input 	   clk,
		     input [12:0]  a,
		     output [15:0] d,
		     input 	   ce,
		     input 	   oe
		  );

`ifdef ROM_ARRAY
   reg [7:0] romh[0:8191];
   reg [7:0] roml[0:8191];
   reg [7:0] dh, dl;

`include "../roms/v3/rom_4d4e_init.v"
   
   assign d = { dh, dl };

   always @(posedge clk)
     begin
	dh <= romh[a];
	dl <= roml[a];
     end

`endif // ROM_ARRAY

`ifdef ROM_CASE
   reg [15:0] q;
   
   always @(posedge clk)
 `include "../roms/v3/rom_4d4e_case.v"

   assign d = q;
`endif // ROM_CASE

endmodule // rom_136020
