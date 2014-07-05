//--------------------------------------------------------------------
//--                                                              ----
//-- MC68000 compatible IP Core					  ----
//--                                                              ----
//-- This file is part of the SUSKA ATARI clone project.          ----
//-- http://www.experiment-s.de                                   ----
//--                                                              ----
//-- Description:                                                 ----
//-- This model provides an opcode and bus timing compatible ip   ----
//-- core compared to Motorola's MC68000 microprocessor.          ----
//--                                                              ----
//-- This file contains the 68Ks data registers.                  ----
//--                                                              ----
//--                                                              ----
//-- Description:                                                 ----
//-- Contains the 68K00 data registers D0 to D7 and related logic ----
//-- to perform byte, word and long data operations.              ----
//--                                                              ----
//--                                                              ----
//-- Author(s):                                                   ----
//-- - Wolfgang Foerster, wf@experiment-s.de; wf@inventronik.de   ----
//--                                                              ----
//--------------------------------------------------------------------
//--                                                              ----
//-- Copyright (C) 2006 - 2011 Wolfgang Foerster                  ----
//--                                                              ----
//-- This source file is free software; you can redistribute it   ----
//-- and/or modify it under the terms of the GNU General Public   ----
//-- License as published by the Free Software Foundation; either ----
//-- version 2 of the License, or (at your option) any later      ----
//-- version.                                                     ----
//--                                                              ----
//-- This program is distributed in the hope that it will be      ----
//-- useful, but WITHOUT ANY WARRANTY; without even the implied   ----
//-- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ----
//-- PURPOSE.  See the GNU General Public License for more        ----
//-- details.                                                     ----
//--                                                              ----
//-- You should have received a copy of the GNU General Public    ----
//-- License along with this program; if not, write to the Free   ----
//-- Software Foundation, Inc., 51 Franklin Street, Fifth Floor,  ----
//-- Boston, MA 02110-1301, USA.                                  ----
//--                                                              ----
//--------------------------------------------------------------------
// 
// Revision History
// 
// Revision 2K6B  2006/12/24 WF
//   Initial Release.
// Revision 2K7A  2007/05/31 WF
//   Updated all modules.
// Revision 2K7B  2007/12/24 WF
//   See the 68K00 top level file.
// Revision 2K8A  2008/07/14 WF
//   See the 68K00 top level file.
// 


module  wf68k00ip_data_registers ( clk, resetn, data_in_a, data_in_b, regsel_a, regsel_b, regsel_c,
				   div_mul_32n64, data_out_a, data_out_b, data_out_c,
				   dr_exg, dr_dec, dr_wr, op, op_size, op_mode, dbcc_cond );

   input        clk;
   input        resetn;
   input [31:0] data_in_a;
   input [31:0] data_in_b;
   input [2:0] 	regsel_a;
   input [2:0] 	regsel_b;
   input [2:0] 	regsel_c;
   input        div_mul_32n64;
   output [31:0] data_out_a;
   output [31:0] data_out_b;
   output [31:0] data_out_c;
   input 	 dr_exg;
   input 	 dr_dec;
   input 	 dr_wr;
   input [6:0] 	 op;
   input [1:0] 	 op_size;
   input [4:0] 	 op_mode ;
   output        dbcc_cond;

`include "wf68k00ip_parms.h"

   reg [31:0] 	 dr[0:7];
   wire [2:0] 	 dr_nr_a;
   wire [2:0] 	 dr_nr_b;
   wire [2:0] 	 dr_nr_c;
   wire [31:0] 	 data_out_a;
   wire [31:0] 	 data_out_b;
   wire [31:0] 	 data_out_c;
   reg 		 dbcc_cond;


   // Address pointers:
   assign dr_nr_a = regsel_a;
   assign dr_nr_b = regsel_b;
   assign dr_nr_c = regsel_c;

   // Output Multiplexer A and B:
   assign data_out_a = dr[dr_nr_a];
   assign data_out_b = dr[dr_nr_b];
   assign data_out_c = dr[dr_nr_c];

   wire [31:0] 	 dr_sel_a, dr_sel_b;
   
   assign dr_sel_a =  dr[dr_nr_a];
   assign dr_sel_b =  dr[dr_nr_b];

   integer i;

   // This process provides data transfer to the respective registers (write).
   // The MOVEM and MOVEQ require a sign extended source data. 
   // The BYTE size is not allowed for MOVEM .
   always @(posedge clk or negedge resetn)
     begin 
       if (~resetn)
         begin
            for (i=0;i<=7;i=i+1)
              dr[i] <= 0;
         end
       else 
         if (dr_wr)
           begin 
              if (op == DIVS | op == DIVU)
                case (op_size)
                  WORD : 
                    dr[dr_nr_a] <= data_in_a;
                  default : // -- LONG.
                    if ((div_mul_32n64 == 1'b0) & (dr[dr_nr_a] == dr[dr_nr_b]))  //-- Long 1.
                      dr[dr_nr_a] <= data_in_a;// -- Quotient returned.
                    else 
                      begin // -- Long 2, 3.
                         dr[dr_nr_a] <= data_in_a;
                         dr[dr_nr_b] <= data_in_b;
                      end
                endcase
              else if (op == MULS | op == MULU)
                begin 
                   if (op_size == WORD) 
                     dr[dr_nr_a] <= data_in_a;
                   else if (div_mul_32n64 == 1'b0)  //-- Long 1.
                     dr[dr_nr_a] <= data_in_a;
                   else  //-- Long 2.
                     begin 
                        dr[dr_nr_a] <= data_in_a;
                        dr[dr_nr_b] <= data_in_b;
                     end
                end 
              else if ((op == MOVE) | (op == MOVEP)) 
                case (op_size)
                  LONG : 
                    dr[dr_nr_a] <= data_in_a;
                  WORD : 
                    dr[dr_nr_a] <= {dr_sel_a[31:16], data_in_a[15:0]};
                  BYTE : 
                    dr[dr_nr_a] <= {dr_sel_a[31:8], data_in_a[7:0]};
		  default :
                    dr[dr_nr_a] <= 32'bx;
                endcase
              else if (op == MOVEQ) 
                begin 
//                   for (i=31;i>=8;i=i-1)
//                     dr[dr_nr_b][i] <= data_in_b[7];
//
//                   dr[dr_nr_b][7:0] <= data_in_b[7:0];

                   dr[dr_nr_b] <= { {24{dr_sel_b[7]}}, data_in_b[7:0] };
                end
              else if (op == MOVEM) 
                begin 
                   if (op_size == WORD) 
                     begin 
//                        for (i=31;i>=16;i=i-1)
//                          dr[dr_nr_b][i] <= data_in_b[15];
//
//                        dr[dr_nr_b][15:0] <= data_in_b[15:0];

                        dr[dr_nr_b] <= { {16{dr_sel_b[15]}}, data_in_b[15:0] };
                     end
                   else 
                     dr[dr_nr_b] <= data_in_b;
                end 
              else if ((op == EXTW) | (op == SWAP))
                dr[dr_nr_b] <= data_in_b;
              else 
		//-- Depending on the size to be written, not all bits of a register
		//-- are affected.
                case (op_size)
                  LONG : 
                    dr[dr_nr_b] <= data_in_b;
                  WORD : 
//                    dr[dr_nr_b][15:0] <= data_in_b[15:0];
		    dr[dr_nr_b] <= { dr_sel_b[31:16], data_in_b[15:0] };
                  BYTE : 
//                    dr[dr_nr_b][7:0] <= data_in_b[7:0];
		    dr[dr_nr_b] <= { dr_sel_b[31:8], data_in_b[7:0] };
		  default:
                    dr[dr_nr_b] <= 32'bx;
                endcase
           end
	//-- Exchange the content of data registers:
         else if (dr_exg & (op_mode == 5'b01000))
           begin // -- Exchange two data registers.
              dr[dr_nr_b] <= data_in_a;
              dr[dr_nr_a] <= data_in_b;
           end
         else if (dr_exg & (op_mode == 5'b10001))
	   // -- Exchange a data and an address register.
           dr[dr_nr_a] <= data_in_a;
	//-- And decrement:
         else if (dr_dec)
//           dr[dr_nr_b][15:0] <= dr_sel_b[15:0] - 1;// -- Used by the DBcc operation.
	dr[dr_nr_b] <= {dr_sel_b[31:16], dr_sel_b[15:0] - 16'd1 } ;// -- Used by the DBcc operation.
     end

   always @(dr_sel_b)
     begin 
	//-- Test condition for the DBcc operation:
        case (dr_sel_b[15:0])
          16'hffff:     dbcc_cond = 1'b1; //-- This is signed -1.
          default : 
            dbcc_cond = 1'b0;
        endcase
     end 

`ifdef debug_regs
   always @(posedge clk)
     if (dr_wr)
       begin
          if (op == DIVS | op == DIVU)
	    ;
          else if (op == MULS | op == MULU)
	    ;
          else if ((op == MOVE) | (op == MOVEP)) 
            case (op_size)
              LONG : $display("R%d <- %x (32)", dr_nr_a, data_in_a);
              WORD : $display("R%d <- %x (32)", dr_nr_a, {dr_sel_a[31:16], data_in_a[15:0]});
	      BYTE : $display("R%d <- %x (32)", dr_nr_a, {dr_sel_a[31:8], data_in_a[7:0]});
	    endcase
          else if (op == MOVEQ)
	    ;
          else if (op == MOVEM) 
	    ;
          else if ((op == EXTW) | (op == SWAP))
	    ;
	  else
            case (op_size)
              LONG : $display("R%d <- %x (32)", dr_nr_b, data_in_b);
              WORD : $display("R%d <- %x (32)", dr_nr_b, {dr_sel_b[31:16], data_in_b[15:0]});
	      BYTE : $display("R%d <- %x (32)", dr_nr_b, {dr_sel_b[31:8], data_in_b[7:0]});
	    endcase
       end

`endif

endmodule
