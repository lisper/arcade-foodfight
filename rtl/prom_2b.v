//
//
//

module prom_2b(
	       input [7:0 ] 	a,
	       output reg [3:0] d,
	       input 		e1,
	       input 		e2
	       );

   always @(a or e1 or e2)
     case (a)
`include "../roms/v3/rom_2p.v"
     endcase
   
endmodule // prom_2b
