//
// foodfight
// fpga top for pipistrello lx45 fpga board
// Brad Parker <brad@heeltoe.com> 5/2014
//

`ifndef ISIM
`define sound
`define hdmi
//`define color_orig
//`define color_2
`define color_2
`endif

module ff_top_lx45(
		   output [5:1]   led,
		   input 	  sysclk,
			      
		   output 	  vga_hsync,
		   output 	  vga_vsync,
		   output 	  vga_blank,
		   output 	  vga_r,
		   output 	  vga_g,
		   output 	  vga_b,
			      
		   input 	  switch,
		   input [10:0]   Wing_A_in,
		   input [6:0] 	  Wing_B_in,
		   output [15:11] Wing_A_out,
 	
		   output [3:0]   tmds,
		   output [3:0]   tmdsb,
			      
		   output 	  audio_l,
		   output 	  audio_r
		   );

   // -----
   
   wire sysclk_buf;
   BUFG sysclk_bufg (.I(sysclk), .O(sysclk_buf));

   wire dcm_reset;

   wire led1;
   wire led2;
   wire led3;
   wire [7:0] audio;
   wire       cga_hsync, cga_vsync, cga_blank;
   wire [7:0] cga_rgb;
   wire [11:0] sw;
   wire [8:1]  sw1;

   wire       clk_vga;
   wire       clk_cpu;
   wire       clk_pix;
   wire       reset;

   wire       sw_coin1, sw_coin2, sw_start1, sw_start2;
   wire       sw_coinaux, sw_throw1, sw_throw2, sw_test;
   wire       sw_js_l, sw_js_r, sw_js_u, sw_js_d;
   wire       auto_throw_n, auto_start_n, auto_coin_n;
   
`ifdef testing
   assign sw_coin1 = ~button1 & auto_coin_n;
   assign sw_coin2 = 1'b1;
   assign sw_start1 = ~button2 & auto_start_n;
   assign sw_start2 = 1'b1;
   assign sw_coinaux = 1'b1;
   assign sw_throw1 = ~button3 & auto_throw_n;
   assign sw_throw2 = 1'b1;
   assign sw_test = 1'b1;
   assign sw_js_l = 1'b0;
   assign sw_js_r = 1'b0;
   assign sw_js_u = 1'b0;
   assign sw_js_d = 1'b0;
`else
   assign sw_coin1 = Wing_A_in[0] & auto_coin_n;
   assign sw_coin2 = 1'b1;
   assign sw_start1 = Wing_A_in[1] & auto_start_n;
   assign sw_start2 = Wing_A_in[2];
   assign sw_coinaux = 1'b1;
   assign sw_throw1 = Wing_B_in[1] & auto_throw_n;
   assign sw_throw2 = 1'b1;
   assign sw_test = 1'b1;
   assign sw_js_l = Wing_A_in[3];
   assign sw_js_r = Wing_A_in[4];
   assign sw_js_u = Wing_A_in[5];
   assign sw_js_d = Wing_A_in[6];

   assign Wing_A_out[11] = led1;
   assign Wing_A_out[12] = led2;
   assign Wing_A_out[13] = led3;
   assign Wing_A_out[14] = reset;
   assign Wing_A_out[15] = switch;
`endif
   
   assign sw = { sw_js_d, sw_js_u, sw_js_r, sw_js_l,
		 sw_coin1, sw_coin2, sw_start1, sw_start2,
		 sw_coinaux, sw_throw1, sw_throw2, sw_test };

   assign sw1 = 8'hbf;

   assign led[1] = led1;
   assign led[2] = led2;
   assign led[3] = led3;
   assign led[4] = reset;
   assign led[5] = switch;

   wire hsync, vsync, blank;

   // video from scan converter
   wire [7:0] vga_rgb;
   wire [2:0] vga_rrr, vga_ggg, vga_bbb;

   // to hdmi
   assign vga_bbb = { vga_rgb[7], vga_rgb[6], 1'b0 };
   assign vga_ggg = { vga_rgb[5], vga_rgb[4], vga_rgb[3] };
   assign vga_rrr = { vga_rgb[2], vga_rgb[1], vga_rgb[0] };

   // to raw vga output
   assign vga_b = vga_rgb[7] | vga_rgb[6];
   assign vga_g = vga_rgb[5] | vga_rgb[4] | vga_rgb[3];
   assign vga_r = vga_rgb[2] | vga_rgb[1] | vga_rgb[0];

   wire clk6m, clk12m, clk25m;

   // game & cpu
   ff_top ff_top(
		 .clk12m(clk12m),
		 .clk6m(clk6m),
		 .reset(reset),
		 .led1(led1),
		 .led2(led2),
		 .led3(led3),
		 .hsync(cga_hsync),
		 .vsync(cga_vsync),
		 .blank(cga_blank),
		 .rgb(cga_rgb),
		 .audio(audio),
		 .sw(sw),
		 .sw1(sw1),
		 .clk_6mhz_o()
		 );

   // clocks and reset
   car_lx45 car(
		.sysclk(sysclk_buf),
		.clk_vga(clk_vga),
		.clk_cpu(clk_cpu),
		.clk_pix(clk_pix),
		.dcm_reset(dcm_reset),
		.button(switch),
		.reset(reset),
		.auto_coin_n(auto_coin_n),
		.auto_start_n(auto_start_n),
		.auto_throw_n(auto_throw_n),
		.clk6m(clk6m),
		.clk12m(clk12m),
		.clk25m(clk25m)
		);

   // cga -> vga
   scanconvert2_lx45 scanconv(
			      .clk6m(clk6m),
			      .clk12m(clk12m),
			      .clk25m(clk25m),
			      .reset(reset),
			      .hsync_i(cga_hsync),
			      .vsync_i(cga_vsync),
			      .blank_i(cga_blank),
			      .rgb_i(cga_rgb),
			      .hsync_o(vga_hsync),
			      .vsync_o(vga_vsync),
			      .blank_o(vga_blank),
			      .rgb_o(vga_rgb)
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
   assign audio_l = audio[1] | audio[4];
   assign audio_r = audio[1] | audio[4];
`endif

`ifdef hdmi
   //
   wire dvid_hsync, dvid_vsync, dvid_blank;
   wire [7:0] dvid_red;
   wire [7:0] dvid_green;
   wire [7:0] dvid_blue;
   reg [15:0]  reset_reg;

   // quick reset
   assign dcm_reset = reset_reg[15];
   initial reset_reg = 16'b1111_1111_1111_1111;
		     
   always @ (posedge sysclk_buf)
     reset_reg <= {reset_reg[14:0],1'b0};

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
`ifdef color_orig
   assign dvid_red   = (vga_rrr == 3'b0) ? 8'b0 : { vga_rrr, 5'b11111 };
   assign dvid_green = (vga_ggg == 3'b0) ? 8'b0 : { vga_ggg, 5'b11111 };
   assign dvid_blue  = (vga_bbb == 3'b0) ? 8'b0 : { vga_bbb, 5'b11111 };
`endif

`ifdef color_2
   assign dvid_red   = (vga_rrr == 3'b0) ? 8'b0 : { vga_rrr, 5'b01111 };
   assign dvid_green = (vga_ggg == 3'b0) ? 8'b0 : { vga_ggg, 5'b01111 };
   assign dvid_blue  = (vga_bbb == 3'b0) ? 8'b0 : { vga_bbb, 5'b01111 };
`endif
   
`ifdef color_3
   assign dvid_red   = (vga_rrr == 3'b0) ? 8'b0 : { vga_rrr, 5'b11000 };
   assign dvid_green = (vga_ggg == 3'b0) ? 8'b0 : { vga_ggg, 5'b11000 };
   assign dvid_blue  = (vga_bbb == 3'b0) ? 8'b0 : { vga_bbb, 5'b11000 };
`endif
   
   assign dvid_hsync = ~vga_hsync;
   assign dvid_vsync = ~vga_vsync;
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
		    .clk_pix(clk_pix),
		    .TMDS(tmds),
		    .TMDSB(tmdsb));
`else // !`ifdef hdmi

   wire       LOCKED;
   reg [15:0]  reset_reg;

   // quick reset
   assign dcm_reset = reset_reg[15];
   initial reset_reg = 16'b1111_1111_1111_1111;
		     
   always @ (posedge sysclk_buf)
     reset_reg <= {reset_reg[14:0],1'b0};

   wire [15:0] do_unused;
   wire        drdy_unused;
   wire        clkfbout;
   wire        clkout0, clkout1, clkout2;
   wire        clkout3_unused, clkout4_unused, clkout5_unused;

   // 50*12 = 600Mhz
   // 600Mhz / 24  = 25Mhz (clk_vga)
   // 600Mhz / 50  = 12MHz (clk_cpu)
   // 600Mhz / 100 = 6MHz  (clk_pix)
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

    .CLKOUT2_DIVIDE         (100),
    .CLKOUT2_PHASE          (0.000),
    .CLKOUT2_DUTY_CYCLE     (0.500),

    .CLKIN_PERIOD           (20.000),
    .REF_JITTER             (0.010))
  pll_base_inst
    // Output clocks
   (.CLKFBOUT              (clkfbout),
    .CLKOUT0               (clkout0),
    .CLKOUT1               (clkout1),
    .CLKOUT2               (clkout2),
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
   BUFG clkout2_buf (.O(clk_pix), .I(clkout2));

   // null drivers
   wire blue_s, green_s, red_s, clock_s;

   assign blue_s = 1'b0;
   assign green_s = 1'b0;
   assign red_s = 1'b0;
   assign clock_s = 1'b0;

   OBUFDS OBUFDS_blue  ( .O(tmds[0]), .OB(tmdsb[0]), .I(blue_s ) );
   OBUFDS OBUFDS_green ( .O(tmds[1]), .OB(tmdsb[1]), .I(green_s) );
   OBUFDS OBUFDS_red   ( .O(tmds[2]), .OB(tmdsb[2]), .I(red_s  ) );
   OBUFDS OBUFDS_clock ( .O(tmds[3]), .OB(tmdsb[3]), .I(clock_s) );

`endif
   
endmodule // ff_top_lx45
