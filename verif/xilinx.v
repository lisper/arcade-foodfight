//

module OBUFDS(output O, output OB, input I);
   assign O = I;
   assign OB = ~I;
endmodule

module BUFG(output O, input I);
   assign O = I;
endmodule

module BUFGMUX(output O, input S, input I1, input I0);
   assign O = S ? I1 : I0;
endmodule

module PLL_BASE(	
		output CLKFBOUT,
		output CLKOUT0,
		output CLKOUT1,
		output CLKOUT2,
		output CLKOUT3,
		output CLKOUT4,
		output CLKOUT5,
		output LOCKED,
		input  RST,
		input  CLKFBIN,
		input  CLKIN
			);

   parameter BANDWIDTH = 0;
   parameter CLK_FEEDBACK = 0;
   parameter COMPENSATION = 0;
   parameter DIVCLK_DIVIDE = 0;
   parameter CLKFBOUT_MULT = 0;
   parameter CLKFBOUT_PHASE = 0;

   parameter CLKOUT0_DIVIDE = 0;
   parameter CLKOUT0_PHASE = 0;
   parameter CLKOUT0_DUTY_CYCLE = 0;

   parameter CLKOUT1_DIVIDE = 0;
   parameter CLKOUT1_PHASE = 0;
   parameter CLKOUT1_DUTY_CYCLE = 0;

   parameter CLKOUT2_DIVIDE = 0;
   parameter CLKOUT2_PHASE = 0;
   parameter CLKOUT2_DUTY_CYCLE = 0;

   parameter CLKIN_PERIOD = 0;
   parameter REF_JITTER = 0;

   assign CLKOUT0 = CLKIN;
   assign CLKOUT1 = CLKIN;
   assign CLKOUT2 = CLKIN;

endmodule
