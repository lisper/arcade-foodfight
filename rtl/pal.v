//
// foodfight
// address decode pal
// Brad Parker <brad@heeltoe.com> 5/2014
//

module pal(
	   input 	 as_n,
	   input [23:18] a,
	   input [2:0] 	 fc,
	   output 	 nvram_n,
	   output 	 i_o_n,
	   output 	 audio2_n,
	   output 	 pf_n,
	   output 	 audio1_n,
	   output 	 audio0_n,
	   output 	 dtack_n,
	   output 	 vpa_n,
	   output 	 avec_n
	   );

   wire nvram, i_o, audio2, pf, audio1, audio0, dtack, vpa, avec;
   
   assign nvram_n  = ~nvram;
   assign i_o_n    = ~i_o;
   assign audio2_n = ~audio2;
   assign pf_n     = ~pf;
   assign audio1_n = ~audio1;
   assign audio0_n = ~audio0;
   assign dtack_n  = ~dtack;
   assign vpa_n    = ~vpa;
   assign avec_n    = ~avec;

   //
   // 2222 1111 1111 11
   // 3210 9876 5432 1098 7654 3210
   //
   // 9     4   8       0    0    0  

   wire [23:16] addr;
   assign addr = { a, 2'b00 };
   
   assign pf     = addr == 8'h80;
   assign nvram  = addr == 8'h90;
   assign i_o    = addr == 8'h94;
   assign audio2 = addr == 8'hac;
   assign audio1 = addr == 8'ha4;
   assign audio0 = addr == 8'ha8;

//   assign dtack  = /*addr >= 8'h00 && addr <= 8'h7f*/addr[23] ? 1'b0 : 1'b1;
`ifdef SIMULATION
   assign dtack  = (^addr === 1'bX) ? 1'b0 :
		   (~addr[23] | (addr == 8'h90));

   assign vpa    = (^addr === 1'bX) ? 1'b0 :
		   ((addr >= 8'h94 && addr <= 8'h97) |   /* i/o */
		    (addr >= 8'ha4 && addr <= 8'hac));    /* pokey */
`else
   assign dtack  = ~addr[23] | (addr == 8'h90);

   assign vpa    = (addr >= 8'h94 && addr <= 8'h97) |   /* i/o */
		   (addr >= 8'ha4 && addr <= 8'hac);    /* pokey */
`endif
   
   
   assign avec   = (fc == 3'b111 & a == 6'h3f/* & ~as_n*/); /* interrupt ack */

   //
   // !nvram   =  !as & a23 & !a22 & !a21 &  a20 & !a19 & !a18 ;
   // !io      =  !as & a23 & !a22 & !a21 &  a20 & !a19 &  a18 ;
   // !audio2  =  !as & a23 & !a22 &  a21 & !a20 &  a19 &  a18 ;
   // !pf      =  !as & a23 & !a22 & !a21 & !a20 & !a19 & !a18 ;
   // !audio1  =  !as & a23 & !a22 &  a21 & !a20 & !a19 &  a18 ;
   // !audio0  =  !as & a23 & !a22 &  a21 & !a20 &  a19 & !a18 ;
   // 
   // !dtack   = ( !as & !a23 ) +  (!as &  a23 & !a22 & !a21 & a20 );
   // !vpa  = ( !as & fc2 & fc1 & fc0 ) + ( !as & a23 & !a22 & a21 & !a20 );
   //
   
endmodule // pal
