
module ram_moram(input 	       p1_clk,
		 input [7:0]   p1_a,
		 input [15:0]  p1_di,
		 input 	       p1_r,
		 input 	       p1_lw,
		 input 	       p1_uw,
		 input 	       p2_clk,
		 input [7:0]   p2_a,
		 input 	       p2_r,
		 output [15:0] p1_do,
		 output [15:0] p2_do
);

   wire [7:0] d1h, d1l, d2h, d2l;

   ram_dp256x8 ramh(.p1_clk(p1_clk),
		    .p1_a(p1_a),
		    .p1_di(p1_di[15:8]),
		    .p1_do(d1h),
		    .p1_r(p1_r),
		    .p1_w(p1_uw),
		    .p2_clk(p2_clk),
		    .p2_a(p2_a),
		    .p2_r(p2_r),
		    .p2_do(d2h));

   ram_dp256x8 raml(.p1_clk(p1_clk),
		    .p1_a(p1_a),
		    .p1_di(p1_di[7:0]),
		    .p1_do(d1l),
		    .p1_r(p1_r),
		    .p1_w(p1_lw),
		    .p2_clk(p2_clk),
		    .p2_a(p2_a),
		    .p2_r(p2_r),
		    .p2_do(d2l));
   
   assign p1_do = { d1h, d1l };
   assign p2_do = { d2h, d2l };
   
`ifdef never
   reg [7:0] ramh[0:255];
   reg [7:0] raml[0:255];
   reg [7:0] d1h, d1l, d2h, d2l;
   
`ifdef debug
   integer    j;
   
   initial
     begin
	for (j = 0; j < 256; j = j + 1)
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
`endif //  `ifdef never
   
endmodule
