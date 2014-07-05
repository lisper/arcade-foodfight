//
//
//

module ff_top_lx45_tb;

   wire [5:1] led;
   wire       vga_hsync;
   wire       vga_vsync;
   wire       vga_r;
   wire       vga_g;
   wire       vga_b;
   wire [3:0] tmds, tmdsb;
   wire       audio_l, audio_r;
   
   reg 	      sysclk;
   reg 	      switch;
   reg 	      button1, button2, button3;
		
   ff_top_lx45 top (
		    .led(led),
		    .sysclk(sysclk),

		    .vga_hsync(vga_hsync),
		    .vga_vsync(vga_vsync),
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
        sysclk = 1'b0;
        #10;
        sysclk = 1'b1;
        #10;
     end

   initial
     begin
	switch = 0;
	button1 = 0;
	button2 = 0;
	button3 = 0;
	
       #500000000;
       $finish;
     end
	  
endmodule
