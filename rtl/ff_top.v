//
// foodfight
// fpga top
// Brad Parker <brad@heeltoe.com> 5/2014
//

module ff_top(
	      input 	   clk12m,
	      input 	   reset,
	      output 	   led1,
	      output 	   led2,
	      output 	   hsync,
	      output 	   vsync,
	      output [7:0] rgb,
	      input [9:0]  sw,
	      input [8:1]  sw1
	      );

   ff ff(
	 .clk_12mhz(clk12m),
	 .reset(reset),
	 .test(sw[0]),
	 .throw2(sw[1]),
	 .throw1(sw[2]),
	 .coinaux(sw[3]),
	 .start2(sw[4]),
	 .start1(sw[5]),
	 .coin2(sw[6]),
	 .coin1(sw[7]),
	 .cntrr(sw[8]),
	 .cntrl(sw[9]),
	 .sw1(sw1),
	 .o_led1(led1),
	 .o_led2(led2),
	 .o_hsync(hsync),
	 .o_compsync(),
	 .o_vsync(vsync),
	 .o_rgb(rgb)
	 );
   
endmodule // ff_top
