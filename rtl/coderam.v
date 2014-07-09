//
// foodfight
// code sram
// Brad Parker <brad@heeltoe.com> 5/2014
//

module coderam(
	       input        clk,
	       input [12:0] a,
	       output [7:0] out,
	       input [7:0]  in,
	       input 	    cs,
	       input 	    we
	       );

   reg [7:0] ram[0:8191];
   reg [7:0] d;

`ifdef debug
   integer    i;
   initial
     begin
	for (i = 0; i < 8192; i = i + 1)
	  ram[i] = 0;
     end
`endif

   assign out = d;

   always @(posedge clk)
     d <= ram[a];
   
   always @(posedge clk)
     if (cs == 0 && we == 0)
       ram[a] <= in;
   
`ifdef async
   assign out = ram[a];

   always @(a or cs or we)
     if (cs == 0 && we == 0)
       ram[a] = in;
`endif
   
   
endmodule // coderam
