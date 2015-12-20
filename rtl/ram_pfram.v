
module ram_pfram(input 	       p1_clk,
		 input [9:0]   p1_a,
		 input [15:0]  p1_di,
		 input 	       p1_r,
		 input 	       p1_lw,
		 input 	       p1_uw,
		 input 	       p2_clk,
		 input [9:0]   p2_a,
		 input 	       p2_r,
		 output [15:0] p1_do,
		 output [15:0] p2_do
);

   reg [7:0] ramh[0:1023];
   reg [7:0] raml[0:1023];
   reg [7:0] d1h, d1l, d2h, d2l;
   
`ifdef debug
   integer    j;
   
   initial
     begin
	for (j = 0; j < 1024; j = j + 1)
	  begin
	     ramh[j] = 0;
	     raml[j] = 0;
	  end
     end
`endif

   // 16 bit read, individual 8 bit writes (uds, lds)
   always @(posedge p1_clk)
     if (p1_r)
       d1h <= ramh[p1_a];

   always @(posedge p1_clk)
     if (p1_r)
       d1l <= raml[p1_a];

   assign p1_do = { d1h, d1l };

   always @(posedge p1_clk)
     if (p1_uw)
       ramh[p1_a] <= p1_di[15:8];

   always @(posedge p1_clk)
     if (p1_lw)
       raml[p1_a] <= p1_di[7:0];

   // 16 bit read
   always @(posedge p2_clk)
     if (p2_r)
       d2h <= ramh[p2_a];

   always @(posedge p2_clk)
     if (p2_r)
       d2l <= raml[p2_a];

   assign p2_do = { d2h, d2l };
   
endmodule
