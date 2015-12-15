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
//-- This file contains the 68Ks address registers.               ----
//--                                                              ----
//--                                                              ----
//-- Description:                                                 ----
//-- This file contains the 68K series data and address           ----
//-- registers, the user stack pointer (USP), the supervisor      ----
//-- stack pointer (SSP) and the 32-bit program counter (PC).     ----
//-- The required sign extensions for the INDEX and the DISPLACE- ----
//-- ment are provided by this model.                             ----
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
// Revision 2K8B  2008/08/15 WF
//   Fixed the Ax,-(Ax) bug, thanks to T. Gubener for finding this out.
//   Fixed LINK A7 bug.
//   Fixed MOVEM (d8,ax,index) bug, thanks to T. Gubener for finding this out.
//   Fixed MOVE (Ax)+, Ax bug, thanks to T. Gubener for finding this out.
// 


module  wf68k00ip_address_registers ( clk, resetn, adata_in, regsel_b, regsel_a, adr_reg_qb, adr_reg_qa,
				      usp_out, ssp_out, pc_out, exword0, exword1, dest_exword0, dest_exword1, dr, usp_cpy, ar_exg, ar_wr,
				      usp_inc, usp_dec, adr_tmp_clr, adr_tmp_inc, ar_inc, ar_dec, 
				      ssp_inc, ssp_dec, ssp_init, sp_add_displ, use_sp_adr, use_ssp_adr,
				      pc_wr, pc_inc, pc_tmp_clr, pc_tmp_inc, pc_init, pc_add_displ,
				      src_destn, sbit, op, op_size, op_mode, op_start, adr_mode,
				      move_d_am, force_biw2, force_biw3, ext_dsize, sel_displace_biw, displace_biw,
				      regsel_index, index_d_in, chk_pc, chk_adr, trap_aerr, adr_eff
`ifdef CHIPSCOPE_M68K
				      , ar_all
`endif
				      );

   input        clk;
   input        resetn;

   // Address and data:
   input [31:0] adata_in ; // Address register and USP, SSP and PC input.
   input [2:0] 	regsel_b ; // Register number.
   input [2:0] 	regsel_a ; // Register number.
   output [31:0] adr_reg_qb ; // Register selected by REGSEL_B.
   output [31:0] adr_reg_qa ; // Register selected by REGSEL_A.
   output [31:0] usp_out ; // User stack pointer.
   output [31:0] ssp_out ; // Supervisor stack pointer.
   output [31:0] pc_out ; // Program counter.

   // Extension words:
   input [15:0]  exword0;
   input [15:0]  exword1;
   input [15:0]  dest_exword0;
   input [15:0]  dest_exword1;

   // Registers controls:
   input 	 dr; // Direction control.
   input 	 usp_cpy; // Copy among address registers.                         
   input 	 ar_exg; // Exchange address register contents.                   
   input 	 ar_wr;	// Address register write.                               
   input 	 usp_inc; // User stack pointer increment by 2.                    
   input 	 usp_dec; // User stack pointer decrement by 2.                    
   input 	 adr_tmp_clr; // Temporary address offset clear.                       
   input 	 adr_tmp_inc; // Address register increment temporarily.               
   input 	 ar_inc; // Address register increment.                           
   input 	 ar_dec; // Address register decrement.                           
   input 	 ssp_inc; // Supervisor stack pointer increment by 2.              
   input 	 ssp_dec; // Supervisor stack pointer decrement by 2.              
   input 	 ssp_init; // Initialize SSP.                                       
   input 	 sp_add_displ; // Forces the adding of the sign extended displacement to the SP.
   input 	 use_sp_adr; // Indicates the use of the stack (suer or supervisor).  
   input 	 use_ssp_adr; // Indicates the use of the supervisor stack.            
   input 	 pc_wr;	// Program counter write.                                
   input 	 pc_inc; // Program counter increment.                            
   input 	 pc_tmp_clr; // Clear temporary PC.                                   
   input 	 pc_tmp_inc; // Increment temporary PC.                               
   input 	 pc_init; // Initialize the program counter.                       
   input 	 pc_add_displ; // Forces the adding of the sign extended displacement to the SP.

   // Misc controls:
   input 	 src_destn; // '1' for read operand from source, '0' store result to destination (MOVE).
   input 	 sbit; // Superuser flag.
   input [6:0] 	 op; // the operations.
   input [1:0] 	 op_size; // BYTE, WORD or LONG.
   input [4:0] 	 op_mode ;
   input 	 op_start; // Used for the MOVEM.
   input [2:0] 	 adr_mode ; // Address mode indicator.
   input [2:0] 	 move_d_am ; // Destination address mode for MOVE.
   input 	 force_biw2;
   input 	 force_biw3;

   // Displacement stuff:
   input [1:0] 	 ext_dsize;
   input 	 sel_displace_biw;
   input [31:0]  displace_biw ; // Displacement (8 or 16 bit).

   // Index and data register stuff:
   input [2:0] 	 regsel_index ; // Index register address select.
   input [31:0]  index_d_in ; // Index from a data register.

   // Traps:
   input 	 chk_pc; // Check program counter for TRAP_AERR.
   input 	 chk_adr; // Check effective address for TRAP_AERR.
   output        trap_aerr; // Address error indication.

   // Effective address (result of the address logic):
   output [31:0] adr_eff; // This is the effective address.
`ifdef CHIPSCOPE_M68K
   output [255:0] ar_all;
`endif
   
`include "wf68k00ip_parms.h"

   reg [31:0] 	 index_tmp;
   reg [31:0] 	 index_ext;
   reg [1:0] 	 iwl_ida=0;
   reg [3:0] 	 pc_tmpvar;
   reg [31:0] 	 adr_eff_tmp;
   reg [31:0] 	 areg;

   reg [31:0] 	 ar [0:6]; // Address registers A0 to A6.
   reg [31:0] 	 data_signed; // Sign extended data.
   reg [31:0] 	 usp; // User stack pointer (refers to A7 in the user mode.).
   reg [31:0] 	 ssp; // Supervisor stack pointer (refers to A7' in the supervisor mode).
   reg [31:0] 	 pc;  // Program counter.
   reg [31:0] 	 areg_tmp; // Temporary address holding register.
   wire [2:0] 	 adr_mode_i;
   wire [31:0] 	 displace;
   reg [31:0] 	 displ_ext;
   wire 	 i_d_a;
   wire 	 i_w_l;
   wire [1:0] 	 i_scale; // Scale information for the index.
   wire 	 index_sign;
   reg [31:0] 	 index_scaled;
   wire [31:0] 	 abs_address;
   wire [2:0] 	 ar_nr_a;
   wire [2:0] 	 ar_nr_b;
   wire [2:0] 	 ar_nr_i;
   reg [31:0] 	 adr_eff_i;
   reg [5:0] 	 adr_tmp;
   wire [4:0] 	 pc_tmp;
   wire [3:0] 	 pc_offset; // Used for PC relative addressing modes.
   wire [2:0] 	 ar_step;
   wire [31:0] 	 adr_reg_qb;
   wire [31:0] 	 adr_reg_qa;
   wire [31:0] 	 usp_out;
   wire [31:0] 	 ssp_out;
   wire [31:0] 	 pc_out;
   wire 	 trap_aerr;
   reg [31:0] 	 adr_eff;


   
   // Address mode selector switch:
   // The default assignment is valid for source and destination access
   // regardless of the value of SRC_DESTn (e.g. ADD, ADDX).
   assign adr_mode_i = (src_destn == 1'b0 & op == MOVE) ? move_d_am :  adr_mode;
   
   // Address pointers:
   assign ar_nr_a = regsel_a;
   assign ar_nr_b = regsel_b;
   assign ar_nr_i = regsel_index;
   
   // TRAP_AERR: 
   // 1. If an operation is read from an odd adress.
   // 2. If the respective stack pointers in use are at an odd address.
   // 2. If there is a WORD oder LONG bus access at an odd address.
   // Note: Do not change the priority of these conditions!
   assign trap_aerr = (chk_pc & pc[0]) ? 1'b1 : // OP-Code at an odd address.
                      (chk_adr & use_ssp_adr & ssp[0]) ? 1'b1 :
                      (chk_adr & use_sp_adr & sbit & ssp[0]) ? 1'b1 :
                      (chk_adr & use_sp_adr & usp[0]) ? 1'b1 :
                      (chk_adr & (use_ssp_adr | use_sp_adr)) ? 1'b0 : // Stack is correct.
		      // MOVEP size is long or word but the acces is at byte boarders:
                      (chk_adr & op != MOVEP & op_size == LONG & adr_eff_i[0]) ? 1'b1 : // LONG at an odd address.
                      (chk_adr & op != MOVEP & op_size == WORD & adr_eff_i[0]) ? 1'b1 : // WORD at an odd address.
                      1'b0;
   
   // The address register increment and decrement values:
   assign ar_step = (op_size == LONG) ? 3'b100 :
                    (op_size == WORD) ? 3'b010 :
                    (op_size == BYTE & ar_nr_b == 7) ? 3'b010 :
                    3'b001;
   
   // Data outputs:
   assign usp_out = usp;
   assign ssp_out = ssp;
   assign pc_out = pc + {27'b0, pc_tmp}; // Plus offset.
   
   assign adr_reg_qa = (op == MOVEM & adr_mode_i == 3'b100 & regsel_a == regsel_b) ? areg_tmp : // See P_AREG_TMP, case A.
                       (op == MOVE & adr_mode == 3'b001 & move_d_am == 3'b100) ? areg_tmp :
                       (op == PEA) ? areg_tmp : // Store the effective address (e.g.: PEA (A7)).
                       (ar_nr_a == 7 & sbit) ? ssp : // Supervisor stack pointer.
                       (ar_nr_a == 7 & ~sbit) ? usp : // User stack pointer.
                       ar[ar_nr_a];
   
   assign adr_reg_qb = (op == LINK) ? areg_tmp :
		       (ar_nr_b == 7 & sbit) ? ssp : // Supervisor stack pointer.
                       (ar_nr_b == 7 & ~sbit) ? usp : // User stack pointer.
                       ar[ar_nr_b];
   
   
   // This register holds a temporary copy of the desired address register
   // for the MOVE and the MOVEM operation. For MOVEM there are two special
   // cases: Case A: if the addressing register in the predecrement mode is
   // written to memory, the initial value (not decremented) is written out.
   // Case B: If the addressing register in the non postincrement addressing
   // mode is loaded from memory, the AREG_TMP holds the old addressing
   // register value until the end of the MOVEM. For the MOVE operation in the
   // predecrement destination mode the value not destination decremented 
   // (if necessary source decremented) is written out. During PEA, this register
   // holds the effective address. This is important for the case PEA(A7) where
   // A7 changes during stacking the effective address.

   always @ (posedge clk or negedge resetn) 
     if (~resetn)
       areg_tmp <= 32'h00000000;
     else 
       if ((op == LINK | op == MOVEM) & op_start) 
         case (ar_nr_b)
           7 : if (sbit)
             areg_tmp <= ssp;
           else 
             areg_tmp <= usp;

           default : 
             areg_tmp <= ar[ar_nr_b];
         endcase
       else if (op == MOVE & op_start)
         case (ar_nr_a)
           7 : if (sbit)
             areg_tmp <= ssp;
           else 
             areg_tmp <= usp;
           
           default : 
             areg_tmp <= ar[ar_nr_a];
         endcase
       else if (op == PEA & op_start)
         areg_tmp <= adr_eff_i;
   
   integer i;
   
   // The MOVEA and MOVEM require a sign extended source data
   // which is provided by this logic. The BYTE size is not
   // allowed for these operations and not taken into account.
   always @ (op or op_size or adata_in or adr_eff_i)
     if ((op == MOVEA | op == MOVEM) & op_size == WORD)
       data_signed = { {16{adata_in[15]}}, adata_in[15:0] };
     else if (op == JMP | op == JSR | op == LEA) 
       data_signed = adr_eff_i;
     else 
       data_signed = adata_in;

   assign i_d_a = (exword0[15] & src_destn) ? 1'b1 :
                  (dest_exword0[15] & src_destn == 1'b0) ? 1'b1 :
                  1'b0;
   
   assign i_w_l = (exword0[11] & src_destn) ? 1'b1 :
                  (dest_exword0[11] & src_destn == 1'b0) ? 1'b1 :
                  1'b0;
   
   // The SCALE is not implemented in the original 68000. Nevertheless, the SCALE
   // is foreseen in this core because the OPCODE compatibility is given.
   assign i_scale = src_destn ? exword0[10:9] : dest_exword0[10:9];
   
   // The absolute address is valid for the absolute address modes 'WORD' and 'LONG'.
   // The sign extension is provided in the address mode process.
   assign abs_address= (adr_mode_i == 3'b111 & regsel_b == 3'b000 & src_destn) ? {16'h0000,exword0} :
                       (adr_mode_i == 3'b111 & regsel_b == 3'b000 & ~src_destn) ? {16'h0000,dest_exword0} :
                       (src_destn) ? {exword0,exword1} :
                       {dest_exword0,dest_exword1};
   
   // This process selects the INDEX from one of the data registers or from one of 
   // the address registers. Furthermore the index needs to be sign extended from 
   // 8 bit to 32 bit or from 16 bit to 32 bit dependent on the address mode.
   // In case of a long word operation, no extension is required. The index is 
   // multiplied by 1, 2, 4 or 8. The ADR_EFF is the scaled index for the address
   // calculation. During the MOVEM operation, the INDEX needs to be registered
   // since the respective address or data register is a matter of change.

   wire [31:0] ar_sel = ar[ar_nr_i];
			   
   always @ (posedge clk or negedge resetn)
     if (~resetn)
       index_tmp <= 0;
     else 
       if (op == MOVEM & op_start & i_d_a)
         index_tmp <= ar_sel;
       else if (op == MOVEM & op_start) 
         index_tmp <= index_d_in;

   always @ (ar_nr_i or i_d_a or i_w_l or
	     ar[0] or ar[1] or ar[2] or ar[3] or ar[4] or ar[5] or ar[6] or
	     op or index_d_in or i_scale or index_tmp or ar_sel)
     begin 
        iwl_ida = {i_w_l,i_d_a};

        case (op)
          MOVEM : 
            case (i_w_l)
              1'b0 : // Sign extended word.
                begin 
                   for (i=31;i>=16;i=i-1)
                     index_ext[i] = index_tmp[15];

                   index_ext[15:0] = index_tmp[15:0];
                end
              1'b1 : // Long word.
                index_ext = index_tmp;
            endcase

          default : 
            case (iwl_ida)
              2'b01 : 
                begin 
		   index_ext[31:16] = {16{ar_sel[15]}};
		   index_ext[15:0] = ar_sel[15:0];
                end
              2'b00 : 
                begin 
                   for (i=31;i>=16;i=i-1)
                     index_ext[i] = index_d_in[15];

                   index_ext[15:0] = index_d_in[15:0];
                end
              2'b11 : 
                index_ext = ar[ar_nr_i];
              2'b10 : 
                index_ext = index_d_in;
            endcase
        endcase

        case (i_scale)
          2'b00 : 
            index_scaled = index_ext; // Multiple by 1.
          2'b01 : 
            index_scaled = {index_ext[31:1],1'b0}; // Multiple by 2.
          2'b10 : 
            index_scaled = {index_ext[31:2],2'b00}; // Multiple by 4.
          2'b11 : 
            index_scaled = {index_ext[31:3],3'b000}; // Multiple by 8.
        endcase
     end 
   
   // Displacement multiplexer:
   assign displace = (sel_displace_biw) ? displace_biw :
                     (ext_dsize == WORD & src_destn) ? {16'h0000,exword0} :
                     (ext_dsize == BYTE & src_destn) ? {24'h000000,exword0[7:0]} :
                     (ext_dsize == WORD) ? {16'h0000,dest_exword0} :
                     {24'h000000,dest_exword0[7:0]};
   
   // The displacement needs to be sign extended from 8 bit to 32, from 16 bit to 32 bit or 
   // not extended dependent on the address mode.
   always @ (displace or ext_dsize) 
     case (ext_dsize)
       BYTE : // 8 bit wide displacement.
         displ_ext = { {24{displace[7]}}, displace[7:0] };
       WORD :  // 16 bit wide displacement.
	 displ_ext = { {16{displace[15]}}, displace[15:0] };
       LONG : 
         displ_ext = displace;
       default:
`ifdef SIMULATION
         displ_ext = 32'bx;
`else
         displ_ext = 32'b0;
`endif
     endcase

   // This process provides a temporary address offset during
   // bus access over several bytes. The 6 bits are used for 
   // the MOVEM command in the non postincrement/predecrement mode.
   // Other commands requires a maximum of
   // 3 bits.
   always @ (posedge clk or negedge resetn) 
     if (~resetn)
       adr_tmp <= 6'b000000;
     else 
       if (adr_tmp_clr) 
         adr_tmp <= 6'd0;
       else if (adr_tmp_inc & op_size == BYTE) 
         adr_tmp <= adr_tmp + 6'd1;
       else if (adr_tmp_inc)
         adr_tmp <= adr_tmp + 6'd2;
   
   // This process provides a temporary program counter offset
   // during the 'fetch phase'.
   always @ (posedge clk or negedge resetn) 
     begin 
        if (~resetn)
          pc_tmpvar <= 4'h0;
        else 
          if (pc_inc | pc_tmp_clr)
            pc_tmpvar <= 4'd0;
          else if (pc_tmp_inc)
            pc_tmpvar <= pc_tmpvar + 4'd1;
     end 

   assign pc_tmp = {pc_tmpvar/*[2:0]*/,1'b0}; // Increment always by two.
   
   // This offset points to the location of the extension word in
   // case of PC relative addressing modes.
   assign pc_offset = (force_biw3 & force_biw2) ? 4'h6 :
                      (force_biw2) ? 4'h4 :
                      4'h2;
   
   // The effective address calculation takes place in this process depending on the 
   // chosen addressing mode.
   always @ (adr_mode_i or regsel_b or
	     ar[0] or ar[1] or ar[2] or ar[3] or ar[4] or ar[5] or ar[6] or
	     ar_nr_b or sbit or usp or ssp or
	     displ_ext or areg_tmp or adr_tmp or op or index_scaled or abs_address or
	     pc or pc_offset or adr_eff_i or dr)
     begin 
        if (op == MOVEM & (adr_mode_i == 3'b010 | adr_mode_i == 3'b101 | adr_mode_i == 3'b110) & dr)
          areg = areg_tmp; // See P_AREG_TMP, case B.
        else 
          case (ar_nr_b)
            7 :     if (sbit)
              areg = ssp;
            else 
              areg = usp;
            
            default : 
              areg = ar[ar_nr_b];
          endcase
        
        case (adr_mode_i)
	  // when "000" | "001" => Direct address modes: no effective address required.
          3'b010,3'b011,3'b100 : 
	    // x"2": Address register indirect mode. Assembler syntax: (An).
	    // x"3": Address register indirect with postincrement mode. Assembler syntax: (An)+.
	    // x"4": Address register indirect with predecrement mode. Assembler syntax: -(An).
	    // x"2": The ADR_EFF is the pointer to the operand.
	    // x"3": The ADR_EFF is the pointer to the operand.
	    // x"4": The ADR_EFF is the pointer to the operand.
            adr_eff_tmp = areg;
          3'b101 :  // Address register indirect with offset. Assembler syntax: (d16,An).
            adr_eff_tmp = areg + displ_ext;
          3'b110 : 
	    // The ADR_EFF is the pointer to the operand.
	    // Assembler syntax: (d8,An,Xn.SIZE*SCALE).
            adr_eff_tmp = (areg + displ_ext) + index_scaled;
          3'b111 : 
            case (regsel_b)
              3'b000 :  // Absolute short addressing mode.
		// Assembler syntax: (xxx).W
		// The ADR_EFF is the pointer to the operand.
                begin 
//                   for (i=31;i>=16;i=i-1)
//                     adr_eff_tmp[i] = abs_address[15]; // Sign extension.
//                   
//                   adr_eff_tmp[15:0] = abs_address[15:0];
                   adr_eff_tmp = { {16{abs_address[15]}}, abs_address[15:0] };
                end
              3'b001 : // Absolute long addressing mode.
		// Assembler syntax: (xxx).L
		// The ADR_EFF is the pointer to the operand.
                adr_eff_tmp = abs_address;
              3'b010 : // Program counter relative with offset.
		// Assembler syntax: (d16,PC).
		// The effective address during PC relative addressing
		// contains the PC offset plus two.
                adr_eff_tmp = (pc + {28'b0, pc_offset}) + displ_ext;
              3'b011 : // Program counter relative with index and offset.
		// Assembler syntax: (d8,PC,Xn.SIZE*SCALE).
		// The effective address during PC relative addressing
		// contains the PC offset plus two.
                adr_eff_tmp = ((pc + {28'b0, pc_offset}) + displ_ext) + index_scaled;
              default : 
`ifdef SIMULATION
                adr_eff_tmp = 32'bx; // Don't care, not used dummy.
`else
                adr_eff_tmp = 32'b0;
`endif
            endcase
          default : 
`ifdef SIMULATION
            adr_eff_tmp = 32'bx;
`else
            adr_eff_tmp = 32'b0; // Result not required.
`endif
        endcase
        adr_eff_i = adr_eff_tmp;
	// Copy of the effective address plus offsets:
        adr_eff = adr_eff_i + {26'b0, adr_tmp};
     end 

   
   // This process provides data transfer to the respective registers (write).
   // Affected are the address registers (AR), the supervisor stack pointer (SSP), 
   // the user stack pointer (USP) and the program counter (PC).
   // Pay attention to the hierachy. The AR_WR must be higher prioritized than the
   // increments and decrements. This is important to the MOVE (Ax)+, Ax operation
   // where AR_WR and AR_INC respective AR_DEC are both active in the end of the 
   // operation. In this case the address register must be written with the source
   // value but may not be incremented or decremented. 
   always @ (posedge clk or negedge resetn)
     begin 
	if (~resetn)
          begin 
             for (i=0;i<=6;i=i+1)
               ar[i] <= 32'b0;
             
             usp <= 32'b0;
             ssp <= 32'b0;
             pc <= 32'b0;
          end
	else 
          begin 
	     // Predecrement and postincrement:
             if (ar_inc & ar_nr_b < 7)
               ar[ar_nr_b] <= ar[ar_nr_b] + { 29'b0, ar_step };
             
             else if (ar_inc & sbit)
               ssp <= ssp + { 29'b0, ar_step };
             
             else if (ar_inc)
               usp <= usp + {29'b0, ar_step };
             
             else if (ar_dec & ar_nr_b < 7)
               ar[ar_nr_b] <= ar[ar_nr_b] - {29'b0, ar_step};
             
             else if (ar_dec & sbit)
               ssp <= ssp - {29'b0, ar_step};

             else if (ar_dec) 
               usp <= usp - {29'b0, ar_step};
             
	     // Write operations are always long:
             if (ar_wr)
               begin 
                  if (ar_nr_a < 7)
                    ar[ar_nr_a] <= data_signed; // Load AREG.
                  else if (sbit) 
                    ssp <= data_signed; // Load SSP.
                  else 
                    usp <= data_signed; // Load USP.
               end 
             
	     // Increment / decrement and initialise the stack:
             if (usp_inc) 
               usp <= usp + 32'd2; // Increment 2 bytes.
             
             else if (usp_dec) 
               usp <= usp - 32'd2; // Decrement 2 bytes.
             
             else if (ssp_init) 
               ssp <= adata_in;
             
             else if (ssp_inc) // Increment 2 bytes.
               ssp <= ssp + 32'd2;
             
             else if (ssp_dec) // Decrement 2 bytes.
               ssp <= ssp - 32'd2;
             
             // Displacement operations.
             if (sp_add_displ & ar_wr & ar_nr_a == 7 & sbit)
               ssp <= data_signed + displ_ext; // Special case: LINK A7,displacement.
             
             else if (sp_add_displ & ar_wr & ar_nr_a == 7)
               usp <= data_signed + displ_ext; // Special case: LINK A7,displacement.
             
             else if (sp_add_displ & sbit)
               ssp <= ssp + displ_ext; // Used for LINK.
             
             else if (sp_add_displ)
               usp <= usp + displ_ext; // Used for LINK.
             
	     // Exchange the content of address registers:
             if (ar_exg & op_mode == 5'b01001)  // Exchange two address registers.
               begin 
                  ar[ar_nr_b] <= ar[ar_nr_a]; // Internal wired because there is no second data input.
                  ar[ar_nr_a] <= adata_in;
               end
             
             else if (ar_exg & op_mode == 5'b10001)  // Exchange a data and an address register.
               ar[ar_nr_b] <= adata_in;
             
	     // Address Register copies:
             if (usp_cpy & dr == 1'b0) // Copy the address register to user stack pointer.
               begin 
                  if (ar_nr_b < 7)
                    usp <= ar[ar_nr_b];
                  else if (sbit)
                    usp <= ssp;
               end 
             else if (usp_cpy) // Copy the user stack pointer to the address register.
               begin 
                  if (ar_nr_b < 7)
                    ar[ar_nr_b] <= usp;
                  else if (sbit)
                    ssp <= usp;
               end 
             
	     // Program counter arithmetics:
             if (pc_wr)  // JMP, JSR.
               pc <= data_signed;
             
             else if (pc_init)
               pc <= adata_in;
             
	     // The PC_ADD_DISPL and the PC_INC are asserted simultaneously when the
	     // operation is used for Bcc and BRA. Therefore the prioritization of
	     // PC_ADD_DISPL over PC_INC is important.
	     // When PC_INC is active, the program counter is increased by the 
	     // value of PC_TMP plus two when the following execution state after 
	     // a fetch phase is FETCH_BIW_1.
             else if (pc_add_displ) // Used for Bcc, BRA, BSR, DBcc.
               pc <= (pc + displ_ext) + 32'd2;
             
             else if (pc_inc)
               pc <= (pc + {27'b0, pc_tmp}) + 32'd2;
          end
     end
   
`ifdef debug
   always @ (posedge clk)
     if (resetn)
       begin
//	  if (pc_init)
//	    $display("PC <- %x (init)", adata_in);
	  if (ssp_init && 0)
	    $display("SSP <- %x (init)", adata_in);

          if (ar_wr && ar_nr_a == 7 && 0)
	    if (sbit)
	      $display("SSP <- %x %x", data_signed, adata_in);
	    else
	      $display("USP <- %x", data_signed);
       end

   always @ (posedge clk)
     if (trap_aerr)
       begin
	  $display("address-error: pc%b ssp%b ssp%b usp%b %b l%b w%b",
		   (chk_pc & pc[0]),
		   (chk_adr & use_ssp_adr & ssp[0]),
                   (chk_adr & use_sp_adr & sbit & ssp[0]),
                   (chk_adr & use_sp_adr & usp[0]),
                   (chk_adr & (use_ssp_adr | use_sp_adr)),
                   (chk_adr & op != MOVEP & op_size == LONG & adr_eff_i[0]),
                   (chk_adr & op != MOVEP & op_size == WORD & adr_eff_i[0]));
	  $display("address-error: adr_eff_i %x", adr_eff_i);
	  $display("address-error: ssp %x, usp %x", ssp, usp);

	  $display("adr_mode_i %b, areg %x, displ_ext %x, index_scaled %x",
		   adr_mode_i, areg, displ_ext, index_scaled);
	  $display("adr_eff_tmp %x", adr_eff_tmp);
	  $display("ext_dsize %d, displace %x, displ_ext %x", ext_dsize, displace, displ_ext);
	  $display("sel_displace_biw %b, displace_biw %x, exword0 %x, dest_exword0 %x",
		   sel_displace_biw, displace_biw, exword0, dest_exword0);
	  $display("exword0 %x, exword1 %x",
		   dest_exword0, dest_exword1);
	  $display("dest_exword0 %x, dest_exword1 %x",
		   dest_exword0, dest_exword1);
       end
`endif //  `ifdef debug

`ifdef SIMULATION_XXX
   //xxxx
   always @(posedge clk)
     if (pc_out >= 32'h2aa2 && pc <= 32'h2aa6)
       begin
	  $display("XXX: %t; pc %x, ar_nr_b %x, adr_mode_i %b, areg %x, adr_eff_tmp %x, adr_eff_i %x, adr_eff %x, trap_aerr %b exec_state=%x, biw %x %x %x",
		   $time, pc_out, ar_nr_b, adr_mode_i, areg, adr_eff_tmp, adr_eff_i, adr_eff, trap_aerr,
		   uut.ff.cpu.wf68k00ip_top.i_68k00.i_ctrl.exec_state,
    		   uut.ff.cpu.wf68k00ip_top.i_68k00.i_opcode.biw[0],
		   uut.ff.cpu.wf68k00ip_top.i_68k00.i_opcode.biw[1],
	           uut.ff.cpu.wf68k00ip_top.i_68k00.i_opcode.biw[2]);
       end
   //xxxx
`endif
   
`ifdef CHIPSCOPE_M68K
   assign ar_all = { ar[0], ar[1], ar[2], ar[3], ar[4], ar[5], ar[6], ssp };
`endif
   
endmodule
