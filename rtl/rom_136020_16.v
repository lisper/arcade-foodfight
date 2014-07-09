//
//
//
module rom_136020_16(
		     input 	   clk,
		     input [12:0]  a,
		     output [15:0] d,
		     input 	   ce,
		     input 	   oe
		  );

   reg [7:0] romh[0:8191];
   reg [7:0] roml[0:8191];
   reg [7:0] dh, dl;

`include "../roms/v3/rom_4d4e_alt.v"
   
   assign d = { dh, dl };

   always @(posedge clk)
     begin
	dh <= romh[a];
	dl <= roml[a];
     end

endmodule // rom_136020
