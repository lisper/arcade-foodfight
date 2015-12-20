
module joystick(
		input clk6m,
		input reset,
		input js_l,
		input js_r,
		input js_u,
		input js_d,
		input [1:0] a,
		input wr_n,
		input rd_n,
		output [15:0] data_out
		);

   assign data_out = 0;

endmodule