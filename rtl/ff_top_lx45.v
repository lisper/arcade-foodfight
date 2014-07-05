//
// foodfight
// fpga top for pipistrello lx45 fpga board
// Brad Parker <brad@heeltoe.com> 5/2014
//

module ff_top_lx45(
		   wire [5:1] led,
		   wire       sysclk,
			      
		   wire       vga_hsync,
		   wire       vga_vsync,
		   wire       vga_r,
		   wire       vga_g,
		   wire       vga_b,
			      
		   wire       switch,
		   wire       button1,
		   wire       button2,
		   wire       button3,
			      
		   wire       tmds,
		   wire       tmdsb,
			      
		   wire       audio_l,
		   wire       audio_r
		   );


   ff_top ff_top(
		 .clk12m(),
		 .reset()
		 );
   
endmodule // ff_top_lx45
