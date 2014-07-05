//
//
//
module ram_93422(
		input [7:0]  a,
		input [3:0]  i,
		output [3:0] d,
		input 	     cs2,
		input 	     cs1,
		input 	     oe,
		input 	     w
		);

   reg [3:0] ram[0:255];

`ifdef debug
   integer    j;
   
   initial
     begin
	for (j = 0; j < 256; j = j + 1)
	  ram[j] = 0;
     end

   assign d = ram[a];

   wire ram_write;
   assign ram_write = ~cs1 & ~w;
   
   always @(a or cs2 or cs1 or w)
     if (ram_write)
       ram[a] = i;
   
`endif
   
endmodule // ram_93422
