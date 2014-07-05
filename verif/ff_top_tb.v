//
//
//

module ff_top_tb;

   reg clk;
   reg reset;

   ff_top ff_top (
		  .clk12m(clk),
		  .reset(reset)
		  );

   always
     begin
        clk = 1'b0;
        #10;
        clk = 1'b1;
        #10;
     end

   initial
     begin
	reset = 1;
	#100 reset = 0;

       #500000000;
       $finish;
     end
	  
endmodule
