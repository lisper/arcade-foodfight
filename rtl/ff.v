//
// food fight
// main rtl file
// Brad Parker <brad@heeltoe.com> 5/2014
//

`define m68k
//`define debug_color
//`define debug_force_pf
//`define debug_h
//`define debug_h_lines
//`define debug_stamps_color
//`define jam_pf
//`define normal_video_with_line
`define normal_video
`define orig_video_timing

module ff(
	  input        clk_12mhz,
	  input        clk_6mhz,
	  input        reset,
	  input        test,
	  input        throw2,
	  input        throw1,
	  input        coinaux,
	  input        start2,
	  input        start1,
	  input        coin2,
	  input        coin1,
	  input        js_l,
	  input        js_r,
	  input        js_u,
	  input        js_d,
	  input [8:1]  sw1, 
	  output       o_led1,
	  output       o_led2,
	  output       o_led3,
	  output       o_hsync,
	  output       o_compsync,
	  output       o_vsync,
	  output       o_blank,
	  output [7:0] o_rgb,
	  output [7:0] o_audio,
	  output       o_clk_6mhz
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

`ifdef m68k
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
   assign a = 24'b0;
   assign ud_out = 16'b0;
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
   wire [15:0] 	 pf_out_display;
   wire [15:0] 	 moram_out;

   //
   wire [15:0] 	 ba;
   wire 	 br_w_n;
   wire 	 r_w_u_n, r_w_l_n, r_n_w;
   wire 	 as;
   wire [7:0] 	 digital_out;
   wire [7:0] 	 pokey_out;
   wire [15:0] 	 analog_out;
   wire [3:0] 	 nvram_out;

   // cpu access
   reg 	u_n_v, u_v_n, u_n_v_d;

   wire rom0_n, rom1_n, rom2_n, rom3_n, ram0_n, ram1_n, objram_n;
   wire watchdog_n, coloram_n, digitalin_n, analogout_n, analogin_n;
   wire i_o_n, pf_n;

   // video timing
   reg vblank, vblank_n;
   reg vsync, vsync_n;
   reg vpreset, vpreset_n;

   reg int4rst_n;
   reg int3rst_n;

   wire       s_1v, s_2v, s_4v, s_8v, s_16v, s_32v, s_64v, s_128v;
   wire       s_1h, s_2h, s_4h, s_8h, s_16h, s_32h, s_64h, s_128h, s_256h;

   wire       s_6mhz;
   wire       s_6m_n;
   wire       s_6mhz_unbuf;
   wire       s_1h_n, s_2h_n, s_4h_n;
   wire [8:0] offset_h;
   reg [7:0]  counter_v;
   
   
   reg 	      hsync, hsync_clr_n;
   wire       hsync_clr;
   wire       compsync;
   wire       s_256h_n;
   wire       blank_n;

   // sync
   reg 	s_8h_d, s_32h_d, s_256h_n_d;
   wire s_8h_rise, s_32h_rise, s_256h_n_rise;
   
   // playfield
   wire [9:0] pfa_cpu;
   wire [9:0] pfa_display;
   wire       csu_n, csl_n;
   wire       s_4hf, s_4vf, s_2vf, s_1vf;
   wire       pfwr_n;
   
   reg [11:4] pf_rom_a;
   wire [7:0] pf_data;
   wire [12:0] pf_rom_addr;
   reg [7:0]   pf_shift;
   wire        pf_s0, pf_s1;
   wire [1:0] pfv_lower;
   reg [7:0]  pf_out_h_hold;
   reg [7:2]  pfv_hold;
   wire [7:0] pfv;
   
   // motion objects
   wire [7:0] moram_addr_cpu;
   wire [6:0] moram_addr_display;
   wire [15:0] mod;
   wire        lwr_n;
   wire        uwr_n;
   
   reg [8:1]   rom_addr_hold;
   reg [8:1]   rom_addr_hold_d;
   wire [12:0] rom_addr;
   wire        rom_addr_4;
   wire [15:0] rom_data;
   reg [15:0]  rom_shift;

   reg [12:0]  mo_rom_addr;

   reg [7:0]   p;
   reg 	       vflip;
   reg 	       hflip;
   reg 	       hflip_hold;
   reg 	       hflip_d;

   wire        regld, hload_n;
   wire        s_4y, s_3y, s_2y, s_1y;
   wire        s_x1, s_x0;
   wire [1:0]  evd;
   wire [1:0]  odd;
   wire        bg;

   wire        mo_romrd;
   
   // line buffers
   reg [15:8] mv_addr_hold;

   reg [7:0]  mv_addr_even;
   reg [7:0]  mv_addr_odd;

   wire [7:0] mv_odd;
   wire [7:0] mv_even;

   wire [7:0] mv;
   reg [7:0]  ov;

   // color ram
   reg [7:0] rgb;
   wire [7:0] rgb_addr_cpu;
   wire [7:0] rgb_addr_display;
   wire [7:0] rgb_cr_out;
   wire       coloramwr_n;

   // sound
   wire       vma;
   wire [7:0] audout;
   wire [5:0] audout0, audout1, audout2;


   // playfield
   wire        pf_obj_n;

   
   // i/o -> cpu
   assign ud_in =
		 ~membufen_n ? mb_out :
		 ~u_n_v ? pf_out :
		 ~objram_n ? moram_out :
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

//   always @(posedge s_32v or negedge int3rst_n)
//     if (~int3rst_n)
//       il3_n <= 1'b1;
//     else
//       il3_n <= 1'b0;

   reg s_32v_d;
   always @(posedge s_6mhz)
     if (reset)
       s_32v_d <= 0;
     else
       s_32v_d <= s_32v;

   wire s_32v_rising;
   assign s_32v_rising = ~s_32v_d & s_32v;

   always @(posedge s_6mhz)
     if (~int3rst_n)
       il3_n <= 1'b1;
     else
       if (s_32v_rising)
	 il3_n <= 1'b0;

   assign il3 = ~il3_n;
   assign il4 = ~il4_n;
   
// page 18 - sheet 5A

   reg counterr;
   reg counterl;
   reg led2;
   reg led1;
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
//   assign o_led3 = ~dtack_n;
   assign o_led3 = 1'b0;
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

//   assign s_6mhz_unbuf = counter_h[0];
   assign s_1h    = counter_h[1];
   assign s_2h    = counter_h[2];
   assign s_4h    = counter_h[3];
   assign s_8h    = counter_h[4];
   assign s_16h   = counter_h[5];
   assign s_32h   = counter_h[6];
   assign s_64h   = counter_h[7];
   assign s_128h  = counter_h[8];
   assign s_256h  = counter_h[9];

   assign s_1h_n = ~s_1h;
   assign s_2h_n = ~s_2h;
   assign s_4h_n = ~s_4h;

`ifdef SIMULATION
//   assign s_6mhz  = counter_h[0];
   assign s_6mhz = clk_6mhz;
   assign s_6mhz_unbuf = clk_6mhz;
`else
//   BUFG s_6mhz_bufg (.O(s_6mhz), .I(counter_h[0]));
   BUFG s_6mhz_bufg (.O(s_6mhz), .I(clk_6mhz));
   assign s_6mhz_unbuf = clk_6mhz;
`endif

   assign o_clk_6mhz = clk_6mhz;
     
   // debug
   assign offset_h = { s_256h, s_128h, s_64h, s_32h, s_16h, s_8h, s_4h, s_2h, s_1h };

   reg [9:0] h_state;
   wire [9:0] h_state_curr, h_state_next;
   assign h_state_curr = { s_256h, s_128h, s_64h, s_32h, s_16h, s_8h, s_4h, s_2h, s_1h, counter_h[0] };
   assign h_state_next = h_state_curr + 10'd1;

   always @(posedge clk_12mhz)
     if (reset)
       h_state <= 0;
     else
       h_state <= h_state_next;

   wire [3:0] s_state;
   assign s_state = h_state[3:0];
   
   //
   always @(negedge clk_12mhz)
     if (reset)
	 counter_v <= 0;
     else
//       if (vpreset)
//         counter_v <= 8'hdc;
//       else
	 if (s_256h_n_rise)
	   counter_v <= counter_v + 8'd1;
   
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
   
//   assign prom_2b_addr = { vblank, s_64v, s_32v, s_16v, s_8v, s_4v, s_2v, s_1v };
   assign prom_2b_addr = { s_128v, s_64v, s_32v, s_16v, s_8v, s_4v, s_2v, s_1v };
   
   prom_2b prom_2b(
		   .clk(clk_12mhz),
		   .a(prom_2b_addr),
		   .d(prom_out)
		   );

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
   assign mpuclk = s_6mhz;
`else
   // buffer?
   BUFG s_6m_n_bufg (.O(s_6m_n), .I(~s_6mhz_unbuf));
   BUFG mpuclk_bufg (.O(mpuclk), .I(s_6mhz_unbuf));
`endif

   assign blank_n = vblank_n & s_256h;

// page 25 - sheet 7A - playfield ram/rom

   assign pfa_cpu = ba[10:1];
   assign pfa_display = { s_128h, s_64h, s_32h, s_16h, s_8h, s_128v, s_64v, s_32v, s_16v, s_8v };
		
   assign csu_n = u_v_n ? 1'b0 : uds_n;
   assign csl_n = u_v_n ? 1'b0 : lds_n;

   assign s_4hf = s_4h ^ pfflip;
   assign s_4vf = s_4v ^ pfflip;
   assign s_2vf = s_2v ^ pfflip;
   assign s_1vf = s_1v ^ pfflip;

   assign pfwr_n = br_w_n | u_n_v_d;

//   ram_907036 chip_3n_3m(
//			 .clk(s_6mhz),
//			 .a(pfa),
//			 .cs_n(csu_n),
//			 .we_n(pfwr_n),
//			 .in(bd_out[15:8]),
//			 .out(pf_out[15:8])
//			 );
//
//   ram_907036 chip_3l_3k(
//			 .clk(s_6mhz),
//			 .a(pfa),
//			 .cs_n(csl_n),
//			 .we_n(pfwr_n),
//			 .in(bd_out[7:0]),
//			 .out(pf_out[7:0])
//			 );

   wire pfwr_u, pfwr_l;

   assign pfwr_u = ~pfwr_n & ~csu_n;
   assign pfwr_l = ~pfwr_n & ~csl_n;
   
   ram_pfram pfram(
		   .p1_clk(s_6mhz),
		   .p1_a(pfa_cpu),
		   .p1_di(bd_out),
		   .p1_do(pf_out),
		   .p1_r(~u_n_v),
		   .p1_uw(pfwr_u),
		   .p1_lw(pfwr_l),

		   .p2_clk(s_6mhz),
		   .p2_a(pfa_display),
		   .p2_r(1'b1),
		   .p2_do(pf_out_display));

//`define old_pf
`ifdef old_pf
   always @(posedge s_4h)
     if (reset)
       pf_out_h_hold <= 8'b0;
     else
       pf_out_h_hold <= pf_out_display[15:8];

   always @(posedge s_4h)
     if (reset)
       pf_rom_a[11:4] <= 8'b0;
     else
`ifndef jam_pf
       pf_rom_a[11:4] <= pf_out_display[7:0];
`else
//       pf_rom_a[11:4] <= 8'h21;
//       pf_rom_a[11:4] <= 8'h11;
//       pf_rom_a[11:4] <= 8'h01;
       pf_rom_a[11:4] <= { s_32v, s_16v, s_8v, s_128h, s_64h, s_32h, s_16h, s_8h };
`endif

`else

   reg s_4h_d;
   always @(posedge clk_12mhz)
     if (reset)
       s_4h_d <= 0;
     else
       s_4h_d <= s_4h;

   wire s_4h_rising;
   assign s_4h_rising = ~s_4h_d & s_4h;

   always @(posedge clk_12mhz)
     if (reset)
       pf_out_h_hold <= 8'b0;
     else
       if (s_4h_rising)
	 pf_out_h_hold <= pf_out_display[15:8];

   always @(posedge clk_12mhz)
     if (reset)
       pf_rom_a[11:4] <= 8'b0;
     else
       if (s_4h_rising)
`ifndef jam_pf
	 pf_rom_a[11:4] <= pf_out_display[7:0];
`else
         pf_rom_a[11:4] <= { s_32v, s_16v, s_8v, s_128h, s_64h, s_32h, s_16h, s_8h };
`endif
`endif
   
   //
   assign pf_rom_addr = { pf_out_h_hold[7], pf_rom_a, s_4hf, s_4vf, s_2vf, s_1vf };

   rom_6lm rom_6lm(
		   .clk(mpuclk),
		   .a(pf_rom_addr),
		   .d(pf_data)
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

   assign moram_addr_cpu = ba[8:1];
   assign moram_addr_display = { h_state[9:4], h_state[2] };

   reg [6:0] moram_addr_next;

   always @(posedge clk_12mhz)
     if (reset)
       moram_addr_next <= 0;
     else
       if (s_state[1:0] == 2'b10)
	 moram_addr_next <= (s_state[3:2] == 2'b11) ?
			    { moram_addr_display[6:1] + 6'd1, 1'b0 } :
			    { moram_addr_display[6:1]       , ~s_state[2] };
   
   assign lwr_n = r_w_l_n | objram_n;
   assign uwr_n = r_w_u_n | objram_n;

   wire moram_cs;
   assign moram_cs = s_state[1:0] == 2'b11;
   
   ram_moram moram(.p1_clk(s_6mhz),
		   .p1_a(moram_addr_cpu),
		   .p1_di(bd_out),
		   .p1_do(moram_out),
		   .p1_r(~objram_n),
		   .p1_lw(~lwr_n),
		   .p1_uw(~uwr_n),

		   .p2_clk(clk_12mhz),
   		   .p2_a({1'b0, moram_addr_next}),
		   .p2_r(moram_cs),
		   .p2_do(mod)
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

   always @(negedge s_6mhz)
     if (reset)
       begin
	  match <= 0;
	  ol_hold <= 0;
       end
     else
       // second half of s_2h=1 (mod = h,v)
       if (s_1h & s_2h)
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

   always @(posedge s_6mhz)
     if (reset)
       rom_addr_hold[8:1] <= 0;
     else
       if (~s_2h & s_4h)
	 rom_addr_hold[8:1] <= mod[7:0];

   assign rom_addr_4 = hflip ^ s_4h;
   assign rom_addr = { rom_addr_hold, rom_addr_4, ol[3:0] };

   always @(negedge clk_6mhz/*posedge clk_12mhz*/)
     if (reset)
       mo_rom_addr <= 0;
     else
       mo_rom_addr <= rom_addr;
   
   rom_136020_16 chip_4e4d(
		      .clk(clk_12mhz),
		      .a(mo_rom_addr),
		      .d(rom_data),
		      .ce(~mo_romrd),
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

   always @(posedge clk_12mhz)
     if (reset)
       begin
	  hflip <= 0;
	  vflip <= 0;
       end
     else
       if (s_state[3:0] == 4'b1000)
	 /*~s_1h & ~s_2h & s_4h*/
	 begin
	    hflip <= mod[15];
	    vflip <= mod[14];
	 end
   
   always @(negedge s_6mhz)
     if (reset)
       hflip_hold <= 0;
   else
       hflip_hold <= hflip;

   always @(negedge s_6mhz)
     if (reset)
       hflip_d <= 0;
   else
       hflip_d <= hflip_hold;

   always @(posedge clk_12mhz)
     if (reset)
       p <= 0;
     else
       if (s_state[3:0] == 4'b1010)
	 begin
	    // color (palette)
	    p[5:0] <= mod[13:8];
	 end

   reg [7:0] p_d;
   always @(negedge s_6mhz)
     if (reset)
       p_d <= 0;
     else
       p_d <= p;
   
   // little state machines to raise regld and hload for one cycle of 12mhz
   reg [1:0] regld_state;
   reg [1:0] hload_state;
   reg [1:0] regld_next;
   reg [1:0] hload_next;

   always @(regld_state or match or s_4h or s_2h or s_2h_n or s_1h or s_1h_n)
     begin
	regld_next = regld_state;

	case (regld_state)
	  2'b00:
	    if (match & s_2h_n & s_1h)
	      regld_next = 2'b01;
	  2'b01:
	      regld_next = 2'b10;
	  2'b10:
	    if ((s_4h & s_2h & s_1h) || (s_4h & s_2h_n & s_1h_n))
	      regld_next = 2'b00;
	  default:
	    regld_next = 2'b00;
	endcase
     end
		      
   always @(hload_state or match or s_4h or s_2h or s_2h_n or s_1h)
     begin
	hload_next = hload_state;

	case (hload_state)
	  2'b00:
	    if (match & s_2h_n & s_1h & s_4h)
	      hload_next = 2'b01;
	  2'b01:
	      hload_next = 2'b10;
	  2'b10:
	    if (s_4h & s_2h & s_1h)
	      hload_next = 2'b00;
	  default:
	    hload_next = 2'b00;
	endcase
     end
		      
   always @(posedge clk_12mhz)
     if (reset)
       regld_state <= 2'b0;
     else
       regld_state <= regld_next;
       
   always @(posedge clk_12mhz)
     if (reset)
       hload_state <= 2'b0;
     else
       hload_state <= hload_next;

   assign hload_n = ~hload_state[0];
   assign regld = regld_state[0];

   assign mo_romrd = ((s_1h & s_2h_n & s_4h) | (s_1h & s_2h_n & s_4h_n)) & ~s_6mhz;
   
//----------------

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
	    if (stamp_active_d)
	      begin
		 if (stamp_active_cnt == 15)
		   begin
		      stamp_active_cnt <= 0;
		      if (hload_n)
			stamp_active_d <= 0;
		   end
		 else
		   stamp_active_cnt <= stamp_active_cnt + 1;
	      end
	    else
	      if (~hload_n & blank_n)
		stamp_active_d <= 1;
       end

   assign stamp_active = stamp_active_d | (~hload_n & blank_n);
   
`endif
	      
// page 33-34 - line buffers

   always @(negedge s_6mhz)
     if (reset)
       mv_addr_hold[15:8] <= 0;
     else
       // falling edge of s_2h
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

   // dual port 256x8
   ram_line line_ram_odd(
			 .rclk(~evenclk),
			 .wclk(~oddclk),
			 .a(mv_addr_odd),
			 .i({p_d[5:0], odd[1:0]}),
			 .o(mv_odd),
			 .r(s_1vx),
			 .oe(s_1vx),
			 .w(~oddcs_n)
			 );

   ram_line line_ram_even(
			  .rclk(~oddclk),
			  .wclk(~evenclk),
			  .a(mv_addr_even),
			  .i({p_d[5:0], evd[1:0]}),
			  .o(mv_even),
			  .r(s_1vx_n),
			  .oe(s_1vx_n),
			  .w(~evencs_n)
			  );

   assign mv = s_1vx_n ? mv_even : mv_odd;

   always @(posedge s_6mhz/* or negedge s_256h*/)
     if (reset)
       ov <= 8'b0;
     else
       ov <= s_256h ? mv : 8'b0;
   
// page 35 - color ram

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
       rgb <= rgb_addr_display;       //debug
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
//       rgb <= rgb_addr_display != 0 ? 8'hff : 8'h00;
`endif

`ifdef normal_video_with_line
   always @(posedge s_6mhz or negedge blank_n)
     if (~blank_n | reset)
       rgb <= 8'b0;
     else
       if (counter_v == 8'hdf)
	 rgb <= 8'hff;
       else
	 rgb <= rgb_cr_out;
`endif
   
   assign coloramwr_n = coloram_n | r_w_l_n;

   assign rgb_addr_cpu = ba[8:1];
   assign rgb_addr_display = ~pf_obj_n ? {1'b0, ov[6:0]} : pfv[7:0];
   
   ram_coloram coloram(
		       .p1_clk(s_6mhz),
		       .p1_a(rgb_addr_cpu),
		       .p1_di(bd_out[7:0]),
		       .p1_do(),
		       .p1_r_n(coloram_n),
		       .p1_w_n(coloramwr_n),

		       .p2_clk(~clk_12mhz),
		       .p2_a(rgb_addr_display),
		       .p2_do(rgb_cr_out),
		       .p2_r_n(1'b0)
		       );

// page 37 - sound

// c0122294-01

   assign vma = ~vma_n;

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
		 .p(8'b0),
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
		 .p(8'b0),
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

   joystick joystick(.clk6m(s_6mhz),
		     .reset(reset),
		     .vblank(vblank),
		     .js_l(js_l),
		     .js_r(js_r),
		     .js_u(js_u),
		     .js_d(js_d),
		     .a(ba[2:1]),
		     .wr_n(analogout_n),
		     .rd_n(analogin_n),
		     .data_out(analog_out));
   
// page 40

`ifdef debug_stamps_color
   assign pf_obj_n = 0;
`else
 `ifdef debug_force_pf
   assign pf_obj_n = 1;
 `else
   assign pf_obj_n = ~ ( (ov[1] | ov[0]) & ~( ov[7] & (pfv[1] | pfv[0]) ) );
 `endif
`endif
   
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
   always @(negedge il4_n)
     begin
	$display("IPL: il4_n %b il3_n %b", il4_n, il3_n);
	$display("IPL: il4_n asserts");
     end

   always @(posedge il4_n)
     begin
	$display("IPL: il4_n %b il3_n %b", il4_n, il3_n);
	$display("IPL: il4_n deasserts");
     end

   always @(negedge il3_n)
     begin
	$display("IPL: il4_n %b il3_n %b", il4_n, il3_n);
	$display("IPL: il3_n asserts");	
     end

   always @(posedge il3_n)
     begin
	$display("IPL: il4_n %b il3_n %b", il4_n, il3_n);
	$display("IPL: il3_n deasserts");
     end

   always @(posedge vblank or posedge s_32v)
     begin
	if (0) $display("IPL: vblank_n=%b, s_32v=%b, int4rst_n=%b, int3rst_n=%b",
			vblank_n, s_32v, int4rst_n, int3rst_n);
     end
`endif


`define CHIPSCOPE_FF
//`define trig_cpu
   
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
`ifdef trig_cpu
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
`else // !`ifdef trig_cpu
		   s_6mhz,//1
		   objram_n,//1
		   lwr_n,//1
		   uwr_n,//1
		   bd_out,//16
		   moram_addr_cpu,//8
		   moram_addr_next,//7
		   mod,//16
		   match,//1
		   hload_n,//1
		   regld,//1
		   hflip,//1
		   vflip,//1
		   oddcs_n,//1
		   evencs_n,//1
		   p[7:0],//8
		   mv_addr_odd,//8
		   mv_addr_even//8
`endif
                   };

   chipscope_icon_ff icon0 (.CONTROL0(control0));
   chipscope_ila_ff ila0 (.CONTROL(control0), .CLK(clk_12mhz), .TRIG0(trig0));
`endif

`ifdef debug_rom   
   integer sc;

   initial
     sc = 0;

   //brad
   always @(negedge mpuclk)
     begin
	if ((~rom0_n) && (~uds_n | ~lds_n))
	  begin
	     sc = sc + 1;
	     if (sc == 2 && ba < 16'h8c)
	       $display("rom: read %x -> %x; pc=%x", ba, mb_out_rom, cpu.wf68k00ip_top.i_68k00.pc_out);
	  end
	else
	  sc = 0;
     end
`endif //  `ifdef debug_rom

`ifdef debug_cpu
   integer count = 0;
   
   always @(posedge s_6m_n)
     begin
	if (
	    cpu.wf68k00ip_top.i_68k00.fc_out_i == 6 &&
	    cpu.wf68k00ip_top.i_68k00.i_ctrl.exec_state == 1 &&
	    cpu.wf68k00ip_top.i_68k00.chk_pc_i
	    )
	  begin
	     if (cpu.wf68k00ip_top.i_68k00.pc_out == 32'h0000008c)
	       begin
		  count = count + 1;
		  
		  $display("%t; pc=%x d0=%x d1=%x d2=%x d3=%x d4=%x d5=%x d6=%x d7=%x",
			   $time,
			   cpu.wf68k00ip_top.i_68k00.pc_out,
			   cpu.wf68k00ip_top.i_68k00.i_datareg.dr[0],
			   cpu.wf68k00ip_top.i_68k00.i_datareg.dr[1],
			   cpu.wf68k00ip_top.i_68k00.i_datareg.dr[2],
			   cpu.wf68k00ip_top.i_68k00.i_datareg.dr[3],
			   cpu.wf68k00ip_top.i_68k00.i_datareg.dr[4],
			   cpu.wf68k00ip_top.i_68k00.i_datareg.dr[5],
			   cpu.wf68k00ip_top.i_68k00.i_datareg.dr[6],
			   cpu.wf68k00ip_top.i_68k00.i_datareg.dr[7]);

		  $display("                     a0=%x a1=%x a2=%x a3=%x a4=%x a5=%x a6=%x ssp=%x",
			   cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[0],
			   cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[1],
			   cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[2],
			   cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[3],
			   cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[4],
			   cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[5],
			   cpu.wf68k00ip_top.i_68k00.i_adrreg.ar[6],
			   cpu.wf68k00ip_top.i_68k00.i_adrreg.ssp);

		  if (count > 1)
		    begin
		       $finish;
		    end
		  end // if (pc == 0x8c)
	  end // if (...
     end // always @ (posedge s_6m_n)
`endif
   
endmodule // ff
