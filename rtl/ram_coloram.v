
module ram_coloram(input        p1_clk,
		   input [7:0] 	p1_a,
		   input [7:0] 	p1_di,
		   output [7:0] p1_do,
		   input 	p1_r_n,
		   input 	p1_w_n,

		   input 	p2_clk,
		   input [7:0] 	p2_a,
		   input 	p2_r_n,
		   output [7:0] p2_do);
   

   reg [7:0] ram[0:255];
   reg [7:0] d1, d2;
   
`ifdef debug
   integer    j;
   
   initial
     begin
	for (j = 0; j < 256; j = j + 1)
	  ram[j] = 0;
     end
`endif

   always @(posedge p1_clk)
     if (~p1_r_n)
       d1 <= ram[p1_a];

   assign p1_do = d1;
   
   always @(posedge p1_clk)
     if (~p1_w_n)
       ram[p1_a] <= p1_di;

   always @(posedge p2_clk)
     if (~p2_r_n)
       d2 <= ram[p2_a];

   assign p2_do = d2;
   
endmodule
