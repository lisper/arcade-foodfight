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


module  wf68k00ip_opcode_decoder ( clk, resetn, data_in, sbit, ov, iw_adr, iw_wr, force_biw2, force_biw3,
				   ext_cnt, dest_ext_cnt, dr, rm, ir, op, op_size, op_mode, biw_0,
				   regsel_20, regsel_119, regsel_index, data_immediate, trap_vector, c_code,
				   mem_shft, reglistmask, bitpos_im, bit_pos, div_mul_32n64, reg_dlq, reg_dhr,
				   scan_traps, trap_illegal, trap_1010, trap_1111, trap_priv, trap_op, trap_v,
				   ew_wr, ew_adr, src_destn, exword0, exword1, dest_exword0, dest_exword1,
				   adr_mode, move_d_am, ext_dsize, sel_displace_biw, displace_biw );

   input        clk;
   input        resetn;
   input [15:0] data_in;
   input        sbit;
   input 	ov; // Overflow flag.

   // Instruction word controls:
   input [1:0]	iw_adr; // Instruction word address.
   input        iw_wr; // Instruction word write control.

   // Further load controls (besides the first instruction word):
   output 	force_biw2;
   output 	force_biw3;
   output [1:0] ext_cnt;
   output [1:0]	dest_ext_cnt;

   // System control flags:
   output 	dr;
   output 	rm;
   output 	ir;

   // System control signals:
   output [6:0] op;
   output [1:0]   op_size; // Operand size.
   output [4:0]   op_mode ;
   output [15:0]  biw_0 ;
   output [2:0]   regsel_20 ;
   output [2:0]   regsel_119 ;
   output [2:0]   regsel_index ;
   output [31:0]  data_immediate ;
   output [3:0]   trap_vector ;
   output [3:0]   c_code ;
   output 	  mem_shft; // Shift operations in registers ('0') or in memory ('1').
   output [15:0]  reglistmask; // Used in MOVEM.

   // Bit operations:
   output 	  bitpos_im;
   output [4:0]   bit_pos ;

   // Multiplication / Division:
   output 	  div_mul_32n64;
   output [2:0]   reg_dlq ;
   output [2:0]   reg_dhr ;

   // Traps:
   input 	  scan_traps;
   output 	  trap_illegal;
   output 	  trap_1010;
   output 	  trap_1111;
   output 	  trap_priv;
   output 	  trap_op;
   output 	  trap_v;

   // Extension word controls:
   input 	  ew_wr; // Write control.
   input 	  ew_adr; // Source extension word address.
   input 	  src_destn; // '1' for read operand from source, '0' store result to destination (MOVE).

   // Extension words:
   output [15:0]  exword0;
   output [15:0]  exword1;
   output [15:0]  dest_exword0;
   output [15:0]  dest_exword1;

   // Address computation stuff:
   output [2:0]   adr_mode ; // Address mode indicator.
   output [2:0]   move_d_am ;// Move statement destination address mode.
   output [1:0]   ext_dsize;// Displacement size, BYTE or WORD.
   output 	  sel_displace_biw;// Select displacement from the basic instruction word BIW, when '1'.
   output [31:0]  displace_biw ;// Displacement (direct encoded, 8 or 16 bit).

`include "wf68k00ip_parms.h"

   reg [15:0] 	  biw [0:2];// Instruction word registers.
   wire 	  ext_en;
   reg [6:0] 	  op_i;
   wire [1:0] 	  op_size_i;
   reg [15:0] 	  exword_reg0;
   reg [15:0] 	  exword_reg1;
   reg [15:0] 	  dest_exword_reg0;
   reg [15:0] 	  dest_exword_reg1;
   wire 	  force_biw2;
   wire 	  force_biw3;
//   wire [1:0] 	  ext_cnt;
//   wire [1:0] 	  dest_ext_cnt;
   wire 	  dr;
   wire 	  rm;
   wire 	  ir;
   wire [6:0] 	  op;
   wire [1:0] 	  op_size;
   wire [4:0] 	  op_mode;
   wire [15:0] 	  biw_0;
   wire [15:0] 	  biw_1;
   wire [2:0] 	  regsel_20;
   wire [2:0] 	  regsel_119;
   wire [2:0] 	  regsel_index;
   wire [31:0] 	  data_immediate;
   wire [3:0] 	  trap_vector;
   wire [3:0] 	  c_code;
   wire 	  mem_shft;
   wire [15:0] 	  reglistmask;
   wire 	  bitpos_im;
   wire [4:0] 	  bit_pos;
   wire 	  div_mul_32n64;
   wire [2:0] 	  reg_dlq;
   wire [2:0] 	  reg_dhr;
   wire 	  trap_illegal;
   wire 	  trap_1010;
   wire 	  trap_1111;
   wire 	  trap_priv;
   wire 	  trap_op;
   wire 	  trap_v;
   wire [15:0] 	  exword0;
   wire [15:0] 	  exword1;
   wire [15:0] 	  dest_exword0;
   wire [15:0] 	  dest_exword1;
   wire [2:0] 	  adr_mode;
   wire [2:0] 	  move_d_am;
   wire [1:0] 	  ext_dsize;
   wire 	  sel_displace_biw;
   wire [31:0] 	  displace_biw;


    
   // In this process the required source and destination extension words
   // for the operations are stored. This process works on the negative 
   // clock edge to meet the timing requirements in conjunction with the 
   // bus interface and the system control state machine.
       
   always @ (negedge resetn or negedge clk )
     if (~resetn)
       begin
          exword_reg0 <= 16'b0;
	  exword_reg1 <= 16'b0;
          dest_exword_reg0 <= 16'b0;
	  dest_exword_reg1 <= 16'b0;
       end
     else 
       // The extension words are written but never initialized
       // during the operation. This does not take any negative
       // effect because the operations, using the extensions,
       // overwrite the respective words during instruction
       // load process.
       if (ew_wr)
	 begin
	    if (src_destn)
	      begin
		 if (ew_adr)
		   exword_reg1 <= data_in;
		 else
		   exword_reg0 <= data_in;
	      end
	    else
	      begin
		 if (ew_adr)
		   dest_exword_reg1 <= data_in;
		 else
		   dest_exword_reg0 <= data_in;
	      end
	 end
   
   assign exword0 = exword_reg0;
   assign exword1 = exword_reg1;
   
   assign dest_exword0 = dest_exword_reg0;
   assign dest_exword1 = dest_exword_reg1;
   
   // Copy signal to port:
   assign op = op_i;
   
   // TRAPS:
   assign trap_1010 = (scan_traps & biw_0[15:12] == 4'b1010) ? 1'b1 : 1'b0;
   assign trap_1111 = (scan_traps & biw_0[15:12] == 4'b1111) ? 1'b1 : 1'b0;
   assign trap_illegal = (scan_traps & op_i == ILLEGAL) ? 1'b1 : 1'b0;
   assign trap_op = (scan_traps & op_i == TRAP) ? 1'b1 : 1'b0;
   assign trap_v = (scan_traps & op_i == TRAPV & ov) ? 1'b1 : 1'b0;
   
   assign trap_priv = op_i == ANDI_TO_SR | op_i == EORI_TO_SR | op_i == MOVE_TO_SR | op_i == MOVE_USP | op_i == ORI_TO_SR | op_i == RESET | op_i == RTE | op_i == STOP ? (~sbit & scan_traps) : 1'b0;
   

   // In this process the different OPCODE registers store all required information for
   // the instruction processing. Depending on the operation, at least the Basic Instruction
   // Word BIW(0) is stored followed by a second and third instruction word Word BIW(1) and
   // BIW(2), if required. This process works on the negative clock edge to meet the timing
   // requirements in conjunction with the bus interface and the system control state machine.
       
   always @ (negedge resetn or negedge clk )
     if (~resetn)
       begin 
          biw[0] <= 16'b0;
          biw[1] <= 16'b0;
          biw[2] <= 16'b0;
       end
     else 
       if (iw_wr)
         biw[iw_adr] <= data_in;
   
   assign biw_0 = biw[0];
   assign biw_1 = biw[1];

   assign dr =  op_i == MOVEM ? biw_0[10] :
		op_i == MOVE_USP ? biw_0[3] :
		biw_0[8]; // Default is valid for ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXR.
   assign rm = biw_0[3]; // Valid for SBCD, SUBX, ABCD, ADDX.
   assign ir = biw_0[5]; // Valid for ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXR.
   
   // Addressing mode:
   // The Default is valid for ORI, ANDI, SUBI, CALLM, ADDI, EORI, CMPI, BTST, BCHG, BCLR, BSET,
   // MOVEA, MOVE_FROM_CCR, MOVE_FROM_SR, NEGX, CLR, MOVE_TO_CCR, NEG, NOT, MOVE_TO_SR, NBCD, PEA, 
   // TAS, TST, MULYU, MULS, DIVU, DIVS, JSR, JMP, MOVEM, LEA, CHK, ADDQ, SUBQ, OR, SUB, SUBA,
   //  CMP, CMPA, EOR, AND, ADDA, ADD, ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXR.
   assign adr_mode = (op_i == ABCD | op_i == SBCD | op_i == ADDX | op_i == SUBX) ? 3'b100 :
                     (op_i == CMPM) ? 3'b011 : // Postincrement.
                     (op_i == MOVEP) ? 3'b101 : // Address register indirect plus 16 bit displacement.
                     biw_0[5:3];
   
   assign move_d_am = biw_0[8:6]; // Move statement destination address mode.
   
   assign regsel_20 = biw_0[2:0];// Valid for ORI, ANDI, SUBI, ADDI, EORI, CMPI, BTST, BCHG, BCLR
                                    // BCLR, BSET, MOVEP, MOVEA, MOVE, MOVE_FROM_CCR, MOVE_FROM_SR,
                                      // MOVE_TO_CCR,  NEGX, CLR, NEG, NOT, MOVE_TO_SR, EXT, NBCD,
                                      // SWAP, PEA, TAS, TST, MULU, MULS, DIVU, DIVS, LINK, UNLK,
                                      // MOVE_USP, JSR, JMP, MOVEM, LEA, CHK, ADDQ, SUBQ, DBcc, Scc,
                                      // OR, SUBX, SUB, SUBA, CMPM, CMP, CMPA, EOR, ABCD, EXG, AND,
                                      // ADDX, ADDA, ADD, ASL, ASR, LSL, LSR, ROL, ROR, ROXL, ROXR.
   
   assign regsel_119 = biw_0[11:9];// Valid for BTST, BCHG, BCLR, BSET,MOVEP, MOVEA, MOVE, LEA,
                                    // CHK, MULU, MULS, DIVU, DIVS, SBCD, OR, SUBX, SUB, SUBA,
                                    // CMPM, CMP, CMPA, EOR, ABCD, EXG, AND, ADDX, ADDA, ADD.
   
   assign regsel_index = (src_destn == 1'b1) ? exword_reg0[14:12] : dest_exword_reg0[14:12];
   
   assign c_code = biw_0[11:8]; // Valid for Bcc, DBcc, Scc.
   
   assign op_mode = (op_i == EXG) ? // Valid for EXT, OR, SUB, SUBA, CMP, CMPA, EOR, AND, ADDA, ADD.
                    biw_0[7:3] : {2'b00,biw_0[8:6]};
   
   assign trap_vector = biw_0[3:0]; // Valid for TRAP.
   
   assign sel_displace_biw = op_i == BCC | op_i == BRA | op_i == BSR | op_i == DBCC | op_i == MOVEP | op_i == LINK ? 1'b1 : 1'b0;
   
   assign displace_biw = (op_i == BRA & biw_0[7:0] == 8'h00) ? {16'h0000,biw_1} : // Word displacement.
                         (op_i == BRA & biw_0[7:0] == 8'hFF) ? {biw_1,biw[2]} : // LONG displacement 68K20+.
                         (op_i == BSR & biw_0[7:0] == 8'h00) ? {16'h0000,biw_1} :
                         (op_i == BSR & biw_0[7:0] == 8'hFF) ? {biw_1,biw[2]} : // LONG displacement 68K20+.
                         (op_i == BCC & biw_0[7:0] == 8'h00) ? {16'h0000,biw_1} :
                         (op_i == BRA | op_i == BSR | op_i == BCC) ? {24'h000000,biw_0[7:0]} :
                         (op_i == LINK & op_size_i == LONG) ? {biw_1,biw[2]} :
                         {16'h0000,biw_1}; // Valid for DBcc, LINK, MOVEP.
   
   assign ext_dsize = (op_i == LINK & op_size_i == LONG) ? LONG :
                      (op_i == DBCC | op_i == MOVEP | op_i == LINK) ? WORD :
                      (op_i == BRA & biw_0[7:0] == 8'h00) ? WORD :
                      (op_i == BRA & biw_0[7:0] == 8'hFF) ? LONG : // 68K20+.
                      (op_i == BSR & biw_0[7:0] == 8'h00) ? WORD :
                      (op_i == BSR & biw_0[7:0] == 8'hFF) ? LONG : // 68K20+.
                      (op_i == BCC & biw_0[7:0] == 8'hFF) ? LONG : // 68K20+.
                      (op_i == BCC & biw_0[7:0] == 8'h00) ? WORD :
                      (op_i == BRA | op_i == BSR | op_i == BCC) ? BYTE :
                      (biw_0[8:6] == 3'b101 & src_destn == 1'b0) ? WORD : // MOVE.
                      (biw_0[8:6] == 3'b110 & src_destn == 1'b0) ? BYTE : // MOVE.
                      (biw_0[5:3] == 3'b111 & biw_0[2:0] == 3'b010) ? WORD :
                      (biw_0[5:3] == 3'b101) ? WORD :
                      BYTE;
   
   // The immediate data is modelled in a way, that not used bits are forced to zero. This requires
   // a bit more logic but makes the CPU immune against compiler behavior concerning the writing of the
   // none used bits in word and byte mode.
   // The last two assignments are valid (in the respective mode) for: ADD, ADDA, AND, BTST, CHK, CMP, CMPA,
   // DIVS, DIVU, MOVEA, MOVE_TO_CCR, MOVE_TO_SR, MULS, MULU, OR, SUB, SUBA, TST.
   assign data_immediate = (op_i == ORI_TO_CCR | op_i == EORI_TO_CCR) ? { 16'b0, 8'b0, biw_1[7:0] } :
                           (op_i == EORI_TO_SR | op_i == ORI_TO_SR | op_i == ANDI_TO_SR) ? {16'h0000,biw_1} :
                           ((op_i == ADDQ | op_i == SUBQ) & biw_0[11:9] == 3'b000) ? 32'h00000008 :
                           (op_i == ADDQ | op_i == SUBQ) ? { 28'b0, 1'b0, biw_0[11:9] } :
                           ((op_i == ANDI | op_i == ADDI) & biw_0[7:6] == 2'b10) ? {biw_1,biw[2]} : // Long.
                           ((op_i == CMPI | op_i == EORI) & (biw_0[7:6] == 2'b10)) ? {biw_1,biw[2]} : // Long.
                           ((op_i == ORI | op_i == SUBI) & (biw_0[7:6] == 2'b10)) ? {biw_1,biw[2]} : // Long.
                           ((op_i == ANDI | op_i == ADDI) & (biw_0[7:6] == 2'b01)) ? {16'h0000,biw_1} : // Word.
                           ((op_i == CMPI | op_i == EORI) & (biw_0[7:6] == 2'b01)) ? {16'h0000,biw_1} : // Word.
                           ((op_i == ORI | op_i == SUBI) & (biw_0[7:6] == 2'b01)) ? {16'h0000,biw_1} : // Word.
                           (op_i == ANDI | op_i == ADDI) ? {16'b0, 8'b0, biw_1[7:0]} : // Byte.
                           (op_i == CMPI | op_i == EORI) ? {16'b0, 8'b0, biw_1[7:0]} : // Byte.
                           (op_i == ORI | op_i == SUBI) ? {24'b0,biw_1[7:0]} : // Byte.
                           (op_i == STOP) ? {16'h0000,biw_1} :
                           (op_i == MOVEQ) ? {24'h000000,biw_0[7:0]} :
                           (op_size_i == LONG) ? {exword_reg0,exword_reg1} :
                           {16'h0000,exword_reg0};
   
   // Bit Position for the bit operations BCHG, BCLR, BSET, BTST:
   // The Bit position is valid if BITPOS_IM is '1'.
   // If BITPOS_IM is '1', the register selected by REGSEL_119 indicates the bit position.
   assign bitpos_im = ((op_i == BCHG | op_i == BCLR | op_i == BSET | op_i == BTST) & biw_0[8] == 1'b0) ? 1'b1 : 1'b0;
   assign bit_pos = biw_1[4:0];
   
   // Multiplication / Division:
   assign div_mul_32n64 = biw_1[10];
   assign reg_dlq = biw_1[14:12];
   assign reg_dhr = biw_1[2:0];
   
   // This signal indicates register or memory shifting.
   assign mem_shft = ((op_i == ASL | op_i == ASR) & biw_0[7:6] == 2'b11) ? 1'b1 :
                     ((op_i == LSL | op_i == LSR) & biw_0[7:6] == 2'b11) ? 1'b1 :
                     ((op_i == ROTL | op_i == ROTR) & biw_0[7:6] == 2'b11) ? 1'b1 :
                     ((op_i == ROXL | op_i == ROXR) & biw_0[7:6] == 2'b11) ? 1'b1 :
                     1'b0;
   
   assign reglistmask = biw_1;
   
   assign op_size = op_size_i;
   assign op_size_i = (op_i == ABCD | op_i == NBCD | op_i == SBCD) ? BYTE :
                       (op_i == ADDA & biw_0[8:6] == 3'b111) ? LONG :
                       (op_i == ADDA & biw_0[8:6] == 3'b011) ? WORD :
                       (op_i == BCHG & biw_0[5:3] == 3'b000) ? LONG :
                       (op_i == BCLR & biw_0[5:3] == 3'b000) ? LONG :
                       (op_i == BSET & biw_0[5:3] == 3'b000) ? LONG :
                       (op_i == BTST & biw_0[5:3] == 3'b000) ? LONG :
                       (op_i == BCHG | op_i == BCLR) ? BYTE : // Memory access is byte.
                       (op_i == BSET | op_i == BTST) ? BYTE : // Memory access is byte.
                       (op_i == CHK & biw_0[8:7] == 2'b11) ? WORD :
                       (op_i == CHK & biw_0[8:7] == 2'b10) ? LONG :
                       (op_i == CMPA & biw_0[8:6] == 3'b111) ? LONG :
                       (op_i == CMPA & biw_0[8:6] == 3'b011) ? WORD :
                       (op_i == DIVS & biw_0[8:6] == 3'b001) ? LONG :
                       (op_i == DIVU & biw_0[8:6] == 3'b001) ? LONG :
                       (op_i == DIVS & biw_0[8:6] == 3'b111) ? WORD :
                       (op_i == DIVU & biw_0[8:6] == 3'b011) ? WORD :
                       (op_i == EXTW & biw_0[7:6] == 2'b11) ? LONG :
                       (op_i == EXTW & biw_0[7:6] == 2'b10) ? WORD :
                       (op_i == LINK & biw_0[15:3] == 13'b0100111001010) ? WORD :
                       (op_i == LINK & biw_0[15:3] == 13'b0100100000001) ? LONG :
                       (op_i == MOVE & biw_0[13:12] == 2'b01) ? BYTE :
                       (op_i == MOVE & biw_0[13:12] == 2'b11) ? WORD :
                       (op_i == MOVE & biw_0[13:12] == 2'b10) ? LONG :
                       (op_i == MOVEA & biw_0[13:12] == 2'b11) ? WORD :
                       (op_i == MOVEA & biw_0[13:12] == 2'b10) ? LONG :
                       (op_i == MOVEM & biw_0[6] == 1'b1) ? LONG :
                       (op_i == MOVEM & biw_0[6] == 1'b0) ? WORD :
                       (op_i == MOVEP & biw_0[8:6] == 3'b111) ? LONG :
                       (op_i == MOVEP & biw_0[8:6] == 3'b101) ? LONG :
                       (op_i == MOVEP & biw_0[8:6] == 3'b110) ? WORD :
                       (op_i == MOVEP & biw_0[8:6] == 3'b100) ? WORD :
                       (op_i == MOVE_FROM_CCR) ? WORD :
                       (op_i == MOVE_FROM_SR) ? WORD :
                       (op_i == MOVE_TO_CCR) ? WORD :
                       (op_i == MOVE_TO_SR) ? WORD :
                       (op_i == MULS & biw_0[8:6] == 3'b000) ? LONG :
                       (op_i == MULU & biw_0[8:6] == 3'b000) ? LONG :
                       (op_i == MULS & biw_0[8:6] == 3'b111) ? WORD :
                       (op_i == MULU & biw_0[8:6] == 3'b011) ? WORD :
                       (op_i == SUBA & biw_0[8:6] == 3'b111) ? LONG :
                       (op_i == SUBA & biw_0[8:6] == 3'b011) ? WORD :
                       (op_i == SCC | op_i == TAS) ? BYTE :
                       ((op_i == ASL | op_i == ASR) & biw_0[7:6] == 2'b11) ? WORD : // Memory Shifts.
                       ((op_i == LSL | op_i == LSR) & biw_0[7:6] == 2'b11) ? WORD : // Memory Shifts.
                       ((op_i == ROTL | op_i == ROTR) & biw_0[7:6] == 2'b11) ? WORD : // Memory Shifts.
                       ((op_i == ROXL | op_i == ROXR) & biw_0[7:6] == 2'b11) ? WORD : // Memory Shifts.
                       (op_i == BSR | op_i == PEA | op_i == RTS) ? LONG : // Long words to/from the stack.
                      // The following three conditions are valid for the listed operations:
                      // ADDI, ANDI, CMP, CMPI, EORI, ORI, SUBI, ADDQ, SUBQ, ADDX, NEGX, SUBX, ASR,
                      // ASL, LSR, LSL, ROXR, ROXL, ROTR, ROTL, CLR, NEG, NOT_B, TST, CMPM, JSR.
                       (biw_0[7:6] == 2'b00) ? BYTE :
                       (biw_0[7:6] == 2'b01) ? WORD :
                       (biw_0[7:6] == 2'b10) ? LONG :
                       LONG; // The default is used for unsized operations LEA, MOVEQ ...
   
   // The FORCE_BIW2 indicates, that an operation needs obligatory a further instruction word.
   assign force_biw2 = (op_i == ORI_TO_CCR | op_i == ORI_TO_SR | op_i == ORI | op_i == ANDI_TO_CCR) ? 1'b1 :
                       (op_i == ANDI_TO_SR | op_i == ANDI | op_i == SUBI | op_i == ADDI | op_i == EORI_TO_CCR) ? 1'b1 :
                       ((op_i == BCHG | op_i == BCLR | op_i == BSET | op_i == BTST) & biw_0[8] == 1'b0) ? 1'b1 :
                       (op_i == EORI_TO_SR | op_i == EORI | op_i == CMPI) ? 1'b1 :
                       (op_i == MOVEP | op_i == LINK | op_i == STOP) ? 1'b1 :
                       ((op_i == DIVS | op_i == DIVU) & biw_0[8:6] == 3'b001) ? 1'b1 :
                       ((op_i == MULS | op_i == MULU) & biw_0[8:6] == 3'b000) ? 1'b1 :
                       (op_i == MOVEM | op_i == DBCC) ? 1'b1 :
                       ((op_i == BRA | op_i == BSR | op_i == BCC) & biw_0[7:0] == 8'h00) ? 1'b1 :
                       ((op_i == BRA | op_i == BSR | op_i == BCC) & biw_0[7:0] == 8'hFF) ? 1'b1 :
                       1'b0;
   
   // The FORCE_BIW3 indicates, that an operation needs obligatory a third instruction word.
   assign force_biw3 = (op_i == ORI & op_size_i == LONG) ? 1'b1 :
                       (op_i == ANDI & op_size_i == LONG) ? 1'b1 :
                       (op_i == SUBI & op_size_i == LONG) ? 1'b1 :
                       (op_i == ADDI & op_size_i == LONG) ? 1'b1 :
                       (op_i == EORI & op_size_i == LONG) ? 1'b1 :
                       (op_i == CMPI & op_size_i == LONG) ? 1'b1 :
                       (op_i == LINK & op_size_i == LONG) ? 1'b1 :
                       ((op_i == BRA | op_i == BSR | op_i == BCC) & biw_0[7:0] == 8'hFF) ? 1'b1 :
                       1'b0;
   
   // Enables extension word fetch for the respective commands.
   assign ext_en = (op_i == ADD | op_i == ADDA | op_i == ADDI | op_i == ADDQ | op_i == AND_B | op_i == ANDI) ? 1'b1 :
                   ((op_i == ASL | op_i == ASR) & biw_0[7:6] == 2'b11) ? 1'b1 : // Memory Shifts.
                   ((op_i == LSL | op_i == LSR) & biw_0[7:6] == 2'b11) ? 1'b1 : // Memory Shifts.
                   ((op_i == ROXL | op_i == ROXR) & biw_0[7:6] == 2'b11) ? 1'b1 : // Memory Shifts.
                   ((op_i == ROTL | op_i == ROTR) & biw_0[7:6] == 2'b11) ? 1'b1 : // Memory Shifts.
                   (op_i == BCHG | op_i == BCLR | op_i == BSET | op_i == BTST | op_i == CHK | op_i == CLR) ? 1'b1 :
                   (op_i == CMP | op_i == CMPA | op_i == CMPI | op_i == DIVS | op_i == DIVU | op_i == EOR) ? 1'b1 :
                   (op_i == EORI | op_i == JMP | op_i == JSR | op_i == LEA | op_i == MOVE | op_i == MOVEA) ? 1'b1 :
                   (op_i == MOVE_FROM_CCR | op_i == MOVE_TO_CCR | op_i == MOVE_FROM_SR | op_i == MOVE_TO_SR) ? 1'b1 :
                   (op_i == MOVEM | op_i == MULS | op_i == MULU | op_i == NBCD | op_i == NEG | op_i == NEGX) ? 1'b1 :
                   (op_i == NOT_B | op_i == OR_B | op_i == ORI | op_i == PEA | op_i == SCC | op_i == SUB) ? 1'b1 :
                   (op_i == SUBA | op_i == SUBI | op_i == SUBQ | op_i == TAS | op_i == TST) ? 1'b1 :
                   1'b0;
   
   // If extension word fetch is enabled, this is the number of source or/and destination extensions to fetch.
   assign ext_cnt =  (biw_0[5:3] == 3'b111 & biw_0[2:0] == 3'b100 & op_size_i == LONG & ext_en) ? 2'd2 :
                     (biw_0[5:3] == 3'b111 & biw_0[2:0] == 3'b001 & ext_en) ? 2'd2 :
                     (biw_0[5:3] == 3'b111 & biw_0[2:0] == 3'b100 & ext_en) ? 2'd1 :
                     (biw_0[5:3] == 3'b111 & biw_0[2:0] == 3'b011 & ext_en) ? 2'd1 :
                     (biw_0[5:3] == 3'b111 & biw_0[2:0] == 3'b010 & ext_en) ? 2'd1 :
                     (biw_0[5:3] == 3'b111 & biw_0[2:0] == 3'b000 & ext_en) ? 2'd1 :
                     (biw_0[5:3] == 3'b110 & ext_en) ? 2'd1 :
                     (biw_0[5:3] == 3'b101 & ext_en) ? 2'd1 :
                     2'd0;
   
   // For the MOVE operation, we need a second set of extension words.
   assign dest_ext_cnt = (biw_0[8:6] == 3'b111 & biw_0[11:9] == 3'b001 & op_i == MOVE) ? 2'd2 :
                         (biw_0[8:6] == 3'b111 & biw_0[11:9] == 3'b000 & op_i == MOVE) ? 2'd1 :
                         (biw_0[8:6] == 3'b110 & op_i == MOVE) ? 2'd1 :
                         (biw_0[8:6] == 3'b101 & op_i == MOVE) ? 2'd1 :
                         2'd0;
   
       
   always @ (biw_0 or biw_1)
     begin 
        // The default OPCODE is the ILLEGAL operation, if no of the following conditions are met.
        // If any not used bit pattern occurs, the CPU will result in an ILLEGAL trap. An exception of
        // this behavior is the OPCODE with the 1010 or the 1111 pattern in the four MSBs. 
        // These lead to the respective traps.
        op_i = ILLEGAL;
        case (biw_0[15:12]) // Operation code map.
          4'h0 : // Bit manipulation / MOVEP / Immediate.
            begin 
               if (biw_0[11:0] == 12'h03C) 
                 op_i = ORI_TO_CCR;
               else if (biw_0[11:0] == 12'h07C) 
                 op_i = ORI_TO_SR;
               else if (biw_0[11:0] == 12'h23C) 
                 op_i = ANDI_TO_CCR;
               else if (biw_0[11:0] == 12'h27C) 
                 op_i = ANDI_TO_SR;
               else if (biw_0[11:0] == 12'hA3C) 
                 op_i = EORI_TO_CCR;
               else if (biw_0[11:0] == 12'hA7C) 
                 op_i = EORI_TO_SR;

               case (biw_0[5:3]) // Addressing mode.
                 3'b000,3'b010,3'b011,3'b100,3'b101,3'b110 : 
                   // Bit operations with static bit number:
                   if (biw_0[11:6] == 6'b100000) 
                     op_i = BTST;
                   else if (biw_0[11:6] == 6'b100001) 
                     op_i = BCHG;
                   else if (biw_0[11:6] == 6'b100010) 
                     op_i = BCLR;
                   else if (biw_0[11:6] == 6'b100011) 
                     op_i = BSET;
                 // Logic operations:
                   else if (biw_0[11:8] == 4'h0 & biw_0[7:6] < 2'b11) 
                     op_i = ORI;
                   else if (biw_0[11:8] == 4'h2 & biw_0[7:6] < 2'b11) 
                     op_i = ANDI;
                   else if (biw_0[11:8] == 4'h4 & biw_0[7:6] < 2'b11) 
                     op_i = SUBI;
                   else if (biw_0[11:8] == 4'h6 & biw_0[7:6] < 2'b11) 
                     op_i = ADDI;
                   else if (biw_0[11:8] == 4'hA & biw_0[7:6] < 2'b11) 
                     op_i = EORI;
                   else if (biw_0[11:8] == 4'hC & biw_0[7:6] < 2'b11) 
                     op_i = CMPI;
                 // Bit operations with dynamic bit number:
                   else if (biw_0[8:6] == 3'b100) 
                     op_i = BTST;
                   else if (biw_0[8:6] == 3'b101) 
                     op_i = BCHG;
                   else if (biw_0[8:6] == 3'b110) 
                     op_i = BCLR;
                   else if (biw_0[8:6] == 3'b111) 
                     op_i = BSET;
                 
                 3'b111 : 
                   // In the addressing mode "111" not all register selections are valid.
                   // Bit operations with static bit number:
                   if (biw_0[11:6] == 6'b100000 & biw_0[2:0] < 3'b100)
                     op_i = BTST;
                   else if (biw_0[11:6] == 6'b100001 & biw_0[2:0] < 3'b010)
                     op_i = BCHG;
                   else if (biw_0[11:6] == 6'b100010 & biw_0[2:0] < 3'b010)
                     op_i = BCLR;
                   else if (biw_0[11:6] == 6'b100011 & biw_0[2:0] < 3'b010)
                     op_i = BSET;
                 // Logic operations:
                   else if (biw_0[11:8] == 4'h0 & biw_0[7:6] < 2'b11 & biw_0[2:0] < 3'b010)
                     op_i = ORI;
                   else if (biw_0[11:8] == 4'h2 & biw_0[7:6] < 2'b11 & biw_0[2:0] < 3'b010)
                     op_i = ANDI;
                   else if (biw_0[11:8] == 4'h4 & biw_0[7:6] < 2'b11 & biw_0[2:0] < 3'b010)
                     op_i = SUBI;
                   else if (biw_0[11:8] == 4'h6 & biw_0[7:6] < 2'b11 & biw_0[2:0] < 3'b010)
                     op_i = ADDI;
                   else if (biw_0[11:8] == 4'hA & biw_0[7:6] < 2'b11 & biw_0[2:0] < 3'b010)
                     op_i = EORI;
                   else if (biw_0[11:8] == 4'hC & biw_0[7:6] < 2'b11 & biw_0[2:0] < 3'b100)
                     op_i = CMPI;
                 // Bit operations with dynamic bit number:
                   else if (biw_0[8:6] == 3'b100 & biw_0[2:0] < 3'b101)
                     op_i = BTST;
                   else if (biw_0[8:6] == 3'b101 & biw_0[2:0] < 3'b010)
                     op_i = BCHG;
                   else if (biw_0[8:6] == 3'b110 & biw_0[2:0] < 3'b010)
                     op_i = BCLR;
                   else if (biw_0[8:6] == 3'b111 & biw_0[2:0] < 3'b010)
                     op_i = BSET;
                 
                 default : ;
               endcase

               if (biw_0[8:6] > 3'b011 & biw_0[5:3] == 3'b001) 
                 op_i = MOVEP;
            end

          4'h1 : // Move BYTE.
            if (biw_0[8:6] == 3'b111 & biw_0[11:9] < 3'b010 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101) 
              op_i = MOVE;
            else if (biw_0[8:6] == 3'b111 & biw_0[11:9] < 3'b010 & biw_0[5:3] != 3'b001 & biw_0[5:3] != 3'b111) 
              op_i = MOVE;
            else if (biw_0[8:6] != 3'b001 & biw_0[8:6] != 3'b111 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
              op_i = MOVE;
            else if (biw_0[8:6] != 3'b001 & biw_0[8:6] != 3'b111 & biw_0[5:3] != 3'b001 & biw_0[5:3] != 3'b111)
              op_i = MOVE;
          
          4'h2,4'h3 : // Move WORD or LONG.
            if (biw_0[8:6] == 3'b111 & biw_0[11:9] < 3'b010 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
              op_i = MOVE;
            else if (biw_0[8:6] == 3'b111 & biw_0[11:9] < 3'b010 & biw_0[5:3] != 3'b111)
              op_i = MOVE;
            else if (biw_0[8:6] == 3'b001 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
              op_i = MOVEA;
            else if (biw_0[8:6] == 3'b001 & biw_0[5:3] != 3'b111)
              op_i = MOVEA;
            else if (biw_0[8:6] != 3'b001 & biw_0[8:6] != 3'b111 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
              op_i = MOVE;
            else if (biw_0[8:6] != 3'b001 & biw_0[8:6] != 3'b111 & biw_0[5:3] != 3'b111)
              op_i = MOVE;

          4'h4 : // Miscellaneous.
            begin 
               if (biw_0[11:0] == 12'hE70) 
                 op_i = RESET;
               else if (biw_0[11:0] == 12'hE71) 
                 op_i = NOP;
               else if (biw_0[11:0] == 12'hE72) 
                 op_i = STOP;
               else if (biw_0[11:0] == 12'hE73) 
                 op_i = RTE;
               else if (biw_0[11:0] == 12'hE75) 
                 op_i = RTS;
               else if (biw_0[11:0] == 12'hE76) 
                 op_i = TRAPV;
               else if (biw_0[11:0] == 12'hE77) 
                 op_i = RTR;
               else if (biw_0[11:0] == 12'hAFA) 
                 op_i = RESERVED;
               else if (biw_0[11:0] == 12'hAFB) 
                 op_i = RESERVED;
               else if (biw_0[11:0] == 12'hAFC) 
                 op_i = ILLEGAL;
               else if (biw_0[11:3] == 9'b100000001) // 68K20, 68K30, 68K40
                 op_i = LINK; // LONG.
               else if (biw_0[11:3] == 9'b111001010) 
                 op_i = LINK; // WORD.
               else if (biw_0[11:3] == 9'b111001011) 
                 op_i = UNLK;
               else if (biw_0[11:3] == 9'b100001000) 
                 op_i = SWAP;
               else if (biw_0[11:4] == 8'hE4) 
                 op_i = TRAP;
               else if (biw_0[11:4] == 8'hE6) 
                 op_i = MOVE_USP;

               case (biw_0[5:3]) // Addressing mode.
                 3'b000,3'b010,3'b011,3'b100,3'b101,3'b110 : 
                   if (biw_0[11:6] == 6'b110001) 
                     begin 
                        if (biw_1[11]) 
                          op_i = DIVS; // Long.
                        else 
                          op_i = DIVU; // Long.
                     end 
                 // 68010 up stuff, pay attention when enabling due to software incompatibilities!
                 // elsif BIW(0)(11 downto 6) = "001011" then
                 // OP_I <= MOVE_FROM_CCR; -- 68K+ enhancement.
                   else if (biw_0[11:6] == 6'b000011) 
                     op_i = MOVE_FROM_SR;
                   else if (biw_0[11:6] == 6'b010011) 
                     op_i = MOVE_TO_CCR;
                   else if (biw_0[11:6] == 6'b011011) 
                     op_i = MOVE_TO_SR;
                   else if (biw_0[11:6] == 6'b110000) 
                     begin 
                        if (biw_1[11])
                          op_i = MULS; // Long.
                        else 
                          op_i = MULU; // Long.
                     end 
                   else if (biw_0[11:6] == 6'b100000) 
                     op_i = NBCD;
                   else if (biw_0[11:6] == 6'b101011) 
                     op_i = TAS;
                 
                 3'b111 : // Not all registers are valid for this mode.
                   if (biw_0[11:6] == 6'b110001 & biw_0[2:0] < 3'b101)
                     begin 
                        if (biw_1[11])
                          op_i = DIVS; // Long.
                        else 
                          op_i = DIVU; // Long.
                     end
		 // 68010 up stuff, pay attention when enabling due to software incompatibilities!
                 // elsif BIW(0)(11 downto 6) = "001011" and BIW(0)(2 downto 0) < "010" then
                 //OP_I <= MOVE_FROM_CCR; -- 68K+ enhancement.
                   else if (biw_0[11:6] == 6'b000011 & biw_0[2:0] < 3'b010)
                     op_i = MOVE_FROM_SR;
                   else if (biw_0[11:6] == 6'b010011 & biw_0[2:0] < 3'b101)
                     op_i = MOVE_TO_CCR;
                   else if (biw_0[11:6] == 6'b011011 & biw_0[2:0] < 3'b101)
                     op_i = MOVE_TO_SR;
                   else if (biw_0[11:6] == 6'b110000 & biw_0[2:0] < 3'b101)
                     begin 
                        if (biw_1[11])
                          op_i = MULS; // Long.
                        else 
                          op_i = MULU; // Long.
                     end 
                   else if (biw_0[11:6] == 6'b100000 & biw_0[2:0] < 3'b010)
                     op_i = NBCD;
                   else if (biw_0[11:6] == 6'b101011 & biw_0[2:0] < 3'b010)
                     op_i = TAS;
                 
                 default : 
                   ;
               endcase

               case (biw_0[5:3]) // Addressing mode.
                 3'b010,3'b101,3'b110 : 
                   if (biw_0[11:6] == 6'b100001)
                     op_i = PEA;
                   else if (biw_0[11:6] == 6'b111010)
                     op_i = JSR;
                   else if (biw_0[11:6] == 6'b111011)
                     op_i = JMP;

                 3'b111 : // Not all registers are valid for this mode.
                   if (biw_0[11:6] == 6'b100001 & biw_0[2:0] < 3'b100) 
                     op_i = PEA;
                   else if (biw_0[11:6] == 6'b111010 & biw_0[2:0] < 3'b100) 
                     op_i = JSR;
                   else if (biw_0[11:6] == 6'b111011 & biw_0[2:0] < 3'b100) 
                     op_i = JMP;
                 
                 default : 
                   ;
               endcase

               // For the following operation codes a SIZE (BIW(0)(7 downto 6)) is not valid.
               // For the following operation codes an addressing mode x"001" is not valid.
               if (biw_0[7:6] < 2'b11 & biw_0[5:3] != 3'b001 & biw_0[5:3] != 3'b111)
                 case (biw_0[11:8])
                   4'h0 : op_i = NEGX;
                   4'h2 : op_i = CLR;
                   4'h4 : op_i = NEG;
                   4'h6 : op_i = NOT_B;
                   default : ;
                 endcase
               // Not all registers are valid for the addressing mode "111":
               else if (biw_0[7:6] < 2'b11 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
                 case (biw_0[11:8])
                   4'h0 : op_i = NEGX;
                   4'h2 : op_i = CLR;
                   4'h4 : op_i = NEG;
                   4'h6 : op_i = NOT_B;
                   default : ;
                 endcase

               if (biw_0[11:8] == 4'hA & biw_0[7:6] < 2'b11 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                 case (biw_0[7:6])
                   2'b01,2'b10 : 
                     op_i = TST; // Long or word, all addressing modes.
                   default : // Byte: Address register direct not allowed.
                     if (biw_0[2:0] != 3'b100)
                       op_i = TST;
                 endcase
               else if (biw_0[11:8] == 4'hA & biw_0[7:6] < 2'b11 & biw_0[5:3] != 3'b111)
                 case (biw_0[7:6])
                   2'b01,2'b10 : 
                     op_i = TST; // Long or word, all addressing modes.
                   default : // Byte: Address register direct not allowed.
                     if (biw_0[5:3] != 3'b001)
                       op_i = TST;
                 endcase

               if (biw_0[11:9] == 3'b100 & biw_0[5:3] == 3'b000)
                 case (biw_0[8:6])
                   3'b010,3'b011 : // Valid OPMODES for this operation code.
                     op_i = EXTW;
                   default : ;
                 endcase

               if (biw_0[8:6] == 3'b111) 
                 case (biw_0[5:3]) // OPMODES.
                   3'b010,3'b101,3'b110 : 
                     op_i = LEA;
                   3'b111 : 
                     if (biw_0[2:0] < 3'b100) // Not all registers are valid for this OPMODE.
                       op_i = LEA;
                   default : ;
                 endcase

               if (biw_0[11] & biw_0[9:7] == 3'b001)
                 begin 
                    if (biw_0[10] == 1'b0) // Register to memory transfer.
                      case (biw_0[5:3]) // OPMODES, no postincrement addressing.
                        3'b010,3'b100,3'b101,3'b110 : 
                          op_i = MOVEM;
                        3'b111 : 
                          if (biw_0[2:0] == 3'b000 | biw_0[2:0] == 3'b001)
                            op_i = MOVEM;
                        default : ;
                      endcase
                    else // Memory to register transfer, no predecrement addressing.
                      case (biw_0[5:3]) // OPMODES.
                        3'b010,3'b011,3'b101,3'b110 : 
                          op_i = MOVEM;
                        3'b111 : 
                          if (biw_0[2:0] < 3'b100)
                            op_i = MOVEM;
                        default : ;
                      endcase
                 end 

               // The size must be "10" or "11" and the OPMODE may not be "001".
               if (biw_0[8:7] >= 2'b10 & biw_0[6:3] == 4'h7 & biw_0[2:0] < 3'b101)
                 op_i = CHK;
               else if (biw_0[8:7] >= 2'b10 & biw_0[6:3] != 4'h1 & biw_0[6:3] < 4'h7)
                 op_i = CHK;
            end
          4'h5 : // ADDQ / SUBQ / Scc / DBcc.
            if (biw_0[7:3] == 5'b11001)
              op_i = DBCC;
            else if (biw_0[7:6] == 2'b11 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
              op_i = SCC;
            else if (biw_0[7:6] == 2'b11 & biw_0[5:3] != 3'b001 & biw_0[5:3] != 3'b111)
              op_i = SCC;
            else if (biw_0[8] == 1'b0 & biw_0[7:6] < 2'b11 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
              op_i = ADDQ;
            else if (biw_0[8] == 1'b0 & (biw_0[7:6] == 2'b01 | biw_0[7:6] == 2'b10) & biw_0[5:3] != 3'b111)
              op_i = ADDQ;
            else if (biw_0[8] == 1'b0 & biw_0[7:6] == 2'b00 & biw_0[5:3] != 3'b001 & biw_0[5:3] != 3'b111)
              op_i = ADDQ;
            else if (biw_0[8] == 1'b1 & biw_0[7:6] < 2'b11 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
              op_i = SUBQ;
            else if (biw_0[8] == 1'b1 & (biw_0[7:6] == 2'b01 | biw_0[7:6] == 2'b10) & biw_0[5:3] != 3'b111)
              op_i = SUBQ;
            else if (biw_0[8] == 1'b1 & biw_0[7:6] == 2'b00 & biw_0[5:3] != 3'b001 & biw_0[5:3] != 3'b111)
              op_i = SUBQ;
          
          4'h6 : // Bcc / BSR / BRA.
            if (biw_0[11:8] == 4'h0)
              op_i = BRA;
            else if (biw_0[11:8] == 4'h1)
              op_i = BSR;
            else 
              op_i = BCC;
          
          4'h7 : // MOVEQ.
            if (biw_0[8] == 1'b0)
              op_i = MOVEQ;

          4'h8 : // OR / DIV / SBCD.
            begin 
               if (biw_0[8:6] == 3'b011 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                 op_i = DIVU; // WORD.
               else if (biw_0[8:6] == 3'b011 & biw_0[5:3] != 3'b001 & biw_0[5:3] != 3'b111)
                 op_i = DIVU; // WORD.
               else if (biw_0[8:6] == 3'b111 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                 op_i = DIVS; // WORD.
               else if (biw_0[8:6] == 3'b111 & biw_0[5:3] != 3'b001 & biw_0[5:3] != 3'b111)
                 op_i = DIVS; // WORD.
               else if (biw_0[8:4] == 5'b10000)
                 op_i = SBCD;

               case (biw_0[8:6])
                 3'b000,3'b001,3'b010 : 
                   if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                     op_i = OR_B;
                   else if (biw_0[5:3] != 3'b001 & biw_0[5:3] != 3'b111)
                     op_i = OR_B;
                 
                 3'b100,3'b101,3'b110 : 
                   if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
                     op_i = OR_B;
                   else if (biw_0[5:3] > 3'b001 & biw_0[5:3] != 3'b111)
                     op_i = OR_B;
                 default : ;
               endcase
            end

          4'h9 : // SUB / SUBX.
            case (biw_0[8:6])
              3'b000 : 
                if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                  op_i = SUB;
                else if (biw_0[5:3] != 3'b111 & biw_0[5:3] != 3'b001)
                  op_i = SUB;

              3'b001,3'b010 : 
                if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                  op_i = SUB;
                else if (biw_0[5:3] != 3'b111)
                  op_i = SUB;
              
              3'b100 : 
                if (biw_0[5:3] == 3'b000 | biw_0[5:3] == 3'b001)
                  op_i = SUBX;
                else if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
                  op_i = SUB;
                else if (biw_0[5:3] != 3'b111 & biw_0[5:3] != 3'b001)
                  op_i = SUB;
              
              3'b101,3'b110 : 
                if (biw_0[5:3] == 3'b000 | biw_0[5:3] == 3'b001)
                  op_i = SUBX;
                else if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
                  op_i = SUB;
                else if (biw_0[5:3] != 3'b111)
                  op_i = SUB;
              
              3'b011,3'b111 : 
                if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                  op_i = SUBA;
                else if (biw_0[5:3] != 3'b111)
                  op_i = SUBA;

              default : ; // U, X, Z, W, H, L, -.
            endcase

          4'hA : // (1010, Unassigned, Reserved).
            op_i = UNIMPLEMENTED;

          4'hB : // CMP / EOR.
            if (biw_0[8] == 1'b1 & biw_0[7:6] < 2'b11 & biw_0[5:3] == 3'b001)
              op_i = CMPM;
            else 
              case (biw_0[8:6]) // OPMODE field.
                3'b000 : 
                  if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                    op_i = CMP;
                  else if (biw_0[5:3] != 3'b001 & biw_0[5:3] != 3'b111)
                    op_i = CMP;

                3'b001,3'b010 : 
                  if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                    op_i = CMP;
                  else if (biw_0[5:3] != 3'b111)
                    op_i = CMP;
                
                3'b011,3'b111 : 
                  if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                    op_i = CMPA;
                  else if (biw_0[5:3] != 3'b111)
                    op_i = CMPA;
                
                3'b100,3'b101,3'b110 : 
                  if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                    op_i = EOR;
                  else if (biw_0[5:3] != 3'b001 & biw_0[5:3] != 3'b111)
                    op_i = EOR;

                default : ; // U, X, Z, W, H, L, -.
              endcase
          
          4'hC : // AND / MUL / ABCD / EXG.
            if (biw_0[8:4] == 5'b10000)
              op_i = ABCD;
            else if (biw_0[8:6] == 3'b011 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
              op_i = MULU; // WORD.
            else if (biw_0[8:6] == 3'b011 & biw_0[5:3] != 3'b001 & biw_0[5:3] != 3'b111)
              op_i = MULU; // WORD.
            else if (biw_0[8:6] == 3'b111 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
              op_i = MULS; // WORD.
            else if (biw_0[8:6] == 3'b111 & biw_0[5:3] != 3'b001 & biw_0[5:3] != 3'b111)
              op_i = MULS; // WORD.
            else if (biw_0[8:3] == 6'b101000 | biw_0[8:3] == 6'b101001 | biw_0[8:3] == 6'b110001)
              op_i = EXG;
            else 
              case (biw_0[8:6]) // OPMODE
                3'b000,3'b001,3'b010 : 
                  if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                    op_i = AND_B;
                  else if (biw_0[5:3] != 3'b001 & biw_0[5:3] != 3'b111)
                    op_i = AND_B;
                
                3'b100,3'b101,3'b110 : 
                  if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
                    op_i = AND_B;
                  else if (biw_0[5:3] > 3'b001 & biw_0[5:3] != 3'b111)
                    op_i = AND_B;
                
                default : ;
              endcase

          4'hD : // ADD / ADDX.
            case (biw_0[8:6])
              3'b000 : 
                if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                  op_i = ADD;
                else if (biw_0[5:3] != 3'b111 & biw_0[5:3] != 3'b001)
                  op_i = ADD;

              3'b001,3'b010 : 
                if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                  op_i = ADD;
                else if (biw_0[5:3] != 3'b111)
                  op_i = ADD;

              3'b100 : 
                if (biw_0[5:3] == 3'b000 | biw_0[5:3] == 3'b001)
                  op_i = ADDX;
                else if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
                  op_i = ADD;
                else if (biw_0[5:3] != 3'b111 & biw_0[5:3] != 3'b001)
                  op_i = ADD;
              
              3'b101,3'b110 : 
                if (biw_0[5:3] == 3'b000 | biw_0[5:3] == 3'b001)
                  op_i = ADDX;
                else if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
                  op_i = ADD;
                else if (biw_0[5:3] != 3'b111)
                  op_i = ADD;
              
              3'b011,3'b111 : 
                if (biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b101)
                  op_i = ADDA;
                else if (biw_0[5:3] != 3'b111)
                  op_i = ADDA;
              default: ; // U, X, Z, W, H, L, -.
            endcase

          4'hE : // Shift / Rotate / Bit Field.
            if (biw_0[11:6] == 6'b000011 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
              op_i = ASR; // Memory shifts.
            else if (biw_0[11:6] == 6'b000011 & biw_0[5:3] > 3'b001 & biw_0[5:3] != 3'b111)
              op_i = ASR; // Memory shifts.
            else if (biw_0[11:6] == 6'b000111 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
              op_i = ASL; // Memory shifts.
            else if (biw_0[11:6] == 6'b000111 & biw_0[5:3] > 3'b001 & biw_0[5:3] != 3'b111)
              op_i = ASL; // Memory shifts.
            else if (biw_0[11:6] == 6'b001011 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
              op_i = LSR; // Memory shifts.
            else if (biw_0[11:6] == 6'b001011 & biw_0[5:3] > 3'b001 & biw_0[5:3] != 3'b111)
              op_i = LSR; // Memory shifts.
            else if (biw_0[11:6] == 6'b001111 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
              op_i = LSL; // Memory shifts.
            else if (biw_0[11:6] == 6'b001111 & biw_0[5:3] > 3'b001 & biw_0[5:3] != 3'b111)
              op_i = LSL; // Memory shifts.
            else if (biw_0[11:6] == 6'b010011 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
              op_i = ROXR; // Memory shifts.
            else if (biw_0[11:6] == 6'b010011 & biw_0[5:3] > 3'b001 & biw_0[5:3] != 3'b111)
              op_i = ROXR; // Memory shifts.
            else if (biw_0[11:6] == 6'b010111 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
              op_i = ROXL; // Memory shifts.
            else if (biw_0[11:6] == 6'b010111 & biw_0[5:3] > 3'b001 & biw_0[5:3] != 3'b111)
              op_i = ROXL; // Memory shifts.
            else if (biw_0[11:6] == 6'b011011 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
              op_i = ROTR; // Memory shifts.
            else if (biw_0[11:6] == 6'b011011 & biw_0[5:3] > 3'b001 & biw_0[5:3] != 3'b111)
              op_i = ROTR; // Memory shifts.
            else if (biw_0[11:6] == 6'b011111 & biw_0[5:3] == 3'b111 & biw_0[2:0] < 3'b010)
              op_i = ROTL; // Memory shifts.
            else if (biw_0[11:6] == 6'b011111 & biw_0[5:3] > 3'b001 & biw_0[5:3] != 3'b111)
              op_i = ROTL; // Memory shifts.
            else if (biw_0[8] == 1'b0 & biw_0[7:6] < 2'b11 & biw_0[4:3] == 2'b00)
              op_i = ASR; // Memory shifts.
            else if (biw_0[8] == 1'b1 & biw_0[7:6] < 2'b11 & biw_0[4:3] == 2'b00)
              op_i = ASL; // Memory shifts.
            else if (biw_0[8] == 1'b0 & biw_0[7:6] < 2'b11 & biw_0[4:3] == 2'b01)
              op_i = LSR; // Memory shifts.
            else if (biw_0[8] == 1'b1 & biw_0[7:6] < 2'b11 & biw_0[4:3] == 2'b01)
              op_i = LSL; // Memory shifts.
            else if (biw_0[8] == 1'b0 & biw_0[7:6] < 2'b11 & biw_0[4:3] == 2'b10)
              op_i = ROXR; // Memory shifts.
            else if (biw_0[8] == 1'b1 & biw_0[7:6] < 2'b11 & biw_0[4:3] == 2'b10)
              op_i = ROXL; // Memory shifts.
            else if (biw_0[8] == 1'b0 & biw_0[7:6] < 2'b11 & biw_0[4:3] == 2'b11)
              op_i = ROTR; // Memory shifts.
            else if (biw_0[8] == 1'b1 & biw_0[7:6] < 2'b11 & biw_0[4:3] == 2'b11)
              op_i = ROTL; // Memory shifts.
          
          4'hF : // 1111, Coprocessor Interface / 68K40 Extensions.
            op_i = UNIMPLEMENTED;
          default : ;// U, X, Z, W, H, L, -.

        endcase
     end 

`ifdef debug
   always @ (posedge clk)
     begin
	if (iw_wr & 0)
          $display("iw_wr; biw[%d] <= %x (posedge)", iw_adr, data_in);
     end

   always @ (negedge clk)
     begin
	if (iw_wr & 0)
          $display("iw_wr; biw[%d] <= %x (negedge)", iw_adr, data_in);
     end

   always @ (posedge clk)
     begin
        if (biw_0[15:12] == 4'h6 & 0)
	  begin
	     $display("biw_0[15:12] == 6, biw_0[11:8]=%x, op_i=%d", biw_0[11:8], op_i);
	  end
     end

`endif
endmodule
