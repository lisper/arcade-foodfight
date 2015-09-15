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
//-- The following operations are additionally supported by this  ----
//-- core:                                                        ----
//--   - CHK (long).                                              ----
//--   - LINK (long).                                             ----
//--   - MOVE FROM CCR.                                           ----
//--   - MULS, MULU: all operation modes word and long.           ----
//--   - DIVS, DIVU: all operation modes word and long.           ----
//--   - DIVSL, DIVUL.                                            ----
//--   - Direct addressing mode enhancements for TST etc.         ----
//--   - PC relative addressing modes for operations like TST.    ----
//--                                                              ----
//-- This file is the top level file of the ip core.              ----
//-- It is intended for use in systems on programmable chips.     ----
//--                                                              ----
//--                                                              ----
//--                                                              ----
//--                                                              ----
//-- Author(s):                                                   ----
//-- - Wolfgang Foerster, wf@experiment-s.de; wf@inventronik.de   ----
//--                                                              ----
//--------------------------------------------------------------------
//--                                                              ----
//-- Copyright (C) 2006 - 2013 Wolfgang Foerster                  ----
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
//   Top level file provided for SOC (systems on programmable chips).
// Revision 2K7B  2007/12/24 WF
//   Several bugfixes in the modules.
//   Optimized the core (reduced the core size 10%).
// Revision 2K8A  2008/07/14 WF
//   Modified the interrupt controller behaviour.
//   A couple of bug fixes in all modules.
//   Deactivated the MOVE_FROM_CCR in the opcode decoder due to
//     compatibility reasons.
//   Some optimizations concerning core size.
// Revision 2K8B  2008/12/24 WF
//   Changed the GET_VECTOR state. The vector is now fetched after the stacking.
//   Changes regarding the read modify write logic of the TAS operation.
//   Fixed a bug in the DATA_EN to provide correct bus arbitration.
//   Further items fixed in collaboration with T. Gubener:
//     PEA (A7): Bugfix.
//     CHK.W: Bugfix.
//     ALU: overflow flag on word and byte wide operations works now correct.
//     ALU: sign flag on word and byte wide operations works now correct.
//     ALU: zero flag on word and byte wide operations works now correct.
//     MOVEM (A0)+, D0: bugfix.
//     LINK A7: bugfix.
//     JSR: removed senseless bus read cycle.
//     Tri-State-Toplevel: provided for top_soc.
//     DIVS, DIVU: data registers will not be overwritten in case of an overflow.
//     DIVS.W, DIVU.W: rectified overflow detection.
//     DIVS.L, DIVU.L: rectified overflow detection.
//     MOVEM (d8,ax,index): bugfix.
//     Pending IPLn is now stored for processing.
//     TAS: correction for function code enable and address enable.
//     MOVE (Ax)+, Ax: bugfix.
// Revision 2K10A  2010/06/20 WF
//   Several minor changes to meet better design tool compatibility.
//   Several minor changes to meet better design tool compatibility.
// Revision 2K11A  2011/06/20 WF
//   Removed EXEC_ABORT from the entity of the bus error unit.
//   Cleaned up the condition code logic in the shifter unit.
//   Removed the signal SHFT_BREAK from logic and entity in the shifter unit.
// Revision 2K11B 20111226 WF
//   Updates and fixes in the bus controller section.
// Revision 2K13A 20130620 WF
//   Minor change for the BERR_I signal.
// Revision 2K13B 20131224 WF
//   Interrupt controller: Changed the sequence for sampling the interrupt vector. 
//     It is now sampled before stacking.
//


module  wf68k00ip_top_soc ( clk, reset_coren, adr_out, adr_en, data_in, data_out, data_en,
			    berrn, reset_inn, reset_out_en, halt_inn, halt_out_en, fc_out, fc_out_en, 
			    avecn, ipln, dtackn, as_outn, as_out_en, rwn_out, rw_out_en,
			    uds_outn, uds_out_en, lds_outn, lds_out_en,
			    e, vma_outn, vma_out_en, vpan, brn, bgn, bgackn );

   input        clk;
   input       	reset_coren;

   // Address and data:
   output [23:1] adr_out;
   output        adr_en;
   input [15:0]  data_in;
   output [15:0] data_out;
   output        data_en;

   // System control:
   input       	 berrn;
   input       	 reset_inn;
   output        reset_out_en;
   input 	 halt_inn;
   output        halt_out_en;

   // Processor status:
   output [2:0]  fc_out;
   output        fc_out_en;

   // Interrupt control:
   input       	 avecn;
   input [2:0] 	 ipln;

   // Aynchronous bus control:
   input       	 dtackn;
   output        as_outn;
   output        as_out_en;
   output        rwn_out;
   output        rw_out_en;
   output        uds_outn;
   output        uds_out_en;
   output        lds_outn;
   output        lds_out_en;

   // Synchronous peripheral control:
   output        e;
   output        vma_outn;
   output        vma_out_en;
   input       	 vpan;

   // Bus arbitration control:
   input       	 brn;
   output        bgn;
   input       	 bgackn;

`include "wf68k00ip_parms.h"

   wire [31:0] 	 adr_eff_i;
   wire       	 adr_en_i;
   wire       	 adr_en_vector_i;
   wire [31:0] 	 adr_i;
   wire [2:0] 	 adr_mode_i;
   wire       	 adr_tmp_clr_i;
   wire       	 adr_tmp_inc_i;
   wire [31:0] 	 alu_op_in_s;
   wire [31:0] 	 alu_op_in_d_hi;
   wire [31:0] 	 alu_op_in_d_lo;
   wire       	 ar_inc_i;
   wire       	 ar_dec_i;
   wire       	 ar_wr_i;
   wire       	 ar_dr_exg_i;
   wire [31:0] 	 areg_data_in;
   wire       	 as_en_i;
   wire       	 as_in;
   reg 		 avec_in =0;
   reg       	 berr_in =0; 
   wire       	 berr_i;
   reg       	 bgack_in =0; 
   wire [4:0] 	 bit_pos_i;
   wire [4:0] 	 bit_pos_op;
   wire       	 bitpos_im_i;
   wire [15:0] 	 biw_0_i;
   reg       	 br_in =0; 
   wire [31:0] 	 bus_buffer_a;
   wire [31:0] 	 bus_buffer_b;
   wire       	 bus_cyc_rdy_i;
   wire       	 byten_word_i;
   wire [3:0] 	 c_code_i;
   wire       	 chk_adr_i;
   wire       	 chk_pc_i;
   wire [5:0] 	 cnt_nr_i;
   wire       	 ctrl_en_i;
   wire       	 ctrl_rdy_i;
   wire [15:0] 	 data_core;
   wire [31:0] 	 data_immediate_i;
   wire [31:0] 	 data_out_i;
   wire       	 data_valid_i;
   wire       	 dbcc_cond_i;
   wire [15:0] 	 dest_exword0_i;
   wire [15:0] 	 dest_exword1_i;
   wire [1:0] 	 dest_ext_cnt_i;
   wire [31:0] 	 displace_biw_i;
   wire       	 div_mul_32n64_i;
   wire       	 dr_i;
   wire       	 dr_dec_i;
   wire       	 dr_wr_i;
   wire [31:0] 	 dreg_data_in_a;
   wire [31:0] 	 dreg_data_in_b;
   wire       	 dtack_in;
   wire       	 ew_wr_i;
   wire 	 ew_adr_i;
   wire       	 exec_abort_i;
   wire       	 exec_resume_i;
   wire [1:0] 	 ext_cnt_i;
   wire [1:0] 	 ext_dsize_i;
   wire [15:0] 	 exword0_i;
   wire [15:0] 	 exword1_i;
   wire       	 fc_en_ctrl;
   wire       	 fc_en_i;
   wire       	 fc_en_irq;
   wire [2:0] 	 fc_out_ctrl;
   wire [2:0] 	 fc_out_i;
   wire [2:0] 	 fc_out_irq;
   wire       	 force_biw2_i;
   wire       	 force_biw3_i;
   reg 		 halt_in;
   wire       	 hi_byte_en_i;
   wire       	 hi_word_en_i;
   wire [9:0] 	 int_vect_i;
   wire       	 init_status_i;
   reg 	[2:0]    ipl_in = 0;
   reg  [2:0] 	 ipl_tmpn = 0;
   wire       	 ir_i;
   wire       	 irq_data_en;
   wire [15:0] 	 irq_dout;
   wire [2:0] 	 irq_exhdl;
   wire       	 irq_save_i;
   wire [1:0]	 iw_adr_i;
   wire       	 iw_wr_i;
   wire       	 lds_en_i;
   wire       	 lds_in;
   wire       	 lo_byte_en_i;
   wire [2:0] 	 move_d_am_i;
   wire       	 mem_shft_i;
   wire       	 movem_adn_i;
   wire [2:0] 	 movem_regsel_i;
   wire       	 pc_add_displ_i;
   wire       	 op_busy_i;
   wire [6:0] 	 op_i;
   wire [4:0] 	 op_mode_i;
   wire [1:0] 	 op_size_i;
   wire       	 op_start_i;
   wire       	 pc_inc_i;
   wire       	 pc_init_i;
   wire       	 pc_init_ctrl;
   wire       	 pc_init_irq;
   wire [31:0] 	 pc_out;
   wire       	 pc_tmp_clr_i;
   wire       	 pc_tmp_inc_i;
   wire       	 pc_wr_i;
   wire       	 preset_irq_mask_i;
   wire [31:0] 	 q_areg_a;
   wire [31:0] 	 q_areg_b;
   wire [31:0] 	 q_dreg_a;
   wire [31:0] 	 q_dreg_b;
   wire [31:0] 	 q_dreg_c;
   wire       	 rd_bus_ctrl;
   wire       	 rd_bus_irq;
   wire       	 rd_bus_i;
   wire [15:0] 	 reglistmask_i;
   wire [2:0] 	 regsel_119_i;
   wire [2:0] 	 regsel_20_i;
   wire [2:0] 	 regsel_adr_a;
   wire [2:0] 	 regsel_adr_b;
   wire [2:0] 	 regsel_data_a;
   wire [2:0] 	 regsel_data_b;
   wire [2:0] 	 regsel_data_c;
   wire [2:0] 	 regsel_dhr;
   wire [2:0] 	 regsel_dlq;
   wire [2:0] 	 regsel_index;
   wire       	 reset_cpu_in;
   wire       	 reset_en_i;
   reg       	 reset_in_in =0; 
   wire       	 reset_rdy_i;
   wire [31:0] 	 result_alu_hi;
   wire [31:0] 	 result_alu_lo;
   wire [31:0] 	 result_shft;
   wire       	 rm_i;
   wire       	 rw_en_i;
   wire       	 rwn_i;
   wire       	 sbit_i;
   wire       	 scan_traps_i;
   wire       	 scc_cond_i;
   wire       	 sel_a_lo;
   wire       	 sel_a_hi;
   wire       	 sel_a_midhi;
   wire       	 sel_a_midlo;
   wire       	 sel_buf_a_lo_i;
   wire       	 sel_buf_a_hi_i;
   wire       	 sel_buf_a_lo_ctrl_i;
   wire       	 sel_buf_a_hi_ctrl_i;
   wire       	 sel_buf_a_lo_irq_i;
   wire       	 sel_buf_a_hi_irq_i;
   wire       	 sel_buf_b_lo_i;
   wire       	 sel_buf_b_hi_i;
   wire       	 sel_displace_biw_i;
   wire       	 shft_busy_i;
   wire [31:0] 	 shft_op_in;
   wire       	 shifter_load_i;
   wire       	 sp_add_displ_i;
   wire [15:0] 	 sr_ccr_mux;
   wire       	 src_destn_i;
   wire       	 ssp_dec_ctrl;
   wire       	 ssp_dec_i;
   wire       	 ssp_dec_irq;
   wire       	 ssp_inc_i;
   wire       	 ssp_init_i;
   wire [31:0] 	 ssp_out;
   wire [15:0] 	 status_reg_i;
   wire       	 sys_init_i;
   wire       	 tas_lock_i;
   wire       	 trap_1010_i;
   wire       	 trap_1111_i;
   wire       	 trap_aerr_i;
   wire       	 trap_chk_i;
   wire       	 trap_chk_en_i;
   wire       	 trap_divzero_i;
   wire       	 trap_illegal_i;
   wire       	 trap_op_i;
   wire       	 trap_priv_i;
   wire       	 trap_trace_i;
   wire       	 trap_v_i;
   wire [3:0] 	 trap_vector_i;
   wire       	 uds_en_i;
   wire       	 uds_in;
   wire       	 unlk_sp_an_i;
   wire       	 usp_cpy_i;
   wire       	 usp_dec_i;
   wire       	 usp_inc_i;
   wire       	 use_int_vect_i;
   wire [31:0] 	 usp_out;
   wire       	 use_sp_adr_i;
   wire       	 use_ssp_adr_i;
   wire       	 vma_en_i;
   wire       	 vma_in;
   reg       	 vpa_in =0; 
   wire       	 wr_bus_ctrl;
   wire       	 wr_bus_i;
   wire       	 wr_bus_irq;
   wire       	 wr_hi_i;
   wire [4:0] 	 xnzvc_alu;
   wire [4:0] 	 xnzvc_i;
   wire [4:0] 	 xnzvc_shft;
   wire [23:1] 	 adr_out;
   wire       	 adr_en;
   wire [15:0] 	 data_out;
   wire       	 data_en;
   wire       	 reset_out_en;
   wire       	 halt_out_en;
   wire [2:0] 	 fc_out;
   wire       	 fc_out_en;
   wire       	 as_outn;
   wire       	 as_out_en;
   wire       	 rwn_out;
   wire       	 rw_out_en;
   wire       	 uds_outn;
   wire       	 uds_out_en;
   wire       	 lds_outn;
   wire       	 lds_out_en;
   wire       	 e;
   wire       	 vma_outn;
   wire       	 vma_out_en;
   wire       	 bgn;

   // The bus control signals used in this core are sampled on the negative clock
   // edge. Thus the signals are valid on the following positive clock edge. In the original
   // 68K machines, the input synchronisation is realized with three latches (see the 68K
   // user manual for more information). This concept is not suitable for a FPGA design 
   // and therefore not used here.
   always @(negedge clk)
     begin 
        berr_in <= berrn;
        halt_in <= halt_inn;
        vpa_in <= vpan;
        br_in <= brn;
        bgack_in <= bgackn;
        reset_in_in <= reset_inn;
        avec_in <= avecn;
     end
   
   // This process provides a filter for the interrupt priority level. It
   // is valid, if it is stable for two consecutive falling clock edges.
   always @(negedge clk)
     if (~reset_coren)
       begin
	  ipl_tmpn <= 0;
	  ipl_in <= 0;
       end
     else
       begin 
          ipl_tmpn <= ipln;
          if (ipl_tmpn == ipln)
            ipl_in <= ipln;
          else 
            ipl_in <= 3'b111;
       end
   
   assign berr_i = (~berr_in) ? 1'b1 :
                   (~berr_in & ~halt_in & rd_bus_i & op_i == TAS) ? 1'b1 : // No retry during read modify write cycles.
                   (~berr_in & ~halt_in & wr_bus_i & op_i == TAS) ? 1'b1 :
                   1'b0;
   
   // The following input may not be sampled
   // due to bus timing constraints.
   assign dtack_in = dtackn;
   
   // Data output multiplexer (tri-state):
   // During long word access, the higher word is written always 16 bit wide. During word or byte access,
   // the access of the higher 8 bits or the lower 8 bits depends on the address boundary or on the
   //- length of the operator defined in the operation (WORD, BYTE).
   assign data_en = (hi_byte_en_i | lo_byte_en_i) | hi_word_en_i;

   assign data_out = irq_data_en                   ? irq_dout :
                     (sel_a_hi & hi_byte_en_i)     ? {data_out_i[31:24], 8'b00000000} : // MOVEP.
                     (sel_a_hi & lo_byte_en_i)     ? {8'b00000000,       data_out_i[31:24]} : // MOVEP.
		     (sel_a_midhi & hi_byte_en_i)  ? {data_out_i[23:16], 8'b00000000} : // MOVEP.
		     (sel_a_midhi & lo_byte_en_i)  ? {8'b00000000,       data_out_i[23:16]} : // MOVEP. // MOVEP.
                     (sel_a_midlo & hi_byte_en_i)  ? {data_out_i[15:8],  8'b00000000} : // MOVEP.
                     (sel_a_midlo & lo_byte_en_i)  ? {8'b00000000,       data_out_i[15:8]} :
                     (sel_a_lo & hi_byte_en_i)     ? {data_out_i[7:0],   8'b00000000} : // MOVEP.
                     (sel_a_lo & lo_byte_en_i)     ? {8'b00000000,       data_out_i[7:0]} : // MOVEP.
                     (hi_word_en_i)                ? data_out_i[31:16] :
                     (hi_byte_en_i & lo_byte_en_i) ? data_out_i[15:0] :
                     (hi_byte_en_i)                ? {data_out_i[7:0],   8'b00000000} :
                     (lo_byte_en_i)                ? {8'b00000000,       data_out_i[7:0]} :
		     16'b0;

   // Bus controls:   
   assign as_outn = as_in;
   assign as_out_en = as_en_i;
   assign rwn_out = rwn_i;
   assign rw_out_en = rw_en_i;
   assign uds_outn = uds_in;
   assign uds_out_en = uds_en_i;
   assign lds_outn = lds_in;
   assign lds_out_en = lds_en_i;
   
   assign vma_outn = vma_in;
   assign vma_out_en = vma_en_i;

   // The function code:
   assign fc_out_en = fc_en_i;
   assign fc_out = fc_out_i;
   assign fc_out_i = fc_en_ctrl ? fc_out_ctrl :
                     fc_en_irq  ? fc_out_irq :
                     3'b0;
   
   assign sys_init_i = (sel_buf_a_hi_irq_i | sel_buf_a_lo_irq_i) ? 1'b1 :  1'b0;
   
   // Bus access control:
   assign byten_word_i = (fc_out_i == 3'b110) ? 1'b1 : // Supervisor program.
                         (fc_out_i == 3'b010) ? 1'b1 : // User program.
                         (use_sp_adr_i) ? 1'b1 : // During stacking.
                         (use_ssp_adr_i) ? 1'b1 : // During stacking.
                         (use_int_vect_i) ? 1'b1 : // During interrupt handling.
                         (op_size_i == BYTE) ? 1'b0 :
                         (op_i == MOVEP) ? 1'b0 :
                         1'b1;

   // Bus buffer A control:
   assign sel_buf_a_hi_i = sel_buf_a_hi_ctrl_i | sel_buf_a_hi_irq_i;
   assign sel_buf_a_lo_i = sel_buf_a_lo_ctrl_i | sel_buf_a_lo_irq_i;
   
   // Some of the controls are asserted by the main control state machine or
   // by the interrupt control state machine but never by both at the same
   // time. So the related signal can be 'ored'; no malfuntion results.
   assign ssp_dec_i = ssp_dec_ctrl | ssp_dec_irq;
   assign rd_bus_i = rd_bus_ctrl | rd_bus_irq;
   assign wr_bus_i = wr_bus_ctrl | wr_bus_irq;
   assign pc_init_i = pc_init_ctrl | pc_init_irq;
   
   // Count value for the shifter unit. It is valid during the shift operations:
   assign cnt_nr_i = (mem_shft_i) ? 6'b000001 : // Memory shifts are 1 bit only.
                     (~ir_i & (regsel_119_i > 3'b000)) ? {3'b000,regsel_119_i} :
                     (~ir_i) ? 6'b001000 : // Shift 8 bits for REGSEL_119 = "000".
                     q_dreg_a[5:0]; // Register contents modulo 64.
   
   // Bit operation position multiplexer:
   // Register bit manipulations are modulo 32 whereas memory bit manipulations are modulo 8.
   assign bit_pos_i = ((bitpos_im_i == 1'b1) & (adr_mode_i == 3'b000)) ? bit_pos_op :
                      (adr_mode_i == 3'b000) ? q_dreg_a[4:0] :
                      (bitpos_im_i == 1'b1) ? {2'b00,bit_pos_op[2:0]} :
                      {2'b00,q_dreg_a[2:0]};
   
   // The condition codes:
   assign xnzvc_i = (op_i == BCHG | op_i == BCLR | op_i == BSET | op_i == BTST) ? xnzvc_shft : 
		    (op_i == ASL | op_i == ASR | op_i == LSL | op_i == LSR |
		     op_i == ROTL | op_i == ROTR | op_i == ROXL | op_i == ROXR) ? xnzvc_shft : 
		    xnzvc_alu;
   
   // Address select stuff:
   // The internal address space is 32 bit long. The 68K00 has 23 addresslines.
   // The internal address space is therefore limited to 24 bit.
   assign adr_out = adr_i[23:1];
   assign adr_en = adr_en_i;
   assign adr_i = (adr_en_vector_i) ? {{28'hFFFFFFF,status_reg_i[10:8]},1'b1} :
                  (use_ssp_adr_i) ? ssp_out :
                  (use_int_vect_i) ? { 22'b0,int_vect_i } :
                  ((use_sp_adr_i) & ( sbit_i)) ? ssp_out :
                  ((use_sp_adr_i) & (~sbit_i)) ? usp_out :
                  ((fc_out_ctrl == 3'b010) | (fc_out_ctrl == 3'b110)) ? pc_out :
                  adr_eff_i;
   
   // Status register multiplexer:
   // The default is valid for MOVE_TO_CCR from memory, MOVE_TO_SR from memory,
   // for the RTR and for stack restoring during exception handling.
   assign sr_ccr_mux = (op_i == ANDI_TO_SR | op_i == EORI_TO_SR | op_i == ORI_TO_SR) ? result_alu_lo[15:0] :
                       (op_i == ANDI_TO_CCR | op_i == EORI_TO_CCR | op_i == ORI_TO_CCR) ? result_alu_lo[15:0] :
                       ((op_i == MOVE_TO_CCR | op_i == MOVE_TO_SR) & (adr_mode_i == 3'b000)) ? q_dreg_b[15:0] :
                       (op_i == MOVE_TO_CCR & adr_mode_i == 3'b111 & regsel_20_i == 3'b100) ? data_immediate_i[15:0] :
                       (op_i == MOVE_TO_SR & adr_mode_i == 3'b111 & regsel_20_i == 3'b100) ? data_immediate_i[15:0] :
                       (op_i == STOP) ? data_immediate_i[15:0] :
                       data_core;
   
   // Note: the address register is never destination during MOVE.
   // Note: The default is also valid for UNLK during writing to the stack pointer.h
   assign regsel_adr_a = ((op_i == ADDQ | op_i == SUBQ) & (adr_mode_i == 3'b001)) ? regsel_20_i :
                         (op_i == LINK | op_i == MOVE) ? regsel_20_i :
                         (op_i == UNLK & (unlk_sp_an_i == 1'b0)) ? regsel_20_i :
                         (op_i == MOVEM) ? movem_regsel_i :
                         regsel_119_i;
   
   assign regsel_adr_b = (src_destn_i == 1'b0) ? regsel_119_i :  regsel_20_i;
   
   assign regsel_data_a = (((op_i == ABCD | op_i == ADDX) | op_i == SBCD) | op_i == SUBX) ? regsel_20_i :
                          (op_i == ADD | op_i == SUB) ? regsel_20_i :
                          (op_i == AND_B | op_i == OR_B) ? regsel_20_i :
                          ((op_i == MULS | op_i == MULU) & (op_size_i == LONG)) ? regsel_dlq :
                          ((op_i == DIVS | op_i == DIVU) & (op_size_i == LONG)) ? regsel_dlq :
                          regsel_119_i;
   
   assign regsel_data_b = (op_i == MOVEM) ? movem_regsel_i :
                          (((op_i == ABCD | op_i == ADDX) | op_i == SBCD) | op_i == SUBX) ? regsel_119_i :
                          (op_i == ADD | op_i == SUB) ? regsel_119_i :
                          (op_i == AND_B | op_i == OR_B) ? regsel_119_i :
                          ((op_i == DIVS | op_i == DIVU) & dr_wr_i) ? regsel_dhr :
                          ((op_i == MULS | op_i == MULU) & dr_wr_i) ? regsel_dhr :
                          (op_i == MOVEQ) ? regsel_119_i :
			  regsel_20_i;
   
   assign regsel_data_c = ((op_i == DIVS | op_i == DIVU) & op_start_i) ? regsel_dhr : regsel_index;
   
   assign data_out_i = (op_i == ABCD | op_i == SBCD) ? result_alu_lo :
                       ((op_i == ADDX | op_i == NEGX) | op_i == SUBX) ? result_alu_lo :
                       (op_i == ADD | op_i == SUB) ? result_alu_lo :
                       (op_i == ADDI | op_i == SUBI) ? result_alu_lo :
                       (op_i == ADDQ | op_i == SUBQ) ? result_alu_lo :
                       (op_i == AND_B | op_i == OR_B) ? result_alu_lo :
                       ((op_i == ANDI | op_i == EORI) | op_i == ORI) ? result_alu_lo:
                       (op_i == ASL | op_i == ASR) ? result_shft :
                       (op_i == LSL | op_i == LSR) ? result_shft :
                       (op_i == ROTL | op_i == ROTR) ? result_shft :
                       (op_i == ROXL | op_i == ROXR) ? result_shft :
                       ((op_i == BCHG | op_i == BSET) | op_i == BCLR) ? result_shft :
                       (op_i == CLR) ? 32'h00000000 :
                       (op_i == MOVE & (adr_mode_i == 3'b000)) ? q_dreg_b :
                       (op_i == MOVE & (adr_mode_i == 3'b001)) ? q_areg_a :
                       ((op_i == MOVE & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? data_immediate_i :
                       (op_i == MOVE) ? bus_buffer_a :
                       (op_i == MOVE_FROM_CCR) ? { 27'b0,status_reg_i[4:0] } :
                       (op_i == MOVE_FROM_SR) ? {16'h0000,status_reg_i} :
                       (op_i == MOVEM & (movem_adn_i == 1'b0)) ? q_dreg_b :
                       (op_i == MOVEM & (movem_adn_i == 1'b1)) ? q_areg_a :
                       (op_i == MOVEP) ? q_dreg_a :
                       ((op_i == NBCD | op_i == NEG) | op_i == NOT_B) ? result_alu_lo :
                       (op_i == PEA) ? q_areg_a :
                       (op_i == SCC & (scc_cond_i == 1'b1)) ? 32'hFFFFFFFF :
                       (op_i == SCC) ? 32'h00000000 :
                       (op_i == JSR | op_i == BSR) ? (pc_out + 32'd2) : // Push the following address to the stack.
                       (op_i == LINK) ? q_areg_b :
                       result_alu_lo; // The default is valid for the TAS operation.
   
   // Data register source: The required sign extensions for the operation
   // MOVEM and MOVEQ are computed in the data register unit.
   assign dreg_data_in_b = (op_i == ABCD | op_i == SBCD) ? result_alu_lo :
                           ((op_i == ADDX | op_i == NEGX) | op_i == SUBX) ? result_alu_lo :
                           (op_i == ADD | op_i == SUB) ? result_alu_lo :
                           (op_i == ADDI | op_i == SUBI) ? result_alu_lo :
                           (op_i == ADDQ | op_i == SUBQ) ? result_alu_lo :
                           (op_i == AND_B | op_i == OR_B) ? result_alu_lo :
                           ((op_i == ANDI | op_i == EORI) | op_i == ORI) ? result_alu_lo :
                           ((op_i == NBCD | op_i == NEG) | op_i == NOT_B) ? result_alu_lo :
                           (op_i == DIVS | op_i == DIVU) ? result_alu_hi :
                           (op_i == MULS | op_i == MULU) ? result_alu_hi :
                           (op_i == ASL | op_i == ASR) ? result_shft :
                           (op_i == LSL | op_i == LSR) ? result_shft :
                           (op_i == ROTL | op_i == ROTR) ? result_shft :
                           (op_i == ROXL | op_i == ROXR) ? result_shft :
                           ((op_i == BCHG | op_i == BSET) | op_i == BCLR) ? result_shft :
                           (op_i == EXG & (op_mode_i == 5'b01000)) ? q_dreg_b : // Exchange two data registers.
                           (op_i == MOVEM) ? bus_buffer_a :
                           (op_i == MOVEQ) ? data_immediate_i :
                           ((op_i == SCC) & (scc_cond_i == 1'b1)) ? 32'hFFFFFFFF :
                           (op_i == SCC) ? 32'h00000000 :
                           (op_i == CLR) ? 32'h00000000 :
                           (op_i == MOVE_FROM_CCR) ? {27'b0,status_reg_i[4:0]} :
                           (op_i == MOVE_FROM_SR) ? {16'h0000,status_reg_i} :
                           result_alu_lo; // Default used for EXT, SWAP, TAS.
   
   assign dreg_data_in_a = (op_i == MOVE & (adr_mode_i == 3'b000)) ? q_dreg_b : // Data to data register.
                           (op_i == MOVE & (adr_mode_i == 3'b001)) ? q_areg_b : // Address to data register.
                           (op_i == EXG & (op_mode_i == 5'b01000)) ? q_dreg_a : // Exchange two data registers.
                           (op_i == EXG) ? q_areg_b : // Exchange data and address registers.
                           ((op_i == MOVE & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? data_immediate_i :
                           (op_i == MOVE | op_i == MOVEP) ? bus_buffer_a :
                            result_alu_lo; // Default for DIVS, MULS and MULU. 
   
   // Address register source: The required sign extension for the operation
   // MOVEA and MOVEM are computed in the address register unit.
   // Note: this logic is priority sensitive!
   assign areg_data_in = (ctrl_rdy_i) ? bus_buffer_a :  // For interrupt handling (init PC, SSP).
                         (op_i == ADDA | op_i == SUBA) ? result_alu_lo :
                         (op_i == ADDQ | op_i == SUBQ) ? result_alu_lo :
                         (op_i == MOVEA & (adr_mode_i == 3'b000)) ? q_dreg_b :
                         (op_i == EXG & (op_mode_i == 5'b01001)) ? q_areg_b : // Exchange two address registers.
                         (op_i == EXG) ? q_dreg_a : // Exchange data and address registers.
                         (op_i == MOVEA & (adr_mode_i == 3'b001)) ? q_areg_b :
                         ((op_i == MOVEA & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? data_immediate_i :
                         (op_i == LINK & sbit_i) ? ssp_out :
                         (op_i == LINK) ? usp_out :
                         ((op_i == RTE | op_i == RTR) | op_i == RTS) ? bus_buffer_a : // Init PC, CCR, SP.
                         (op_i == UNLK & unlk_sp_an_i) ? q_areg_b : // An to SP.
                         ((fc_out_i == 3'b010) | (fc_out_i == 3'b110)) ? {16'h0000,data_core} : // User program space.
                          bus_buffer_a;
   
   // ALU source operand: The required sign extensions for the operations 
   // ADDA, CMPA and SUBA are computed in the ALU unit.
   assign alu_op_in_s = ((op_i == ABCD | op_i == SBCD) & (rm_i == 1'b0)) ? q_dreg_a :
                        (op_i == ABCD | op_i == SBCD) ? bus_buffer_a :
                        ((op_i == ADDX | op_i == SUBX) & (rm_i == 1'b0)) ? q_dreg_a :
                        (op_i == ADDX | op_i == SUBX) ? bus_buffer_a :
                        (((op_i == ADD | op_i == SUB) & (op_mode_i[2] == 1'b0)) & (adr_mode_i == 3'b000)) ? q_dreg_a :
                        (((op_i == ADD | op_i == SUB) & (op_mode_i[2] == 1'b0)) & (adr_mode_i == 3'b001)) ? q_areg_b :
                        (((op_i == ADD | op_i == SUB) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? data_immediate_i :
                        ((op_i == ADD | op_i == SUB) & (op_mode_i[2] == 1'b0)) ? bus_buffer_a :
                        ((op_i == ADD | op_i == SUB) & (op_mode_i[2] == 1'b1)) ? q_dreg_b :
                        (((op_i == ADDA | op_i == CMPA) | op_i == SUBA) & (adr_mode_i == 3'b000)) ? q_dreg_b :
                        (((op_i == ADDA | op_i == CMPA) | op_i == SUBA) & (adr_mode_i == 3'b001)) ? q_areg_b :
                        ((((op_i == ADDA | op_i == CMPA) | op_i == SUBA) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? data_immediate_i :
                        ((op_i == ADDA | op_i == CMPA) | op_i == SUBA) ? bus_buffer_a :
                        (op_i == ADDI | op_i == SUBI) ? data_immediate_i :
                        (op_i == ADDQ | op_i == SUBQ) ? data_immediate_i :
                        (((op_i == AND_B | op_i == OR_B) & (op_mode_i[2] == 1'b0)) & (adr_mode_i == 3'b000)) ? q_dreg_a :
                        (((op_i == AND_B | op_i == OR_B) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? data_immediate_i :
                        ((op_i == AND_B | op_i == OR_B) & (op_mode_i[2] == 1'b0)) ? bus_buffer_a :
                        ((op_i == AND_B | op_i == OR_B) & (op_mode_i[2] == 1'b1)) ? q_dreg_b :
                        (((op_i == ANDI | op_i == CMPI) | op_i == EORI) | op_i == ORI) ? data_immediate_i :
                        (op_i == ANDI_TO_CCR | op_i == ANDI_TO_SR) ? data_immediate_i :
                        (op_i == EORI_TO_CCR | op_i == EORI_TO_SR) ? data_immediate_i :
                        (op_i == ORI_TO_CCR | op_i == ORI_TO_SR) ? data_immediate_i :
                        (op_i == CHK & (adr_mode_i == 3'b000)) ? q_dreg_b :
                        ((op_i == CHK & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? data_immediate_i :
                        (op_i == CHK) ? bus_buffer_a :
                        (op_i == CMP & (adr_mode_i == 3'b000)) ? q_dreg_b :
                        (op_i == CMP & (adr_mode_i == 3'b001)) ? q_areg_b :
                        ((op_i == CMP & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? data_immediate_i :
                        (op_i == CMP | op_i == CMPM) ? bus_buffer_a :
                        (op_i == EOR) ? q_dreg_a :
                        (op_i == EXTW | op_i == SWAP) ? q_dreg_b :
			// MOVE and MOVEQ are switched here for condition code calculation:
                        (op_i == MOVE & (adr_mode_i == 3'b000)) ? q_dreg_b :
                        (op_i == MOVE & (adr_mode_i == 3'b000)) ? q_dreg_b :
                        (op_i == MOVE & (adr_mode_i == 3'b001)) ? q_areg_a :
                        (op_i == MOVEQ) ? data_immediate_i :
                        ((op_i == MOVE & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? data_immediate_i :
                        (op_i == MOVE) ? bus_buffer_a :
                        ((op_i == DIVS | op_i == DIVU) & (adr_mode_i == 3'b000)) ? q_dreg_b :
                        (((op_i == DIVS | op_i == DIVU) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? data_immediate_i :
                        (op_i == DIVS | op_i == DIVU) ? bus_buffer_a :
                        (((op_size_i == WORD) & (op_i == MULS | op_i == MULU)) & (adr_mode_i == 3'b000)) ? {16'h0000,q_dreg_b[15:0]} :
                        ((op_i == MULS | op_i == MULU) & (adr_mode_i == 3'b000)) ? q_dreg_b :
                        ((((op_size_i == WORD) & (op_i == MULS | op_i == MULU)) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? {16'h0000,data_immediate_i[15:0]} :
                        (((op_i == MULS | op_i == MULU) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? data_immediate_i :
                        ((op_size_i == WORD) & (op_i == MULS | op_i == MULU)) ? {16'h0000,bus_buffer_a[15:0]} :
                        (op_i == MULS | op_i == MULU) ? bus_buffer_a :
                        32'h00000000; // The default is valid for NBCD, NEG, NEGX.

   assign alu_op_in_d_lo = ((op_i == ABCD | op_i == SBCD) & (rm_i == 1'b0)) ? q_dreg_b :
                           (op_i == ABCD | op_i == SBCD) ? bus_buffer_b :
                           ((op_i == ADDX | op_i == SUBX) & (rm_i == 1'b0)) ? q_dreg_b :
                           (op_i == ADDX | op_i == SUBX) ? bus_buffer_b :
                           ((op_i == ADD | op_i == SUB) & (op_mode_i[2] == 1'b0)) ? q_dreg_b :
                           ((op_i == ADD | op_i == SUB) & (op_mode_i[2] == 1'b1)) ? bus_buffer_a :
                           ((op_i == ADDA | op_i == CMPA) | op_i == SUBA) ? q_areg_a :
                           ((op_i == ADDI | op_i == SUBI) & (adr_mode_i == 3'b000)) ? q_dreg_b :
                           (op_i == ADDI | op_i == SUBI) ? bus_buffer_a :
                           ((op_i == ADDQ | op_i == SUBQ) & (adr_mode_i == 3'b000)) ? q_dreg_b :
                           ((op_i == ADDQ | op_i == SUBQ) & (adr_mode_i == 3'b001)) ? q_areg_b :
                           (op_i == ADDQ | op_i == SUBQ) ? bus_buffer_a :
                           ((op_i == AND_B | op_i == OR_B) & (op_mode_i[2] == 1'b0)) ? q_dreg_b :
                           (op_i == EOR & (adr_mode_i == 3'b000)) ? q_dreg_b :
                           (((op_i == AND_B | op_i == EOR) | op_i == OR_B) & (op_mode_i[2] == 1'b1)) ? bus_buffer_a :
                           ((((op_i == ANDI | op_i == CMPI) | op_i == EORI) | op_i == ORI) & (adr_mode_i == 3'b000)) ? q_dreg_b :
                           (((op_i == ANDI | op_i == CMPI) | op_i == EORI) | op_i == ORI) ? bus_buffer_a :
                           (op_i == ANDI_TO_CCR | op_i == ANDI_TO_SR) ? {16'h0000,status_reg_i} :
                           (op_i == EORI_TO_CCR | op_i == EORI_TO_SR) ? {16'h0000,status_reg_i} :
                           (op_i == ORI_TO_CCR | op_i == ORI_TO_SR) ? {16'h0000,status_reg_i} :
                           (op_i == CHK | op_i == CMP) ? q_dreg_a :
                           (op_i == CMPM) ? bus_buffer_b :
                           (op_i == DIVS | op_i == DIVU) ? q_dreg_a :
                           ((op_size_i == LONG) & (op_i == MULS | op_i == MULU)) ? {16'h0000,q_dreg_a[15:0]} :
                           (op_i == MULS | op_i == MULU) ? q_dreg_a :
                           ((((op_i == NBCD | op_i == NEG) | op_i == NEGX) | op_i == NOT_B) & (adr_mode_i == 3'b000)) ? q_dreg_b :
                           (((op_i == NBCD | op_i == NEG) | op_i == NEGX) | op_i == NOT_B) ? bus_buffer_a :
                           (op_i == TAS & (adr_mode_i == 3'b000)) ? q_dreg_b :
                           (op_i == TAS) ? bus_buffer_a :
                           (op_i == TST & (adr_mode_i == 3'b000)) ? q_dreg_b :
                           (op_i == TST & (adr_mode_i == 3'b001)) ? q_areg_b :
                           ((op_i == TST & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? data_immediate_i :
                           bus_buffer_a; // Valid for TST.
   
   assign alu_op_in_d_hi = q_dreg_c; // Used for DIVUL, DIVSL.
   
   assign shft_op_in = ((op_i == ASL | op_i == ASR) & mem_shft_i == 1'b0) ? q_dreg_b :
                       (op_i == ASL | op_i == ASR) ? bus_buffer_a :
                       ((op_i == LSL | op_i == LSR) & mem_shft_i == 1'b0) ? q_dreg_b :
                       (op_i == LSL | op_i == LSR) ? bus_buffer_a :
                       ((op_i == ROTL | op_i == ROTR) & mem_shft_i == 1'b0) ? q_dreg_b :
                       (op_i == ROTL | op_i == ROTR) ? bus_buffer_a :
                       ((op_i == ROXL | op_i == ROXR) & mem_shft_i == 1'b0) ? q_dreg_b :
                       (op_i == ROXL | op_i == ROXR) ? bus_buffer_a :
                       ((op_i == BTST & adr_mode_i == 3'b111) & (regsel_20_i == 3'b100)) ? data_immediate_i :
                       ((((op_i == BCHG | op_i == BCLR) | op_i == BSET) | op_i == BTST) & (adr_mode_i == 3'b000)) ? q_dreg_b :
                       (((op_i == BCHG | op_i == BCLR) | op_i == BSET) | op_i == BTST) ? bus_buffer_a :
		       32'b0; // Dummy.
      
   wf68k00ip_control i_ctrl(.clk(clk),
			    .resetn(reset_coren),
			    .sr_ccr_in(sr_ccr_mux),
			    .c_code(c_code_i),
			    .reglistmask(reglistmask_i),
			    .ctrl_en(ctrl_en_i),
			    .exec_abort(exec_abort_i),
			    .data_valid(data_valid_i),
			    .bus_cyc_rdy(bus_cyc_rdy_i),
			    .ctrl_rdy(ctrl_rdy_i),
			    .init_status(init_status_i),
			    .preset_irq_mask(preset_irq_mask_i),
			    .irq(irq_exhdl),
			    .irq_save(irq_save_i),
			    .xnzvc_in(xnzvc_i),
			    .status_reg_out(status_reg_i),
			    .force_biw2(force_biw2_i),
			    .force_biw3(force_biw3_i),
			    .ext_cnt(ext_cnt_i),
			    .dest_ext_cnt(dest_ext_cnt_i),
			    .regsel_20(regsel_20_i),
			    .iw_adr(iw_adr_i),
			    .iw_wr(iw_wr_i),
			    .src_destn(src_destn_i),
			    .ew_wr(ew_wr_i),
			    .ew_adr(ew_adr_i),
			    .rd_bus(rd_bus_ctrl),
			    .wr_bus(wr_bus_ctrl),
			    .tas_lock(tas_lock_i),
			    .wr_hi(wr_hi_i),
			    .sel_a_hi(sel_a_hi),
			    .sel_a_midhi(sel_a_midhi),
			    .sel_a_midlo(sel_a_midlo),
			    .sel_a_lo(sel_a_lo),
			    .sel_buff_a_lo(sel_buf_a_lo_ctrl_i),
			    .sel_buff_a_hi(sel_buf_a_hi_ctrl_i),
			    .sel_buff_b_lo(sel_buf_b_lo_i),
			    .sel_buff_b_hi(sel_buf_b_hi_i),
			    .fc_out(fc_out_ctrl),
			    .fc_en(fc_en_ctrl),
			    .pc_init(pc_init_ctrl),
			    .pc_wr(pc_wr_i),
			    .pc_inc(pc_inc_i),
			    .pc_tmp_clr(pc_tmp_clr_i),
			    .pc_tmp_inc(pc_tmp_inc_i),
			    .pc_add_displ(pc_add_displ_i),
			    .usp_inc(usp_inc_i),
			    .ssp_inc(ssp_inc_i),
			    .usp_dec(usp_dec_i),
			    .ssp_dec(ssp_dec_ctrl),
			    .usp_cpy(usp_cpy_i),
			    .sp_add_displ(sp_add_displ_i),
			    .adr_tmp_clr(adr_tmp_clr_i),
			    .adr_tmp_inc(adr_tmp_inc_i),
			    .ar_inc(ar_inc_i),
			    .ar_dec(ar_dec_i),
			    .ar_wr(ar_wr_i),
			    .ar_dr_exg(ar_dr_exg_i),
			    .dr_wr(dr_wr_i),
			    .dr_dec(dr_dec_i),
			    .scan_traps(scan_traps_i),
			    .trap_priv(trap_priv_i),
			    .trap_trace(trap_trace_i),
			    .op(op_i),
			    .op_mode(op_mode_i[2:0]),
			    .op_size(op_size_i),
			    .adr_mode(adr_mode_i),
			    .move_d_am(move_d_am_i),
			    .reset_rdy(reset_rdy_i),
			    .op_busy(op_busy_i),
			    .mem_shft(mem_shft_i),
			    .shft_busy(shft_busy_i),
			    .dr(dr_i),
			    .rm(rm_i),
			    .div_mul_32n64(div_mul_32n64_i),
			    .exec_resume(exec_resume_i),
			    .dbcc_cond(dbcc_cond_i),
			    .use_sp_adr(use_sp_adr_i),
			    .op_start(op_start_i),
			    .trap_chk_en(trap_chk_en_i),
			    .movem_regsel(movem_regsel_i),
			    .movem_adn(movem_adn_i),
			    .scc_cond(scc_cond_i),
			    .shifter_load(shifter_load_i),
			    .chk_pc(chk_pc_i),
			    .chk_adr(chk_adr_i),
			    .sbit(sbit_i),
			    .unlk_sp_an(unlk_sp_an_i),
			    .reset_en(reset_en_i));
   
   wf68k00ip_interrupt_control i_irq_ctrl(.clk(clk),
					  .resetn(reset_coren),
					  .reset_cpun(reset_cpu_in),
					  .berr(berr_i),
					  .haltn(halt_in),
					  .adr_in(adr_i),
					  .use_ssp_adr(use_ssp_adr_i),
					  .adr_en_vector(adr_en_vector_i),
					  .data_in(data_core[7:0]),
					  .data_out(irq_dout),
					  .data_en(irq_data_en),
					  .rwn(rwn_i),
					  .rd_bus(rd_bus_irq),
					  .wr_bus(wr_bus_irq),
					  .halt_en(halt_out_en),
					  .fc_in(fc_out_i),
					  .fc_out(fc_out_irq),
					  .fc_en(fc_en_irq),
					  .sel_buff_a_lo(sel_buf_a_lo_irq_i),
					  .sel_buff_a_hi(sel_buf_a_hi_irq_i),
					  .status_reg_in(status_reg_i),
					  .pc(pc_out),
					  .init_status(init_status_i),
					  .preset_irq_mask(preset_irq_mask_i),
					  .ssp_dec(ssp_dec_irq),
					  .ssp_init(ssp_init_i),
					  .pc_init(pc_init_irq),
					  .biw_0(biw_0_i),
					  .bus_cyc_rdy(bus_cyc_rdy_i),
					  .ctrl_rdy(ctrl_rdy_i),
					  .ctrl_en(ctrl_en_i),
					  .exec_abort(exec_abort_i),
					  .exec_resume(exec_resume_i),
					  .irq_inn(ipl_in),
					  .irq_out(irq_exhdl),
					  .avecn(avec_in), // Originally 68Ks use VPAn.
					  .irq_save(irq_save_i),
					  .int_vect(int_vect_i),
					  .use_int_vect(use_int_vect_i),
					  .trap_aerr(trap_aerr_i),
					  .trap_op(trap_op_i),
					  .trap_vector(trap_vector_i),
					  .trap_v(trap_v_i),
					  .trap_chk(trap_chk_i),
					  .trap_divzero(trap_divzero_i),
					  .trap_illegal(trap_illegal_i),
					  .trap_1010(trap_1010_i),
					  .trap_1111(trap_1111_i),
					  .trap_trace(trap_trace_i),
					  .trap_priv(trap_priv_i));
   
   wf68k00ip_opcode_decoder i_opcode(.clk(clk),
				     .resetn(reset_coren),
				     .data_in(data_in),
				     .sbit(sbit_i),
				     .ov(status_reg_i[1]),
				     .iw_adr(iw_adr_i),
				     .iw_wr(iw_wr_i),
				     .force_biw2(force_biw2_i),
				     .force_biw3(force_biw3_i),
				     .ext_cnt(ext_cnt_i),
				     .dest_ext_cnt(dest_ext_cnt_i),
				     .dr(dr_i),
				     .rm(rm_i),
				     .ir(ir_i),
				     .op(op_i),
				     .op_size(op_size_i),
				     .op_mode(op_mode_i),
				     .biw_0(biw_0_i),
				     .regsel_20(regsel_20_i),
				     .regsel_119(regsel_119_i),
				     .regsel_index(regsel_index),
				     .data_immediate(data_immediate_i),
				     .trap_vector(trap_vector_i),
				     .c_code(c_code_i),
				     .mem_shft(mem_shft_i),
				     .reglistmask(reglistmask_i),
				     .bitpos_im(bitpos_im_i),
				     .bit_pos(bit_pos_op),
				     .div_mul_32n64(div_mul_32n64_i),
				     .reg_dlq(regsel_dlq),
				     .reg_dhr(regsel_dhr),
				     .scan_traps(scan_traps_i),
				     .trap_illegal(trap_illegal_i),
				     .trap_1010(trap_1010_i),
				     .trap_1111(trap_1111_i),
				     .trap_priv(trap_priv_i),
				     .trap_op(trap_op_i),
				     .trap_v(trap_v_i),
				     .ew_wr(ew_wr_i),
				     .ew_adr(ew_adr_i),
				     .src_destn(src_destn_i),
				     .exword0(exword0_i),
				     .exword1(exword1_i),
				     .dest_exword0(dest_exword0_i),
				     .dest_exword1(dest_exword1_i),
				     .adr_mode(adr_mode_i),
				     .move_d_am(move_d_am_i),
				     .ext_dsize(ext_dsize_i),
				     .sel_displace_biw(sel_displace_biw_i),
				     .displace_biw(displace_biw_i));
   
   wf68k00ip_address_registers i_adrreg(.clk(clk),
					.resetn(reset_coren),
					.adata_in(areg_data_in),
					.regsel_b(regsel_adr_b),
					.regsel_a(regsel_adr_a),
					.adr_reg_qb(q_areg_b),
					.adr_reg_qa(q_areg_a),
					.usp_out(usp_out),
					.ssp_out(ssp_out),
					.pc_out(pc_out),
					.exword0(exword0_i),
					.exword1(exword1_i),
					.dest_exword0(dest_exword0_i),
					.dest_exword1(dest_exword1_i),
					.dr(dr_i),
					.usp_cpy(usp_cpy_i),
					.ar_exg(ar_dr_exg_i),
					.ar_wr(ar_wr_i),
					.usp_inc(usp_inc_i),
					.usp_dec(usp_dec_i),
					.adr_tmp_clr(adr_tmp_clr_i),
					.adr_tmp_inc(adr_tmp_inc_i),
					.ar_inc(ar_inc_i),
					.ar_dec(ar_dec_i),
					.ssp_inc(ssp_inc_i),
					.ssp_dec(ssp_dec_i),
					.ssp_init(ssp_init_i),
					.sp_add_displ(sp_add_displ_i),
					.use_sp_adr(use_sp_adr_i),
					.use_ssp_adr(use_ssp_adr_i),
					.pc_wr(pc_wr_i),
					.pc_inc(pc_inc_i),
					.pc_tmp_clr(pc_tmp_clr_i),
					.pc_tmp_inc(pc_tmp_inc_i),
					.pc_init(pc_init_i),
					.pc_add_displ(pc_add_displ_i),
					.src_destn(src_destn_i),
					.sbit(sbit_i),
					.op(op_i),
					.op_size(op_size_i),
					.op_mode(op_mode_i),
					.op_start(op_start_i),
					.adr_mode(adr_mode_i),
					.move_d_am(move_d_am_i),
					.force_biw2(force_biw2_i),
					.force_biw3(force_biw3_i),
					.ext_dsize(ext_dsize_i),
					.sel_displace_biw(sel_displace_biw_i),
					.displace_biw(displace_biw_i),
					.regsel_index(regsel_data_c),
					.index_d_in(q_dreg_c),
					.chk_pc(chk_pc_i),
					.chk_adr(chk_adr_i),
					.trap_aerr(trap_aerr_i),
					.adr_eff(adr_eff_i));
   
   wf68k00ip_data_registers i_datareg(.clk(clk),
				      .resetn(reset_coren),
				      .data_in_a(dreg_data_in_a),
				      .data_in_b(dreg_data_in_b),
				      .regsel_a(regsel_data_a),
				      .regsel_b(regsel_data_b),
				      .regsel_c(regsel_data_c),
				      .div_mul_32n64(div_mul_32n64_i),
				      .data_out_a(q_dreg_a),
				      .data_out_b(q_dreg_b),
				      .data_out_c(q_dreg_c),
				      .dr_exg(ar_dr_exg_i),
				      .dr_dec(dr_dec_i),
				      .dr_wr(dr_wr_i),
				      .op(op_i),
				      .op_size(op_size_i),
				      .op_mode(op_mode_i),
				      .dbcc_cond(dbcc_cond_i));
   
   wf68k00ip_alu i_alu(.resetn(reset_coren),
		       .clk(clk),
		       .adr_mode(adr_mode_i),
		       .op_size(op_size_i),
		       .op(op_i),
		       .xnzvc_in(status_reg_i[4:0]),
		       .xnzvc_out(xnzvc_alu),
		       .op_in_s(alu_op_in_s),
		       .op_in_d_hi(alu_op_in_d_hi),
		       .op_in_d_lo(alu_op_in_d_lo),
		       .result_hi(result_alu_hi),
		       .result_lo(result_alu_lo),
		       .op_start(op_start_i),
		       .trap_chk_en(trap_chk_en_i),
		       .div_mul_32n64(div_mul_32n64_i),
		       .op_busy(op_busy_i),
		       .trap_chk(trap_chk_i),
		       .trap_divzero(trap_divzero_i));
   
   wf68k00ip_shifter i_shft(.clk(clk),
			    .resetn(reset_coren),
			    .data_in(shft_op_in),
			    .data_out(result_shft),
			    .op(op_i),
			    .op_size(op_size_i),
			    .bit_pos(bit_pos_i),
			    .cnt_nr(cnt_nr_i),
			    .shifter_load(shifter_load_i),
			    .shft_busy(shft_busy_i),
			    .xnzvc_in(status_reg_i[4:0]),
			    .xnzvc_out(xnzvc_shft));
   
   wf68k00ip_bus_interface i_bus_if(.clk(clk),
				    .resetn(reset_coren),
				    .reset_inn(reset_in_in),
				    .reset_out_en(reset_out_en),
				    .reset_cpun(reset_cpu_in),
				    .reset_en(reset_en_i),
				    .reset_rdy(reset_rdy_i),
				    .data_in(data_in),
				    .sel_a_hi(sel_a_hi),
				    .sel_a_midhi(sel_a_midhi),
				    .sel_a_midlo(sel_a_midlo),
				    .sel_a_lo(sel_a_lo),
				    .sel_buff_a_lo(sel_buf_a_lo_i),
				    .sel_buff_a_hi(sel_buf_a_hi_i),
				    .sel_buff_b_lo(sel_buf_b_lo_i),
				    .sel_buff_b_hi(sel_buf_b_hi_i),
				    .sys_init(sys_init_i),
				    .op_size(op_size_i),
				    .buffer_a(bus_buffer_a),
				    .buffer_b(bus_buffer_b),
				    .data_core_out(data_core),
				    .rd_bus(rd_bus_i),
				    .wr_bus(wr_bus_i),
				    .tas_lock(tas_lock_i),
				    .a0(adr_i[0]),
				    .byten_word(byten_word_i),
				    .bus_cyc_rdy(bus_cyc_rdy_i),
				    .data_valid(data_valid_i),
				    .dtackn(dtack_in),
				    .berrn(berr_in),
				    .avecn(avec_in),
				    .haltn(halt_in),
				    .adr_en(adr_en_i),
				    .wr_hi(wr_hi_i),
				    .hi_word_en(hi_word_en_i),
				    .hi_byte_en(hi_byte_en_i),
				    .lo_byte_en(lo_byte_en_i),
				    .fc_en(fc_en_i),
				    .asn(as_in),
				    .as_en(as_en_i),
				    .udsn(uds_in),
				    .uds_en(uds_en_i),
				    .ldsn(lds_in),
				    .lds_en(lds_en_i),
				    .rwn(rwn_i),
				    .rw_en(rw_en_i),
				    .vpan(vpa_in),
				    .vman(vma_in),
				    .vma_en(vma_en_i),
				    .e(e),
				    .brn(br_in),
				    .bgackn(bgack_in),
				    .bgn(bgn));

`ifdef debug_xxx
   always @(posedge clk)
     begin
	if (rd_bus_i && 0)
	  $display("%t; rd_bus_ctrl=%b, rd_bus_irq=%b, adr_i=%x", $time, rd_bus_ctrl, rd_bus_irq, adr_i);
	if (wr_bus_i && 0)
	  $display("%t; wr_bus_ctrl=%b, wr_bus_irq=%b, adr_i=%x", $time, wr_bus_ctrl, wr_bus_irq, adr_i);
     end


   always @(posedge clk)
     begin
	if (fc_out == 3'h6 && i_ctrl.exec_state == 5'd1 && chk_pc_i && 0)
	  $display("pc: %x", pc_out);
     end

   always @(posedge clk)
     begin
        if (op_i == UNLK & unlk_sp_an_i)
	  $display("unlk: areg_data_in %x, q_areg_b %x", q_areg_b, areg_data_in);
     end

   //always @(ipl_tmpn or ipln or ipl_in)
   //$display("m68k: ipl_in %b, ipln %b, ipl_tmpn %b; %t", ipl_in, ipln, ipl_tmpn, $time);
   
`endif

//`define CHIPSCOPE_M68K

`ifdef __CVER__
 `ifdef CHIPSCOPE_M68K
  `undef CHIPSCOPE_M68K
 `endif
`endif

`ifdef SIMULATION
 `ifdef CHIPSCOPE_M68K
  `undef CHIPSCOPE_M68K
 `endif
`endif
   
`ifdef CHIPSCOPE_M68K
   // chipscope
   wire [35:0] control1;
   wire [99:0] trig1;
   wire        mclk_en;
   wire        mclk;
        
   assign trig1 = {
		   reset_coren, //1
		   reset_inn,   //1
		   dtackn,      //1
		   as_outn,     //1
		   rwn_out,     //1
		   uds_outn,    //1
		   lds_outn,    //1
		   fc_out,      //3
		   ipln,        //3
                   pc_out,      //32
		   data_in,     //16
		   data_out,    //16
		   adr_out      //23
                   };

   chipscope_icon_m68k icon1 (.CONTROL0(control1));
   chipscope_ila_m68k ila1 (.CONTROL(control1), .CLK(clk), .TRIG0(trig1));
`endif

   
endmodule
