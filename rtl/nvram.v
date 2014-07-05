//
//
//

module nvram_x2212(
		   input [7:0] 	a,
		   input [3:0] 	i,
		   output [3:0] o,
		   input 	ce_n,
		   input 	rw_n,
		   input 	recall_n,
		   input 	update
		   );

   reg [3:0] ram[0:255];

//   assign o = 0;

`ifdef debug
   integer    j;
   
   initial
     begin
	for (j = 0; j < 256; j = j + 1)
	  ram[j] = 4'b1111/*0*/;
     end

   assign o = ram[a];

   always @(a or ce_n or rw_n)
     if (rw_n == 0 & ce_n == 0)
       ram[a] = i;
   
`endif
  
endmodule


