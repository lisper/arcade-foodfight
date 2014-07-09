
module car_lx45(
		input  sysclk,
		input  clk_vga,
		input  clk_cpu,
		input  dcm_reset,
		input  button,
		output clk12m,
		output clk25m,
		output reset
		);

   reg [15:0] r_count;

   always @(posedge sysclk)
     if (dcm_reset)
       r_count <= 16'd0;
     else
       if (r_count != 16'hffff)
	 r_count <= r_count + 16'd1;

   assign reset = r_count < 16'h00ff;

   assign clk12m = clk_cpu;
   assign clk25m = clk_vga;
   
endmodule
