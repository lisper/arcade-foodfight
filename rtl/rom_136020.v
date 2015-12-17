//
//
//
module rom_136020(
		  input        clk,
		  input [12:0] a,
		  output [7:0] d,
		  input        ce,
		  input        oe
		  );

   parameter hi = 0;

   reg [7:0] rom[0:8191];
   reg [7:0] data;

`include "../roms/v3/rom_4d4e_init.v"
   
   initial
     begin
	if (hi)
	  begin
	     rom[0] = 1;
	  end
	else
	  begin
	     rom[0] = 0;
	  end
     end

   assign d = data;

   always @(posedge clk)
     if (~ce)
       data <= rom[a];

endmodule // rom_136020
