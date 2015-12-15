//
//
//

module nvram_x2212(
		   input 	clk,
		   input [7:0] 	a,
		   input [3:0] 	i,
		   output [3:0] o,
		   input 	ce_n,
		   input 	rw_n,
		   input 	recall_n,
		   input 	update
		   );

   reg [3:0] ram[0:255];
   reg [3:0] d;
   
`ifdef SIMULATION
   integer    j;
   
   initial
     begin
	for (j = 0; j < 256; j = j + 1)
	  ram[j] = 4'b1111/*0*/;
     end

   always @(posedge clk)
       if (^ram[a] === 1'bX)
	 begin
	    $display("nvram: reading x's %b @ %x", ram[a], a);
	    $finish;
	 end

   always @(posedge clk)
     if (ce_n == 0 && rw_n == 0)
       if (^i === 1'bX)
	 begin
	    $display("nvram: writing x's %b @ %x", i, a);
	    $finish;
	 end
`endif
   
   assign o = d;

   always @(posedge clk)
     d <= ram[a];
   
   always @(posedge clk)
     if (ce_n == 0 && rw_n == 0)
       ram[a] <= i;

`ifdef async
   assign o = ram[a];

   always @(a or ce_n or rw_n or i)
     if (rw_n == 0 & ce_n == 0)
       ram[a] = i;
`endif
   
endmodule


