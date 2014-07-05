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


module  wf68k00ip_alu ( resetn, clk, adr_mode, op_size, op, xnzvc_in, xnzvc_out, op_in_s, op_in_d_hi, op_in_d_lo, result_hi, result_lo, op_start, trap_chk_en, div_mul_32n64, op_busy, trap_chk, trap_divzero );
    //type op_sizetype
     parameter LONG=2'd0;
     parameter WORD=2'd1;
     parameter BYTE=2'd2;
     
//type d_sizetype
     parameter long__d_sizetype=2'd0;
     parameter word__d_sizetype=2'd1;
     parameter byte__d_sizetype=2'd2;
     
//type op_68k00
     parameter abcd__op_68k00=7'd0;
     parameter add__op_68k00=7'd1;
     parameter adda__op_68k00=7'd2;
     parameter addi__op_68k00=7'd3;
     parameter addq__op_68k00=7'd4;
     parameter addx__op_68k00=7'd5;
     parameter and_b__op_68k00=7'd6;
     parameter andi__op_68k00=7'd7;
     parameter andi_to_ccr__op_68k00=7'd8;
     parameter andi_to_sr__op_68k00=7'd9;
     parameter asl__op_68k00=7'd10;
     parameter asr__op_68k00=7'd11;
     parameter bcc__op_68k00=7'd12;
     parameter bchg__op_68k00=7'd13;
     parameter bclr__op_68k00=7'd14;
     parameter bra__op_68k00=7'd15;
     parameter bset__op_68k00=7'd16;
     parameter bsr__op_68k00=7'd17;
     parameter btst__op_68k00=7'd18;
     parameter chk__op_68k00=7'd19;
     parameter clr__op_68k00=7'd20;
     parameter cmp__op_68k00=7'd21;
     parameter cmpa__op_68k00=7'd22;
     parameter cmpi__op_68k00=7'd23;
     parameter cmpm__op_68k00=7'd24;
     parameter dbcc__op_68k00=7'd25;
     parameter divs__op_68k00=7'd26;
     parameter divu__op_68k00=7'd27;
     parameter eor__op_68k00=7'd28;
     parameter eori__op_68k00=7'd29;
     parameter eori_to_ccr__op_68k00=7'd30;
     parameter eori_to_sr__op_68k00=7'd31;
     parameter exg__op_68k00=7'd32;
     parameter extw__op_68k00=7'd33;
     parameter illegal__op_68k00=7'd34;
     parameter jmp__op_68k00=7'd35;
     parameter jsr__op_68k00=7'd36;
     parameter lea__op_68k00=7'd37;
     parameter link__op_68k00=7'd38;
     parameter lsl__op_68k00=7'd39;
     parameter lsr__op_68k00=7'd40;
     parameter move__op_68k00=7'd41;
     parameter movea__op_68k00=7'd42;
     parameter move_from_ccr__op_68k00=7'd43;
     parameter move_to_ccr__op_68k00=7'd44;
     parameter move_from_sr__op_68k00=7'd45;
     parameter move_to_sr__op_68k00=7'd46;
     parameter move_usp__op_68k00=7'd47;
     parameter movem__op_68k00=7'd48;
     parameter movep__op_68k00=7'd49;
     parameter moveq__op_68k00=7'd50;
     parameter muls__op_68k00=7'd51;
     parameter mulu__op_68k00=7'd52;
     parameter nbcd__op_68k00=7'd53;
     parameter neg__op_68k00=7'd54;
     parameter negx__op_68k00=7'd55;
     parameter nop__op_68k00=7'd56;
     parameter not_b__op_68k00=7'd57;
     parameter or_b__op_68k00=7'd58;
     parameter ori__op_68k00=7'd59;
     parameter ori_to_ccr__op_68k00=7'd60;
     parameter ori_to_sr__op_68k00=7'd61;
     parameter pea__op_68k00=7'd62;
     parameter reset__op_68k00=7'd63;
     parameter rotl__op_68k00=7'd64;
     parameter rotr__op_68k00=7'd65;
     parameter roxl__op_68k00=7'd66;
     parameter roxr__op_68k00=7'd67;
     parameter rte__op_68k00=7'd68;
     parameter rtr__op_68k00=7'd69;
     parameter rts__op_68k00=7'd70;
     parameter sbcd__op_68k00=7'd71;
     parameter scc__op_68k00=7'd72;
     parameter stop__op_68k00=7'd73;
     parameter sub__op_68k00=7'd74;
     parameter suba__op_68k00=7'd75;
     parameter subi__op_68k00=7'd76;
     parameter subq__op_68k00=7'd77;
     parameter subx__op_68k00=7'd78;
     parameter swap__op_68k00=7'd79;
     parameter tas__op_68k00=7'd80;
     parameter trap__op_68k00=7'd81;
     parameter trapv__op_68k00=7'd82;
     parameter tst__op_68k00=7'd83;
     parameter unlk__op_68k00=7'd84;
     parameter reserved__op_68k00=7'd85;
     parameter unimplemented__op_68k00=7'd86;
     

    input  [0:0] resetn;
    input  [0:0] clk;
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
    input  [0:0] op_start;
    input  [0:0] trap_chk_en;
    input  [0:0] div_mul_32n64;
    output  [0:0] op_busy;
    output  [0:0] trap_chk;
    output  [0:0] trap_divzero;


    reg [0:0] p_intop__x_in_i;
    reg [31:0] p_intop__result;
    reg [31:0] p_special__result;
    reg [0:0] p_bcdop__x_in_i;
    reg [4:0] p_bcdop__temp0;
    reg [4:0] p_bcdop__temp1;
    reg [3:0] p_bcdop__z_0;
    reg [0:0] p_bcdop__c_0;
    reg [3:0] p_bcdop__z_1;
    reg p_bcdop__c_1;
    reg [3:0] p_bcdop__s_0;
    reg [3:0] p_bcdop__s_1;
    reg cond_codes__z;
    reg cond_codes__rm;
    reg cond_codes__sm;
    reg cond_codes__dm;
    reg [2:0] cond_codes__rm_sm_dm=0;
    reg [32:0] mul_div_buffer__div_result_var;
//type mul_states
    parameter mul_idle__mul_states=2'd0;
    parameter mul_add__mul_states=2'd1;
    parameter mul_verify_shift__mul_states=2'd2;
    
//type div_states
    parameter div_idle__div_states=2'd0;
    parameter div_verify__div_states=2'd1;
    parameter div_addsub__div_states=2'd2;
    parameter div_sign__div_states=2'd3;
    
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
reg [0:0] op_mul =0; 
reg [0:0] op_div =0; 
    wire [31:0] mul_div_op_s;
    wire [31:0] mul_op_d;
    reg [31:0] div_var;
reg [0:0] div_shift_en =0; 
wire [0:0] chk_cond;
    reg [4:0] xnzvc_out;
    wire [31:0] result_hi;
    wire [31:0] result_lo;
wire [0:0] op_busy;
wire [0:0] trap_chk;
wire [0:0] trap_divzero;


    
   assign {op_busy}=(op_mul | op_div);
   
   // Result multiplexers:
   assign result_hi = op == divs__op_68k00 ? result_ii_out[31:0] : 
		      op == divu__op_68k00 ? result_ii_out[31:0] : 
		      op == muls__op_68k00 ? result_ii_out[31:0] : 
		      op == mulu__op_68k00 ? result_ii_out[31:0] : 
		      32'h00000000;
   
   assign result_lo = op==and_b__op_68k00 ? result_logop : 
		      op==andi__op_68k00 ? result_logop : 
		      op==andi_to_ccr__op_68k00 ? result_logop : 
		      op==andi_to_sr__op_68k00 ? result_logop : 
		      op==eor__op_68k00 ? result_logop : 
		      op==eori__op_68k00 ? result_logop : 
		      op==eori_to_ccr__op_68k00 ? result_logop : 
           op==eori_to_sr__op_68k00 ? result_logop : 
           op==not_b__op_68k00 ? result_logop : 
           op==or_b__op_68k00 ? result_logop : 
           op==ori__op_68k00 ? result_logop : 
           op==ori_to_ccr__op_68k00 ? result_logop : 
           op==ori_to_sr__op_68k00 ? result_logop : 
           op==add__op_68k00 ? result_intop : 
           op==adda__op_68k00 ? result_intop : 
           op==addi__op_68k00 ? result_intop : 
           op==addq__op_68k00 ? result_intop : 
           op==addx__op_68k00 ? result_intop : 
           op==clr__op_68k00 ? result_intop : 
           op==cmp__op_68k00 ? result_intop : 
           op==cmpa__op_68k00 ? result_intop : 
           op==cmpi__op_68k00 ? result_intop : 
           op==cmpm__op_68k00 ? result_intop : 
           op==neg__op_68k00 ? result_intop : 
           op==negx__op_68k00 ? result_intop : 
           op==sub__op_68k00 ? result_intop : 
           op==suba__op_68k00 ? result_intop : 
           op==subi__op_68k00 ? result_intop : 
           op==subq__op_68k00 ? result_intop : 
           op==subx__op_68k00 ? result_intop : 
           op==extw__op_68k00 ? result_special : 
           op==swap__op_68k00 ? result_special : 
           op==tas__op_68k00 ? result_special : 
           op==abcd__op_68k00 ? {24'h000000,result_bcd} : 
           op==nbcd__op_68k00 ? {24'h000000,result_bcd} : 
           op==sbcd__op_68k00 ? {24'h000000,result_bcd} : 
           op==divs__op_68k00 ? result_i_out : 
           op==divu__op_68k00 ? result_i_out : 
           op==muls__op_68k00 ? result_i_out : 
           op==mulu__op_68k00 ? result_i_out : 
           op_in_s;
   
   // Use low bytes of RESULT_II and RESULT_I for word wide DIVS, DIVU:
   // Use (OV_DIV_MUL = '1' and OP_START = '0') because OV_DIV_MUL is cleared right after OP_START but the
   // condition codes depend on RESULT_I_OUT.
   assign {result_i_out}=((ov_div_mul == 1'b1) & (op_start == 1'b0)) ? 
                             op_in_d_lo
                          : ((op == muls__op_68k00) | (op == mulu__op_68k00)) ? 
                             result_i
                          : (op_size == WORD) ? 
                             {result_ii[15:0],result_i[15:0]}
                          :  result_i;
   
   assign {result_ii_out}=((ov_div_mul == 1'b1) & (op_start == 1'b0)) ? 
                              {1'b0,op_in_d_hi}
                           :  result_ii;
   
       
   // This module provides the required sign extensions.
   always @ (op or op_in_s or op_in_d_lo or op_size ) // begin 
           case (op_size)
               LONG : 
                   begin 
                       op_in_s_sign <= op_in_s;
                       op_in_d_sign_lo <= op_in_d_lo;
                   end
               WORD : 
                   begin 
                       begin :Block_Name_1
                           integer i;
                           for (i=31;i>=16;i=i-1) begin 
                               begin 
                                   op_in_s_sign[i] <= op_in_s[15];
                                   op_in_d_sign_lo[i] <= op_in_d_lo[15];
                               end
                               
                           end //for
                       end //end Block
                       op_in_s_sign[15:0] <= op_in_s[15:0];
                       op_in_d_sign_lo[15:0] <= op_in_d_lo[15:0];
                   end
               BYTE : 
                   begin 
                       begin :Block_Name_2
                           integer i;
                           for (i=31;i>=8;i=i-1) begin 
                               begin 
                                   op_in_s_sign[i] <= op_in_s[7];
                                   op_in_d_sign_lo[i] <= op_in_d_lo[7];
                               end
                               
                           end //for
                       end //end Block
                       op_in_s_sign[7:0] <= op_in_s[7:0];
                       op_in_d_sign_lo[7:0] <= op_in_d_lo[7:0];
                   end
           endcase
   // end always 
   
   assign {chk_cond}=(op_in_d_sign_lo[31] == 1'b1) ? 
                         1'b1 // -- Negative destination.
                      : (op_in_d_sign_lo > op_in_s_sign) ? 
                         1'b1
                      :  1'b0;  // -- Destination > Source.
   
   assign {trap_chk}=(trap_chk_en == 1'b1) ? 
                         chk_cond
                      :  1'b0;
   
   assign {trap_divzero}=((((op == divu__op_68k00) & (div_state == div_idle__div_states)) & (op_start == 1'b1)) & (op_in_s == 32'h00000000)) ? 
                             1'b1
                          : ((((op == divs__op_68k00) & (div_state == div_idle__div_states)) & (op_start == 1'b1)) & (op_in_s == 32'h00000000)) ? 
                             1'b1
                          :  1'b0;
   
       
   //-- This process provides the logic operations:
   //-- AND, OR, XOR and NOT.
   //-- The logic operations require no signed / unsigned
   //-- modelling.
   always @ (op or op_in_s or op_in_d_lo ) // begin 
           case (op)
               and_b__op_68k00,andi__op_68k00,andi_to_ccr__op_68k00,andi_to_sr__op_68k00 : 
                       result_logop <= (op_in_s & op_in_d_lo);
               or_b__op_68k00,ori__op_68k00,ori_to_ccr__op_68k00,ori_to_sr__op_68k00 : 
                       result_logop <= (op_in_s | op_in_d_lo);
               eor__op_68k00,eori__op_68k00,eori_to_ccr__op_68k00,eori_to_sr__op_68k00 : 
                       result_logop <= (op_in_s ^ op_in_d_lo);
               not_b__op_68k00 : 
                       result_logop <= ~ (op_in_d_lo);
               move__op_68k00 : //-- Used for MOVE.
                       result_logop <= op_in_s;
               default : //-- Used for TST.
                       result_logop <= op_in_d_lo;
           endcase
   // end always 
   
       
   //-- The integer arithmetics ADD, SUB, NEG and CMP in their different variations are modelled here.
   always @ (op or op_in_s or op_in_s_sign or op_in_d_lo or op_in_d_sign_lo or adr_mode or xnzvc_in or result_intop ) // begin 
       begin 
           p_intop__x_in_i[0] = xnzvc_in[4]; //-- Extended Flag.
           case (op)
               adda__op_68k00 : 
                       p_intop__result = (op_in_d_lo + op_in_s_sign);//-- No sign extension for the destination.
               addq__op_68k00 : 
                       case (adr_mode)
                           3'b001 : 
                                   p_intop__result = (op_in_d_lo + op_in_s_sign);//-- No sign extension for address destination.
                           default : 
                                   p_intop__result = (op_in_d_sign_lo + op_in_s_sign);
                       endcase
               add__op_68k00,addi__op_68k00 : 
                       p_intop__result = (op_in_d_sign_lo + op_in_s_sign);
               addx__op_68k00 : 
                       p_intop__result = ((op_in_d_sign_lo + op_in_s_sign) + p_intop__x_in_i);
               cmpa__op_68k00,suba__op_68k00 : //-- No sign extension for the destination.
                       p_intop__result = (op_in_d_lo - op_in_s_sign);
               subq__op_68k00 : 
                       case (adr_mode) //-- No sign extension for address destination.
                           3'b001 : 
                                   p_intop__result = (op_in_d_lo - op_in_s_sign);
                           default : 
                                   p_intop__result = (op_in_d_sign_lo - op_in_s_sign);
                       endcase
               cmp__op_68k00,cmpi__op_68k00,cmpm__op_68k00,sub__op_68k00,subi__op_68k00 : 
                       p_intop__result = (op_in_d_sign_lo - op_in_s_sign);
               subx__op_68k00 : 
                       p_intop__result = ((op_in_d_sign_lo - op_in_s_sign) - p_intop__x_in_i);
               neg__op_68k00 : 
                       p_intop__result = (op_in_s_sign - op_in_d_sign_lo);
               negx__op_68k00 : 
                       p_intop__result = ((op_in_s_sign - op_in_d_sign_lo) - p_intop__x_in_i);
               clr__op_68k00 : 
                       p_intop__result = {(31-0+1- 0){1'b0}};
               default : //-- Don't care.
                       p_intop__result = {(31-0+1- 0){1'b0}};
           endcase
           result_intop <= p_intop__result;
       end 
   // end always 
   
   //-- This process provides the calculation for special operations.
   always @ (op or op_in_s or op_in_d_lo or op_size or result_intop ) // begin 
       begin 
           case (op)
               extw__op_68k00 : 
                       case (op_size)
                           LONG : 
                               begin 
                                   begin :Block_Name_3
                                       integer i;
                                       for (i=31;i>=16;i=i-1) begin 
                                           p_special__result[i] = op_in_s[15];
                                           
                                       end //for
                                   end //end Block
                                   p_special__result[15:0] = op_in_s[15:0];
                               end
                           default : 
                               begin 
                                   begin :Block_Name_4
                                       integer i;
                                       for (i=15;i>=8;i=i-1) begin 
                                           p_special__result[i] = op_in_s[7];
                                           
                                       end //for
                                   end //end Block
                                   p_special__result[31:16] = op_in_s[31:16];
                                   p_special__result[7:0] = op_in_s[7:0];
                               end
                       endcase
               swap__op_68k00 : 
                       p_special__result = {op_in_s[15:0],op_in_s[31:16]};
               tas__op_68k00 : //-- Set the MSB.
                       p_special__result = {24'b0, 1'b1, op_in_d_lo[6:0]};
               default : //-- Don't care.
                       p_special__result = {(31-0+1- 0){1'b0}};
           endcase
           result_special <= p_special__result;
       end 
   // end always 
   
   //-- The BCD operations are all byte wide and unsigned.
   always @ (op or xnzvc_in or op_in_s or op_in_d_lo ) // begin 
       begin 
           p_bcdop__x_in_i[0] = xnzvc_in[4]; //-- Extended Flag.
           case (op)
               abcd__op_68k00 : 
                   begin 
                       p_bcdop__temp0 = (({1'b0,op_in_d_lo[3:0]} + {1'b0,op_in_s[3:0]}) + {4'b0000,p_bcdop__x_in_i});
                       p_bcdop__temp1 = (({1'b0,op_in_d_lo[7:4]} + {1'b0,op_in_s[7:4]}) + {4'b0000,p_bcdop__c_0});
                   end
               nbcd__op_68k00 : 
                   begin 
                       p_bcdop__temp0 = ((5'b00000 - {1'b0,op_in_d_lo[3:0]}) - {4'b0000,p_bcdop__x_in_i});
                       p_bcdop__temp1 = ((5'b00000 - {1'b0,op_in_d_lo[7:4]}) - {4'b0000,p_bcdop__c_0});
                   end
               default : //-- Valid for SBCD.
                   begin 
                       p_bcdop__temp0 = (({1'b0,op_in_d_lo[3:0]} - {1'b0,op_in_s[3:0]}) - {4'b0000,p_bcdop__x_in_i});
                       p_bcdop__temp1 = (({1'b0,op_in_d_lo[7:4]} - {1'b0,op_in_s[7:4]}) - {4'b0000,p_bcdop__c_0});
                   end
           endcase
           if ((p_bcdop__temp0 > 5'b01001)) 
               begin 
                   p_bcdop__z_0 = 4'b0110;
                   p_bcdop__c_0 = 1'b1;
               end
               
           else 
               begin 
                   p_bcdop__z_0 = 4'b0000;
                   p_bcdop__c_0 = 1'b0;
               end
               
           if ((p_bcdop__temp1 > 5'b01001)) 
               begin 
                   p_bcdop__z_1 = 4'b0110;
                   p_bcdop__c_1 = 1'b1;
               end
               
           else 
               begin 
                   p_bcdop__z_1 = 4'b0000;
                   p_bcdop__c_1 = 1'b0;
               end
               
           case (op)
               abcd__op_68k00 : 
                   begin 
                       p_bcdop__s_1 = (p_bcdop__temp1[3:0] + p_bcdop__z_1);
                       p_bcdop__s_0 = (p_bcdop__temp0[3:0] + p_bcdop__z_0);
                   end
               default : //-- Valid for SBCD, NBCD.
                   begin 
                       p_bcdop__s_1 = (p_bcdop__temp1[3:0] - p_bcdop__z_1);
                       p_bcdop__s_0 = (p_bcdop__temp0[3:0] - p_bcdop__z_0);
                   end
           endcase
           cb_bcd <= p_bcdop__c_1;
           result_bcd[7:4] <= p_bcdop__s_1;
           result_bcd[3:0] <= p_bcdop__s_0;
       end 
   // end always 
   
//	-- In this process all the condition codes X (eXtended), N (Negative)
//	-- Z (Zero), V (oVerflow) and C (Carry / borrow) are calculated for
//	-- all integer operations. Except for the MULS, MULU, DIVS, DIVU the
//	-- new conditions are valid one clock cycle after the operation starts.
//	-- For the multiplication and the division, the codes are valid after
//	-- BUSY is released.
//	-- Although MOVE, MOVEQ and CHK does not require any data processing by the ALU,
//	-- the condition codes are computated here.
       
   always @ (op or result_bcd or cb_bcd or result_logop or result_intop or op_size or xnzvc_in or result_special or op_in_d_lo or chk_cond or op_in_d_sign_lo or op_in_s_sign or result_i or result_i_out or result_ii or mul_state or div_mul_32n64 or ov_div_mul ) // begin 
       begin 
	  //RM_SM_DM := To_Bit(RM) & To_Bit(SM) & To_Bit(DM);
	  cond_codes__rm_sm_dm = { cond_codes__rm, cond_codes__sm, cond_codes__dm };
           case (op)
               add__op_68k00,addi__op_68k00,addq__op_68k00,addx__op_68k00,cmp__op_68k00,cmpa__op_68k00,cmpi__op_68k00,cmpm__op_68k00,neg__op_68k00,negx__op_68k00,sub__op_68k00,subi__op_68k00,subq__op_68k00,subx__op_68k00 : 
                       case (op_size)
                           LONG : 
                               begin 
                                   cond_codes__rm = result_intop[31];
                                   cond_codes__sm = op_in_s_sign[31];
                                   cond_codes__dm = op_in_d_sign_lo[31];
                               end
                           WORD : 
                               begin 
                                   cond_codes__rm = result_intop[15];
                                   cond_codes__sm = op_in_s_sign[15];
                                   cond_codes__dm = op_in_d_sign_lo[15];
                               end
                           BYTE : 
                               begin 
                                   cond_codes__rm = result_intop[7];
                                   cond_codes__sm = op_in_s_sign[7];
                                   cond_codes__dm = op_in_d_sign_lo[7];
                               end
                       endcase
               default : 
                   begin 
                       cond_codes__rm = 1'bx;
                       cond_codes__sm = 1'bx;
                       cond_codes__dm = 1'bx;
                   end
           endcase
           case (op)
               add__op_68k00,addi__op_68k00,addq__op_68k00,addx__op_68k00,cmp__op_68k00,cmpa__op_68k00,cmpi__op_68k00,cmpm__op_68k00,neg__op_68k00,negx__op_68k00,sub__op_68k00,subi__op_68k00,subq__op_68k00,subx__op_68k00 : 
                       if (((op_size == LONG) & (result_intop == 32'h00000000))) 
                               cond_codes__z = 1'b1;
                       else if (((op_size == WORD) & (result_intop[15:0] == 16'h0000))) 
                               cond_codes__z = 1'b1;
                       else if (((op_size == BYTE) & (result_intop[7:0] == 8'h00))) 
                               cond_codes__z = 1'b1;
                       else 
                               cond_codes__z = 1'b0;

                       
               default : 
                       cond_codes__z = 1'b0;
           endcase
           case (op)
               abcd__op_68k00,nbcd__op_68k00,sbcd__op_68k00 : 
                       if ((result_bcd == 8'h00)) 
                               xnzvc_out <= {{{{cb_bcd,1'bx},xnzvc_in[2]},1'bx},cb_bcd};
                       else 
                               xnzvc_out <= {{{{cb_bcd,1'bx},1'b0},1'bx},cb_bcd};

                       
               add__op_68k00,addi__op_68k00,addq__op_68k00,addx__op_68k00 : 
                   begin 
                       if ((cond_codes__z == 1'b1)) 
                           begin 
                                   if ((op == addx__op_68k00)) 
                                           xnzvc_out[3:2] <= {1'b0,xnzvc_in[2]};
                                   else 
                                           xnzvc_out[3:2] <= 2'b01;

                                   
                           end 
                       else 
                               xnzvc_out[3:2] <= {cond_codes__rm,1'b0};

                       case (cond_codes__rm_sm_dm)
                           3'b011 : 
                                   xnzvc_out[1] <= 1'b1;
                           3'b100 : 
                                   xnzvc_out[1] <= 1'b1;
                           default : 
                                   xnzvc_out[1] <= 1'b0;
                       endcase
                       if (((((cond_codes__sm == 1'b1) & (cond_codes__dm == 1'b1)) | ((cond_codes__rm == 1'b0) & (cond_codes__sm == 1'b1))) | ((cond_codes__rm == 1'b0) & (cond_codes__dm == 1'b1)))) 
                           begin 
                               xnzvc_out[4] <= 1'b1;
                               xnzvc_out[0] <= 1'b1;
                           end
                       else 
                           begin 
                               xnzvc_out[4] <= 1'b0;
                               xnzvc_out[0] <= 1'b0;
                           end

                       
                   end
               clr__op_68k00 : 
                       xnzvc_out <= {xnzvc_in[4],4'b0100};
               sub__op_68k00,subi__op_68k00,subq__op_68k00,subx__op_68k00 : 
                   begin 
                       if ((cond_codes__z == 1'b1)) 
                           begin 
                                   if ((op == subx__op_68k00)) 
                                           xnzvc_out[3:2] <= {1'b0,xnzvc_in[2]};
                                   else 
                                           xnzvc_out[3:2] <= 2'b01;

                                   
                           end 
                       else 
                               xnzvc_out[3:2] <= {cond_codes__rm,1'b0};

                       case (cond_codes__rm_sm_dm)
                           3'b001 : 
                                   xnzvc_out[1] <= 1'b1;
                           3'b110 : 
                                   xnzvc_out[1] <= 1'b1;
                           default : 
                                   xnzvc_out[1] <= 1'b0;
                       endcase
                       if (((((cond_codes__sm == 1'b1) & (cond_codes__dm == 1'b0)) | ((cond_codes__rm == 1'b1) & (cond_codes__sm == 1'b1))) | ((cond_codes__rm == 1'b1) & (cond_codes__dm == 1'b0)))) 
                           begin 
                               xnzvc_out[4] <= 1'b1;
                               xnzvc_out[0] <= 1'b1;
                           end
                       else 
                           begin 
                               xnzvc_out[4] <= 1'b0;
                               xnzvc_out[0] <= 1'b0;
                           end

                       
                   end
               cmp__op_68k00,cmpa__op_68k00,cmpi__op_68k00,cmpm__op_68k00 : 
                   begin 
                       xnzvc_out[4] <= xnzvc_in[4];
                       if ((cond_codes__z == 1'b1)) 
                               xnzvc_out[3:2] <= 2'b01;
                       else 
                               xnzvc_out[3:2] <= {cond_codes__rm,1'b0};

                       case (cond_codes__rm_sm_dm)
                           3'b001 : 
                                   xnzvc_out[1] <= 1'b1;
                           3'b110 : 
                                   xnzvc_out[1] <= 1'b1;
                           default : 
                                   xnzvc_out[1] <= 1'b0;
                       endcase
                       if (((((cond_codes__sm == 1'b1) & (cond_codes__dm == 1'b0)) | ((cond_codes__rm == 1'b1) & (cond_codes__sm == 1'b1))) | ((cond_codes__rm == 1'b1) & (cond_codes__dm == 1'b0)))) 
                               xnzvc_out[0] <= 1'b1;
                       else 
                               xnzvc_out[0] <= 1'b0;

                       
                   end
               neg__op_68k00,negx__op_68k00 : 
                   begin 
                       if ((cond_codes__z == 1'b1)) 
                           begin 
                                   if ((op == negx__op_68k00)) 
                                           xnzvc_out[3:2] <= {1'b0,xnzvc_in[2]};
                                   else 
                                           xnzvc_out[3:2] <= 2'b01;

                                   
                           end 
                       else 
                               xnzvc_out[3:2] <= {cond_codes__rm,1'b0};

                       xnzvc_out[4] <= (cond_codes__dm | cond_codes__rm);
                       xnzvc_out[1] <= (cond_codes__dm & cond_codes__rm);
                       xnzvc_out[0] <= (cond_codes__dm | cond_codes__rm);
                   end
               and_b__op_68k00,andi__op_68k00,eor__op_68k00,eori__op_68k00,or_b__op_68k00,ori__op_68k00,move__op_68k00,not_b__op_68k00,tst__op_68k00 : 
                       case (op_size)
                           LONG : 
                                   if ((result_logop == 32'h00000000)) 
                                           xnzvc_out <= {xnzvc_in[4],4'b0100};
                                   else 
                                           xnzvc_out <= {{xnzvc_in[4],result_logop[31]},3'b000};

                                   
                           WORD : 
                                   if ((result_logop[15:0] == 16'h0000)) 
                                           xnzvc_out <= {xnzvc_in[4],4'b0100};
                                   else 
                                           xnzvc_out <= {{xnzvc_in[4],result_logop[15]},3'b000};

                                   
                           default : 
                                   if ((result_logop[7:0] == 8'h00)) 
                                           xnzvc_out <= {xnzvc_in[4],4'b0100};
                                   else 
                                           xnzvc_out <= {{xnzvc_in[4],result_logop[7]},3'b000};

                                   
                       endcase
               chk__op_68k00 : 
                       if ((op_in_d_sign_lo[31] == 1'b1)) 
                               xnzvc_out <= {{xnzvc_in[4],1'b1},3'bxxx};
                       else if ((chk_cond == 1'b1)) 
                               xnzvc_out <= {{xnzvc_in[4],1'b0},3'bxxx};
                       else 
                               xnzvc_out <= {xnzvc_in[4:3],3'bxxx};

                       
               divs__op_68k00,divu__op_68k00 : 
                       if (((op_size == WORD) & (result_i_out[15] == 1'b1))) 
                               xnzvc_out <= {{{{xnzvc_in[4],1'b1},1'b0},ov_div_mul},1'b0};
                       else if (((op_size == WORD) & (result_i_out[15:0] == 16'h0000))) 
                               xnzvc_out <= {{{{xnzvc_in[4],1'b0},1'b1},ov_div_mul},1'b0};
                       else if (((op_size == LONG) & (result_i_out[31] == 1'b1))) 
                               xnzvc_out <= {{{{xnzvc_in[4],1'b1},1'b0},ov_div_mul},1'b0};
                       else if (((op_size == LONG) & (result_i_out == 32'h00000000))) 
                               xnzvc_out <= {{{{xnzvc_in[4],1'b0},1'b1},ov_div_mul},1'b0};
                       else 
                               xnzvc_out <= {{{{xnzvc_in[4],1'b0},1'b0},ov_div_mul},1'b0};

                       
               extw__op_68k00 : 
                       case (op_size)
                           LONG : 
                                   if ((result_special == 32'h00000000)) 
                                           xnzvc_out <= {xnzvc_in[4],4'b0100};
                                   else 
                                           xnzvc_out <= {{xnzvc_in[4],result_special[31]},3'b000};

                                   
                           default : 
                                   if ((result_special[15:0] == 16'h0000)) 
                                           xnzvc_out <= {xnzvc_in[4],4'b0100};
                                   else 
                                           xnzvc_out <= {{xnzvc_in[4],result_special[15]},3'b000};

                                   
                       endcase
               moveq__op_68k00 : 
                       if ((op_in_s_sign[7:0] == 8'h00)) 
                               xnzvc_out <= {xnzvc_in[4],4'b0100};
                       else 
                               xnzvc_out <= {{xnzvc_in[4],op_in_s_sign[7]},3'b000};

                       
               muls__op_68k00,mulu__op_68k00 : 
                   begin 
                       xnzvc_out <= {{{{xnzvc_in[4],1'b0},1'b0},1'b0},1'b0};
                       if (((result_i == 32'h00000000) & (result_ii[31:0] == 32'h00000000))) 
                               xnzvc_out <= {{{{xnzvc_in[4],1'b0},1'b1},1'b0},1'b0};
                       else if (((op_size == WORD) & (result_i[31] == 1'b1))) 
                               xnzvc_out <= {{{{xnzvc_in[4],1'b1},1'b0},1'b0},1'b0};
                       else if (((op_size == LONG) & (div_mul_32n64 == 1'b0))) 
                           begin 
                                   if (((ov_div_mul == 1'b1) & (op_in_d_lo[31] == 1'b1))) 
                                           xnzvc_out <= {{{{xnzvc_in[4],1'b1},1'b0},1'b1},1'b0};
                                   else if (((ov_div_mul == 1'b1) & (op_in_d_lo == 32'h00000000))) 
                                           xnzvc_out <= {{{{xnzvc_in[4],1'b0},1'b1},1'b1},1'b0};
                                   else if ((result_i[31] == 1'b1)) 
                                           xnzvc_out <= {{{{xnzvc_in[4],1'b1},1'b0},1'b0},1'b0};
                                   else if ((result_i == 32'h00000000)) 
                                           xnzvc_out <= {{{{xnzvc_in[4],1'b0},1'b1},1'b0},1'b0};

                                   
                           end 
                       else if (((op_size == LONG) & (result_ii[31] == 1'b1))) 
                               xnzvc_out <= {{{{xnzvc_in[4],1'b1},1'b0},1'b0},1'b0};
                       else if (((op_size == LONG) & ({result_ii,result_i} == {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0/*aggregate*/}))) 
                               xnzvc_out <= {{{{xnzvc_in[4],1'b0},1'b1},1'b0},1'b0};

                       
                   end
               swap__op_68k00 : 
                       if ((result_special == 32'h00000000)) 
                               xnzvc_out <= {xnzvc_in[4],4'b0100};
                       else 
                               xnzvc_out <= {{xnzvc_in[4],result_special[31]},3'b000};

                       
               tas__op_68k00 : 
                       if ((op_in_d_sign_lo[7:0] == 8'h00)) 
                               xnzvc_out <= {xnzvc_in[4],4'b0100};
                       else 
                               xnzvc_out <= {{xnzvc_in[4],op_in_d_sign_lo[7]},3'b000};

                       
               default : 
                       xnzvc_out <= 5'bxxxxx;
           endcase
       end 
   // end always 
   
   assign {mul_div_op_s}=(((op_size == WORD) & (op_in_s[15] == 1'b1)) & ((op == muls__op_68k00) | (op == divs__op_68k00))) ? 
                             {16'hFFFF,op_in_s[15:0]}
                          : (op_size == WORD) ? 
                             {16'h0000,op_in_s[15:0]}
                          :  op_in_s;
   
   assign {mul_op_d}=(((op_size == WORD) & (op_in_d_lo[15] == 1'b1)) & (op == muls__op_68k00)) ? 
                         {16'hFFFF,op_in_d_lo[15:0]}
                      : (op_size == WORD) ? 
                         {16'h0000,op_in_d_lo[15:0]}
                      :  op_in_d_lo;
   
       
   always @ (negedge resetn or posedge clk ) // begin 
           if ((resetn == 1'b0)) 
               begin 
                   result_i <= {(31-0+1- 0){1'b0}};
                   result_ii <= {(32-0+1- 0){1'b0}};
                   mul_div_buffer__div_result_var = {(32-0+1- 0){1'b0}};
                   ov_div_mul <= 1'b0;
               end
               
           else 
               
                   if ((op_start == 1'b1)) 
                       begin 
                           ov_div_mul <= 1'b0;
                           case (op)
                               muls__op_68k00,mulu__op_68k00 : 
                                   begin 
                                       result_ii <= {(32-0+1- 0){1'b0}};
                                       if (((op_in_d_lo == 32'h00000000) | (op_in_s == 32'h00000000))) 
                                               result_i <= 32'h00000000;
                                       else 
                                               result_i <= mul_op_d;

                                       
                                   end
                               divu__op_68k00 : 
                                   begin 
                                       if (((op_size == LONG) & (div_mul_32n64 == 1'b1))) 
                                               dividend <= {op_in_d_hi,op_in_d_lo};
                                       else 
                                               dividend <= {32'h00000000,op_in_d_lo};

                                       divisor <= {32'h00000000,mul_div_op_s};
                                       result_i <= {(31-0+1- 0){1'b0}};
                                       result_ii <= {(32-0+1- 0){1'b0}};
                                       div_var <= 32'h00000001;
                                       mul_div_buffer__div_result_var = {(32-0+1- 0){1'b0}};
                                   end
                               divs__op_68k00 : 
                                   begin 
                                       if ((((op_size == LONG) & (div_mul_32n64 == 1'b1)) & (op_in_d_hi[31] == 1'b0))) 
                                               dividend <= {op_in_d_hi,op_in_d_lo};
                                       else if (((op_size == LONG) & (div_mul_32n64 == 1'b1))) 
                                               dividend <= (~ ({op_in_d_hi,op_in_d_lo}) + 1'b1);
                                       else if ((op_in_d_lo[31] == 1'b0)) 
                                               dividend <= {32'h00000000,op_in_d_lo};
                                       else 
                                               dividend <= ({32'h00000000,~ (op_in_d_lo)} + 1'b1);

                                       if ((mul_div_op_s[31] == 1'b1)) 
                                               divisor <= ({32'h00000000,~ (mul_div_op_s)} + 1'b1);
                                       else 
                                               divisor <= {32'h00000000,mul_div_op_s};

                                       result_i <= {(31-0+1- 0){1'b0}};
                                       result_ii <= {(32-0+1- 0){1'b0}};
                                       div_var <= 32'h00000001;
                                       mul_div_buffer__div_result_var = {(32-0+1- 0){1'b0}};
                                   end
                               default : 
                                       ;//null
                           endcase
                       end
                       
                   else if ((mul_state == mul_add__mul_states)) 
                       result_ii <= (result_ii + mul_div_op_s);
                       
                   else if ((mul_state == mul_verify_shift__mul_states)) 
                       begin 
                           case (mul_cyc_cnt)
                               6'b000000 : 
                                       if (((((op == muls__op_68k00) & (op_size == LONG)) & (mul_div_op_s[31] == 1'b1)) & (op_in_d_lo[31] == 1'b1))) 
                                               result_ii <= (((({1'b0,result_ii[32:1]} + ~ (op_in_d_lo)) + 1'b1) + ~ (mul_div_op_s)) + 1'b1);
                                       else if ((((op == muls__op_68k00) & (op_size == LONG)) & (mul_div_op_s[31] == 1'b1))) 
                                               result_ii <= (({1'b0,result_ii[32:1]} + ~ (op_in_d_lo)) + 1'b1);
                                       else if ((((op == muls__op_68k00) & (op_size == LONG)) & (op_in_d_lo[31] == 1'b1))) 
                                               result_ii <= (({1'b0,result_ii[32:1]} + ~ (mul_div_op_s)) + 1'b1);
                                       else 
                                               result_ii <= {1'b0,result_ii[32:1]};

                                       
                               default : 
                                       result_ii <= {1'b0,result_ii[32:1]};
                           endcase
                           result_i <= {result_ii[0],result_i[31:1]};
                           if ((((((op == muls__op_68k00) & (op_size == LONG)) & (result_i[31] == 1'b1)) & (div_mul_32n64 == 1'b0)) & (!(result_ii[31:0]==32'hFFFFFFFF)))) 
                               ov_div_mul <= 1'b1;
                               
                           else if ((((((op == muls__op_68k00) & (op_size == LONG)) & (result_i[31] == 1'b0)) & (div_mul_32n64 == 1'b0)) & (!(result_ii[31:0]==32'h00000000)))) 
                               ov_div_mul <= 1'b1;
                               
                           else if (((((op == mulu__op_68k00) & (op_size == LONG)) & (div_mul_32n64 == 1'b0)) & (!(result_ii[31:0]==32'h00000000)))) 
                               ov_div_mul <= 1'b1;
                               
                           
                           
                       end
                       
                   else if ((div_shift_en == 1'b1)) 
                       begin 
                           divisor <= {divisor[62:0],1'b0};
                           div_var <= {div_var[30:0],1'b0};
                       end
                       
                   else if ((div_state == div_addsub__div_states)) 
                       begin 
                           dividend <= (dividend - divisor);
                           mul_div_buffer__div_result_var = ({1'b0,result_i} + div_var);
                           result_i <= mul_div_buffer__div_result_var[31:0];
                           div_var <= 32'h00000001;
                           if (((op == divs__op_68k00) & (mul_div_op_s[31] == 1'b1))) 
                               divisor <= ({32'h00000000,~ (mul_div_op_s)} + 1'b1);
                               
                           else 
                               divisor <= {32'h00000000,mul_div_op_s};
                               
                           
                           if ((((op_size == LONG) & (op == divs__op_68k00)) & (!(mul_div_buffer__div_result_var[32:31]==2'b00)))) 
                               ov_div_mul <= 1'b1;
                               
                           else if ((((op_size == WORD) & (op == divs__op_68k00)) & (!(mul_div_buffer__div_result_var[32:15]==18'b000000000000000000)))) 
                               ov_div_mul <= 1'b1;
                               
                           else if ((((op_size == LONG) & (op == divu__op_68k00)) & (mul_div_buffer__div_result_var[32] == 1'b1))) 
                               ov_div_mul <= 1'b1;
                               
                           else if ((((op_size == WORD) & (op == divu__op_68k00)) & (!(mul_div_buffer__div_result_var[32:16]==17'b00000000000000000)))) 
                               ov_div_mul <= 1'b1;
                               
                           
                           
                       end
                       
                   else if ((div_state == div_sign__div_states)) 
                       begin 
                           case (op_size)
                               LONG : 
                                       if ((((div_mul_32n64 == 1'b1) & (op == divs__op_68k00)) & ((op_in_d_hi[31] ^ op_in_s[31]) == 1'b1))) 
                                               result_i <= (~ (result_i) + 1'b1);
                                       else if (((op == divs__op_68k00) & ((op_in_d_lo[31] ^ op_in_s[31]) == 1'b1))) 
                                               result_i <= (~ (result_i) + 1'b1);

                                       
                               default : 
                                       if (((op == divs__op_68k00) & ((op_in_d_lo[31] ^ op_in_s[15]) == 1'b1))) 
                                               result_i <= (~ (result_i) + 1'b1);

                                       
                           endcase
                           if (((((op == divs__op_68k00) & (op_size == LONG)) & (div_mul_32n64 == 1'b1)) & (op_in_d_hi[31] == 1'b1))) 
                               result_ii[31:0] <= (~ (dividend[31:0]) + 1'b1);
                               
                           else if (((op == divs__op_68k00) & (op_in_d_lo[31] == 1'b1))) 
                               result_ii[31:0] <= (~ (dividend[31:0]) + 1'b1);
                               
                           else 
                               result_ii[31:0] <= dividend[31:0];
                               
                           
                           
                       end
                       
                   
                   
               
           
   // end always 
   
   always @ (negedge resetn or posedge clk ) begin 
       if ((resetn == 1'b0)) 
           begin 
               mul_cyc_cnt <= 6'b000000;
               mul_state <= mul_idle__mul_states;
           end
           
       else 
           begin 
               mul_state <= next_mul_state;
               if ((((op == muls__op_68k00) | (op == mulu__op_68k00)) & (op_start == 1'b1))) 
                   mul_cyc_cnt <= 6'b100000;
                   
               else if (((mul_state == mul_verify_shift__mul_states) & ((op_in_d_lo == 32'h00000000) | (op_in_s == 32'h00000000)))) 
                   mul_cyc_cnt <= 6'b000000;
                   
               else if ((mul_state == mul_verify_shift__mul_states)) 
                   case (mul_cyc_cnt)
                       6'b000000 : 
                               ;//null
                       default : 
                               mul_cyc_cnt <= (mul_cyc_cnt - 1'b1);
                   endcase
                   
               
               
           end
           
       
    end// always 
       
   always @ (resetn or clk or mul_cyc_cnt or mul_state ) // begin 
       begin 
           case (mul_cyc_cnt)
               6'b000000 : 
                       if ((mul_state == mul_idle__mul_states)) 
                               op_mul <= 1'b0;
                       else 
                               op_mul <= 1'b1;

                       
               default : 
                       op_mul <= 1'b1;
           endcase
       end 
   // end always 
   
       
   always @ (mul_state or op_start or op or result_i or mul_cyc_cnt or op_in_d_lo or op_in_s ) // begin 
           case (mul_state)
               mul_idle__mul_states : 
                       if ((((op == muls__op_68k00) | (op == mulu__op_68k00)) & (op_start == 1'b1))) 
                               next_mul_state <= mul_verify_shift__mul_states;
                       else 
                               next_mul_state <= mul_idle__mul_states;

                       
               mul_verify_shift__mul_states : 
                       if (((op_in_d_lo == 32'h00000000) | (op_in_s == 32'h00000000))) 
                               next_mul_state <= mul_idle__mul_states;
                       else if ((result_i[0] == 1'b1)) 
                               next_mul_state <= mul_add__mul_states;
                       else 
                               case (mul_cyc_cnt)
                                   6'b000000 : 
                                           next_mul_state <= mul_idle__mul_states;
                                   default : 
                                           next_mul_state <= mul_verify_shift__mul_states;
                               endcase

                       
               mul_add__mul_states : 
                       next_mul_state <= mul_verify_shift__mul_states;
           endcase
   // end always 
   
       
   always @ (negedge resetn or posedge clk ) // begin 
           if ((resetn == 1'b0)) 
               div_state <= div_idle__div_states;
               
           else 
               div_state <= next_div_state;
               
           
   // end always 
   
       
   always @ (div_state or op_start or op or op_in_s or dividend or divisor or result_i or op_size or ov_div_mul ) // begin 
       begin 
           div_shift_en <= 1'b0;
           op_div <= 1'b1;
           case (div_state)
               div_idle__div_states : 
                   begin 
                       if (((((op == divs__op_68k00) | (op == divu__op_68k00)) & (op_start == 1'b1)) & (op_in_s == 32'h00000000))) 
                               next_div_state <= div_idle__div_states;
                       else if ((((op == divs__op_68k00) | (op == divu__op_68k00)) & (op_start == 1'b1))) 
                               next_div_state <= div_verify__div_states;
                       else 
                               next_div_state <= div_idle__div_states;

                       op_div <= 1'b0;
                   end
               div_verify__div_states : 
                       if ((ov_div_mul == 1'b1)) 
                               next_div_state <= div_idle__div_states;
                       else if ((dividend < divisor)) 
                               next_div_state <= div_sign__div_states;
                       else if (({divisor[63:0],1'b0} > {1'b0,dividend})) 
                               next_div_state <= div_addsub__div_states;
                       else 
                           begin 
                               next_div_state <= div_verify__div_states;
                               div_shift_en <= 1'b1;
                           end

                       
               div_addsub__div_states : 
                       next_div_state <= div_verify__div_states;
               div_sign__div_states : 
                       next_div_state <= div_idle__div_states;
           endcase
       end 
   // end always 
    

endmodule
//--------------------------------------------------------------------
//--                                                              ----
//-- MC68000 compatible IP Core					                  ----
//--                                                              ----
//-- This file is part of the SUSKA ATARI clone project.          ----
//-- http://www.experiment-s.de                                   ----
//--                                                              ----
//-- Description:                                                 ----
//-- This model provides an opcode and bus timing compatible ip   ----
//-- core compared to Motorola's MC68000 microprocessor.          ----
//--                                                              ----
//-- This file is the package file of the ip core.                ----
//--                                                              ----
//--                                                              ----
//--                                                              ----
//--                                                              ----
//-- Author(s):                                                   ----
//-- - Wolfgang Foerster, wf@experiment-s.de; wf@inventronik.de   ----
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
// Revision 2K8A  2008/07/14 WF
//   See the 68K00 top level file.
// Revision 2K8B  2008/12/24 WF
//   See the 68K00 top level file.
// 

