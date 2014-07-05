
module ram_dp256x8(input rclk,
		   input 	wclk,
		   input [7:0] 	a,
		   input [7:0] 	i,
		   output [7:0] o,
		   input 	oe,
		   input 	r,
		   input 	w);

   reg [7:0] ram[0:255];
   reg [7:0] d;
   
`ifdef debug
   integer    j;
   
   initial
     begin
	for (j = 0; j < 256; j = j + 1)
	  ram[j] = 0;
     end

   wire ram_read;
   wire ram_write;
   assign ram_read = r/*~cs & w*/;
   assign ram_write = w/*~cs & ~w*/;

   always @(posedge rclk)
     if (ram_read)
       d <= ram[a];

   assign o = d;
   
   always @(posedge wclk)
     if (ram_write)
       ram[a] <= i;
`endif
   
endmodule // ram_dp256x8
