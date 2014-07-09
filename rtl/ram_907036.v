//
//
//
module ram_907036(
		  input        clk,
		  input [9:0]  a,
		  input [7:0]  in,
		  output [7:0] out,
		  input        cs_n,
		  input        we_n
		  );

   reg [7:0] ram[0:1023];
   reg [7:0] data;
   
`ifdef debug
   integer    i;
   
   initial
     begin
	for (i = 0; i < 1024; i = i + 1)
	  ram[i] = 0;
     end
`endif

   assign out = data;

   always @(posedge clk)
     data <= ram[a];

   always @(posedge clk)
     if (we_n == 0)
       ram[a] <= in;

`ifdef async
   assign out = ram[a];

   always @(a or we_n or in)
     if (we_n == 0)
       ram[a] = in;   
`endif

endmodule // ram_907036

