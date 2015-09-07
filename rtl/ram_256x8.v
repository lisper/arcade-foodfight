
module ram_256x8(input clk,
		 input [7:0]  a,
		 input [7:0]  i,
		 output [7:0] o,
		 input 	      r_n,
		 input 	      w_n);

   reg [7:0] ram[0:255];
   reg [7:0] d;
   
`ifdef debug
   integer    j;
   
   initial
     begin
	for (j = 0; j < 256; j = j + 1)
	  ram[j] = 0;
     end
`endif

   wire ram_read, ram_write;
   assign ram_read = ~r_n/*~cs & ~r_n*/;
   assign ram_write = ~w_n/*~cs & ~w_n*/;

   always @(posedge clk)
     if (ram_read)
       d <= ram[a];

   assign o = d;
   
   always @(posedge clk)
     if (ram_write)
       ram[a] <= i;
   
endmodule // ram_dp256x8
