//
//
//
module rom_136020(
		  input [12:0] a,
		  output [7:0] d,
		  input        ce,
		  input        oe
		  );

   reg [7:0] rom[0:8191];

   assign d = rom[a];

endmodule // rom_136020
