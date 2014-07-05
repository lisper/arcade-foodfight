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
//-- This file contains the 68Ks shifter unit.                    ----
//--                                                              ----
//--                                                              ----
//-- Description:                                                 ----
//-- This module performs the shifting operations ASL, ASR, LSL,  ----
//-- LSR, ROL, ROR, ROXL and ROXR as also the bit manipulation    ----
//-- and test operations BCHG, BCLR, BSET and BTST.               ----
//-- The timing of the core is as follows:                        ----
//-- All bit manipulation operations are performed by concurrent  ----
//-- statement modelling which results in immediate bit process-  ----
//-- ing. Thus, the result is valid one clock cycle after the     ----
//-- settings for the operands are stable.
//-- The shift and rotate operations start with SHIFTER_LOAD.     ----
//-- The data processing time is depending on the selected number ----
//-- of bits and is indicated by the SHFT_BUSY flag. During       ----
//-- SHFT_BUSY is asserted, the data calculation is in progress.  ----
//-- The execution time for these operations is n clock           ----
//-- cycles +2 where n is the desired number of shifts or rotates.----
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
// Revision 2K11A  2011/06/20 WF
//   Cleaned up the condition code logic.
//   Removed the signal SHFT_BREAK from logic and entity.
// 


module  wf68k00ip_shifter ( clk, resetn, data_in, data_out, op, op_size,
			    bit_pos, cnt_nr, shifter_load, shft_busy, xnzvc_in, xnzvc_out );

   input        clk;
   input        resetn;
   input [31:0] data_in;
   output [31:0] data_out;
   input [6:0] 	 op;
   input [1:0] 	 op_size;
   input [4:0] 	 bit_pos;
   input [5:0] 	 cnt_nr;
   input 	 shifter_load;
   output        shft_busy;
   input [4:0] 	 xnzvc_in;
   output [4:0]  xnzvc_out;

`include "wf68k00ip_parms.h"

   reg [5:0] 	 bit_cnt;
   reg 		 n_flag;
   reg 		 z_flag;
   reg 		 v_flag;
   reg 		 c_flag;

   //type shift_states
    parameter IDLE = 1'd0;
    parameter RUN = 1'd1;
    
   reg 		 shift_state;
   reg [31:0] 	 bit_op;
   reg [31:0] 	 shft_op;
   reg 		 shft_en =0; 
   reg 		 x_flag;
   wire [31:0] 	 data_out;
   reg 		 shft_busy =0; 
   reg [4:0] 	 xnzvc_out;


   // Output multiplexer:
   assign data_out = (op == BCHG | op == BCLR | op == BSET | op == BTST) ? bit_op :
		     shft_op; // Valid for ASL | ASR | LSL | LSR | ROTL | ROTR | ROXL | ROXR.
       
   // Bit manipulation operations.
   always @(bit_pos or op or data_in)
       begin 
	  // The default is the unmanipulated data.
           bit_op = data_in;
           case (op)
               BCHG : 
                       bit_op[bit_pos] = ~data_in[bit_pos];
               BCLR : 
                       bit_op[bit_pos] = 1'b0;
               BSET : 
                       bit_op[bit_pos] = 1'b1;
               default : 
                       bit_op = data_in;
           endcase
       end 

       
   always @(negedge resetn or posedge clk)
     if (~resetn)
       shft_op <= 32'b0;
     else 
       if (shifter_load) // Load data in the shifter unit.
         shft_op <= data_in; // Load data for the shift or rotate operations.
       else if (shft_en) // Shift and rotate operations:
         case (op)
           ASL : 
             if (op_size == LONG) 
               shft_op <= {shft_op[30:0],1'b0};
             else if (op_size == WORD) 
               shft_op <= {{16'h0000,shft_op[14:0]},1'b0};
             else // OP_SIZE = BYTE.
               shft_op <= {{24'h000000,shft_op[6:0]},1'b0};
                                   
           ASR : 
             if (op_size == LONG) 
               shft_op <= {shft_op[31],shft_op[31:1]};
             else if (op_size == WORD) 
               shft_op <= {{16'h0000,shft_op[15]},shft_op[15:1]};
             else // OP_SIZE = BYTE.
               shft_op <= {{24'h000000,shft_op[7]},shft_op[7:1]};

           LSL : 
             if (op_size == LONG) 
               shft_op <= {shft_op[30:0],1'b0};
             else if ((op_size == WORD)) 
               shft_op <= {{16'h0000,shft_op[14:0]},1'b0};
             else // OP_SIZE = BYTE.
               shft_op <= {{24'h000000,shft_op[6:0]},1'b0};

           LSR : 
             if (op_size == LONG) 
               shft_op <= {1'b0,shft_op[31:1]};
             else if (op_size == WORD) 
               shft_op <= {17'b0,shft_op[15:1]};
             else // OP_SIZE = BYTE.
               shft_op <= {25'b0,shft_op[7:1]};

           ROTL : 
             if (op_size == LONG) 
               shft_op <= {shft_op[30:0],shft_op[31]};
             else if (op_size == WORD) 
               shft_op <= {{16'h0000,shft_op[14:0]},shft_op[15]};
             else // OP_SIZE = BYTE.
               shft_op <= {{24'h000000,shft_op[6:0]},shft_op[7]};
	   // X not affected;
           ROTR : 
             if (op_size == LONG) 
               shft_op <= {shft_op[0],shft_op[31:1]};
             else if (op_size == WORD) 
               shft_op <= {{16'h0000,shft_op[0]},shft_op[15:1]};
             else // OP_SIZE = BYTE.
               shft_op <= {{24'h000000,shft_op[0]},shft_op[7:1]};
	   // X not affected;
           ROXL : 
             if (op_size == LONG) 
               shft_op <= {shft_op[30:0],x_flag};
             else if (op_size == WORD) 
               shft_op <= {{16'h0000,shft_op[14:0]},x_flag};
             else // OP_SIZE = BYTE.
               shft_op <= {{24'h000000,shft_op[6:0]},x_flag};

           ROXR : 
             if (op_size == LONG) 
               shft_op <= {x_flag,shft_op[31:1]};
             else if (op_size == WORD) 
               shft_op <= {{16'h0000,x_flag},shft_op[15:1]};
             else // OP_SIZE = BYTE.
               shft_op <= {{24'h000000,x_flag},shft_op[7:1]};

           default : 
             ;// Unaffected, forbidden.
         endcase
                       

   // The variable shift or rotate length requires a control
   // to achieve the correct OPERAND manipulation. This
   // process controls the shift process and asserts the
   // SHFT_BUSY flag during shift or rotation.
   
   always @(posedge clk or negedge resetn)
     begin 
      if (~resetn)
        begin 
           shift_state <= IDLE;
	   bit_cnt <= 6'b0;
           shft_en <= 1'b0;
           shft_busy <= 1'b0;
        end
      else 
        if (shift_state == IDLE) 
          begin 
             if (shifter_load & (cnt_nr != 6'b000000))
               begin 
                  shift_state <= RUN;
                  bit_cnt <= cnt_nr;
                  shft_en <= 1'b1;
                  shft_busy <= 1'b1;
               end
             else 
               begin 
                  shift_state <= IDLE;
                  bit_cnt <= 6'b0;
                  shft_en <= 1'b0;
                  shft_busy <= 1'b0;
               end
          end 
        else if (shift_state == RUN)
          begin 
             if (bit_cnt == 6'b000001) 
               begin 
                  shift_state <= IDLE;
                  bit_cnt <= cnt_nr;
                  shft_en <= 1'b0;
                  shft_busy <= 1'b0;
               end
             else 
               begin 
                  shift_state <= RUN;
                  bit_cnt <= bit_cnt - 6'd1;
                  shft_en <= 1'b1;
                  shft_busy <= 1'b1;
               end
          end 
   end
       
   // This process provides the flags for the shifter and the bit operations.
   // The flags for the shifter are valid after the shift operation, when the
   // SHFT_BUSY flag is not asserted. The flags of the bit operations are
   // valid immediately due to the one clock cycle process time.

   always @(posedge clk or negedge resetn)
     begin 
       if (~resetn)
	 // Extended flag:
         x_flag <= 1'b0;
       else 
         if (shifter_load | (cnt_nr == 6'b000000))
           x_flag <= xnzvc_in[4]; // Unaffected.
         else if (shft_en)
           case (op)
             ROTL,ROTR : 
               x_flag <= xnzvc_in[4];
             ASL,LSL,ROXL : 
               case (op_size)
                 LONG : 
                   x_flag <= shft_op[31];
                 WORD : 
                   x_flag <= shft_op[15];
                 BYTE : 
                   x_flag <= shft_op[7];
                 default : 
                   x_flag <= 1'bx;
               endcase
             default : 
               x_flag <= shft_op[0]; // ASR, LSR, ROXR.
           endcase
    end

   // This process provides a detection of any toggling of the most significant
   // bit of the shifter unit during the ASL shift process. For all other shift
   // operations, the V flag is always zero.

   // Overflow flag:
   always @(posedge clk or negedge resetn)
     begin 
       if (~resetn)
	 v_flag <= 1'b0;
       else 
         if (shifter_load | (cnt_nr == 6'b000000))
           v_flag <= 1'b0;
         else if (shft_en)
           case (op)
             ASL : // ASR MSB is always unchanged.
               if (op_size == LONG) 
                 v_flag <= (shft_op[31] ^ shft_op[30]) | v_flag;
               else if (op_size == WORD)
                 v_flag <= (shft_op[15] ^ shft_op[14]) | v_flag;
               else 
                 v_flag <= (shft_op[7] ^ shft_op[6]) | v_flag;
             default : 
               v_flag <= 1'b0;
           endcase
     end
   
   // Carry Flag:
   always @(posedge clk or negedge resetn)
     begin 
	if (~resetn) 
	  c_flag <= 0;
	else 
          if ((op == ROXL | op == ROXR) & (cnt_nr == 6'b000000))
            c_flag <= xnzvc_in[4];
          else if (cnt_nr == 6'b000000)
            c_flag <= 1'b0;
          else 
            case (op)
              ASL,LSL,ROTL,ROXL : 
                case (op_size)
                  LONG : 
                    c_flag <= shft_op[31];
                  WORD : 
                    c_flag <= shft_op[15];
                  BYTE : 
                    c_flag <= shft_op[7];
		  default:
		    c_flag <= 1'bx;
                endcase
              default : 
                c_flag <= shft_op[0];
            endcase
     end
       
   // Negative flag:
   always @(op_size or shft_op)
     begin 
        case (op_size)
          LONG : 
            n_flag = shft_op[31];
          WORD : 
            n_flag = shft_op[15];
          default : 
            n_flag = shft_op[7]; // Byte.
        endcase
     end

   // Zero flag:
   always @(op_size or shft_op)
     begin
        if (op_size == LONG & (shft_op == 32'h00000000))
          z_flag = 1'b1;
        else if (op_size == WORD & (shft_op[15:0] == 16'h0000))
          z_flag = 1'b1;
        else if (op_size == BYTE & (shft_op[7:0] == 8'h00))
          z_flag = 1'b1;
        else 
          z_flag = 1'b0;
     end // always @ (op_size or shft_op)
   
   always @(bit_pos or op or xnzvc_in or data_in or op_size or shft_op or x_flag or n_flag or z_flag or v_flag or c_flag)
     begin
        case (op)
          BCHG,BCLR,BSET,BTST : 
            xnzvc_out = { xnzvc_in[4:3], ~data_in[bit_pos], xnzvc_in[1:0] };
          default : // ASL, ASR, LSL, LSR, TOL, ROR, ROXL, ROXR.
            xnzvc_out = {x_flag, n_flag, z_flag, v_flag, c_flag};
        endcase
     end 

endmodule
