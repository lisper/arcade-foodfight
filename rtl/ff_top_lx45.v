//
// foodfight
// fpga top for pipistrello lx45 fpga board
// Brad Parker <brad@heeltoe.com> 5/2014
//

`define sound
//`define hdmi

module ff_top_lx45(
		   output [5:1] led,
		   input 	sysclk,
			      
		   output 	vga_hsync,
		   output 	vga_vsync,
		   output 	vga_blank,
		   output 	vga_r,
		   output 	vga_g,
		   output 	vga_b,
			      
		   input 	switch,
		   input 	button1,
		   input 	button2,
		   input 	button3,
			      
		   output [3:0] tmds,
		   output [3:0] tmdsb,
			      
		   output 	audio_l,
		   output 	audio_r
		   );

   // -----
   
   wire sysclk_buf;
   BUFG sysclk_bufg (.I(sysclk), .O(sysclk_buf));

   wire dcm_reset;

   wire led1;
   wire led2;
   wire [7:0] audio;
   wire [7:0] rgb;
   wire [2:9] vga_rrr, vga_ggg, vga_bbb;
   
   assign vga_rrr = { rgb[7], rgb[6], rgb[5] };
   assign vga_ggg = { rgb[4], rgb[3], 1'b0   };
   assign vga_bbb = { rgb[0], rgb[1], rgb[2] };

   assign vga_r = rgb[7] | rgb[6] | rgb[5];
   assign vga_g = rgb[4] | rgb[3];
   assign vga_b = rgb[0] | rgb[1] | rgb[2];
   
   wire [9:0] sw;
   wire [8:1] sw1;

   wire       clk_vga;
   wire       clk_cpu;
   wire       reset;

   assign sw = 0;
   assign sw1 = 0;

   assign led[1] = led1;
   assign led[2] = led2;
   
   ff_top ff_top(
		 .clk12m(clk12m),
		 .reset(reset),
		 .led1(led1),
		 .led2(led2),
		 .hsync(vga_hsync),
		 .vsync(vga_vsync),
		 .blank(vga_blank),
		 .rgb(rgb),
		 .audio(audio),
		 .sw(sw),
		 .sw1(sw1)
		 );

   car_lx45 car(
		.sysclk(sysclk_buf),
		.clk_vga(clk_vga),
		.clk_cpu(clk_cpu),
		.dcm_reset(dcm_reset),
		.button(button1),
		.reset(reset),
		.clk12m(clk12m),
		.clk25m()
		);
   
`ifdef sound
   //
   wire dac_o;
   
   ds_dac ds_output(.clk_i(sysclk_buf),
		    .res_i(reset),
		    .dac_i(audio),
		    .dac_o(dac_o)
		    );

   assign audio_l = dac_o;
   assign audio_r = dac_o;
`else
   assign audio_l = dac[1] | dac[4];
   assign audio_r = dac[1] | dac[4];
`endif

`ifdef hdmi
   //
   wire dvid_hsync, dvid_vsync, dvid_blank;
   wire [7:0] dvid_red;
   wire [7:0] dvid_green;
   wire [7:0] dvid_blue;
   reg [3:0]  reset_reg;

   // quick reset
   assign dcm_reset = reset_reg[3];
   initial reset_reg = 4'b1111;
		     
   always @ (posedge sysclk_buf)
     reset_reg <= {reset_reg[2:0],1'b0};

   //
   // 12mhz clock, 83ns
   // video counter; 0..16639
   // video addres
   // 11111
   // 432109876543210
   // xxxxxxxxxx1110x hsync 001e
   // x11111xxxxxxxxx vsync
   // 1xxxxxxxxxxxxxx mask
   // 011111100000000 mask

   // x11 111x xxxx xxxx vsync
   //
   // 111111000000000
   // 7  e   0   0	7300 32256
   // 100000011111111
   // 4  0   f   f      40ff 16639
   //
   //
   // 32 x 1000ns = 32us / line
   // 16640 x 1000ns = 16.640us / frame

   //
   assign dvid_red   = (vga_rrr == 3'b0) ? 8'b0 : { vga_rrr,   5'b11111 };
   assign dvid_green = (vga_ggg == 3'b0) ? 8'b0 : { vga_ggg, 5'b11111 };
   assign dvid_blue  = (vga_bbb == 3'b0) ? 8'b0 : { vga_bbb,  5'b11111 };
   
   assign dvid_hsync = vga_hsync;
   assign dvid_vsync = vga_vsync;
   assign dvid_blank = vga_blank;

   dvid_output hdmi(.clk50(sysclk_buf),
		    .reset(/*reset*/dcm_reset),
		    .reset_clk(dcm_reset),
		    .red(dvid_red),
		    .green(dvid_green),
		    .blue(dvid_blue),
		    .hsync(dvid_hsync),
		    .vsync(dvid_vsync),
		    .blank(dvid_blank),
		    .clk_vga(clk_vga),
		    .clk_cpu(clk_cpu),
		    .TMDS(tmds),
		    .TMDSB(tmdsb));
`else // !`ifdef hdmi

   wire       LOCKED;
   reg [3:0]  reset_reg;

   // quick reset
   assign dcm_reset = reset_reg[3];
   initial reset_reg = 4'b1111;
		     
   always @ (posedge sysclk_buf)
     reset_reg <= {reset_reg[2:0],1'b0};

   wire [15:0] do_unused;
   wire        drdy_unused;
   wire        clkfbout;
   wire        clkout2_unused, clkout3_unused, clkout4_unused, clkout5_unused;

   // 50*12 = 600Mhz
   // 600Mhz / 24 = 25Mhz (clk_vga)
   // 600Mhz / 50 = 12MHz (clk_cpu)
  PLL_BASE
  #(.BANDWIDTH              ("OPTIMIZED"),
    .CLK_FEEDBACK           ("CLKFBOUT"),
    .COMPENSATION           ("INTERNAL"),
    .DIVCLK_DIVIDE          (1),
    .CLKFBOUT_MULT          (12),
    .CLKFBOUT_PHASE         (0.000),

    .CLKOUT0_DIVIDE         (24),
    .CLKOUT0_PHASE          (0.000),
    .CLKOUT0_DUTY_CYCLE     (0.500),

    .CLKOUT1_DIVIDE         (50),
    .CLKOUT1_PHASE          (0.000),
    .CLKOUT1_DUTY_CYCLE     (0.500),

    .CLKIN_PERIOD           (20.000),
    .REF_JITTER             (0.010))
  pll_base_inst
    // Output clocks
   (.CLKFBOUT              (clkfbout),
    .CLKOUT0               (clkout0),
    .CLKOUT1               (clkout1),
    .CLKOUT2               (clkout2_unused),
    .CLKOUT3               (clkout3_unused),
    .CLKOUT4               (clkout4_unused),
    .CLKOUT5               (clkout5_unused),
    // Status and control signals
    .LOCKED                (LOCKED),
    .RST                   (dcm_reset),
     // Input clock control
    .CLKFBIN               (clkfbout),
    .CLKIN                 (sysclk_buf));

  BUFG clkout0_buf (.O(clk_vga), .I(clkout0));
  BUFG clkout1_buf (.O(clk_cpu), .I(clkout1));

`endif
   
endmodule // ff_top_lx45
