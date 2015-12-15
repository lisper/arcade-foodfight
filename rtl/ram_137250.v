//
//
//
module ram_137250(
		  input        clk,
		  input [7:0]  a,
		  input [3:0]  i,
		  output [3:0] d,
		  input        cs,
		  input        w,
		  input        oe
		 );

   reg [3:0] ram[0:255];
   reg [3:0] data;
   
`ifdef debug
   integer    j;
   
   initial
     begin
	for (j = 0; j < 256; j = j + 1)
	  ram[j] = 0;
     end
`endif

   assign d = data;

   always @(posedge clk)
     if (cs == 0)
       data <= ram[a];

   always @(posedge clk)
     if (w == 0)
       ram[a] <= i;
   
`ifdef async
   assign d = ram[a];

   always @(a or cs2 or cs1 or w)
     if (w == 0)
       ram[a] = i;
   
`endif
   
endmodule // ram_137250

  