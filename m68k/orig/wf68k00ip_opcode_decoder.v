//--------------------------------------------------------------------
//--                                                              ----
//-- MC68000 compatible IP Core                                   ----
//--                                                              ----
//-- This file is part of the SUSKA ATARI clone project.          ----
//-- http://www.experiment-s.de                                   ----
//--                                                              ----
//-- Description:                                                 ----
//-- This model provides an opcode and bus timing compatible ip   ----
//-- core compared to Motorola's MC68000 microprocessor.          ----
//--                                                              ----
//-- This file contains the opcode decoder.                       ----
//--                                                              ----
//--                                                              ----
//-- Description:                                                 ----
//-- Performs an instruction opcode decoding and the control      ----
//-- functions for all other blocks.                              ----
//-- This Opcode decoder of the 68K00 decodes already the opera-  ----
//-- tions long division (signed and unsigned (DIVL) and long     ----
//-- multiplication (signed and unsigned) (MULL).                 ----
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
// Revision 2K13B  20131224 WF
//   Minor optimizations.
// 


module  wf68k00ip_opcode_decoder ( clk, resetn, data_in, sbit, ov, iw_adr, iw_wr, force_biw2, force_biw3, ext_cnt, dest_ext_cnt, dr, rm, ir, op, op_size, op_mode, biw_0, regsel_20, regsel_119, regsel_index, data_immediate, trap_vector, c_code, mem_shft, reglistmask, bitpos_im, bit_pos, div_mul_32n64, reg_dlq, reg_dhr, scan_traps, trap_illegal, trap_1010, trap_1111, trap_priv, trap_op, trap_v, ew_wr, ew_adr, src_destn, exword, dest_exword, adr_mode, move_d_am, ext_dsize, sel_displace_biw, displace_biw );
    //type op_sizetype
     parameter long__op_sizetype=2'd0;
     parameter word__op_sizetype=2'd1;
     parameter byte__op_sizetype=2'd2;
     
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
     

    input  [0:0] clk;
    input  [0:0] resetn;
    input [15:0]  data_in ;
    input  [0:0] sbit;
    input ov; // -- Overflow flag.
   //-- Instruction word controls:
    input iw_adr; //-- Instruction word address.
    input  [0:0] iw_wr;//-- Instruction word write control.

   //-- Further load controls (besides the first instruction word):
    output  [0:0] force_biw2;
    output  [0:0] force_biw3;
    output ext_cnt;
    output dest_ext_cnt;

   //-- System control flags:
    output  [0:0] dr;
    output  [0:0] rm;
    output  [0:0] ir;

   //-- System control signals:
    output  [6:0] op;
    output  [1:0] op_size;//-- Operand size.
    output [4:0]  op_mode ;
    output [15:0]  biw_0 ;
    output [2:0]  regsel_20 ;
    output [2:0]  regsel_119 ;
    output [2:0]  regsel_index ;
    output [31:0]  data_immediate ;
    output [3:0]  trap_vector ;
    output [3:0]  c_code ;
    output  [0:0] mem_shft;//-- Shift operations in registers ('0') or in memory ('1').
    output [15:0]  reglistmask ;//-- Used in MOVEM.

   //-- Bit operations:
    output  [0:0] bitpos_im;
    output [4:0]  bit_pos ;

   //-- Multiplication / Division:
    output  [0:0] div_mul_32n64;
    output [2:0]  reg_dlq ;
    output [2:0]  reg_dhr ;

   //-- Traps:
    input  [0:0] scan_traps;
    output  [0:0] trap_illegal;
    output  [0:0] trap_1010;
    output  [0:0] trap_1111;
    output  [0:0] trap_priv;
    output  [0:0] trap_op;
    output  [0:0] trap_v;

   //-- Extension word controls:
    input  [0:0] ew_wr; //-- Write control.
    input ew_adr; //-- Source extension word address.
    input  [0:0] src_destn; //-- '1' for read operand from source, '0' store result to destination (MOVE).

   //-- Extension words:
    output [15:0]  exword  [0:1];
    output [15:0]  dest_exword  [0:1];

   //-- Address computation stuff:
    output [2:0]  adr_mode ; //-- Address mode indicator.
    output [2:0]  move_d_am ;//-- Move statement destination address mode.
    output  [1:0] ext_dsize;//-- Displacement size, BYTE or WORD.
    output  [0:0] sel_displace_biw;//-- Select displacement from the basic instruction word BIW, when '1'.
    output [31:0]  displace_biw ;//-- Displacement (direct encoded, 8 or 16 bit).


    reg [15:0] biw [0:2];//-- Instruction word registers.
wire [0:0] ext_en;
reg [6:0] op_i;
wire [1:0] op_size_i;
    reg [15:0] exword_reg [0:1];
    reg [15:0] dest_exword_reg [0:1];
wire [0:0] force_biw2;
wire [0:0] force_biw3;
    wire [31:0] ext_cnt;
    wire [31:0] dest_ext_cnt;
wire [0:0] dr;
wire [0:0] rm;
wire [0:0] ir;
wire [6:0] op;
wire [1:0] op_size;
    wire [4:0] op_mode;
    wire [15:0] biw_0;
    wire [2:0] regsel_20;
    wire [2:0] regsel_119;
    wire [2:0] regsel_index;
    wire [31:0] data_immediate;
    wire [3:0] trap_vector;
    wire [3:0] c_code;
wire [0:0] mem_shft;
    wire [15:0] reglistmask;
wire [0:0] bitpos_im;
    wire [4:0] bit_pos;
wire [0:0] div_mul_32n64;
    wire [2:0] reg_dlq;
    wire [2:0] reg_dhr;
wire [0:0] trap_illegal;
wire [0:0] trap_1010;
wire [0:0] trap_1111;
wire [0:0] trap_priv;
wire [0:0] trap_op;
wire [0:0] trap_v;
    wire [15:0] exword [0:1];
    wire [15:0] dest_exword [0:1];
    wire [2:0] adr_mode;
    wire [2:0] move_d_am;
wire [1:0] ext_dsize;
wire [0:0] sel_displace_biw;
    wire [31:0] displace_biw;


    
   //-- In this process the required source and destination extension words
   //-- for the operations are stored. This process works on the negative 
   //-- clock edge to meet the timing requirements in conjunction with the 
   //-- bus interface and the system control state machine.
       
   always @ (negedge resetn or negedge clk ) // begin 
           if ((resetn == 1'b0)) 
               begin :Block_Name_1
                   integer i;
                   for (i=0;i<=1;i=i+1) begin 
                       begin 
                           exword_reg[i] <= {(15-0+1- 0){1'b0}};
                           dest_exword_reg[i] <= {(15-0+1- 0){1'b0}};
                       end
                       
                   end //for
               end //end Block
               
           else 
             //-- The extension words are written but never initialized
             //-- during the operation. This does not take any negative
             //-- effect because the operations, using the extensions,
             //-- overwrite the respective words during instruction
             //-- load process.
               
                   if (((ew_wr == 1'b1) & (src_destn == 1'b1))) 
                       exword_reg[ew_adr] <= data_in;
                       
                   else if ((ew_wr == 1'b1)) 
                       dest_exword_reg[ew_adr] <= data_in;
                       
                   
                   
               
           
   // end always 
   
   assign {exword}=exword_reg;
   
   assign {dest_exword}=dest_exword_reg;
   
   //-- Copy signal to port:
   assign {op}=op_i;
   
   //-- TRAPS:
   assign {trap_1010}=((scan_traps == 1'b1) & (biw[0][15:12] == 4'b1010)) ? 
                          1'b1
                       :  1'b0;
   
   assign {trap_1111}=((scan_traps == 1'b1) & (biw[0][15:12] == 4'b1111)) ? 
                          1'b1
                       :  1'b0;
   
   assign {trap_illegal}=((scan_traps == 1'b1) & (op_i == illegal__op_68k00)) ? 
                             1'b1
                          :  1'b0;
   
   assign {trap_op}=((scan_traps == 1'b1) & (op_i == trap__op_68k00)) ? 
                        1'b1
                     :  1'b0;
   
   assign {trap_v}=(((scan_traps == 1'b1) & (op_i == trapv__op_68k00)) & (ov == 1'b1)) ? 
                       1'b1
                    :  1'b0;
   
   assign trap_priv=op_i==andi_to_sr__op_68k00 ? (~ (sbit) & scan_traps) : 
           op_i==eori_to_sr__op_68k00 ? (~ (sbit) & scan_traps) : 
           op_i==move_to_sr__op_68k00 ? (~ (sbit) & scan_traps) : 
           op_i==move_usp__op_68k00 ? (~ (sbit) & scan_traps) : 
           op_i==ori_to_sr__op_68k00 ? (~ (sbit) & scan_traps) : 
           op_i==reset__op_68k00 ? (~ (sbit) & scan_traps) : 
           op_i==rte__op_68k00 ? (~ (sbit) & scan_traps) : 
           op_i==stop__op_68k00 ? (~ (sbit) & scan_traps) : 
           1'b0;
   

   //-- In this process the different OPCODE registers store all required information for
   //-- the instruction processing. Depending on the operation, at least the Basic Instruction
   //-- Word BIW(0) is stored followed by a second and third instruction word Word BIW(1) and
   //-- BIW(2), if required. This process works on the negative clock edge to meet the timing
   //-- requirements in conjunction with the bus interface and the system control state machine.
       
   always @ (negedge resetn or negedge clk ) // begin 
           if ((resetn == 1'b0)) 
               begin 
                   biw[0] <= {(15-0+1- 0){1'b0}};
                   biw[1] <= {(15-0+1- 0){1'b0}};
                   biw[2] <= {(15-0+1- 0){1'b0}};
               end
               
           else 
               
                   if ((iw_wr == 1'b1)) 
                       biw[iw_adr] <= data_in;
                       
   // end always 
   
   assign {biw_0}=biw[0];

   assign dr =  op_i == MOVEM ? biw[0][10] :
		op_i == MOVE_USP ? biw[0][3] :
		biw[0][8]; // Default is valid for ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXR.
   
   assign rm = biw[0][3]; //-- Valid for SBCD, SUBX, ABCD, ADDX.
   assign ir = biw[0][5]; //-- Valid for ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXR.
   
   //-- Addressing mode:
   //-- The Default is valid for ORI, ANDI, SUBI, CALLM, ADDI, EORI, CMPI, BTST, BCHG, BCLR, BSET,
   //-- MOVEA, MOVE_FROM_CCR, MOVE_FROM_SR, NEGX, CLR, MOVE_TO_CCR, NEG, NOT, MOVE_TO_SR, NBCD, PEA, 
   //-- TAS, TST, MULYU, MULS, DIVU, DIVS, JSR, JMP, MOVEM, LEA, CHK, ADDQ, SUBQ, OR, SUB, SUBA,
   //--  CMP, CMPA, EOR, AND, ADDA, ADD, ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXR.
   assign {adr_mode}=((((op_i == abcd__op_68k00) | (op_i == sbcd__op_68k00)) | (op_i == addx__op_68k00)) | (op_i == subx__op_68k00)) ? 
                         3'b100
                      : (op_i == cmpm__op_68k00) ?  //  -- Postincrement.
                         3'b011
                      : (op_i == movep__op_68k00) ? //-- Address register indirect plus 16 bit displacement.
                         3'b101
                      :  biw[0][5:3];
   
   assign {move_d_am}=biw[0][8:6]; //-- Move statement destination address mode.
   
   assign {regsel_20}=biw[0][2:0];//-- Valid for ORI, ANDI, SUBI, ADDI, EORI, CMPI, BTST, BCHG, BCLR
                                    //    -- BCLR, BSET, MOVEP, MOVEA, MOVE, MOVE_FROM_CCR, MOVE_FROM_SR,
                                      //  -- MOVE_TO_CCR,  NEGX, CLR, NEG, NOT, MOVE_TO_SR, EXT, NBCD,
                                      //  -- SWAP, PEA, TAS, TST, MULU, MULS, DIVU, DIVS, LINK, UNLK,
                                      //  -- MOVE_USP, JSR, JMP, MOVEM, LEA, CHK, ADDQ, SUBQ, DBcc, Scc,
                                      //  -- OR, SUBX, SUB, SUBA, CMPM, CMP, CMPA, EOR, ABCD, EXG, AND,
                                      //  -- ADDX, ADDA, ADD, ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXR.
   
   assign {regsel_119}=biw[0][11:9];// -- Valid for BTST, BCHG, BCLR, BSET,MOVEP, MOVEA, MOVE, LEA,
                                    //    -- CHK, MULU, MULS, DIVU, DIVS, SBCD, OR, SUBX, SUB, SUBA,
                                    //    -- CMPM, CMP, CMPA, EOR, ABCD, EXG, AND, ADDX, ADDA, ADD.
   
   assign {regsel_index}=(src_destn == 1'b1) ? 
                             exword_reg[0][14:12]
                          :  dest_exword_reg[0][14:12];
   
   assign {c_code}=biw[0][11:8]; //-- Valid for Bcc, DBcc, Scc.
   
   assign {op_mode}=(op_i == exg__op_68k00) ? //-- Valid for EXT, OR, SUB, SUBA, CMP, CMPA, EOR, AND, ADDA, ADD.
                        biw[0][7:3]
                     :  {2'b00,biw[0][8:6]};
   
   assign {trap_vector}=biw[0][3:0]; //-- Valid for TRAP.
   
   assign sel_displace_biw=op_i==bcc__op_68k00 ? 1'b1 : 
           op_i==bra__op_68k00 ? 1'b1 : 
           op_i==bsr__op_68k00 ? 1'b1 : 
           op_i==dbcc__op_68k00 ? 1'b1 : 
           op_i==movep__op_68k00 ? 1'b1 : 
           op_i==link__op_68k00 ? 1'b1 : 
           1'b0;
   
   assign {displace_biw}=((op_i == bra__op_68k00) & (biw[0][7:0] == 8'h00)) ? //-- Word displacement.
                             {16'h0000,biw[1]}
                          : ((op_i == bra__op_68k00) & (biw[0][7:0] == 8'hFF)) ? //-- LONG displacement 68K20+.
                             {biw[1],biw[2]}
                          : ((op_i == bsr__op_68k00) & (biw[0][7:0] == 8'h00)) ? 
                             {16'h0000,biw[1]}
                          : ((op_i == bsr__op_68k00) & (biw[0][7:0] == 8'hFF)) ? //-- LONG displacement 68K20+.
                             {biw[1],biw[2]}
                          : ((op_i == bcc__op_68k00) & (biw[0][7:0] == 8'h00)) ? 
                             {16'h0000,biw[1]}
                          : (((op_i == bra__op_68k00) | (op_i == bsr__op_68k00)) | (op_i == bcc__op_68k00)) ? 
                             {24'h000000,biw[0][7:0]}
                          : ((op_i == link__op_68k00) & (op_size_i == long__op_sizetype)) ? 
                             {biw[1],biw[2]}
                          :  {16'h0000,biw[1]}; //-- Valid for DBcc, LINK, MOVEP.
   
   assign {ext_dsize}=((op_i == link__op_68k00) & (op_size_i == long__op_sizetype)) ? 
                          long__d_sizetype
                       : (((op_i == dbcc__op_68k00) | (op_i == movep__op_68k00)) | (op_i == link__op_68k00)) ? 
                          word__d_sizetype
                       : ((op_i == bra__op_68k00) & (biw[0][7:0] == 8'h00)) ? 
                          word__d_sizetype
                       : ((op_i == bra__op_68k00) & (biw[0][7:0] == 8'hFF)) ? //-- 68K20+.
                          long__d_sizetype
                       : ((op_i == bsr__op_68k00) & (biw[0][7:0] == 8'h00)) ? 
                          word__d_sizetype
                       : ((op_i == bsr__op_68k00) & (biw[0][7:0] == 8'hFF)) ? // -- 68K20+.
                          long__d_sizetype
                       : ((op_i == bcc__op_68k00) & (biw[0][7:0] == 8'hFF)) ? // -- 68K20+.
                          long__d_sizetype
                       : ((op_i == bcc__op_68k00) & (biw[0][7:0] == 8'h00)) ? 
                          word__d_sizetype
                       : (((op_i == bra__op_68k00) | (op_i == bsr__op_68k00)) | (op_i == bcc__op_68k00)) ? 
                          byte__d_sizetype
                       : ((biw[0][8:6] == 3'b101) & (src_destn == 1'b0)) ? //-- MOVE.
                          word__d_sizetype
                       : ((biw[0][8:6] == 3'b110) & (src_destn == 1'b0)) ? //-- MOVE.
                          byte__d_sizetype
                       : ((biw[0][5:3] == 3'b111) & (biw[0][2:0] == 3'b010)) ? 
                          word__d_sizetype
                       : (biw[0][5:3] == 3'b101) ? 
                          word__d_sizetype
                       :  byte__d_sizetype;
   
   //-- The immediate data is modelled in a way, that not used bits are forced to zero. This requires
   //-- a bit more logic but makes the CPU immune against compiler behavior concerning the writing of the
   //-- none used bits in word and byte mode.
   //-- The last two assignments are valid (in the respective mode) for: ADD, ADDA, AND, BTST, CHK, CMP, CMPA,
   //-- DIVS, DIVU, MOVEA, MOVE_TO_CCR, MOVE_TO_SR, MULS, MULU, OR, SUB, SUBA, TST.
   assign {data_immediate}=((op_i == ori_to_ccr__op_68k00) | (op_i == eori_to_ccr__op_68k00)) ? 
                               {{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0/*aggregate*/},biw[1][7:0]}
                            : (((op_i == eori_to_sr__op_68k00) | (op_i == ori_to_sr__op_68k00)) | (op_i == andi_to_sr__op_68k00)) ? 
                               {16'h0000,biw[1]}
                            : (((op_i == addq__op_68k00) | (op_i == subq__op_68k00)) & (biw[0][11:9] == 3'b000)) ? 
                               32'h00000008
                            : ((op_i == addq__op_68k00) | (op_i == subq__op_68k00)) ? 
                               {{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0/*aggregate*/},biw[0][11:9]}
                            : (((op_i == andi__op_68k00) | (op_i == addi__op_68k00)) & (biw[0][7:6] == 2'b10)) ? 
                               {biw[1],biw[2]}
                            : (((op_i == cmpi__op_68k00) | (op_i == eori__op_68k00)) & (biw[0][7:6] == 2'b10)) ? 
                               {biw[1],biw[2]}
                            : (((op_i == ori__op_68k00) | (op_i == subi__op_68k00)) & (biw[0][7:6] == 2'b10)) ? 
                               {biw[1],biw[2]}
                            : (((op_i == andi__op_68k00) | (op_i == addi__op_68k00)) & (biw[0][7:6] == 2'b01)) ? 
                               {16'h0000,biw[1]}
                            : (((op_i == cmpi__op_68k00) | (op_i == eori__op_68k00)) & (biw[0][7:6] == 2'b01)) ? 
                               {16'h0000,biw[1]}
                            : (((op_i == ori__op_68k00) | (op_i == subi__op_68k00)) & (biw[0][7:6] == 2'b01)) ? 
                               {16'h0000,biw[1]}
                            : ((op_i == andi__op_68k00) | (op_i == addi__op_68k00)) ? 
                               {{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0/*aggregate*/},biw[1][7:0]}
                            : ((op_i == cmpi__op_68k00) | (op_i == eori__op_68k00)) ? 
                               {{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0/*aggregate*/},biw[1][7:0]}
                            : ((op_i == ori__op_68k00) | (op_i == subi__op_68k00)) ? 
                               {{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0/*aggregate*/},biw[1][7:0]}
                            : (op_i == stop__op_68k00) ? 
                               {16'h0000,biw[1]}
                            : (op_i == moveq__op_68k00) ? 
                               {24'h000000,biw[0][7:0]}
                            : (op_size_i == long__op_sizetype) ? 
                               {exword_reg[0],exword_reg[1]}
                            :  {16'h0000,exword_reg[0]};
   
   assign {bitpos_im}=(((((op_i == bchg__op_68k00) | (op_i == bclr__op_68k00)) | (op_i == bset__op_68k00)) | (op_i == btst__op_68k00)) & (biw[0][8] == 1'b0)) ? 
                          1'b1
                       :  1'b0;
   
   assign {bit_pos}=biw[1][4:0];
   
   assign div_mul_32n64 = biw[1][10];
   
   assign {reg_dlq}=biw[1][14:12];
   
   assign {reg_dhr}=biw[1][2:0];
   
   assign {mem_shft}=(((op_i == asl__op_68k00) | (op_i == asr__op_68k00)) & (biw[0][7:6] == 2'b11)) ? 
                         1'b1
                      : (((op_i == lsl__op_68k00) | (op_i == lsr__op_68k00)) & (biw[0][7:6] == 2'b11)) ? 
                         1'b1
                      : (((op_i == rotl__op_68k00) | (op_i == rotr__op_68k00)) & (biw[0][7:6] == 2'b11)) ? 
                         1'b1
                      : (((op_i == roxl__op_68k00) | (op_i == roxr__op_68k00)) & (biw[0][7:6] == 2'b11)) ? 
                         1'b1
                      :  1'b0;
   
   assign {reglistmask}=biw[1];
   
   assign {op_size}=op_size_i;
   
   assign {op_size_i}=(((op_i == abcd__op_68k00) | (op_i == nbcd__op_68k00)) | (op_i == sbcd__op_68k00)) ? 
                          byte__op_sizetype
                       : ((op_i == adda__op_68k00) & (biw[0][8:6] == 3'b111)) ? 
                          long__op_sizetype
                       : ((op_i == adda__op_68k00) & (biw[0][8:6] == 3'b011)) ? 
                          word__op_sizetype
                       : ((op_i == bchg__op_68k00) & (biw[0][5:3] == 3'b000)) ? 
                          long__op_sizetype
                       : ((op_i == bclr__op_68k00) & (biw[0][5:3] == 3'b000)) ? 
                          long__op_sizetype
                       : ((op_i == bset__op_68k00) & (biw[0][5:3] == 3'b000)) ? 
                          long__op_sizetype
                       : ((op_i == btst__op_68k00) & (biw[0][5:3] == 3'b000)) ? 
                          long__op_sizetype
                       : ((op_i == bchg__op_68k00) | (op_i == bclr__op_68k00)) ? 
                          byte__op_sizetype
                       : ((op_i == bset__op_68k00) | (op_i == btst__op_68k00)) ? 
                          byte__op_sizetype
                       : ((op_i == chk__op_68k00) & (biw[0][8:7] == 2'b11)) ? 
                          word__op_sizetype
                       : ((op_i == chk__op_68k00) & (biw[0][8:7] == 2'b10)) ? 
                          long__op_sizetype
                       : ((op_i == cmpa__op_68k00) & (biw[0][8:6] == 3'b111)) ? 
                          long__op_sizetype
                       : ((op_i == cmpa__op_68k00) & (biw[0][8:6] == 3'b011)) ? 
                          word__op_sizetype
                       : ((op_i == divs__op_68k00) & (biw[0][8:6] == 3'b001)) ? 
                          long__op_sizetype
                       : ((op_i == divu__op_68k00) & (biw[0][8:6] == 3'b001)) ? 
                          long__op_sizetype
                       : ((op_i == divs__op_68k00) & (biw[0][8:6] == 3'b111)) ? 
                          word__op_sizetype
                       : ((op_i == divu__op_68k00) & (biw[0][8:6] == 3'b011)) ? 
                          word__op_sizetype
                       : ((op_i == extw__op_68k00) & (biw[0][7:6] == 2'b11)) ? 
                          long__op_sizetype
                       : ((op_i == extw__op_68k00) & (biw[0][7:6] == 2'b10)) ? 
                          word__op_sizetype
                       : ((op_i == link__op_68k00) & (biw[0][15:3] == 13'b0100111001010)) ? 
                          word__op_sizetype
                       : ((op_i == link__op_68k00) & (biw[0][15:3] == 13'b0100100000001)) ? 
                          long__op_sizetype
                       : ((op_i == move__op_68k00) & (biw[0][13:12] == 2'b01)) ? 
                          byte__op_sizetype
                       : ((op_i == move__op_68k00) & (biw[0][13:12] == 2'b11)) ? 
                          word__op_sizetype
                       : ((op_i == move__op_68k00) & (biw[0][13:12] == 2'b10)) ? 
                          long__op_sizetype
                       : ((op_i == movea__op_68k00) & (biw[0][13:12] == 2'b11)) ? 
                          word__op_sizetype
                       : ((op_i == movea__op_68k00) & (biw[0][13:12] == 2'b10)) ? 
                          long__op_sizetype
                       : ((op_i == movem__op_68k00) & (biw[0][6] == 1'b1)) ? 
                          long__op_sizetype
                       : ((op_i == movem__op_68k00) & (biw[0][6] == 1'b0)) ? 
                          word__op_sizetype
                       : ((op_i == movep__op_68k00) & (biw[0][8:6] == 3'b111)) ? 
                          long__op_sizetype
                       : ((op_i == movep__op_68k00) & (biw[0][8:6] == 3'b101)) ? 
                          long__op_sizetype
                       : ((op_i == movep__op_68k00) & (biw[0][8:6] == 3'b110)) ? 
                          word__op_sizetype
                       : ((op_i == movep__op_68k00) & (biw[0][8:6] == 3'b100)) ? 
                          word__op_sizetype
                       : (op_i == move_from_ccr__op_68k00) ? 
                          word__op_sizetype
                       : (op_i == move_from_sr__op_68k00) ? 
                          word__op_sizetype
                       : (op_i == move_to_ccr__op_68k00) ? 
                          word__op_sizetype
                       : (op_i == move_to_sr__op_68k00) ? 
                          word__op_sizetype
                       : ((op_i == muls__op_68k00) & (biw[0][8:6] == 3'b000)) ? 
                          long__op_sizetype
                       : ((op_i == mulu__op_68k00) & (biw[0][8:6] == 3'b000)) ? 
                          long__op_sizetype
                       : ((op_i == muls__op_68k00) & (biw[0][8:6] == 3'b111)) ? 
                          word__op_sizetype
                       : ((op_i == mulu__op_68k00) & (biw[0][8:6] == 3'b011)) ? 
                          word__op_sizetype
                       : ((op_i == suba__op_68k00) & (biw[0][8:6] == 3'b111)) ? 
                          long__op_sizetype
                       : ((op_i == suba__op_68k00) & (biw[0][8:6] == 3'b011)) ? 
                          word__op_sizetype
                       : ((op_i == scc__op_68k00) | (op_i == tas__op_68k00)) ? 
                          byte__op_sizetype
                       : (((op_i == asl__op_68k00) | (op_i == asr__op_68k00)) & (biw[0][7:6] == 2'b11)) ? 
                          word__op_sizetype
                       : (((op_i == lsl__op_68k00) | (op_i == lsr__op_68k00)) & (biw[0][7:6] == 2'b11)) ? 
                          word__op_sizetype
                       : (((op_i == rotl__op_68k00) | (op_i == rotr__op_68k00)) & (biw[0][7:6] == 2'b11)) ? 
                          word__op_sizetype
                       : (((op_i == roxl__op_68k00) | (op_i == roxr__op_68k00)) & (biw[0][7:6] == 2'b11)) ? 
                          word__op_sizetype
                       : (((op_i == bsr__op_68k00) | (op_i == pea__op_68k00)) | (op_i == rts__op_68k00)) ? 
                          long__op_sizetype
                       : (biw[0][7:6] == 2'b00) ? 
                          byte__op_sizetype
                       : (biw[0][7:6] == 2'b01) ? 
                          word__op_sizetype
                       : (biw[0][7:6] == 2'b10) ? 
                          long__op_sizetype
                       :  long__op_sizetype;
   
   assign {force_biw2}=((((op_i == ori_to_ccr__op_68k00) | (op_i == ori_to_sr__op_68k00)) | (op_i == ori__op_68k00)) | (op_i == andi_to_ccr__op_68k00)) ? 
                           1'b1
                        : (((((op_i == andi_to_sr__op_68k00) | (op_i == andi__op_68k00)) | (op_i == subi__op_68k00)) | (op_i == addi__op_68k00)) | (op_i == eori_to_ccr__op_68k00)) ? 
                           1'b1
                        : (((((op_i == bchg__op_68k00) | (op_i == bclr__op_68k00)) | (op_i == bset__op_68k00)) | (op_i == btst__op_68k00)) & (biw[0][8] == 1'b0)) ? 
                           1'b1
                        : (((op_i == eori_to_sr__op_68k00) | (op_i == eori__op_68k00)) | (op_i == cmpi__op_68k00)) ? 
                           1'b1
                        : (((op_i == movep__op_68k00) | (op_i == link__op_68k00)) | (op_i == stop__op_68k00)) ? 
                           1'b1
                        : (((op_i == divs__op_68k00) | (op_i == divu__op_68k00)) & (biw[0][8:6] == 3'b001)) ? 
                           1'b1
                        : (((op_i == muls__op_68k00) | (op_i == mulu__op_68k00)) & (biw[0][8:6] == 3'b000)) ? 
                           1'b1
                        : ((op_i == movem__op_68k00) | (op_i == dbcc__op_68k00)) ? 
                           1'b1
                        : ((((op_i == bra__op_68k00) | (op_i == bsr__op_68k00)) | (op_i == bcc__op_68k00)) & (biw[0][7:0] == 8'h00)) ? 
                           1'b1
                        : ((((op_i == bra__op_68k00) | (op_i == bsr__op_68k00)) | (op_i == bcc__op_68k00)) & (biw[0][7:0] == 8'hFF)) ? 
                           1'b1
                        :  1'b0;
   
   assign {force_biw3}=((op_i == ori__op_68k00) & (op_size_i == long__op_sizetype)) ? 
                           1'b1
                        : ((op_i == andi__op_68k00) & (op_size_i == long__op_sizetype)) ? 
                           1'b1
                        : ((op_i == subi__op_68k00) & (op_size_i == long__op_sizetype)) ? 
                           1'b1
                        : ((op_i == addi__op_68k00) & (op_size_i == long__op_sizetype)) ? 
                           1'b1
                        : ((op_i == eori__op_68k00) & (op_size_i == long__op_sizetype)) ? 
                           1'b1
                        : ((op_i == cmpi__op_68k00) & (op_size_i == long__op_sizetype)) ? 
                           1'b1
                        : ((op_i == link__op_68k00) & (op_size_i == long__op_sizetype)) ? 
                           1'b1
                        : ((((op_i == bra__op_68k00) | (op_i == bsr__op_68k00)) | (op_i == bcc__op_68k00)) & (biw[0][7:0] == 8'hFF)) ? 
                           1'b1
                        :  1'b0;
   
   assign {ext_en}=((((((op_i == add__op_68k00) | (op_i == adda__op_68k00)) | (op_i == addi__op_68k00)) | (op_i == addq__op_68k00)) | (op_i == and_b__op_68k00)) | (op_i == andi__op_68k00)) ? 
                       1'b1
                    : (((op_i == asl__op_68k00) | (op_i == asr__op_68k00)) & (biw[0][7:6] == 2'b11)) ? 
                       1'b1
                    : (((op_i == lsl__op_68k00) | (op_i == lsr__op_68k00)) & (biw[0][7:6] == 2'b11)) ? 
                       1'b1
                    : (((op_i == roxl__op_68k00) | (op_i == roxr__op_68k00)) & (biw[0][7:6] == 2'b11)) ? 
                       1'b1
                    : (((op_i == rotl__op_68k00) | (op_i == rotr__op_68k00)) & (biw[0][7:6] == 2'b11)) ? 
                       1'b1
                    : ((((((op_i == bchg__op_68k00) | (op_i == bclr__op_68k00)) | (op_i == bset__op_68k00)) | (op_i == btst__op_68k00)) | (op_i == chk__op_68k00)) | (op_i == clr__op_68k00)) ? 
                       1'b1
                    : ((((((op_i == cmp__op_68k00) | (op_i == cmpa__op_68k00)) | (op_i == cmpi__op_68k00)) | (op_i == divs__op_68k00)) | (op_i == divu__op_68k00)) | (op_i == eor__op_68k00)) ? 
                       1'b1
                    : ((((((op_i == eori__op_68k00) | (op_i == jmp__op_68k00)) | (op_i == jsr__op_68k00)) | (op_i == lea__op_68k00)) | (op_i == move__op_68k00)) | (op_i == movea__op_68k00)) ? 
                       1'b1
                    : ((((op_i == move_from_ccr__op_68k00) | (op_i == move_to_ccr__op_68k00)) | (op_i == move_from_sr__op_68k00)) | (op_i == move_to_sr__op_68k00)) ? 
                       1'b1
                    : ((((((op_i == movem__op_68k00) | (op_i == muls__op_68k00)) | (op_i == mulu__op_68k00)) | (op_i == nbcd__op_68k00)) | (op_i == neg__op_68k00)) | (op_i == negx__op_68k00)) ? 
                       1'b1
                    : ((((((op_i == not_b__op_68k00) | (op_i == or_b__op_68k00)) | (op_i == ori__op_68k00)) | (op_i == pea__op_68k00)) | (op_i == scc__op_68k00)) | (op_i == sub__op_68k00)) ? 
                       1'b1
                    : (((((op_i == suba__op_68k00) | (op_i == subi__op_68k00)) | (op_i == subq__op_68k00)) | (op_i == tas__op_68k00)) | (op_i == tst__op_68k00)) ? 
                       1'b1
                    :  1'b0;
   
   assign {ext_cnt}=((((biw[0][5:3] == 3'b111) & (biw[0][2:0] == 3'b100)) & (op_size_i == long__op_sizetype)) & (ext_en == 1'b1)) ? 
                        2
                     : (((biw[0][5:3] == 3'b111) & (biw[0][2:0] == 3'b001)) & (ext_en == 1'b1)) ? 
                        2
                     : (((biw[0][5:3] == 3'b111) & (biw[0][2:0] == 3'b100)) & (ext_en == 1'b1)) ? 
                        1
                     : (((biw[0][5:3] == 3'b111) & (biw[0][2:0] == 3'b011)) & (ext_en == 1'b1)) ? 
                        1
                     : (((biw[0][5:3] == 3'b111) & (biw[0][2:0] == 3'b010)) & (ext_en == 1'b1)) ? 
                        1
                     : (((biw[0][5:3] == 3'b111) & (biw[0][2:0] == 3'b000)) & (ext_en == 1'b1)) ? 
                        1
                     : ((biw[0][5:3] == 3'b110) & (ext_en == 1'b1)) ? 
                        1
                     : ((biw[0][5:3] == 3'b101) & (ext_en == 1'b1)) ? 
                        1
                     :  0;
   
   assign {dest_ext_cnt}=(((biw[0][8:6] == 3'b111) & (biw[0][11:9] == 3'b001)) & (op_i == move__op_68k00)) ? 
                             2
                          : (((biw[0][8:6] == 3'b111) & (biw[0][11:9] == 3'b000)) & (op_i == move__op_68k00)) ? 
                             1
                          : ((biw[0][8:6] == 3'b110) & (op_i == move__op_68k00)) ? 
                             1
                          : ((biw[0][8:6] == 3'b101) & (op_i == move__op_68k00)) ? 
                             1
                          :  0;
   
       
   always @ (biw_W  ) // begin 
       begin 
           op_i <= illegal__op_68k00;
           case (biw[0][15:12])
               4'h0 : 
                   begin 
                       if ((biw[0][11:0] == 12'h03C)) 
                               op_i <= ori_to_ccr__op_68k00;
                       else if ((biw[0][11:0] == 12'h07C)) 
                               op_i <= ori_to_sr__op_68k00;
                       else if ((biw[0][11:0] == 12'h23C)) 
                               op_i <= andi_to_ccr__op_68k00;
                       else if ((biw[0][11:0] == 12'h27C)) 
                               op_i <= andi_to_sr__op_68k00;
                       else if ((biw[0][11:0] == 12'hA3C)) 
                               op_i <= eori_to_ccr__op_68k00;
                       else if ((biw[0][11:0] == 12'hA7C)) 
                               op_i <= eori_to_sr__op_68k00;

                       case (biw[0][5:3])
                           3'b000,3'b010,3'b011,3'b100,3'b101,3'b110 : 
                                   if ((biw[0][11:6] == 6'b100000)) 
                                           op_i <= btst__op_68k00;
                                   else if ((biw[0][11:6] == 6'b100001)) 
                                           op_i <= bchg__op_68k00;
                                   else if ((biw[0][11:6] == 6'b100010)) 
                                           op_i <= bclr__op_68k00;
                                   else if ((biw[0][11:6] == 6'b100011)) 
                                           op_i <= bset__op_68k00;
                                   else if (((biw[0][11:8] == 4'h0) & (biw[0][7:6] < 2'b11))) 
                                           op_i <= ori__op_68k00;
                                   else if (((biw[0][11:8] == 4'h2) & (biw[0][7:6] < 2'b11))) 
                                           op_i <= andi__op_68k00;
                                   else if (((biw[0][11:8] == 4'h4) & (biw[0][7:6] < 2'b11))) 
                                           op_i <= subi__op_68k00;
                                   else if (((biw[0][11:8] == 4'h6) & (biw[0][7:6] < 2'b11))) 
                                           op_i <= addi__op_68k00;
                                   else if (((biw[0][11:8] == 4'hA) & (biw[0][7:6] < 2'b11))) 
                                           op_i <= eori__op_68k00;
                                   else if (((biw[0][11:8] == 4'hC) & (biw[0][7:6] < 2'b11))) 
                                           op_i <= cmpi__op_68k00;
                                   else if ((biw[0][8:6] == 3'b100)) 
                                           op_i <= btst__op_68k00;
                                   else if ((biw[0][8:6] == 3'b101)) 
                                           op_i <= bchg__op_68k00;
                                   else if ((biw[0][8:6] == 3'b110)) 
                                           op_i <= bclr__op_68k00;
                                   else if ((biw[0][8:6] == 3'b111)) 
                                           op_i <= bset__op_68k00;

                                   
                           3'b111 : 
                                   if (((biw[0][11:6] == 6'b100000) & (biw[0][2:0] < 3'b100))) 
                                           op_i <= btst__op_68k00;
                                   else if (((biw[0][11:6] == 6'b100001) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= bchg__op_68k00;
                                   else if (((biw[0][11:6] == 6'b100010) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= bclr__op_68k00;
                                   else if (((biw[0][11:6] == 6'b100011) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= bset__op_68k00;
                                   else if ((((biw[0][11:8] == 4'h0) & (biw[0][7:6] < 2'b11)) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= ori__op_68k00;
                                   else if ((((biw[0][11:8] == 4'h2) & (biw[0][7:6] < 2'b11)) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= andi__op_68k00;
                                   else if ((((biw[0][11:8] == 4'h4) & (biw[0][7:6] < 2'b11)) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= subi__op_68k00;
                                   else if ((((biw[0][11:8] == 4'h6) & (biw[0][7:6] < 2'b11)) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= addi__op_68k00;
                                   else if ((((biw[0][11:8] == 4'hA) & (biw[0][7:6] < 2'b11)) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= eori__op_68k00;
                                   else if ((((biw[0][11:8] == 4'hC) & (biw[0][7:6] < 2'b11)) & (biw[0][2:0] < 3'b100))) 
                                           op_i <= cmpi__op_68k00;
                                   else if (((biw[0][8:6] == 3'b100) & (biw[0][2:0] < 3'b101))) 
                                           op_i <= btst__op_68k00;
                                   else if (((biw[0][8:6] == 3'b101) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= bchg__op_68k00;
                                   else if (((biw[0][8:6] == 3'b110) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= bclr__op_68k00;
                                   else if (((biw[0][8:6] == 3'b111) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= bset__op_68k00;

                                   
                           default : 
                                   ;//null
                       endcase
                       if (((biw[0][8:6] > 3'b011) & (biw[0][5:3] == 3'b001))) 
                               op_i <= movep__op_68k00;

                       
                   end
               4'h1 : 
                       if (((((biw[0][8:6] == 3'b111) & (biw[0][11:9] < 3'b010)) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b101))) 
                               op_i <= move__op_68k00;
                       else if (((((biw[0][8:6] == 3'b111) & (biw[0][11:9] < 3'b010)) & (!(biw[0][5:3]==3'b001))) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= move__op_68k00;
                       else if (((((!(biw[0][8:6]==3'b001)) & (!(biw[0][8:6]==3'b111))) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b101))) 
                               op_i <= move__op_68k00;
                       else if (((((!(biw[0][8:6]==3'b001)) & (!(biw[0][8:6]==3'b111))) & (!(biw[0][5:3]==3'b001))) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= move__op_68k00;

                       
               4'h2,4'h3 : 
                       if (((((biw[0][8:6] == 3'b111) & (biw[0][11:9] < 3'b010)) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b101))) 
                               op_i <= move__op_68k00;
                       else if ((((biw[0][8:6] == 3'b111) & (biw[0][11:9] < 3'b010)) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= move__op_68k00;
                       else if ((((biw[0][8:6] == 3'b001) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b101))) 
                               op_i <= movea__op_68k00;
                       else if (((biw[0][8:6] == 3'b001) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= movea__op_68k00;
                       else if (((((!(biw[0][8:6]==3'b001)) & (!(biw[0][8:6]==3'b111))) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b101))) 
                               op_i <= move__op_68k00;
                       else if ((((!(biw[0][8:6]==3'b001)) & (!(biw[0][8:6]==3'b111))) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= move__op_68k00;

                       
               4'h4 : 
                   begin 
                       if ((biw[0][11:0] == 12'hE70)) 
                               op_i <= reset__op_68k00;
                       else if ((biw[0][11:0] == 12'hE71)) 
                               op_i <= nop__op_68k00;
                       else if ((biw[0][11:0] == 12'hE72)) 
                               op_i <= stop__op_68k00;
                       else if ((biw[0][11:0] == 12'hE73)) 
                               op_i <= rte__op_68k00;
                       else if ((biw[0][11:0] == 12'hE75)) 
                               op_i <= rts__op_68k00;
                       else if ((biw[0][11:0] == 12'hE76)) 
                               op_i <= trapv__op_68k00;
                       else if ((biw[0][11:0] == 12'hE77)) 
                               op_i <= rtr__op_68k00;
                       else if ((biw[0][11:0] == 12'hAFA)) 
                               op_i <= reserved__op_68k00;
                       else if ((biw[0][11:0] == 12'hAFB)) 
                               op_i <= reserved__op_68k00;
                       else if ((biw[0][11:0] == 12'hAFC)) 
                               op_i <= illegal__op_68k00;
                       else if ((biw[0][11:3] == 9'b100000001)) 
                               op_i <= link__op_68k00;
                       else if ((biw[0][11:3] == 9'b111001010)) 
                               op_i <= link__op_68k00;
                       else if ((biw[0][11:3] == 9'b111001011)) 
                               op_i <= unlk__op_68k00;
                       else if ((biw[0][11:3] == 9'b100001000)) 
                               op_i <= swap__op_68k00;
                       else if ((biw[0][11:4] == 8'hE4)) 
                               op_i <= trap__op_68k00;
                       else if ((biw[0][11:4] == 8'hE6)) 
                               op_i <= move_usp__op_68k00;

                       case (biw[0][5:3])
                           3'b000,3'b010,3'b011,3'b100,3'b101,3'b110 : 
                                   if ((biw[0][11:6] == 6'b110001)) 
                                       begin 
                                               if ((biw[1][11] == 1'b1)) 
                                                       op_i <= divs__op_68k00;
                                               else 
                                                       op_i <= divu__op_68k00;

                                               
                                       end 
                                   else if ((biw[0][11:6] == 6'b000011)) 
                                           op_i <= move_from_sr__op_68k00;
                                   else if ((biw[0][11:6] == 6'b010011)) 
                                           op_i <= move_to_ccr__op_68k00;
                                   else if ((biw[0][11:6] == 6'b011011)) 
                                           op_i <= move_to_sr__op_68k00;
                                   else if ((biw[0][11:6] == 6'b110000)) 
                                       begin 
                                               if ((biw[1][11] == 1'b1)) 
                                                       op_i <= muls__op_68k00;
                                               else 
                                                       op_i <= mulu__op_68k00;

                                               
                                       end 
                                   else if ((biw[0][11:6] == 6'b100000)) 
                                           op_i <= nbcd__op_68k00;
                                   else if ((biw[0][11:6] == 6'b101011)) 
                                           op_i <= tas__op_68k00;

                                   
                           3'b111 : 
                                   if (((biw[0][11:6] == 6'b110001) & (biw[0][2:0] < 3'b101))) 
                                       begin 
                                               if ((biw[1][11] == 1'b1)) 
                                                       op_i <= divs__op_68k00;
                                               else 
                                                       op_i <= divu__op_68k00;

                                               
                                       end 
                                   else if (((biw[0][11:6] == 6'b000011) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= move_from_sr__op_68k00;
                                   else if (((biw[0][11:6] == 6'b010011) & (biw[0][2:0] < 3'b101))) 
                                           op_i <= move_to_ccr__op_68k00;
                                   else if (((biw[0][11:6] == 6'b011011) & (biw[0][2:0] < 3'b101))) 
                                           op_i <= move_to_sr__op_68k00;
                                   else if (((biw[0][11:6] == 6'b110000) & (biw[0][2:0] < 3'b101))) 
                                       begin 
                                               if ((biw[1][11] == 1'b1)) 
                                                       op_i <= muls__op_68k00;
                                               else 
                                                       op_i <= mulu__op_68k00;

                                               
                                       end 
                                   else if (((biw[0][11:6] == 6'b100000) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= nbcd__op_68k00;
                                   else if (((biw[0][11:6] == 6'b101011) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= tas__op_68k00;

                                   
                           default : 
                                   ;//null
                       endcase
                       case (biw[0][5:3])
                           3'b010,3'b101,3'b110 : 
                                   if ((biw[0][11:6] == 6'b100001)) 
                                           op_i <= pea__op_68k00;
                                   else if ((biw[0][11:6] == 6'b111010)) 
                                           op_i <= jsr__op_68k00;
                                   else if ((biw[0][11:6] == 6'b111011)) 
                                           op_i <= jmp__op_68k00;

                                   
                           3'b111 : 
                                   if (((biw[0][11:6] == 6'b100001) & (biw[0][2:0] < 3'b100))) 
                                           op_i <= pea__op_68k00;
                                   else if (((biw[0][11:6] == 6'b111010) & (biw[0][2:0] < 3'b100))) 
                                           op_i <= jsr__op_68k00;
                                   else if (((biw[0][11:6] == 6'b111011) & (biw[0][2:0] < 3'b100))) 
                                           op_i <= jmp__op_68k00;

                                   
                           default : 
                                   ;//null
                       endcase
                       if ((((biw[0][7:6] < 2'b11) & (!(biw[0][5:3]==3'b001))) & (!(biw[0][5:3]==3'b111)))) 
                               case (biw[0][11:8])
                                   4'h0 : 
                                           op_i <= negx__op_68k00;
                                   4'h2 : 
                                           op_i <= clr__op_68k00;
                                   4'h4 : 
                                           op_i <= neg__op_68k00;
                                   4'h6 : 
                                           op_i <= not_b__op_68k00;
                                   default : 
                                           ;//null
                               endcase
                       else if ((((biw[0][7:6] < 2'b11) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b010))) 
                               case (biw[0][11:8])
                                   4'h0 : 
                                           op_i <= negx__op_68k00;
                                   4'h2 : 
                                           op_i <= clr__op_68k00;
                                   4'h4 : 
                                           op_i <= neg__op_68k00;
                                   4'h6 : 
                                           op_i <= not_b__op_68k00;
                                   default : 
                                           ;//null
                               endcase

                       if (((((biw[0][11:8] == 4'hA) & (biw[0][7:6] < 2'b11)) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b101))) 
                               case (biw[0][7:6])
                                   2'b01,2'b10 : 
                                           op_i <= tst__op_68k00;
                                   default : 
                                           if ((!(biw[0][2:0]==3'b100))) 
                                                   op_i <= tst__op_68k00;

                                           
                               endcase
                       else if ((((biw[0][11:8] == 4'hA) & (biw[0][7:6] < 2'b11)) & (!(biw[0][5:3]==3'b111)))) 
                               case (biw[0][7:6])
                                   2'b01,2'b10 : 
                                           op_i <= tst__op_68k00;
                                   default : 
                                           if ((!(biw[0][5:3]==3'b001))) 
                                                   op_i <= tst__op_68k00;

                                           
                               endcase

                       if (((biw[0][11:9] == 3'b100) & (biw[0][5:3] == 3'b000))) 
                               case (biw[0][8:6])
                                   3'b010,3'b011 : 
                                           op_i <= extw__op_68k00;
                                   default : 
                                           ;//null
                               endcase

                       if ((biw[0][8:6] == 3'b111)) 
                               case (biw[0][5:3])
                                   3'b010,3'b101,3'b110 : 
                                           op_i <= lea__op_68k00;
                                   3'b111 : 
                                           if ((biw[0][2:0] < 3'b100)) 
                                                   op_i <= lea__op_68k00;

                                           
                                   default : 
                                           ;//null
                               endcase

                       if (((biw[0][11] == 1'b1) & (biw[0][9:7] == 3'b001))) 
                           begin 
                                   if ((biw[0][10] == 1'b0)) 
                                           case (biw[0][5:3])
                                               3'b010,3'b100,3'b101,3'b110 : 
                                                       op_i <= movem__op_68k00;
                                               3'b111 : 
                                                       if (((biw[0][2:0] == 3'b000) | (biw[0][2:0] == 3'b001))) 
                                                               op_i <= movem__op_68k00;

                                                       
                                               default : 
                                                       ;//null
                                           endcase
                                   else 
                                           case (biw[0][5:3])
                                               3'b010,3'b011,3'b101,3'b110 : 
                                                       op_i <= movem__op_68k00;
                                               3'b111 : 
                                                       if ((biw[0][2:0] < 3'b100)) 
                                                               op_i <= movem__op_68k00;

                                                       
                                               default : 
                                                       ;//null
                                           endcase

                                   
                           end 

                       if ((((biw[0][8:7] >= 2'b10) & (biw[0][6:3] == 4'h7)) & (biw[0][2:0] < 3'b101))) 
                               op_i <= chk__op_68k00;
                       else if ((((biw[0][8:7] >= 2'b10) & (!(biw[0][6:3]==4'h1))) & (biw[0][6:3] < 4'h7))) 
                               op_i <= chk__op_68k00;

                       
                   end
               4'h5 : 
                       if ((biw[0][7:3] == 5'b11001)) 
                               op_i <= dbcc__op_68k00;
                       else if ((((biw[0][7:6] == 2'b11) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b010))) 
                               op_i <= scc__op_68k00;
                       else if ((((biw[0][7:6] == 2'b11) & (!(biw[0][5:3]==3'b001))) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= scc__op_68k00;
                       else if (((((biw[0][8] == 1'b0) & (biw[0][7:6] < 2'b11)) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b010))) 
                               op_i <= addq__op_68k00;
                       else if ((((biw[0][8] == 1'b0) & ((biw[0][7:6] == 2'b01) | (biw[0][7:6] == 2'b10))) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= addq__op_68k00;
                       else if (((((biw[0][8] == 1'b0) & (biw[0][7:6] == 2'b00)) & (!(biw[0][5:3]==3'b001))) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= addq__op_68k00;
                       else if (((((biw[0][8] == 1'b1) & (biw[0][7:6] < 2'b11)) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b010))) 
                               op_i <= subq__op_68k00;
                       else if ((((biw[0][8] == 1'b1) & ((biw[0][7:6] == 2'b01) | (biw[0][7:6] == 2'b10))) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= subq__op_68k00;
                       else if (((((biw[0][8] == 1'b1) & (biw[0][7:6] == 2'b00)) & (!(biw[0][5:3]==3'b001))) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= subq__op_68k00;

                       
               4'h6 : 
                       if ((biw[0][11:8] == 4'h0)) 
                               op_i <= bra__op_68k00;
                       else if ((biw[0][11:8] == 4'h1)) 
                               op_i <= bsr__op_68k00;
                       else 
                               op_i <= bcc__op_68k00;

                       
               4'h7 : 
                       if ((biw[0][8] == 1'b0)) 
                               op_i <= moveq__op_68k00;

                       
               4'h8 : 
                   begin 
                       if ((((biw[0][8:6] == 3'b011) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b101))) 
                               op_i <= divu__op_68k00;
                       else if ((((biw[0][8:6] == 3'b011) & (!(biw[0][5:3]==3'b001))) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= divu__op_68k00;
                       else if ((((biw[0][8:6] == 3'b111) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b101))) 
                               op_i <= divs__op_68k00;
                       else if ((((biw[0][8:6] == 3'b111) & (!(biw[0][5:3]==3'b001))) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= divs__op_68k00;
                       else if ((biw[0][8:4] == 5'b10000)) 
                               op_i <= sbcd__op_68k00;

                       case (biw[0][8:6])
                           3'b000,3'b001,3'b010 : 
                                   if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b101))) 
                                           op_i <= or_b__op_68k00;
                                   else if (((!(biw[0][5:3]==3'b001)) & (!(biw[0][5:3]==3'b111)))) 
                                           op_i <= or_b__op_68k00;

                                   
                           3'b100,3'b101,3'b110 : 
                                   if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= or_b__op_68k00;
                                   else if (((biw[0][5:3] > 3'b001) & (!(biw[0][5:3]==3'b111)))) 
                                           op_i <= or_b__op_68k00;

                                   
                           default : 
                                   ;//null
                       endcase
                   end
               4'h9 : 
                       case (biw[0][8:6])
                           3'b000 : 
                                   if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b101))) 
                                           op_i <= sub__op_68k00;
                                   else if (((!(biw[0][5:3]==3'b111)) & (!(biw[0][5:3]==3'b001)))) 
                                           op_i <= sub__op_68k00;

                                   
                           3'b001,3'b010 : 
                                   if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b101))) 
                                           op_i <= sub__op_68k00;
                                   else if ((!(biw[0][5:3]==3'b111))) 
                                           op_i <= sub__op_68k00;

                                   
                           3'b100 : 
                                   if (((biw[0][5:3] == 3'b000) | (biw[0][5:3] == 3'b001))) 
                                           op_i <= subx__op_68k00;
                                   else if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= sub__op_68k00;
                                   else if (((!(biw[0][5:3]==3'b111)) & (!(biw[0][5:3]==3'b001)))) 
                                           op_i <= sub__op_68k00;

                                   
                           3'b101,3'b110 : 
                                   if (((biw[0][5:3] == 3'b000) | (biw[0][5:3] == 3'b001))) 
                                           op_i <= subx__op_68k00;
                                   else if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= sub__op_68k00;
                                   else if ((!(biw[0][5:3]==3'b111))) 
                                           op_i <= sub__op_68k00;

                                   
                           3'b011,3'b111 : 
                                   if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b101))) 
                                           op_i <= suba__op_68k00;
                                   else if ((!(biw[0][5:3]==3'b111))) 
                                           op_i <= suba__op_68k00;

                                   
                           default : 
                                   ;//null
                       endcase
               4'hA : 
                       op_i <= unimplemented__op_68k00;
               4'hB : 
                       if ((((biw[0][8] == 1'b1) & (biw[0][7:6] < 2'b11)) & (biw[0][5:3] == 3'b001))) 
                               op_i <= cmpm__op_68k00;
                       else 
                               case (biw[0][8:6])
                                   3'b000 : 
                                           if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b101))) 
                                                   op_i <= cmp__op_68k00;
                                           else if (((!(biw[0][5:3]==3'b001)) & (!(biw[0][5:3]==3'b111)))) 
                                                   op_i <= cmp__op_68k00;

                                           
                                   3'b001,3'b010 : 
                                           if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b101))) 
                                                   op_i <= cmp__op_68k00;
                                           else if ((!(biw[0][5:3]==3'b111))) 
                                                   op_i <= cmp__op_68k00;

                                           
                                   3'b011,3'b111 : 
                                           if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b101))) 
                                                   op_i <= cmpa__op_68k00;
                                           else if ((!(biw[0][5:3]==3'b111))) 
                                                   op_i <= cmpa__op_68k00;

                                           
                                   3'b100,3'b101,3'b110 : 
                                           if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b101))) 
                                                   op_i <= eor__op_68k00;
                                           else if (((!(biw[0][5:3]==3'b001)) & (!(biw[0][5:3]==3'b111)))) 
                                                   op_i <= eor__op_68k00;

                                           
                                   default : 
                                           ;//null
                               endcase

                       
               4'hC : 
                       if ((biw[0][8:4] == 5'b10000)) 
                               op_i <= abcd__op_68k00;
                       else if ((((biw[0][8:6] == 3'b011) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b101))) 
                               op_i <= mulu__op_68k00;
                       else if ((((biw[0][8:6] == 3'b011) & (!(biw[0][5:3]==3'b001))) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= mulu__op_68k00;
                       else if ((((biw[0][8:6] == 3'b111) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b101))) 
                               op_i <= muls__op_68k00;
                       else if ((((biw[0][8:6] == 3'b111) & (!(biw[0][5:3]==3'b001))) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= muls__op_68k00;
                       else if ((((biw[0][8:3] == 6'b101000) | (biw[0][8:3] == 6'b101001)) | (biw[0][8:3] == 6'b110001))) 
                               op_i <= exg__op_68k00;
                       else 
                               case (biw[0][8:6])
                                   3'b000,3'b001,3'b010 : 
                                           if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b101))) 
                                                   op_i <= and_b__op_68k00;
                                           else if (((!(biw[0][5:3]==3'b001)) & (!(biw[0][5:3]==3'b111)))) 
                                                   op_i <= and_b__op_68k00;

                                           
                                   3'b100,3'b101,3'b110 : 
                                           if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b010))) 
                                                   op_i <= and_b__op_68k00;
                                           else if (((biw[0][5:3] > 3'b001) & (!(biw[0][5:3]==3'b111)))) 
                                                   op_i <= and_b__op_68k00;

                                           
                                   default : 
                                           ;//null
                               endcase

                       
               4'hD : 
                       case (biw[0][8:6])
                           3'b000 : 
                                   if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b101))) 
                                           op_i <= add__op_68k00;
                                   else if (((!(biw[0][5:3]==3'b111)) & (!(biw[0][5:3]==3'b001)))) 
                                           op_i <= add__op_68k00;

                                   
                           3'b001,3'b010 : 
                                   if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b101))) 
                                           op_i <= add__op_68k00;
                                   else if ((!(biw[0][5:3]==3'b111))) 
                                           op_i <= add__op_68k00;

                                   
                           3'b100 : 
                                   if (((biw[0][5:3] == 3'b000) | (biw[0][5:3] == 3'b001))) 
                                           op_i <= addx__op_68k00;
                                   else if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= add__op_68k00;
                                   else if (((!(biw[0][5:3]==3'b111)) & (!(biw[0][5:3]==3'b001)))) 
                                           op_i <= add__op_68k00;

                                   
                           3'b101,3'b110 : 
                                   if (((biw[0][5:3] == 3'b000) | (biw[0][5:3] == 3'b001))) 
                                           op_i <= addx__op_68k00;
                                   else if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b010))) 
                                           op_i <= add__op_68k00;
                                   else if ((!(biw[0][5:3]==3'b111))) 
                                           op_i <= add__op_68k00;

                                   
                           3'b011,3'b111 : 
                                   if (((biw[0][5:3] == 3'b111) & (biw[0][2:0] < 3'b101))) 
                                           op_i <= adda__op_68k00;
                                   else if ((!(biw[0][5:3]==3'b111))) 
                                           op_i <= adda__op_68k00;

                                   
                           default : 
                                   ;//null
                       endcase
               4'hE : 
                       if ((((biw[0][11:6] == 6'b000011) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b010))) 
                               op_i <= asr__op_68k00;
                       else if ((((biw[0][11:6] == 6'b000011) & (biw[0][5:3] > 3'b001)) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= asr__op_68k00;
                       else if ((((biw[0][11:6] == 6'b000111) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b010))) 
                               op_i <= asl__op_68k00;
                       else if ((((biw[0][11:6] == 6'b000111) & (biw[0][5:3] > 3'b001)) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= asl__op_68k00;
                       else if ((((biw[0][11:6] == 6'b001011) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b010))) 
                               op_i <= lsr__op_68k00;
                       else if ((((biw[0][11:6] == 6'b001011) & (biw[0][5:3] > 3'b001)) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= lsr__op_68k00;
                       else if ((((biw[0][11:6] == 6'b001111) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b010))) 
                               op_i <= lsl__op_68k00;
                       else if ((((biw[0][11:6] == 6'b001111) & (biw[0][5:3] > 3'b001)) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= lsl__op_68k00;
                       else if ((((biw[0][11:6] == 6'b010011) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b010))) 
                               op_i <= roxr__op_68k00;
                       else if ((((biw[0][11:6] == 6'b010011) & (biw[0][5:3] > 3'b001)) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= roxr__op_68k00;
                       else if ((((biw[0][11:6] == 6'b010111) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b010))) 
                               op_i <= roxl__op_68k00;
                       else if ((((biw[0][11:6] == 6'b010111) & (biw[0][5:3] > 3'b001)) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= roxl__op_68k00;
                       else if ((((biw[0][11:6] == 6'b011011) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b010))) 
                               op_i <= rotr__op_68k00;
                       else if ((((biw[0][11:6] == 6'b011011) & (biw[0][5:3] > 3'b001)) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= rotr__op_68k00;
                       else if ((((biw[0][11:6] == 6'b011111) & (biw[0][5:3] == 3'b111)) & (biw[0][2:0] < 3'b010))) 
                               op_i <= rotl__op_68k00;
                       else if ((((biw[0][11:6] == 6'b011111) & (biw[0][5:3] > 3'b001)) & (!(biw[0][5:3]==3'b111)))) 
                               op_i <= rotl__op_68k00;
                       else if ((((biw[0][8] == 1'b0) & (biw[0][7:6] < 2'b11)) & (biw[0][4:3] == 2'b00))) 
                               op_i <= asr__op_68k00;
                       else if ((((biw[0][8] == 1'b1) & (biw[0][7:6] < 2'b11)) & (biw[0][4:3] == 2'b00))) 
                               op_i <= asl__op_68k00;
                       else if ((((biw[0][8] == 1'b0) & (biw[0][7:6] < 2'b11)) & (biw[0][4:3] == 2'b01))) 
                               op_i <= lsr__op_68k00;
                       else if ((((biw[0][8] == 1'b1) & (biw[0][7:6] < 2'b11)) & (biw[0][4:3] == 2'b01))) 
                               op_i <= lsl__op_68k00;
                       else if ((((biw[0][8] == 1'b0) & (biw[0][7:6] < 2'b11)) & (biw[0][4:3] == 2'b10))) 
                               op_i <= roxr__op_68k00;
                       else if ((((biw[0][8] == 1'b1) & (biw[0][7:6] < 2'b11)) & (biw[0][4:3] == 2'b10))) 
                               op_i <= roxl__op_68k00;
                       else if ((((biw[0][8] == 1'b0) & (biw[0][7:6] < 2'b11)) & (biw[0][4:3] == 2'b11))) 
                               op_i <= rotr__op_68k00;
                       else if ((((biw[0][8] == 1'b1) & (biw[0][7:6] < 2'b11)) & (biw[0][4:3] == 2'b11))) 
                               op_i <= rotl__op_68k00;

                       
               4'hF : 
                       op_i <= unimplemented__op_68k00;
               default : 
                       ;//null
           endcase
       end 
   // end always 
    

    generate 
        begin :Block_Name_2
            wire [0* 16: (2 +1)*16-1 ] biw_W ;
            genvar j;
                for ( j=0; j<=2;j=j+1) begin :Block_Name_3
                      assign biw_W [j * 16 +:16 ]=biw[j];
                end//for 
        end//block
    endgenerate 

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

