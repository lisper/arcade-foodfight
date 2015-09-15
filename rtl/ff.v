//
// food fight
// main rtl file
// Brad Parker <brad@heeltoe.com> 5/2014
//

`define cpu
//`define debug_color
//`define debug_force_pf
//`define debug_h
//`define debug_h_lines
//`define debug_stamps
//`define debug_stamps_color
`define normal_video
`define orig_video_timing

module ff(
	  input        clk_12mhz,
	  input        reset,
	  input        test,
	  input        throw2,
	  input        throw1,
	  input        coinaux,
	  input        start2,
	  input        start1,
	  input        coin2,
	  input        coin1,
	  input        cntrr,
	  input        cntrl,
	  input [8:1]  sw1, 
	  output       o_led1,
	  output       o_led2,
	  output       o_led3,
	  output       o_hsync,
	  output       o_compsync,
	  output       o_vsync,
	  output       o_blank,
	  output [7:0] o_rgb,
	  output [7:0] o_audio
	  );

// page 15 - sheet 4B

   wire mpuclk;
   wire [23:0] 	 a;
   wire [15:0] 	 ud_in;
   wire [15:0] 	 ud_out;
   wire 	 r_w_n;
   wire 	 uds_n;
   wire 	 lds_n;
   wire 	 as_n;
   wire 	 vpa_n;
   wire 	 vma_n;
   wire 	 avec_n;
   wire 	 mdtack_n;
   wire [2:0] 	 fc;
   wire 	 halt_n;
   wire 	 reset_n;
   wire 	 il3, il4;
   wire 	 e;

   reg 		 il3_n = 1;
   reg 		 il4_n = 1;

`ifdef cpu   
   mc68000 cpu(
	       .clk(mpuclk),
	       .reset_n(reset_n),
	       .a_out(a),
	       .d_in(ud_in),
	       .d_out(ud_out),
	       .ipl({1'b1, il4_n, il3_n}),
	       .bgack_n(1'b1),
	       .bg_n(),
	       .br_n(1'b1),
	       .dtack_n(mdtack_n),
	       .lds_n(lds_n),
	       .uds_n(uds_n),
	       .r_w_n(r_w_n),
	       .as_n(as_n),
	       .halt_n(halt_n),
	       .berr_n(1'b1),
	       .vpa_n(vpa_n),
	       .vma_n(vma_n),
	       .avec_n(avec_n),
	       .e(e),
	       .fc(fc)
	       );
`else // !`ifdef cpu
   assign a_out = 24'b0;
   assign d_out = 16'b0;
   assign bg_n = 1'b1;
   assign lds_n = 1'b1;
   assign uds_n = 1'b1;
   assign r_w_n = 1'b1;
   assign as_n = 1'b1;
   assign vma_n = 1'b1;
   assign e = 1'b0;
   assign fc = 0;
`endif
   
   assign reset_n = ~reset;
   assign halt_n = 1'b1;

   wire nvram_n, audio2_n, audio1_n, audio0_n, dtack_n, recall_n;
   reg 		 membufen_n;

   // cpu -> i/o
   wire [15:0] 	 bd_out;
   assign bd_out = ud_out;

   wire [15:0] 	 mb_out;
   wire [15:0] 	 pf_out;

   //
   wire [15:0] 	 ba;
   wire 	 br_w_n;
   wire 	 r_w_u_n, r_w_l_n, r_n_w;
   wire 	 as;
   wire [7:0] 	 digital_out;
   wire [7:0] 	 pokey_out;
   wire [15:0] 	 analog_out;
   wire [3:0] 	 nvram_out;

   // i/o -> cpu
   assign ud_in =
		 ~membufen_n ? mb_out :
		 ~u_n_v ? pf_out :
		 ~analogin_n ? analog_out :
		 ~audio0_n ? { 8'b0, pokey_out } :
		 ~digitalin_n ? { 8'b0, digital_out } :
		 ~nvram_n ? { 12'b0, nvram_out } :
		 16'b0;

   assign ba = { a[15:1], 1'b0 };
   assign br_w_n = r_w_n;
   
   assign r_w_u_n = r_w_n | uds_n;
   assign r_w_l_n = r_w_n | lds_n;
   assign r_n_w = ~br_w_n;
   assign as = ~as_n;

   assign mdtack_n = ~( ~dtack_n | ~u_n_v_d );

   always @(posedge mpuclk)
     if (reset)
       membufen_n <= 1'b0;
     else
       membufen_n <= as_n ? 1'b1 : a[23];

   //
   assign digital_out = { test, throw2, throw1, coinaux, start2, start1, coin2, coin1 };

   //
   always @(posedge vblank or negedge int4rst_n)
     if (~int4rst_n)
       il4_n <= 1'b1;
     else
       il4_n <= 1'b0;

   always @(posedge s_32v or negedge int3rst_n)
     if (~int3rst_n)
       il3_n <= 1'b1;
     else
       il3_n <= 1'b0;

   assign il3 = ~il3_n;
   assign il4 = ~il4_n;
   
// page 18 - sheet 5A

   reg counterr;
   reg counterl;
   reg led2;
   reg led1;
   reg int4rst_n;
   reg int3rst_n;
   reg update;
   reg pfflip;

   wire s_ctrl;
   assign s_ctrl = r_w_l_n | digitalin_n;
   
//   always @(posedge s_ctrl or posedge reset)
   always @(posedge mpuclk)
     if (reset)
       begin
     	  counterr <= 1'b0;
	  counterl <= 1'b0;
	  led2 <= 1'b0;
	  led1 <= 1'b0;
	  int4rst_n <= 1'b0;
	  int3rst_n <= 1'b0;
	  update <= 1'b0;
	  pfflip <= 1'b0;
       end
     else
if (~s_ctrl)
  begin
	  counterr <= bd_out[7];
	  counterl <= bd_out[6];
	  led2 <= bd_out[5];
	  led1 <= bd_out[4];
	  int4rst_n <= bd_out[3];
	  int3rst_n <= bd_out[2];
	  update <= bd_out[1];
	  pfflip <= bd_out[0];
       end

   assign o_led1 = led1;
   assign o_led2 = led2;
   assign o_led3 = ~dtack_n;
`ifdef orig_video_timing
   assign o_hsync = hsync;
`else
   assign o_hsync = hsync_new;
`endif
   assign o_vsync = vsync;
   assign o_blank = ~blank_n;
   assign o_compsync = compsync;
   assign o_rgb = rgb;


   //
   nvram_x2212 nvram(
		     .clk(mpuclk),
		     .a(ba[8:1]),
		     .i(bd_out[3:0]),
		     .o(nvram_out),
		     .ce_n(nvram_n),
		     .rw_n(br_w_n),
		     .recall_n(recall_n),
		     .update(update)
		     );

   
// page 19 - sheet 5B

   wire rom0_n, rom1_n, rom2_n, rom3_n, ram0_n, ram1_n, objram_n;
   wire watchdog_n, coloram_n, digitalin_n, analogout_n, analogin_n;
   wire i_o_n, pf_n;
   
   pal pal(
	   .as_n(as_n),
	   .a(a[23:18]),
	   .fc(fc[2:0]),
	   .nvram_n(nvram_n),
	   .i_o_n(i_o_n),
	   .audio2_n(audio2_n),
	   .pf_n(pf_n),
	   .audio1_n(audio1_n),
	   .audio0_n(audio0_n),
	   .dtack_n(dtack_n),
	   .vpa_n(vpa_n),
	   .avec_n(avec_n)
	   );

   assign rom0_n   = ~( as & ~a[23] & ~a[22] & ~a[16] & ~ba[15] & ~ba[14] );
   assign rom1_n   = ~( as & ~a[23] & ~a[22] & ~a[16] & ~ba[15] &  ba[14] );
   assign rom2_n   = ~( as & ~a[23] & ~a[22] & ~a[16] &  ba[15] & ~ba[14] );
   assign rom3_n   = ~( as & ~a[23] & ~a[22] & ~a[16] &  ba[15] &  ba[14] );
   //assign        = ~( as & ~a[23] & ~a[22] &  a[16] & ~ba[15] & ~ba[14] );
   assign ram0_n   = ~( as & ~a[23] & ~a[22] &  a[16] & ~ba[15] &  ba[14] );
   assign ram1_n   = ~( as & ~a[23] & ~a[22] &  a[16] &  ba[15] & ~ba[14] );
   assign objram_n = ~( as & ~a[23] & ~a[22] &  a[16] &  ba[15] &  ba[14] );

   assign watchdog_n   = ~( ~i_o_n &            a[16] &  ba[15] & ~ba[14] );
   assign recall_n     = ~( ~i_o_n &            a[16] & ~ba[15] &  ba[14] );
   assign coloram_n    = ~( ~i_o_n &            a[16] & ~ba[15] & ~ba[14] );
   //assign            = ~( ~i_o_n &           ~a[16] &  ba[15] &  ba[14] );
   assign digitalin_n  = ~( ~i_o_n &           ~a[16] &  ba[15] & ~ba[14] );
   assign analogout_n  = ~( ~i_o_n &           ~a[16] & ~ba[15] &  ba[14] );
   assign analogin_n   = ~( ~i_o_n &           ~a[16] & ~ba[15] & ~ba[14] );

// page 20 - sheet 5B

   reg 	u_n_v, u_v_n, u_n_v_d;
   
   always @(posedge s_4h or posedge as_n)
     if (as_n)
       begin
	  // async preset; jam output 1 when as=0
	  u_n_v <= 1;
	  u_v_n <= 0;
       end
     else
       begin
	  u_n_v <= pf_n;
	  u_v_n <= ~pf_n;
       end
   
   always @(posedge s_6mhz or posedge as_n)
     // async clr; jam output 0 (q#=1) when as=0
     if (as_n)
       u_n_v_d <= 1;
     else
       u_n_v_d <= ~u_v_n;

// page 21 - sheet 6A

   wire [15:0] 	 mb_out_rom;
   wire [15:0] 	 mb_out_ram;

   coderom16 coderom (
		     .clk(mpuclk),
		     .a(ba[13:1]),
		     .out(mb_out_rom),
		     .ce0(rom0_n),
		     .ce1(rom1_n),
		     .ce2(rom2_n),
		     .ce3(rom3_n)
		     );
   
   coderam coderam_h(
		     .clk(mpuclk),
		     .a(ba[13:1]),
		     .out(mb_out_ram[15:8]),
		     .in(bd_out[15:8]),
		     .cs(ram0_n & ram1_n),
		     .we(r_w_u_n)
		     );

   coderam coderam_l(
		     .clk(mpuclk),
		     .a(ba[13:1]),
		     .out(mb_out_ram[7:0]),
		     .in(bd_out[7:0]),
		     .cs(ram0_n & ram1_n),
		     .we(r_w_l_n)
		     );
   
   assign mb_out = (~ram0_n | ~ram1_n) ? mb_out_ram : mb_out_rom;

// page 23 - sheet 6B - sync

`ifdef orig_video_timing
   /* verilator lint_off UNOPTFLAT */
   reg [11:0] counter_h;
   /* verilator lint_on UNOPTFLAT */
   
   always @(posedge clk_12mhz)
     if (reset)
       counter_h <= 12'b1101_0000_0000;
     else
       begin
	  if (counter_h == 12'b1111_1111_1111)
	    counter_h <= 12'b1101_0000_0000;
	  else
	    counter_h <= counter_h + 12'd1;
       end
`else // !`ifdef never
 `define CNT_H_MAX 1023
   reg [11:0] cnt_h;
   always @(posedge clk_12mhz)
     if (reset)
       cnt_h <= 0;
     else
       if (cnt_h == `CNT_H_MAX)
	 cnt_h <= 0;
       else
	 cnt_h <= cnt_h + 12'd1;

   /* verilator lint_off UNOPTFLAT */
   reg [11:0] counter_h;
   /* verilator lint_on UNOPTFLAT */
   wire       counter_h_clr/*verilator public_flat_rd*/;
   wire       counter_h_counting/*verilator public_flat_rd*/;

   assign counter_h_clr = cnt_h < 256 || cnt_h > (256+`CNT_H_MAX);
   assign counter_h_counting = cnt_h >= 256 && cnt_h <= (256+`CNT_H_MAX);
   
   always @(posedge clk_12mhz)
     if (reset)
       counter_h <= 0;
     else
       if (counter_h_clr)
//	 counter_h <= { 11'b0, ~counter_h[0] };
//	 counter_h <= { 11'b001_0000_0000, ~counter_h[0] };
	 counter_h <= { 11'b000_1111_1000, ~counter_h[0] };
       else
	 if (counter_h_counting)
	   counter_h <= counter_h + 12'd1;

   wire       hsync_new_on;

   assign hsync_new_on = cnt_h >= 64 && cnt_h <= 128;

   reg hsync_new;
   
   always @(posedge clk_12mhz)
     if (reset)
       hsync_new <= 0;
     else
       hsync_new <= hsync_new_on;

`endif
   
   wire       s_6mhz, s_6m_n;
   wire       s_1h, s_2h, s_4h, s_8h, s_16h, s_32h, s_64h, s_128h, s_256h;

   wire       s_6mhz_unbuf;
   assign s_6mhz_unbuf = counter_h[0];
   
`ifdef SIMULATION
   assign s_6mhz  = counter_h[0];
`else
   BUFG s_6mhz_bufg (.O(s_6mhz), .I(counter_h[0]));
`endif
   assign s_1h    = counter_h[1];
   assign s_2h    = counter_h[2];
   assign s_4h    = counter_h[3];
   assign s_8h    = counter_h[4];
   assign s_16h   = counter_h[5];
   assign s_32h   = counter_h[6];
   assign s_64h   = counter_h[7];
   assign s_128h  = counter_h[8];
   assign s_256h  = counter_h[9];

   wire s_2h_n, s_4h_n;
   assign s_2h_n = ~s_2h;
   assign s_4h_n = ~s_4h;

   // debug
   wire [8:0] offset_h;
   assign offset_h = { s_256h, s_128h, s_64h, s_32h, s_16h, s_8h, s_4h, s_2h, s_1h };

   //
   reg [7:0]  counter_v;
   
   always @(negedge clk_12mhz)
     if (reset)
	 counter_v <= 0;
     else
       if (~vpreset_n)
	 counter_v <= 8'hdf/*8'hdc*/;
       else
	 if (s_256h_n_rise)
	   counter_v <= counter_v + 8'd1;
   
   wire       s_1v, s_2v, s_4v, s_8v, s_16v, s_32v, s_64v, s_128v;

   assign s_1v    = counter_v[0];
   assign s_2v    = counter_v[1];
   assign s_4v    = counter_v[2];
   assign s_8v    = counter_v[3];
   assign s_16v   = counter_v[4];
   assign s_32v   = counter_v[5];
   assign s_64v   = counter_v[6];
   assign s_128v  = counter_v[7];

   //
   wire [7:0] prom_2b_addr;
   wire [3:0] prom_out;
   
   assign prom_2b_addr = { vblank, s_64v, s_32v, s_16v, s_8v, s_4v, s_2v, s_1v };
   
   prom_2b prom_2b(
		   .clk(clk_12mhz),
		   .a(prom_2b_addr),
		   .d(prom_out),
		   .e1(1'b0),
		   .e2(1'b0)
		   );

   reg vblank, vblank_n;
   reg vsync, vsync_n;
   reg vpreset, vpreset_n;

//   always @(posedge s_256h_n or negedge s_128v)
   always @(negedge clk_12mhz)
     if (~s_128v | ~reset_n)
       begin
	  vblank <= 1'b0;
	  vblank_n <= 1'b1;
	  vsync <= 1'b0;
	  vsync_n <= 1'b1;
	  vpreset <= 1'b0;
	  vpreset_n <= 1'b1;
       end
     else
       if (s_256h_n/*_rise*/)
       begin
	  vblank    <=  prom_out[2];
	  vblank_n  <= ~prom_out[2];
	  vsync     <=  prom_out[1];
	  vsync_n   <= ~prom_out[1];
	  vpreset   <=  prom_out[0];
	  vpreset_n <= ~prom_out[0];
       end
   
// page 24 - sheet 6B - sync

   //
   reg 	s_8h_d, s_32h_d, s_256h_n_d;
   wire s_8h_rise, s_32h_rise, s_256h_n_rise;
   
   always @(posedge s_6mhz)
     if (~reset_n)
       begin
	  s_8h_d <= 0;
	  s_32h_d <= 0;
	  s_256h_n_d <= 0;
       end
     else
       begin
	  s_8h_d <= s_8h;
	  s_32h_d <= s_32h;
	  s_256h_n_d <= s_256h_n;
       end
   
   assign s_8h_rise = ~s_8h_d & s_8h;
   assign s_32h_rise = ~s_32h_d & s_32h;
   assign s_256h_n_rise = ~s_256h_n_d & s_256h_n;

   //
   reg hsync, hsync_clr_n;
   wire hsync_clr;
   wire compsync;
   wire s_256h_n;
   wire blank_n;
   
   always @(posedge s_6mhz/*clk_12mhz*/)
     if (reset)
       hsync_clr_n <= 1'b1;
     else
       if (s_256h)
	 hsync_clr_n <= 1'b0;
       else
	 if (s_32h_rise)
	   hsync_clr_n <= ~s_64h;

   assign hsync_clr = ~hsync_clr_n;

   always @(posedge s_6mhz/*clk_12mhz*/)
     if (hsync_clr)
       hsync <= 1'b0;
     else
       if (s_8h_rise)
	 hsync <= s_32h;

   assign s_256h_n = 1'b1 ^ s_256h;   
   
   assign compsync = hsync ^ vsync;

`ifdef SIMULATION
   assign s_6m_n = ~s_6mhz;
   assign mpuclk = ~s_6mhz;
`else
   // buffer?
   BUFG s_6m_n_bufg (.O(s_6m_n), .I(~s_6mhz_unbuf));
   BUFG mpuclk_bufg (.O(mpuclk), .I(~s_6mhz_unbuf));
`endif

   assign blank_n = vblank_n & s_256h;

// page 25 - sheet 7A - playfield ram/rom

   wire [9:0] pfa;
   wire csu_n, csl_n;
   wire s_4hf, s_4vf, s_2vf, s_1vf;
   wire pfwr_n;
   
   assign pfa = u_v_n ?
		{ ba[10:1] } :
		{ s_128h, s_64h, s_32h, s_16h, s_8h, s_128v, s_64v, s_32v, s_16v, s_8v };

   assign csu_n = u_v_n ? 1'b0 : uds_n;
   assign csl_n = u_v_n ? 1'b0 : lds_n;

   assign s_4hf = s_4h ^ pfflip;
   assign s_4vf = s_4v ^ pfflip;
   assign s_2vf = s_2v ^ pfflip;
   assign s_1vf = s_1v ^ pfflip;

   assign pfwr_n = br_w_n | u_n_v_d;

   ram_907036 chip_3n_3m(
			 .clk(s_6mhz),
			 .a(pfa),
			 .cs_n(csu_n),
			 .we_n(pfwr_n),
			 .in(bd_out[15:8]),
			 .out(pf_out[15:8])
			 );

   ram_907036 chip_3l_3k(
			 .clk(s_6mhz),
			 .a(pfa),
			 .cs_n(csl_n),
			 .we_n(pfwr_n),
			 .in(bd_out[7:0]),
			 .out(pf_out[7:0])
			 );

   reg [11:4] pf_rom_a;
   wire [7:0] pf_data;
   wire [12:0] pf_rom_addr;
   reg [7:0]   pf_shift;
   wire        pf_s0, pf_s1;
   wire [1:0] pfv_lower;
   reg [7:0]  pf_out_h_hold;
   reg [7:2]  pfv_hold;
   wire [7:0] pfv;
   
   
   always @(posedge s_4h)
     if (reset)
       pf_out_h_hold <= 8'b0;
     else
       pf_out_h_hold <= pf_out[15:8];

   always @(posedge s_4h)
     if (reset)
       pf_rom_a[11:4] <= 8'b0;
     else
       pf_rom_a[11:4] <= pf_out[7:0];

   assign pf_rom_addr = { pf_out_h_hold[7], pf_rom_a, s_4hf, s_4vf, s_2vf, s_1vf };

   rom_6lm rom_6lm(
		   .clk(s_6m_n),
		   .a(pf_rom_addr),
		   .d(pf_data),
		   .ce(1'b0),
		   .oe(1'b0)
		   );

   always @(posedge s_6mhz)
     if (reset)
       pf_shift <= 8'b0;
     else
       case ({pf_s1, pf_s0})
	 2'b00: pf_shift <= pf_shift;
	 2'b01: pf_shift <= {1'b0, pf_shift[7:1]};
	 2'b10: pf_shift <= {pf_shift[6:0], 1'b0};
	 2'b11: pf_shift <= pf_data;
       endcase

   assign pf_s0 = ~pfflip ? (s_2h & s_1h) : 1'b1;
   assign pf_s1 = ~pfflip ? 1'b1 : (s_2h & s_1h);

   assign pfv_lower[0] = ~pfflip ? pf_shift[7] : pf_shift[4];
   assign pfv_lower[1] = ~pfflip ? pf_shift[3] : pf_shift[0];

   always @(posedge s_4h_n)
     if (reset)
       pfv_hold[7:2] <= 0;
     else
       pfv_hold[7:2] <= pf_out_h_hold[5:0];

   assign pfv = { pfv_hold, pfv_lower };
   
// page 28 - sheet 7B - motion object ram

   wire [6:0] moram_addr;
   wire [15:0] mod;
   wire        lwr_n;
   wire        uwr_n;
   
   assign moram_addr = objram_n ?
		       {s_256h, s_128h, s_64h, s_32h, s_16h, s_8h, s_2h} :
		       ba[7:1];

   assign lwr_n = lds_n | (~objram_n ? br_w_n : 1'b1);
   assign uwr_n = uds_n | (~objram_n ? br_w_n : 1'b1);

   ram_137250 chip_6c(
		      .clk(s_6mhz),
		      .a({1'b0, moram_addr}),
		      .i(bd_out[15:12]),
		      .d(mod[15:12]),
		      .cs2(1'b1),
		      .cs1(1'b0),
		      .w(uwr_n),
		      .oe(1'b0)
		      );


   ram_137250 chip_6d(
		      .clk(s_6mhz),
		      .a({1'b0, moram_addr}),
		      .i(bd_out[11:8]),
		      .d(mod[11:8]),
		      .cs2(1'b1),
		      .cs1(1'b0),
		      .w(uwr_n),
		      .oe(1'b0)
		      );

   ram_137250 chip_6e(
		      .clk(s_6mhz),
		      .a({1'b0, moram_addr}),
		      .i(bd_out[7:4]),
		      .d(mod[7:4]),
		      .cs2(1'b1),
		      .cs1(1'b0),
		      .w(lwr_n),
		      .oe(1'b0)
		      );

   ram_137250 chip_6f(
		      .clk(s_6mhz),
		      .a({1'b0, moram_addr}),
		      .i(bd_out[3:0]),
		      .d(mod[3:0]),
		      .cs2(1'b1),
		      .cs1(1'b0),
		      .w(lwr_n),
		      .oe(1'b0)
		      );


// page 29 - sheet 8A - vertical position

   wire [7:0] sum;
   wire       match_v;
   reg 	      s_1vx;
   /* verilator lint_off UNOPTFLAT */
   reg 	      s_1vx_n;
   /* verilator lint_on UNOPTFLAT */
   wire       clk_1vx;

   
   assign sum = {s_128v, s_64v, s_32v, s_16v, s_8v, s_4v, s_2v, s_1v} + mod[7:0];
   assign match_v = sum[7] & sum[6] & sum[5] & sum[4];

//   assign clk_1vx = s_6mhz & s_1h & s_2h_n & s_4h;
//
//   always @(posedge clk_1vx)
//     if (reset)
//       begin
//	  s_1vx <= 0;
//	  s_1vx_n <= 0;
//       end
//     else
//       begin
//	  s_1vx <= s_1v;
//	  s_1vx_n <= ~s_1v;
//       end

   always @(posedge s_6mhz)
     if (reset)
       begin
	  s_1vx <= 0;
	  s_1vx_n <= 0;
       end
     else
       if (s_1h & s_2h_n & s_4h)
	 begin
	    s_1vx <= s_1v;
	    s_1vx_n <= ~s_1v;
	 end

// page 30 - sheet 8A - vertical position

   wire [3:0] ol;
   reg [3:0]  ol_hold;
   reg 	      match;
   wire       oddld_n, oddclr_n, evenclr_n, evenld_n;
   wire       oddclk, evencs_n, oddcs_n, evenclk;

   assign ol = {vflip, vflip, vflip, vflip} ^ ol_hold;

//   always @(posedge s_2h_n)
//     if (reset)
//       begin
//	  match <= 0;
//	  ol_hold <= 0;
//       end
//     else
//       begin
//	  match <= match_v;
//	  ol_hold <= sum[3:0];
//       end
   always @(posedge s_6m_n)
     if (reset)
       begin
	  match <= 0;
	  ol_hold <= 0;
       end
     else
       if (s_2h/* & ~s_4h*/)
	 begin
	    match <= match_v;
	    ol_hold <= sum[3:0];
	 end

   // s_1vx == 0 -> write odd line, read even line
   // s_1vx == 1 -> write even line, read odd line
   assign oddld_n   = ~s_1vx ? hload_n : 1'b1;
   assign oddclr_n  = ~s_1vx ? 1'b1 : s_256h;

   assign evenld_n  = ~s_1vx ? 1'b1 : hload_n;
   assign evenclr_n = ~s_1vx ? s_256h : 1'b1;

   assign oddcs_n  = ~s_1vx_n ? s_256h_n : bg;
   assign evencs_n = ~s_1vx_n ? bg : s_256h_n;

`ifdef SIMULATION   
   assign oddclk   = ~s_1vx_n ? s_6m_n : clk_12mhz;
   assign evenclk  = ~s_1vx_n ? clk_12mhz : s_6m_n;
`else
   BUFGMUX oddclk_bufg  (.O(oddclk),  .S(~s_1vx_n), .I1(s_6m_n),    .I0(clk_12mhz));
   BUFGMUX evenclk_bufg (.O(evenclk), .S(~s_1vx_n), .I1(clk_12mhz), .I0(s_6m_n));
`endif

// page 31 - motion object rom

   reg [8:1] rom_addr_hold;
   reg [8:1] rom_addr_hold_d;
   wire [12:0] rom_addr;
   wire        rom_addr_4;
   wire [15:0] rom_data;
   reg [15:0]  rom_shift;

   always @(posedge s_6mhz/*s_6m_n*/)
     if (reset)
       rom_addr_hold[8:1] <= 0;
     else
       if (~s_2h & s_1h)
	 rom_addr_hold[8:1] <= mod[7:0];

   always @(posedge s_6mhz)
     if (reset)
       rom_addr_hold_d <= 0;
     else
       if (s_2h & s_1h)
	 rom_addr_hold_d <= rom_addr_hold;

   assign rom_addr_4 = hflip ^ s_4h;
   assign rom_addr = { rom_addr_hold_d, rom_addr_4, ol[3:0] };

   rom_136020_16 chip_4e4d(
		      .clk(clk_12mhz),
		      .a(rom_addr),
		      .d(rom_data),
		      .ce(1'b0),
		      .oe(1'b0)
		      );

   //
   wire [1:0] s1s0;
   assign s1s0 = {s_3y, s_4y};
   
   always @(posedge clk_12mhz)
     if (reset)
       rom_shift <= 16'b0;
     else
       case (s1s0)
	 2'b00: rom_shift <= rom_shift;
	 2'b01: rom_shift <= {rom_shift[14:8], 1'b0, rom_shift[6:0], 1'b0};
	 2'b10: rom_shift <= {1'b0, rom_shift[15:9], 1'b0, rom_shift[7:1]};
	 2'b11: rom_shift <= rom_data;
       endcase
   
// page 32

   reg [7:0]   p;
   reg 	       vflip;
   reg 	       hflip;
   reg 	       hflip_d;

   wire regld, hload_n;
   wire s_4y, s_3y, s_2y, s_1y;
   wire s_x1, s_x0;
   wire [1:0] evd;
   wire [1:0] odd;
   wire bg;
   

//   always @(posedge s_2h)
   always @(posedge s_6m_n)
     if (reset)
       begin
	  hflip <= 0;
	  vflip <= 0;
       end
     else
       if (~s_2h & s_4h)
       begin
	  hflip <= mod[15];
	  vflip <= mod[14];
       end

   always @(posedge clk_12mhz)
     if (reset)
       begin
	  p <= 0;
	  hflip_d <= 0;
       end
     else
       if (~hload_n)
	 begin
	    p[5:0] <= mod[13:8];
	    hflip_d <= hflip;
	 end

   assign regld = match & s_2h_n & s_1h & s_6mhz_unbuf;
   assign hload_n = ~(s_4h & regld);

   assign s_4y = hflip_d ? regld : 1'b1;
   assign s_3y = hflip_d ? 1'b1 : regld;
   assign s_2y = hflip_d ? rom_shift[0] : rom_shift[7];
   assign s_1y = hflip_d ? rom_shift[8] : rom_shift[15];

   assign s_x1 = vblank_n & s_1vx;
   assign s_x0 = vblank_n & s_1vx_n;

   assign evd[1] = s_x1 & s_2y;
   assign evd[0] = s_x1 & s_1y;

   assign bg = ~(s_1y | s_2y);

   assign odd[1] = s_x0 & s_2y;
   assign odd[0] = s_x0 & s_1y;

`ifdef debug
   reg stamp_active_d;
   reg [3:0] stamp_active_cnt;
   wire stamp_active;
   
   always @(posedge clk_12mhz)
     if (reset)
       begin
	  stamp_active_d <= 0;
	  stamp_active_cnt <= 0;
       end
     else
       begin
	  if (~hload_n & blank_n)
	    stamp_active_d <= 1;
	  else
	    if (stamp_active_d)
	      if (stamp_active_cnt == 15)
		begin
		   stamp_active_d <= 0;
		   stamp_active_cnt <= 0;
		end
	      else
		stamp_active_cnt <= stamp_active_cnt + 1;
       end

   assign stamp_active = stamp_active_d | (~hload_n & blank_n);
   
`endif
	      
// page 33-34 - line buffers

   reg [15:8] mv_addr_hold;

   reg [7:0]  mv_addr_even;
   reg [7:0]  mv_addr_odd;

   wire [7:0] mv_odd;
   wire [7:0] mv_even;

   wire [7:0] mv;
   reg [7:0] ov;


//   always @(posedge s_2h_n)
//     if (reset)
//       mv_addr_hold[15:8] <= 0;
//     else
//       mv_addr_hold[15:8] <= mod[15:8];
   always @(posedge s_6m_n)
     if (reset)
       mv_addr_hold[15:8] <= 0;
     else
       if (s_2h)
	 mv_addr_hold[15:8] <= mod[15:8];
   
   always @(posedge oddclk)
     if (reset)
       mv_addr_odd <= 0;
     else
       if (~oddld_n)
	 mv_addr_odd <= mv_addr_hold;
       else
	 // sync clear - 74S163
	 if (~oddclr_n)
	   mv_addr_odd <= 8'b0;
	 else
	   mv_addr_odd <= mv_addr_odd + 8'd1;
       
   always @(posedge evenclk)
     if (reset)
       mv_addr_even <= 0;
     else
       if (~evenld_n)
	 mv_addr_even <= mv_addr_hold;
       else
	 // sync clear - 74S163
	 if (~evenclr_n)
	   mv_addr_even <= 8'b0;
	 else
	   mv_addr_even <= mv_addr_even + 8'd1;

   assign mv = s_1vx_n ? mv_even : mv_odd;

   // dual port 256x8
   ram_dp256x8 line_ram_odd(
			    .rclk(~evenclk),
			    .wclk(~oddclk),
			    .a(mv_addr_odd),
			    .i({p[5:0], odd[1:0]}),
			    .o(mv_odd),
			    .r(s_1vx),
			    .oe(s_1vx),
			    .w(~oddcs_n)
			    );

   ram_dp256x8 line_ram_even(
			     .rclk(~oddclk),
			     .wclk(~evenclk),
			     .a(mv_addr_even),
			     .i({p[5:0], evd[1:0]}),
			     .o(mv_even),
			     .r(s_1vx_n),
			     .oe(s_1vx_n),
			     .w(~evencs_n)
			     );

   always @(posedge s_6mhz/* or negedge s_256h*/)
     if (reset)
       ov <= 8'b0;
     else
       ov <= s_256h ? mv : 8'b0;
   
// page 35 - color ram

   reg [7:0] rgb;
   wire [7:0] rgb_addr;
   wire [7:0] rgb_cr_out;
   wire       coloramwr_n;

`ifdef debug_h
   always @(posedge s_6mhz or negedge blank_n)
     if (reset)
       rgb <= 8'b0;
     else
       if (~blank_n)
	 rgb <= 8'hff;
       else
	 rgb <= ({ s_128h, s_64h, s_32h, s_16h, s_8h } < 5'h10) ? /* rgb_cr_out*/ 8'h0f : 8'hf0;
`endif

`ifdef debug_color
   always @(posedge s_6mhz or negedge blank_n)
     if (~blank_n | reset)
       rgb <= 8'b0;
     else
       rgb <= rgb_addr;       //debug
`endif

`ifdef debug_h_lines
   always @(posedge s_6mhz or negedge blank_n)
     if (/*~blank_n |*/ reset)
       rgb <= 8'b0;
     else
       rgb <=
(blank_n == 0) ? 8'h07 :
(s_256h == 0) ? 8'h1c :
hsync ? 8'hff :
//	     counter_h_clr ? (counter_v == 0 ? 8'hf0 :
//			      vblank ? 8'hc0 :
//			      8'hff) :
//	     vblank ? 8'h0 :
//	     cnt_h < (256+16) ? 8'h0 :
//	     cnt_h > (256+511+16) ? 8'h0 :
	     rgb_cr_out;
`endif

`ifdef normal_video
   always @(posedge s_6mhz or negedge blank_n)
     if (~blank_n | reset)
       rgb <= 8'b0;
     else
       rgb <= rgb_cr_out;
`endif

`ifdef debug_stamps_color
   always @(posedge s_6mhz or negedge blank_n)
     if (~blank_n | reset)
       rgb <= 8'b0;
     else
       rgb <= rgb_cr_out != 0 ? 8'hff : 8'h00;
//       rgb <= rgb_addr != 0 ? 8'hff : 8'h00;
`endif
   
   assign coloramwr_n = coloram_n | r_w_l_n;

   assign rgb_addr =
		    ~coloram_n ? ba[8:1] :
		    ~vcrsel_n ? (~pf_obj_n ? {1'b0, ov[6:0]} : pfv[7:0]) :
		    8'b0;

//`define async_line_ram
`ifdef async_line_ram
   ram_93422 chip_7p(
		.a(rgb_addr),
		.i(bd_out[7:4]),
		.d(rgb_cr_out[7:4]),
		.cs2(1'b1),
		.cs1(1'b0),
		.oe(1'b0),
		.w(coloramwr_n)
		);

   ram_93422 chip_7n(
		.a(rgb_addr),
		.i(bd_out[3:0]),
		.d(rgb_cr_out[3:0]),
		.cs2(1'b1),
		.cs1(1'b0),
		.oe(1'b0),
		.w(coloramwr_n)
		);
`else
   ram_256x8 chip_7n7p(
		       .clk(~clk_12mhz),
		       .a(rgb_addr),
		       .i(bd_out[7:0]),
		       .o(rgb_cr_out),
		       .r_n(1'b0),
		       .w_n(coloramwr_n)
		       );
`endif
   
// page 37 - sound

// c0122294-01

   wire       vma;
   assign vma = ~vma_n;

   wire [7:0] audout;
   wire [5:0] audout0, audout1, audout2;

   assign audout = {2'b0, audout0} + {2'b0, audout1} + {2'b0, audout2};
   assign o_audio = audout;
   
   pokey pokey_2(
		 .phi2(e),
		 .reset(reset),
		 .r_w_n(br_w_n),
		 .cs0_n(vma),
		 .cs1_n(audio2_n),
		 .a(ba[4:1]),
		 .d_in(bd_out[7:0]),
		 .d_out(),
		 .p(),
		 .aud(audout2)
		 );

   pokey pokey_1(
		 .phi2(e),
		 .reset(reset),
		 .r_w_n(br_w_n),
		 .cs0_n(vma),
		 .cs1_n(audio1_n),
		 .a(ba[4:1]),
		 .d_in(bd_out[7:0]),
		 .d_out(),
		 .p(),
		 .aud(audout1)
		 );

   pokey pokey_0(
		 .phi2(e),
		 .reset(reset),
		 .r_w_n(br_w_n),
		 .cs0_n(vma),
		 .cs1_n(audio0_n),
		 .a(ba[4:1]),
		 .d_in(bd_out[7:0]),
		 .d_out(pokey_out),
		 .p(sw1),
		 .aud(audout0)
		 );


// page 38

// analogout_n drive STRT on ADC0809
// analogin enables LS244 -> bd[7:0]
   
   assign analog_out = 16'b0;
   
// page 40

   wire        pf_obj_n;
   wire        vcrsel_n;

`ifdef debug_stamps_color
   assign pf_obj_n = 0;
`else
 `ifdef debug_force_pf
   assign pf_obj_n = 1;
 `else
   assign pf_obj_n = ~ ( (ov[1] | ov[0]) & ~( ov[7] & (pfv[1] | pfv[0]) ) );
 `endif
`endif
   
   assign vcrsel_n = ~coloram_n;

`ifdef debug_pf
   always @(negedge pfwr_n)
     begin
	if (~pfwr_n/* & (~csl_n | ~csu_n)*/)
	  begin
	     $display("pf: write %x (%x) <- %x", pfa, a, bd_out);
	  end

	if (~watchdog_n && 0)
	  $display("watchdog: write %x", a);
     end

   always @(negedge uds_n or negedge lds_n)
     begin
	if (pfwr_n & (~csl_n | ~csu_n) && ~pf_n && (~uds_n | ~lds_n))
	  begin
	     $display("pf: read %x (%x) -> %x", pfa, a, pf_out);
	  end
     end
`endif

`ifdef debug_objram
   always @(posedge mpuclk)
     begin
	if (~lwr_n | ~uwr_n)
	  $display("objram: write %x <- %x", moram_addr, bd_out);
     end
`endif

`ifdef debug
   always @(posedge mpuclk)
     begin
	if (nvram_n == 0 && br_w_n == 0)
	  $display("nvram: write a=%x d=%x", ba[8:1], bd_out[3:0]);
//	if (nvram_n == 0 && br_w_n == 1)
//	  $display("nvram: read a=%x d=%x", ba[8:1], nvram_out);
	if (recall_n == 0)
	  $display("nvram: recall_n");
//	if (update)
//	  $display("nvram: update");
     end
`endif
   
`ifdef debug
   always @(negedge uds_n or negedge lds_n)
     begin
	if (~digitalin_n & r_w_l_n && a != 24'h948000)
	  $display("digital: read %x -> %x (%x); select %b", a, ud_in, digital_out, ~(~r_n_w | digitalin_n));
	if (~digitalin_n & ~r_w_l_n)
	  $display("digital: write %x <- %x (%x)", a, ud_out, bd_out);
     end

`ifdef debug_color_all
   always @(posedge mpuclk)
     begin
	if (~coloramwr_n)
	  $display("color: write %x <- %x", rgb_addr, bd_out);
     end
`endif

   always @(posedge mpuclk)
     if (~s_ctrl)
       $display("control: in=%x; %t", bd_out, $time);

   always @(negedge vma or negedge audio0_n)
     if (~vma && ~audio0_n)
       $display("pokey0: a=%x, in=%x out=%x r_w_n=%b %t", a[4:1], bd_out[7:0], pokey_out, br_w_n, $time);
   
   always @(negedge vma or negedge audio1_n)
     if (~vma && ~audio1_n)
       $display("pokey1: a=%x, in=%x %t", a[4:1], bd_out[7:0], $time);
   
   always @(negedge vma or negedge audio2_n)
     if (~vma && ~audio2_n)
       $display("pokey2: a=%x, in=%x %t", a[4:1], bd_out[7:0], $time);
   
`endif //  `ifdef debug

`ifdef debug_ram   
//   always @(negedge mpuclk)
   always @(posedge uds_n or posedge lds_n)
     begin
	if ((~ram0_n | ~ram1_n) && (~r_w_u_n | ~r_w_l_n) /*&& (~uds_n | ~lds_n)*/)
	  $display("ram: write %x <- %x (%b%b); pc=%x",
		   ba, bd_out, ~r_w_u_n, ~r_w_l_n, cpu.wf68k00ip_top.i_68k00.pc_out);
     end

//   always @(negedge mpuclk)
   always @(posedge uds_n or posedge lds_n)
     begin
	if ((~ram0_n | ~ram1_n) && (r_w_u_n & r_w_l_n) /*&& (~uds_n | ~lds_n)*/)
	  $display("ram: read %x -> %x; pc=%x", ba, mb_out_ram, cpu.wf68k00ip_top.i_68k00.pc_out);
     end
`endif
   
`ifdef debug_ram   
//   always @(negedge ram0_n or negedge ram1_n)
//     always @(ram0_n or ram1_n or r_w_u_n or r_w_l_n or uds_n or lds_n)
   always @(posedge uds_n or posedge lds_n)
     begin
	if ((~ram0_n | ~ram1_n) | (~r_w_u_n | ~r_w_l_n)) 
	  $display("ram: a=%x ba=%x out=%x in=%x ramx_n=%b%b r_w=%b%b ds=%b%b; pc=%x",
		   a, ba, bd_out, mb_out_ram,
		   ram0_n, ram1_n,
		   r_w_u_n, r_w_l_n,
		   uds_n, lds_n,
		   cpu.wf68k00ip_top.i_68k00.pc_out);
     end
`endif //  `ifdef debug_ram

`ifdef debug
   always @(negedge il4_n or negedge il3_n)
     begin
	$display("IPL: il4_n %b il3_n %b", il4_n, il3_n);
	if (il4_n == 0) $display("IPL: il4_n asserts");
	if (il3_n == 0) $display("IPL: il3_n asserts");	
     end

   always @(posedge il4_n or posedge il3_n)
     begin
	$display("IPL: il4_n %b il3_n %b", il4_n, il3_n);
	if (il4_n == 1) $display("IPL: il4_n deasserts");
	if (il3_n == 1) $display("IPL: il3_n deasserts");	
     end

   always @(posedge vblank_n or posedge s_32v)
     begin
	if (0) $display("IPL: vblank_n=%b, s_32v=%b, int4rst_n=%b, int3rst_n=%b",
			vblank_n, s_32v, int4rst_n, int3rst_n);
     end
`endif


//`define CHIPSCOPE_FF

`ifdef __CVER__
 `ifdef CHIPSCOPE_FF
  `undef CHIPSCOPE_FF
 `endif
`endif

`ifdef SIMULATION
 `ifdef CHIPSCOPE_FF
  `undef CHIPSCOPE_FF
 `endif
`endif
   
`ifdef CHIPSCOPE_FF
   // chipscope
   wire [35:0] control0;
   wire [82:0] trig0;
   wire        mclk_en;
   wire        mclk;
        
   assign trig0 = {
		   mpuclk,//1
		   reset_n,//1
		   uds_n,//1
		   lds_n,//1
		   r_w_n,//1
		   as_n,//1
		   mdtack_n,//1

		   rom0_n, //1
		   rom1_n, //1
		   rom2_n, //1
		   rom3_n, //1
		   mb_out_rom,//16

		   ud_in,//16
		   ud_out,//16
		   a //24
                   };

   chipscope_icon_ff icon0 (.CONTROL0(control0));
   chipscope_ila_ff ila0 (.CONTROL(control0), .CLK(clk_12mhz), .TRIG0(trig0));
`endif

endmodule // ff
