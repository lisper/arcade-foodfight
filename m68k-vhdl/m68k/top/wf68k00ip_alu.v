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
//-- This file contains the arithmetic logic unit (ALU).          ----
//--                                                              ----
//--                                                              ----
//-- Description:                                                 ----
//-- Arithmetic Logic Unit performs the arithmetic and logic      ----
//-- operations during execution of an instruction. It contains   ----
//-- the accumulator and related logic such as arithmetic unit,   ----
//-- logic unit, multiplier and divider. BCD operation are exe-   ----
//-- cuted in this unit and condition code flags (N-negative,     ----
//-- Z-zero, C-carry V-overflow) for most instructions.           ----
//-- For a proper operation, the ALU requires sign extended       ----
//-- operands OP_IN_S, OP_IN_D_LO and OP_IN_D_HI. In case of the  ----
//-- OP_IN_D_HI a sign extension is required for the long         ----
//-- (DIVL) only.                                                 ----
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
// Revision 2K8B  2008/08/17 WF
//   Fixed a serious bug concerning the Z and V condition codes for word and byte
//   sized operands. Thanks to T. Gubener for finding the bug.
// Revision 2K13B  20131224 WF
//   Fixed the N-Flag logic for the CHK operation.
//   DIV_RESULT_VAR is now 64 bit wide to handle the overflow correctly.


module  wf68k00ip_alu ( resetn, clk, adr_mode, op_size, op, xnzvc_in, xnzvc_out,
			op_in_s, op_in_d_hi, op_in_d_lo, result_hi, result_lo,
			op_start, trap_chk_en, div_mul_32n64, op_busy, trap_chk, trap_divzero );

    input   resetn;
    input   clk;
    input [2:0]  adr_mode ;
    input  [1:0] op_size;
    input  [6:0] op;
    input [4:0]  xnzvc_in ;
    output [4:0]  xnzvc_out ;
    input [31:0]  op_in_s ;
    input [31:0]  op_in_d_hi ;
    input [31:0]  op_in_d_lo ;
    output [31:0]  result_hi ;
    output [31:0]  result_lo ;
    input   op_start;
    input   trap_chk_en;
    input   div_mul_32n64;
    output   op_busy;
    output   trap_chk;
    output   trap_divzero;

`include "wf68k00ip_parms.h"

    reg  x_in_i;
    reg [4:0] temp0;
    reg [4:0] temp1;
    reg [3:0] z_0;
    reg  c_0;
    reg [3:0] z_1;
    reg c_1;
    reg [3:0] s_0;
    reg [3:0] s_1;
    reg z;
    reg rm;
    reg sm;
    reg dm;
    reg [2:0] rm_sm_dm=0;
    reg [32:0] div_result_var;

//type mul_states
    parameter MUL_IDLE = 2'd0;
    parameter MUL_ADD = 2'd1;
    parameter MUL_VERIFY_SHIFT = 2'd2;
    
//type div_states
    parameter DIV_IDLE=2'd0;
    parameter DIV_VERIFY=2'd1;
    parameter DIV_ADDSUB=2'd2;
    parameter DIV_SIGN=2'd3;
    
reg [1:0] mul_state;
reg [1:0] next_mul_state;
reg [1:0] div_state;
reg [1:0] next_div_state;
    reg [31:0] op_in_s_sign;
    reg [31:0] op_in_d_sign_lo;
    reg [31:0] result_logop;
    reg [7:0] result_bcd;
    reg [31:0] result_intop;
   reg [31:0] result_special;
    wire [31:0] result_i_out;
    reg [31:0] result_i;
    wire [32:0] result_ii_out;
    reg [32:0] result_ii;
    reg [63:0] divisor;
    reg [63:0] dividend;
    reg cb_bcd;
    reg ov_div_mul;
    reg [5:0] mul_cyc_cnt;
   reg 	      op_mul =0; 
   reg 	      op_div =0; 
   wire [31:0] mul_div_op_s;
   wire [31:0] mul_op_d;
   reg [31:0]  div_var;
   reg 	       div_shift_en =0; 
   wire        chk_cond;
   reg [4:0]   xnzvc_out;
   wire [31:0] result_hi;
   wire [31:0] result_lo;
   wire        op_busy;
   wire        trap_chk;
   wire        trap_divzero;


    
   assign op_busy = op_mul | op_div;
   
   // Result multiplexers:
   assign result_hi = op == DIVS ? result_ii_out[31:0] : 
		      op == DIVU ? result_ii_out[31:0] : 
		      op == MULS ? result_ii_out[31:0] : 
		      op == MULU ? result_ii_out[31:0] : 
		      32'h00000000;
   
   assign result_lo = (op == AND_B | op == ANDI | op == ANDI_TO_CCR | op == ANDI_TO_SR | op == EOR | op == EORI | op == EORI_TO_CCR) ? result_logop :
		      (op == EORI_TO_SR | op == NOT_B | op == OR_B | op == ORI | op == ORI_TO_CCR | op == ORI_TO_SR) ? result_logop :
		      (op == ADD | op == ADDA | op == ADDI | op == ADDQ | op == ADDX | op == CLR | op == CMP | op == CMPA | op == CMPI | op == CMPM) ? result_intop : 
		      (op == NEG | op == NEGX | op == SUB | op == SUBA | op == SUBI | op == SUBQ | op == SUBX) ? result_intop : 
		      (op == EXTW | op == SWAP | op == TAS) ? result_special : 
		      (op == ABCD | op == NBCD | op == SBCD) ? {24'h000000,result_bcd} : // Byte only.
		      (op == DIVS | op == DIVU) ? result_i_out : 
		      (op == MULS | op == MULU) ? result_i_out : 
		      op_in_s; // Default for MOVE, MOVEQ.
   
   // Use low bytes of RESULT_II and RESULT_I for word wide DIVS, DIVU:
   // Use (OV_DIV_MUL = '1' and OP_START = '0') because OV_DIV_MUL is cleared right after OP_START but the
   // condition codes depend on RESULT_I_OUT.
   assign result_i_out = (ov_div_mul & op_start == 1'b0) ? op_in_d_lo :
                         (op == MULS | op == MULU) ? result_i :
                         (op_size == WORD) ? {result_ii[15:0],result_i[15:0]} :
                         result_i;
   
   assign result_ii_out = (ov_div_mul & op_start == 1'b0) ? {1'b0,op_in_d_hi} : result_ii;
   
   integer i;
       
   // This module provides the required sign extensions.
   always @ (op or op_in_s or op_in_d_lo or op_size )
     begin
        case (op_size)
          LONG : 
            begin 
               op_in_s_sign = op_in_s;
               op_in_d_sign_lo = op_in_d_lo;
            end
          WORD : 
            begin 
               for (i=31;i>=16;i=i-1)
                 begin 
                    op_in_s_sign[i] = op_in_s[15];
                    op_in_d_sign_lo[i] = op_in_d_lo[15];
                 end

               op_in_s_sign[15:0] = op_in_s[15:0];
               op_in_d_sign_lo[15:0] = op_in_d_lo[15:0];
            end
          BYTE : 
            begin 
               for (i=31;i>=8;i=i-1)
                 begin 
                    op_in_s_sign[i] = op_in_s[7];
                    op_in_d_sign_lo[i] = op_in_d_lo[7];
                 end
	       
               op_in_s_sign[7:0] = op_in_s[7:0];
               op_in_d_sign_lo[7:0] = op_in_d_lo[7:0];
            end
          default : 
            begin 
               op_in_s_sign = 32'bx;
               op_in_d_sign_lo = 32'bx;
            end
        endcase
     end 
   
   assign chk_cond = (op_in_d_sign_lo[31] == 1'b1) ? 1'b1 // Negative destination.
                      : (op_in_d_sign_lo > op_in_s_sign) ? 1'b1
                      :  1'b0;  // Destination > Source.
   
   assign trap_chk = (trap_chk_en == 1'b1) ? chk_cond :  1'b0;
   
   assign trap_divzero = (op == DIVU & div_state == DIV_IDLE & op_start & op_in_s == 32'h00000000) ? 1'b1 :
                         (op == DIVS & div_state == DIV_IDLE & op_start & op_in_s == 32'h00000000) ? 1'b1 :
                         1'b0;
   
       
   // This process provides the logic operations:
   // AND, OR, XOR and NOT.
   // The logic operations require no signed / unsigned
   // modelling.
   always @ (op or op_in_s or op_in_d_lo ) 
     case (op)
       AND_B,ANDI,ANDI_TO_CCR,ANDI_TO_SR : 
         result_logop = op_in_s & op_in_d_lo;
       OR_B,ORI,ORI_TO_CCR,ORI_TO_SR : 
         result_logop = op_in_s | op_in_d_lo;
       EOR,EORI,EORI_TO_CCR,EORI_TO_SR : 
         result_logop = op_in_s ^ op_in_d_lo;
       NOT_B : 
         result_logop = ~op_in_d_lo;
       MOVE : // Used for MOVE.
         result_logop = op_in_s;
       default : // Used for TST.
         result_logop = op_in_d_lo;
     endcase
   
       
   // The integer arithmetics ADD, SUB, NEG and CMP in their different variations are modelled here.
   always @ (op or op_in_s or op_in_s_sign or op_in_d_lo or op_in_d_sign_lo or adr_mode or xnzvc_in or result_intop ) 
     begin 
        x_in_i = xnzvc_in[4]; // Extended Flag.
        case (op)
          ADDA : 
            result_intop = op_in_d_lo + op_in_s_sign;// No sign extension for the destination.
          ADDQ : 
            case (adr_mode)
              3'b001 : 
                result_intop = op_in_d_lo + op_in_s_sign;// No sign extension for address destination.
              default : 
                result_intop = op_in_d_sign_lo + op_in_s_sign;
            endcase
          ADD,ADDI : 
            result_intop = op_in_d_sign_lo + op_in_s_sign;
          ADDX : 
            result_intop = (op_in_d_sign_lo + op_in_s_sign) + {31'b0, x_in_i};
          CMPA,SUBA : // No sign extension for the destination.
            result_intop = op_in_d_lo - op_in_s_sign;
          SUBQ : 
            case (adr_mode) // No sign extension for address destination.
              3'b001 : 
                result_intop = op_in_d_lo - op_in_s_sign;
              default : 
                result_intop = op_in_d_sign_lo - op_in_s_sign;
            endcase
          CMP,CMPI,CMPM,SUB,SUBI : 
            result_intop = op_in_d_sign_lo - op_in_s_sign;
          SUBX : 
            result_intop = (op_in_d_sign_lo - op_in_s_sign) - {31'b0, x_in_i};
          NEG : 
            result_intop = op_in_s_sign - op_in_d_sign_lo;
          NEGX : 
            result_intop = (op_in_s_sign - op_in_d_sign_lo) - {31'b0, x_in_i};
          CLR : 
            result_intop = 32'b0;
          default : // Don't care.
            result_intop = 32'b0;
        endcase
     end 
   
   // This process provides the calculation for special operations.
   always @ (op or op_in_s or op_in_d_lo or op_size) 
     begin 
        case (op)
          EXTW : 
            case (op_size)
              LONG : 
                begin 
                   for (i=31;i>=16;i=i-1)
                         result_special[i] = op_in_s[15];
		   
                   result_special[15:0] = op_in_s[15:0];
                end
              default : 
                begin 
                   for (i=15;i>=8;i=i-1)
                     result_special[i] = op_in_s[7];
                         
                   result_special[31:16] = op_in_s[31:16];
                   result_special[7:0] = op_in_s[7:0];
                end
            endcase
          SWAP : 
            result_special = {op_in_s[15:0],op_in_s[31:16]};
          TAS : // Set the MSB.
            result_special = {24'b0, 1'b1, op_in_d_lo[6:0]};
          default : // Don't care.
            result_special = 32'b0;
        endcase
     end 
   
   // The BCD operations are all byte wide and unsigned.
   always @ (op or xnzvc_in or op_in_s or op_in_d_lo ) 
       begin 
          x_in_i = xnzvc_in[4]; // Extended Flag.
           case (op)
               ABCD : 
                   begin 
                       temp0 = ({1'b0,op_in_d_lo[3:0]} + {1'b0,op_in_s[3:0]}) + {4'b0000,x_in_i};
                       temp1 = ({1'b0,op_in_d_lo[7:4]} + {1'b0,op_in_s[7:4]}) + {4'b0000,c_0};
                   end
               NBCD : 
                   begin 
                       temp0 = (5'b00000 - {1'b0,op_in_d_lo[3:0]}) - {4'b0000,x_in_i};
                       temp1 = (5'b00000 - {1'b0,op_in_d_lo[7:4]}) - {4'b0000,c_0};
                   end
               default : // Valid for SBCD.
                   begin 
                       temp0 = ({1'b0,op_in_d_lo[3:0]} - {1'b0,op_in_s[3:0]}) - {4'b0000,x_in_i};
                       temp1 = ({1'b0,op_in_d_lo[7:4]} - {1'b0,op_in_s[7:4]}) - {4'b0000,c_0};
                   end
           endcase

           if (temp0 > 5'b01001)
               begin 
                   z_0 = 4'b0110;
                   c_0 = 1'b1;
               end
           else 
               begin 
                   z_0 = 4'b0000;
                   c_0 = 1'b0;
               end
               
           if ((temp1 > 5'b01001)) 
               begin 
                   z_1 = 4'b0110;
                   c_1 = 1'b1;
               end
           else 
               begin 
                   z_1 = 4'b0000;
                   c_1 = 1'b0;
               end
               
           case (op)
               ABCD : 
                   begin 
                       s_1 = temp1[3:0] + z_1;
                       s_0 = temp0[3:0] + z_0;
                   end
               default : // Valid for SBCD, NBCD.
                   begin 
                       s_1 = temp1[3:0] - z_1;
                       s_0 = temp0[3:0] - z_0;
                   end
           endcase

           cb_bcd = c_1;
           result_bcd[7:4] = s_1;
           result_bcd[3:0] = s_0;
       end 

   
   // In this process all the condition codes X (eXtended), N (Negative)
   // Z (Zero), V (oVerflow) and C (Carry / borrow) are calculated for
   // all integer operations. Except for the MULS, MULU, DIVS, DIVU the
   // new conditions are valid one clock cycle after the operation starts.
   // For the multiplication and the division, the codes are valid after
   // BUSY is released.
   // Although MOVE, MOVEQ and CHK does not require any data processing by the ALU,
   // the condition codes are computated here.
   
   always @ (op or result_bcd or cb_bcd or result_logop or result_intop or op_size or
     xnzvc_in or result_special or op_in_d_lo or chk_cond or op_in_d_sign_lo or op_in_s_sign or
     result_i or result_i_out or result_ii or mul_state or div_mul_32n64 or ov_div_mul ) 
     begin 
	//RM_SM_DM := To_Bit(RM) & To_Bit(SM) & To_Bit(DM);
	rm_sm_dm = { rm, sm, dm };
        case (op)
          ADD,ADDI,ADDQ,ADDX,CMP,CMPA,CMPI,CMPM,NEG,NEGX,SUB,SUBI,SUBQ,SUBX : 
            case (op_size)
              LONG : 
                begin 
                   rm = result_intop[31];
                   sm = op_in_s_sign[31];
                   dm = op_in_d_sign_lo[31];
                end
              WORD : 
                begin 
                   rm = result_intop[15];
                   sm = op_in_s_sign[15];
                   dm = op_in_d_sign_lo[15];
                end
              BYTE : 
                begin 
                   rm = result_intop[7];
                   sm = op_in_s_sign[7];
                   dm = op_in_d_sign_lo[7];
                end
	      default :
		begin
		   rm = 1'bx;
		   sm = 1'bx;
		   dm = 1'bx;
		end
            endcase
          default : 
            begin 
               rm = 1'bx;
               sm = 1'bx;
               dm = 1'bx;
            end
        endcase
        case (op)
          ADD,ADDI,ADDQ,ADDX,CMP,CMPA,CMPI,CMPM,NEG,NEGX,SUB,SUBI,SUBQ,SUBX : 
            if (op_size == LONG & result_intop == 32'h00000000)
              z = 1'b1;
            else if (op_size == WORD & result_intop[15:0] == 16'h0000)
              z = 1'b1;
            else if (op_size == BYTE & result_intop[7:0] == 8'h00)
              z = 1'b1;
            else 
              z = 1'b0;
          default : 
            z = 1'b0;
        endcase
        case (op)
          ABCD,NBCD,SBCD : 
            if (result_bcd == 8'h00) 
              xnzvc_out = {cb_bcd,1'bx,xnzvc_in[2],1'bx,cb_bcd};
            else 
              xnzvc_out = {cb_bcd,1'bx,1'b0,1'bx,cb_bcd};
          
          ADD,ADDI,ADDQ,ADDX : 
            begin 
               if (z)
                 begin 
                    if (op == ADDX) 
                      xnzvc_out[3:2] = {1'b0,xnzvc_in[2]};
                    else 
                      xnzvc_out[3:2] = 2'b01;
                 end 
               else 
                 xnzvc_out[3:2] = {rm,1'b0};

               case (rm_sm_dm)
                 3'b011 : 
                   xnzvc_out[1] = 1'b1;
                 3'b100 : 
                   xnzvc_out[1] = 1'b1;
                 default : 
                   xnzvc_out[1] = 1'b0;
               endcase
               if ((sm & dm) | (rm == 1'b0 & sm) | (rm == 1'b0 & dm))
                 begin 
                    xnzvc_out[4] = 1'b1;
                    xnzvc_out[0] = 1'b1;
                 end
               else 
                 begin 
                    xnzvc_out[4] = 1'b0;
                    xnzvc_out[0] = 1'b0;
                 end
            end
          CLR : 
            xnzvc_out = {xnzvc_in[4],4'b0100};
          SUB,SUBI,SUBQ,SUBX : 
            begin 
               if (z)
                 begin 
                    if ((op == SUBX)) 
                      xnzvc_out[3:2] = {1'b0,xnzvc_in[2]};
                    else 
                      xnzvc_out[3:2] = 2'b01;
                 end 
               else 
                 xnzvc_out[3:2] = {rm,1'b0};

               case (rm_sm_dm)
                 3'b001 : 
                   xnzvc_out[1] = 1'b1;
                 3'b110 : 
                   xnzvc_out[1] = 1'b1;
                 default : 
                   xnzvc_out[1] = 1'b0;
               endcase
               if ((sm & dm == 1'b0) | (rm & sm) | (rm & dm == 1'b0))
                 begin 
                    xnzvc_out[4] = 1'b1;
                    xnzvc_out[0] = 1'b1;
                 end
               else 
                 begin 
                    xnzvc_out[4] = 1'b0;
                    xnzvc_out[0] = 1'b0;
                 end
            end
          CMP,CMPA,CMPI,CMPM : 
            begin 
               xnzvc_out[4] = xnzvc_in[4];
               if (z)
                 xnzvc_out[3:2] = 2'b01;
               else 
                 xnzvc_out[3:2] = {rm,1'b0};

               case (rm_sm_dm)
                 3'b001 : 
                   xnzvc_out[1] = 1'b1;
                 3'b110 : 
                   xnzvc_out[1] = 1'b1;
                 default : 
                   xnzvc_out[1] = 1'b0;
               endcase
               if ((sm & dm == 1'b0) | (rm & sm) | (rm & dm == 1'b0))
                 xnzvc_out[0] = 1'b1;
               else 
                 xnzvc_out[0] = 1'b0;
            end
          NEG,NEGX : 
            begin 
               if (z)
                 begin 
                    if ((op == NEGX)) 
                      xnzvc_out[3:2] = {1'b0,xnzvc_in[2]};
                    else 
                      xnzvc_out[3:2] = 2'b01;
                 end 
               else 
                 xnzvc_out[3:2] = {rm,1'b0};

               xnzvc_out[4] = dm | rm;
               xnzvc_out[1] = dm & rm;
               xnzvc_out[0] = dm | rm;
            end
          AND_B,ANDI,EOR,EORI,OR_B,ORI,MOVE,NOT_B,TST : 
            case (op_size)
              LONG : 
                if ((result_logop == 32'h00000000)) 
                  xnzvc_out = {xnzvc_in[4],4'b0100};
                else 
                  xnzvc_out = {{xnzvc_in[4],result_logop[31]},3'b000};

              
              WORD : 
                if ((result_logop[15:0] == 16'h0000)) 
                  xnzvc_out = {xnzvc_in[4],4'b0100};
                else 
                  xnzvc_out = {{xnzvc_in[4],result_logop[15]},3'b000};

              
              default : 
                if ((result_logop[7:0] == 8'h00)) 
                  xnzvc_out = {xnzvc_in[4],4'b0100};
                else 
                  xnzvc_out = {{xnzvc_in[4],result_logop[7]},3'b000};

              
            endcase
          CHK : 
            if ((op_in_d_sign_lo[31] == 1'b1)) 
              xnzvc_out = {{xnzvc_in[4],1'b1},3'bxxx};
            else if ((chk_cond == 1'b1)) 
              xnzvc_out = {{xnzvc_in[4],1'b0},3'bxxx};
            else 
              xnzvc_out = {xnzvc_in[4:3],3'bxxx};

          
          DIVS,DIVU : 
            if (((op_size == WORD) & (result_i_out[15] == 1'b1))) 
              xnzvc_out = {{{{xnzvc_in[4],1'b1},1'b0},ov_div_mul},1'b0};
            else if (((op_size == WORD) & (result_i_out[15:0] == 16'h0000))) 
              xnzvc_out = {{{{xnzvc_in[4],1'b0},1'b1},ov_div_mul},1'b0};
            else if (((op_size == LONG) & (result_i_out[31] == 1'b1))) 
              xnzvc_out = {{{{xnzvc_in[4],1'b1},1'b0},ov_div_mul},1'b0};
            else if (((op_size == LONG) & (result_i_out == 32'h00000000))) 
              xnzvc_out = {{{{xnzvc_in[4],1'b0},1'b1},ov_div_mul},1'b0};
            else 
              xnzvc_out = {{{{xnzvc_in[4],1'b0},1'b0},ov_div_mul},1'b0};

          
          EXTW : 
            case (op_size)
              LONG : 
                if (result_special == 32'h00000000)
                  xnzvc_out = {xnzvc_in[4],4'b0100};
                else 
                  xnzvc_out = {{xnzvc_in[4],result_special[31]},3'b000};
              
              default : 
                if ((result_special[15:0] == 16'h0000)) 
                  xnzvc_out = {xnzvc_in[4],4'b0100};
                else 
                  xnzvc_out = {{xnzvc_in[4],result_special[15]},3'b000};
            endcase

          MOVEQ : 
            if ((op_in_s_sign[7:0] == 8'h00)) 
              xnzvc_out = {xnzvc_in[4],4'b0100};
            else 
              xnzvc_out = {xnzvc_in[4],op_in_s_sign[7],3'b000};
          
          MULS,MULU : 
            begin 
               xnzvc_out = {{{{xnzvc_in[4],1'b0},1'b0},1'b0},1'b0};
               if (((result_i == 32'h00000000) & (result_ii[31:0] == 32'h00000000))) 
                 xnzvc_out = {{{{xnzvc_in[4],1'b0},1'b1},1'b0},1'b0};
               else if (((op_size == WORD) & (result_i[31] == 1'b1))) 
                 xnzvc_out = {{{{xnzvc_in[4],1'b1},1'b0},1'b0},1'b0};
               else if (((op_size == LONG) & (div_mul_32n64 == 1'b0))) 
                 begin 
                    if (((ov_div_mul == 1'b1) & (op_in_d_lo[31] == 1'b1))) 
                      xnzvc_out = {{{{xnzvc_in[4],1'b1},1'b0},1'b1},1'b0};
                    else if (((ov_div_mul == 1'b1) & (op_in_d_lo == 32'h00000000))) 
                      xnzvc_out = {{{{xnzvc_in[4],1'b0},1'b1},1'b1},1'b0};
                    else if ((result_i[31] == 1'b1)) 
                      xnzvc_out = {{{{xnzvc_in[4],1'b1},1'b0},1'b0},1'b0};
                    else if ((result_i == 32'h00000000)) 
                      xnzvc_out = {{{{xnzvc_in[4],1'b0},1'b1},1'b0},1'b0};
                 end 
               else if (op_size == LONG & result_ii[31] == 1'b1) 
                 xnzvc_out = {xnzvc_in[4],1'b1,1'b0,1'b0,1'b0};
               else if (op_size == LONG & {result_ii,result_i} == 65'b0) 
                 xnzvc_out = {{{{xnzvc_in[4],1'b0},1'b1},1'b0},1'b0};
            end

          SWAP : 
            if (result_special == 32'h00000000)
              xnzvc_out = {xnzvc_in[4],4'b0100};
            else 
              xnzvc_out = {{xnzvc_in[4],result_special[31]},3'b000};
          
          TAS : 
            if (op_in_d_sign_lo[7:0] == 8'h00)
              xnzvc_out = {xnzvc_in[4],4'b0100};
            else 
              xnzvc_out = {{xnzvc_in[4],op_in_d_sign_lo[7]},3'b000};

          default : 
            xnzvc_out = 5'bxxxxx;
        endcase
     end 
   
   assign mul_div_op_s = (op_size == WORD & op_in_s[15] & (op == MULS | op == DIVS)) ? {16'hFFFF,op_in_s[15:0]} :
                         (op_size == WORD) ? {16'h0000,op_in_s[15:0]} :
                         op_in_s;
   
   assign mul_op_d = (op_size == WORD & op_in_d_lo[15] & op == MULS) ? {16'hFFFF,op_in_d_lo[15:0]} :
                     (op_size == WORD) ? {16'h0000,op_in_d_lo[15:0]} :
                     op_in_d_lo;
   
       
   always @ (posedge clk or negedge resetn) 
     if (~resetn)
       begin 
          result_i <= 32'b0;
          result_ii <= 33'b0;
          div_result_var = 33'b0;
          ov_div_mul <= 1'b0;
       end
     else 
       if (op_start)
         begin 
            ov_div_mul <= 1'b0;
            case (op)
              MULS,MULU : 
                begin 
                   result_ii <= 33'b0;
                   if (op_in_d_lo == 32'h00000000 | op_in_s == 32'h00000000)
                     result_i <= 32'h00000000;
                   else 
                     result_i <= mul_op_d;
                end
              DIVU : 
                begin 
                   if (op_size == LONG & div_mul_32n64)
                     dividend <= {op_in_d_hi,op_in_d_lo};
                   else 
                     dividend <= {32'h00000000,op_in_d_lo};

                   divisor <= {32'h00000000,mul_div_op_s};
                   result_i <= 32'b0;
                   result_ii <= 33'b0;
                   div_var <= 32'h00000001;
                   div_result_var = 33'b0;
                end
              DIVS : 
                begin 
                   if (op_size == LONG & div_mul_32n64 & op_in_d_hi[31] == 1'b0)
                     dividend <= {op_in_d_hi,op_in_d_lo};
                   else if (op_size == LONG & div_mul_32n64)
                     dividend <= ~{op_in_d_hi,op_in_d_lo} + 64'd1;
                   else if (op_in_d_lo[31] == 1'b0)
                     dividend <= {32'h00000000,op_in_d_lo};
                   else 
                     dividend <= {32'h00000000,~op_in_d_lo} + 64'd1;

                   if (mul_div_op_s[31])
                     divisor <= {32'h00000000,~mul_div_op_s} + 64'd1;
                   else 
                     divisor <= {32'h00000000,mul_div_op_s};

                   result_i <= 32'b0;
                   result_ii <= 33'b0;
                   div_var <= 32'h00000001;
                   div_result_var = 33'b0;
                end
              default : 
                ;//null
            endcase
         end
       else if (mul_state == MUL_ADD) 
         result_ii <= (result_ii + mul_div_op_s);
       else if (mul_state == MUL_VERIFY_SHIFT) 
         begin 
            case (mul_cyc_cnt)
              6'b000000 : 
                if (op == MULS & op_size == LONG & mul_div_op_s[31] & op_in_d_lo[31])
                  result_ii <= {1'b0,result_ii[32:1]} + {1'b0,~op_in_d_lo} + 33'd1 + {1'b0,~mul_div_op_s} + 33'd1;
                else if (op == MULS & op_size == LONG & mul_div_op_s[31])
                  result_ii <= {1'b0,result_ii[32:1]} + {1'b0,~op_in_d_lo} + 33'd1;
                else if (op == MULS & op_size == LONG & op_in_d_lo[31])
                  result_ii <= {1'b0,result_ii[32:1]} + {1'b0,~mul_div_op_s} + 33'd1;
                else 
                  result_ii <= {1'b0,result_ii[32:1]};
              default : 
                result_ii <= {1'b0,result_ii[32:1]};
            endcase
            result_i <= {result_ii[0],result_i[31:1]};
            if (op == MULS & op_size == LONG & result_i[31] & (div_mul_32n64 == 1'b0) & result_ii[31:0] != 32'hFFFFFFFF)
              ov_div_mul <= 1'b1;
            else if (op == MULS & op_size == LONG & (result_i[31] == 1'b0) & (div_mul_32n64 == 1'b0) & result_ii[31:0] != 32'h00000000)
              ov_div_mul <= 1'b1;
            else if (op == MULU & op_size == LONG & (div_mul_32n64 == 1'b0) & result_ii[31:0] != 32'h00000000)
              ov_div_mul <= 1'b1;
         end
   
       else if (div_shift_en)
         begin 
            divisor <= {divisor[62:0],1'b0};
            div_var <= {div_var[30:0],1'b0};
         end
       else if (div_state == DIV_ADDSUB) 
         begin 
            dividend <= dividend - divisor;
            div_result_var = {1'b0,result_i} + div_var;
            result_i <= div_result_var[31:0];
            div_var <= 32'h00000001;
            if (op == DIVS & mul_div_op_s[31] == 1'b1) 
              divisor <= {32'h00000000,~mul_div_op_s} + 64'd1;
            else 
              divisor <= {32'h00000000,mul_div_op_s};
            
            if (op_size == LONG & op == DIVS & div_result_var[32:31] != 2'b00) 
              ov_div_mul <= 1'b1;
            else if (op_size == WORD & op == DIVS & div_result_var[32:15] != 18'b000000000000000000)
              ov_div_mul <= 1'b1;
            else if (op_size == LONG & op == DIVU & div_result_var[32] == 1'b1)
              ov_div_mul <= 1'b1;
            else if (op_size == WORD & op == DIVU & div_result_var[32:16] != 17'b00000000000000000)
              ov_div_mul <= 1'b1;
         end
       else if (div_state == DIV_SIGN) 
         begin 
            case (op_size)
              LONG : 
                if (div_mul_32n64 & op == DIVS & (op_in_d_hi[31] ^ op_in_s[31]))
                  result_i <= ~result_i + 32'd1;
                else if (op == DIVS & (op_in_d_lo[31] ^ op_in_s[31]) == 1'b1)
                  result_i <= ~result_i + 32'd1;

              default : 
                if (op == DIVS & (op_in_d_lo[31] ^ op_in_s[15]) == 1'b1)
                  result_i <= ~result_i + 32'd1;
            endcase
            if (op == DIVS & op_size == LONG & div_mul_32n64 & op_in_d_hi[31])
              result_ii[31:0] <= ~dividend[31:0] + 32'd1;
            else if (op == DIVS & op_in_d_lo[31])
              result_ii[31:0] <= ~dividend[31:0] + 32'd1;
            else 
              result_ii[31:0] <= dividend[31:0];
         end
   
   always @ (posedge clk or negedge resetn)
     begin 
	if (~resetn)
          begin 
             mul_cyc_cnt <= 6'b000000;
             mul_state <= MUL_IDLE;
          end
	else 
          begin 
             mul_state <= next_mul_state;
             if ((op == MULS | op == MULU) & op_start)
               mul_cyc_cnt <= 6'b100000;
             else if (mul_state == MUL_VERIFY_SHIFT & (op_in_d_lo == 32'h00000000 | op_in_s == 32'h00000000))
               mul_cyc_cnt <= 6'b000000;
             else if (mul_state == MUL_VERIFY_SHIFT) 
               case (mul_cyc_cnt)
                 6'b000000 : ;
                 default : 
                   mul_cyc_cnt <= mul_cyc_cnt - 6'd1;
               endcase
          end
    end
       
   always @ (mul_cyc_cnt or mul_state ) 
     begin 
        case (mul_cyc_cnt)
          6'b000000 : 
            if (mul_state == MUL_IDLE) 
              op_mul = 1'b0;
            else 
              op_mul = 1'b1;

          default : 
            op_mul = 1'b1;
        endcase
     end 
       
   always @ (mul_state or op_start or op or result_i or mul_cyc_cnt or op_in_d_lo or op_in_s )
     case (mul_state)
       MUL_IDLE : 
         if ((op == MULS | op == MULU) & op_start)
           next_mul_state = MUL_VERIFY_SHIFT;
         else 
           next_mul_state = MUL_IDLE;

       MUL_VERIFY_SHIFT : 
         if (op_in_d_lo == 32'h00000000 | op_in_s == 32'h00000000) 
           next_mul_state = MUL_IDLE;
         else if (result_i[0] == 1'b1) 
           next_mul_state = MUL_ADD;
         else 
           case (mul_cyc_cnt)
             6'b000000 : 
               next_mul_state = MUL_IDLE;
             default : 
               next_mul_state = MUL_VERIFY_SHIFT;
           endcase
       
       MUL_ADD : 
         next_mul_state = MUL_VERIFY_SHIFT;

       default:
           next_mul_state = MUL_IDLE;
       
     endcase
   
       
   always @ (posedge clk or negedge resetn) 
     if (~resetn)
       div_state <= DIV_IDLE;
     else 
       div_state <= next_div_state;
   
   always @(div_state or op_start or op or op_in_s or dividend or divisor or result_i or op_size or ov_div_mul ) 
     begin 
        div_shift_en = 1'b0;
        op_div = 1'b1;
        case (div_state)
          DIV_IDLE : 
            begin 
               if ((op == DIVS | op == DIVU) & op_start & op_in_s == 32'h00000000)
                 next_div_state = DIV_IDLE;
               else if ((op == DIVS | op == DIVU) & op_start)
                 next_div_state = DIV_VERIFY;
               else 
                 next_div_state = DIV_IDLE;

               op_div = 1'b0;
            end

          DIV_VERIFY : 
            if (ov_div_mul)
              next_div_state = DIV_IDLE;
            else if (dividend < divisor) 
              next_div_state = DIV_SIGN;
            else if ({divisor[63:0],1'b0} > {1'b0,dividend}) 
              next_div_state = DIV_ADDSUB;
            else 
              begin 
                 next_div_state = DIV_VERIFY;
                 div_shift_en = 1'b1;
              end

          DIV_ADDSUB : 
            next_div_state = DIV_VERIFY;
          DIV_SIGN : 
            next_div_state = DIV_IDLE;
        endcase
     end 

endmodule
