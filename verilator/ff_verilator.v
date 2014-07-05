//
// top end ff for verilator
//

`define sdl_display

module ff_verilator;

   wire CLK;
   wire clk25;
   wire clk12;
   wire reset;
   
   wire       hsync;
   wire       vsync;
   wire [7:0] rgb;
   
   wire       led1;
   wire       led2;
   wire [9:0] sw;
   wire [8:1] sw1;
   

   
   //-------------------------------------------------------------------

   ff_top uut(
	      .clk12m(clk12),
	      .reset(reset),
	      .led1(led1),
	      .led2(led2),
	      .hsync(hsync),
	      .vsync(vsync),
	      .rgb(rgb),
	      .sw(sw),
	      .sw1(sw1)
	      );

`ifdef sdl_display
   //
   import "DPI-C" function void dpi_vga_init(input integer h,
					     input integer v);

   import "DPI-C" function void dpi_vga_display(input integer vsync_,
						input integer hsync_,
    						input integer pixel_);

   wire      pixclk;
   assign pixclk = clk12/*clk25*//*CLK*/;

   initial
     begin
	dpi_vga_init(680, 260);
//	dpi_vga_init(480, 640);
     end

   wire [31:0] pxd;
   wire [31:0] hs;
   wire [31:0] vs;

   wire [2:0]  vgaBlue;
   wire [2:0]  vgaGreen;
   wire [2:0]  vgaRed;

   assign vgaBlue = { rgb[7:6], 1'b0 };
   assign vgaGreen = rgb[5:3];
   assign vgaRed = rgb[2:0];

   assign pxd = { 24'b0, vgaBlue, vgaGreen[2:1], vgaRed };
//   assign pxd = { 24'b0, rgb };

   assign vs = {31'b0, ~vsync};
   assign hs = {31'b0, ~hsync};
//   assign hs = {31'b0, hsync};
   
   always @(posedge pixclk)
     dpi_vga_display(vs, hs, pxd);
`endif
   
endmodule // ff_cpu_test

