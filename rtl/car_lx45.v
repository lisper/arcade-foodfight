
module car_lx45(
		input  sysclk,
		input  clk_vga,
		input  clk_cpu,
		input  clk_pix,
		input  dcm_reset,
		input  button,
		output clk6m,
		output clk12m,
		output clk25m,
		output reset
		);

   reg [15:0] r_count;

   always @(posedge sysclk)
     if (dcm_reset | button)
       r_count <= 16'd0;
     else
       if (r_count != 16'hffff)
	 r_count <= r_count + 16'd1;

`ifdef SIMULATION
   assign reset = r_count < 16'h00ff;
`else
   assign reset = r_count < 16'h0fff;
`endif

   assign clk6m  = clk_pix;
   assign clk12m = clk_cpu;
   assign clk25m = clk_vga;
   
endmodule
