//
//
//

//`define color_bars
//`define color_bars_sync
`define unchanged
//`define doubler

module scanconvert_lx45(
			input 	     clk6m,
			input 	     clk12m,
			input 	     reset,
			input 	     hsync_i,
			input 	     vsync_i,
			input 	     blank_i,
			input [7:0]  rgb_i,
			output 	     hsync_o,
			output 	     vsync_o,
			output 	     blank_o,
			output [7:0] rgb_o
			);

`ifdef color_bars_sync
   reg 	     hsync_i_d, vsync_i_d;
   wire      hsync_i_fall, vsync_i_fall;
   wire      hsync_i_rise, vsync_i_rise;

   always @(posedge clk6m)
     if (reset)
       begin
	  hsync_i_d <= 0;
	  vsync_i_d <= 0;
       end
     else
       begin
	  hsync_i_d <= hsync_i;
	  vsync_i_d <= vsync_i;
       end

   assign hsync_i_rise = ~hsync_i_d & hsync_i;
   assign vsync_i_rise = ~vsync_i_d & vsync_i;

   assign hsync_i_fall = hsync_i_d & ~hsync_i;
   assign vsync_i_fall = vsync_i_d & ~vsync_i;

   reg [10:0] hcnt;
   reg [10:0] vcnt;
   wire      hsync;
   wire      vsync;

   //
   always @(posedge clk6m)
     if (reset)
       begin
	  vcnt <= 0;
	  hcnt <= 0;
       end
     else
       begin
//	  if (hsync_i_fall) $display("hsync_i_fall, hcnt %d", hcnt);
	  if (vsync_i_fall) $display("vsync_i_fall, vcnt %d", vcnt);
	  
	  if (hsync_i_fall)
	    hcnt <= 188;
	  else
	    if (hcnt == /*189*/191)
	      hcnt <= 0;
	    else
	      hcnt <= hcnt + 11'd1;

	  if (vsync_i_fall)
	    vcnt <= 0;
	  else
	    if (hcnt == /*189*/191)
	      vcnt <= vcnt + 11'd1;
       end
   
   assign hsync = (hcnt > 164 & hcnt < 188);
   assign vsync = (vcnt == 508 | vcnt == 509);

   assign hsync_o = ~hsync;
   assign vsync_o = ~vsync;
   assign blank_o = 1'b0;

   wire [7:0] bars;
   assign bars = hcnt;
//   assign rgb_o = bars/* | rgb_i*/ | rgb_i;
   assign rgb_o = (hcnt < 16) ? bars :
		  (hcnt > 191-32) ? bars :
		  (vcnt < 32) ? bars :
		  (vcnt > 500) ? bars :
		  rgb_i;
`endif

`ifdef color_bars
   reg [10:0] hcnt;
   reg [10:0] vcnt;
   wire      hsync;
   wire      vsync;

   //
   always @(posedge clk6m)
     if (reset)
       begin
	  vcnt <= 0;
	  hcnt <= 0;
       end
     else
       begin
	  if (hcnt == 189)
	    begin
	       hcnt <= 0;

	       if (vcnt == 544)
		 vcnt <= 0;
	       else
		 vcnt <= vcnt + 11'd1;
	    end
	  else
	    hcnt <= hcnt + 11'd1;
       end
   
   assign hsync = (hcnt > 160 & hcnt < 188);
   assign vsync = (vcnt > 530 & vcnt < 534);

   assign hsync_o = ~hsync;
   assign vsync_o = ~vsync;
   assign blank_o = 1'b0;

   wire [7:0] bars;
   assign bars = hcnt;
   assign rgb_o = bars;
`endif
   
`ifdef unchanged
   reg 	     hsync_i_d, vsync_i_d;
   wire      hsync_i_fall, vsync_i_fall;

   reg [10:0] hcnt;
   reg [10:0] vcnt;
   wire       hsync;
   wire       vsync;

   //
   // output is 2x hsync rate of input
   //
   // input	--l0-- --l1-- --l2-- --l3-- ...
   // output	xx-xx- l0-l0- l1-l1- l2-l2- ...
   //
   always @(posedge clk6m)
     if (reset)
       begin
	  hsync_i_d <= 0;
	  vsync_i_d <= 0;
       end
     else
       begin
	  hsync_i_d <= hsync_i;
	  vsync_i_d <= vsync_i;
       end

   assign hsync_i_fall = hsync_i_d & ~hsync_i;
   assign vsync_i_fall = vsync_i_d & ~vsync_i;

   //
   always @(posedge clk6m)
     if (reset)
       begin
	  hcnt <= 0;
	  vcnt <= 0;
       end
     else
       begin
	  if (hsync_i_fall)
	    hcnt <= 188;
	  else
	    if (hcnt == 191)
	      hcnt <= 0;
	    else
	      hcnt <= hcnt + 10'd1;

	  if (vsync_i_fall)
	    vcnt <= 0;
	  else
	    if (hcnt == 191)
	      vcnt <= vcnt + 11'd1;
       end
   
   assign hsync = (hcnt > 164 & hcnt < 188);
   assign vsync = (vcnt == 508 | vcnt == 509);

   assign hsync_o = ~hsync;
   assign vsync_o = ~vsync;
   assign blank_o = 1'b0;

   wire [7:0] bars;
   assign bars = hcnt[7:0];
		
   assign rgb_o = (hcnt < 16) ? bars :
		  (hcnt > 191-32) ? bars :
		  (vcnt < 40) ? bars :
		  (vcnt > 500) ? bars :
		  rgb_i;

`endif
		 
`ifdef doubler
   reg 	     hsync_i_d, vsync_i_d;
   wire      hsync_i_fall, vsync_i_fall;

   reg [10:0] icount;
   reg [10:0] hcount;
   reg [10:0] vcount;
   wire       hsync;
   wire       vsync;

   reg [7:0]  line[0:1023];

   wire [9:0] w_addr;
   wire [9:0] r_addr;
   
   wire       oline, iline;
   wire [7:0] w_data;
   reg [7:0]  rgb_data;

   
   //
   // output is 2x hsync rate of input
   //
   // input	--l0-- --l1-- --l2-- --l3-- ...
   // output	xx-xx- l0-l0- l1-l1- l2-l2- ...
   //
   always @(posedge clk12m)
     if (reset)
       begin
	  hsync_i_d <= 0;
	  vsync_i_d <= 0;
       end
     else
       begin
	  hsync_i_d <= hsync_i;
	  vsync_i_d <= vsync_i;
       end

   assign hsync_i_fall = hsync_i_d & ~hsync_i;
   assign vsync_i_fall = vsync_i_d & ~vsync_i;

   //
   always @(posedge clk12m)
     if (reset)
       begin
	  icount <= 0;
	  hcount <= 0;
	  vcount <= 11'h7ff;
       end
     else
       begin
	  if (hsync_i_fall/*hcount == 382*/ && blank_i)
	    icount <= 0;
	  else
	    icount <= icount + 10'd1;
	  
	  if (hsync_i_fall)
	    hcount <= 376;
	  else
	    if (hcount == 382)
	      hcount <= 0;
	    else
	      hcount <= hcount + 10'd1;

	  if (vsync_i_fall)
	    vcount <= 11'h7ff; // we want vcount == 0 after first hsync_i
	  else
	    if (hcount == 382)
	      vcount <= vcount + 11'd1;
       end
   
   assign hsync = (hcount > 328 & hcount < 376);
   assign vsync = (vcount == 508 | vcount == 509);

   assign hsync_o = ~hsync;
   assign vsync_o = ~vsync;
   assign blank_o = 1'b0;

   wire [7:0] bars;
   assign bars = hcount[7:0];
		
//   assign rgb_o = (hcount < 16*2) ? bars :
///*		  (hcount > (191-32)*2) ? bars : */
//		  (vcount < 40) ? bars :
//		  (vcount > 500) ? bars :
//		  rgb_data;

//assign rgb_o = rgb_data;

assign rgb_o = (hcount < 16) ? bars :
	       (hcount > 376) ? bars :
	       rgb_data;

   // -------
   
   assign iline = vcount[1];
   assign oline = ~vcount[1];

   assign w_addr = { iline, icount[9:1] };
//   assign r_addr = { oline, hcount[7:0] };
   assign r_addr = { oline, hcount[8:0] };

   always @(posedge clk12m)
     if (reset)
       rgb_data <= 8'b0;
     else
       begin
	  line[w_addr] <= rgb_i;
	  rgb_data <= line[r_addr];
       end
`endif
   
endmodule
