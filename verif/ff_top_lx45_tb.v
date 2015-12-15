//
//
//

`timescale 1ns/1ns

`ifndef ISIM
// `define use_vga
`endif

module ff_top_lx45_tb;

   reg clk_50m, clk_25m;

   wire [5:1] led;
   wire       vga_hsync;
   wire       vga_vsync;
   wire       vga_blank;
   wire       vga_r;
   wire       vga_g;
   wire       vga_b;
   wire [3:0] tmds, tmdsb;
   wire       audio_l, audio_r;
   
   wire	      sysclk;
   reg 	      switch;
   reg 	      button1, button2, button3;

   assign sysclk = clk_50m;
   
   ff_top_lx45 top (
		    .led(led),
		    .sysclk(sysclk),

		    .vga_hsync(vga_hsync),
		    .vga_vsync(vga_vsync),
		    .vga_blank(vga_blank),
		    .vga_r(vga_r),
		    .vga_g(vga_g),
		    .vga_b(vga_b),
		    
		    .switch(switch),
		    .button1(button1),
		    .button2(button2),
		    .button3(button3),
		    
		    .tmds(tmds),
		    .tmdsb(tmdsb),
		    
		    .audio_l(audio_l),
		    .audio_r(audio_r)
		    );

   always
     begin
        clk_50m = 1'b0;
        #10;
        clk_50m = 1'b1;
        #10;
     end

   initial
     clk_25m = 0;
   
   always @(posedge clk_50m)
     clk_25m <= ~clk_25m;

   initial
     begin
	clk_50m = 0;
	clk_25m = 0;
	
	switch = 0;
	button1 = 0;
	button2 = 0;
	button3 = 0;
	
       #500000000;
       $finish;
     end

`ifdef use_vga
   initial
     begin
	$cv_init_vga(800, 600);
     end

   wire [7:0] rgb8;
   wire [2:0] red, green, blue;

   assign red   = vga_r ? 3'b111 : 0;
   assign green = vga_g ? 3'b111 : 0;
   assign blue  = vga_b ? 3'b111 : 0;
   
   assign rgb8 = { red, green[1:0], blue };
   
   always @(posedge clk_25m)
     begin
	$cv_clk_vga(vga_vsync, vga_hsync, rgb8);
     end
`endif

endmodule
