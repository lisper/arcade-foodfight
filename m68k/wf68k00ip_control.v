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
//-- This file contains the system control unit.                  ----
//--                                                              ----
//--                                                              ----
//-- Description:                                                 ----
//-- Performs the core synchronization and data flow control.     ----
//-- This module manages execution of all instructions. It con-   ----
//-- tains the status register which consists of two portions     ----
//-- supervisor byte and user byte and its related logic.         ----
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
// Revision 2K8B  2008/12/24 WF
//   Fixed a minor bug in the RESET operation.
//   Changes regarding the read modify write logic of the TAS operation.
//   Changed OP_START to solve the Ax,-(Ax) bug, see address register section.
//   Fixed useless bus read operation during JSR. Thanks to T. Gubener for finding this.
//   Fixed MOVEM (A0)+,D0 bug. Thanks to T. Gubener for finding this.
//   Fixed LINK A7.
//   Changed OP_START to manage MOVEM index storage.
// Revision 2K9B  2009/12/24 WF
//   Changed UNLK A7 logic due to compatibility reasons with MC68000.


module  wf68k00ip_control ( clk, resetn, c_code, reglistmask, ctrl_en, exec_abort, data_valid,
			    bus_cyc_rdy, ctrl_rdy, init_status, preset_irq_mask, sr_ccr_in,
			    irq, irq_save, xnzvc_in, status_reg_out, force_biw2, force_biw3,
			    ext_cnt, dest_ext_cnt, regsel_20, iw_adr, iw_wr, src_destn,
			    ew_wr, ew_adr, rd_bus, wr_bus, tas_lock, wr_hi,
			    sel_a_hi, sel_a_midhi, sel_a_midlo, sel_a_lo, sel_buff_a_lo, sel_buff_a_hi,
			    sel_buff_b_lo, sel_buff_b_hi, fc_out, fc_en,
			    pc_init, pc_wr, pc_inc, pc_tmp_clr, pc_tmp_inc, pc_add_displ,
			    usp_inc, ssp_inc, usp_dec, ssp_dec, usp_cpy, sp_add_displ,
			    adr_tmp_clr, adr_tmp_inc, ar_inc, ar_dec, ar_wr, ar_dr_exg,
			    dr_wr, dr_dec, scan_traps, trap_priv, trap_trace,
			    op, op_mode, op_size, adr_mode, move_d_am, reset_rdy,
			    op_busy, mem_shft, shft_busy, dr, rm, div_mul_32n64,
			    exec_resume, dbcc_cond, use_sp_adr, op_start, trap_chk_en,
			    movem_regsel, movem_adn, scc_cond, shifter_load, chk_pc, chk_adr,
			    sbit, unlk_sp_an, reset_en );

   input        clk;
   input        resetn;
   input [3:0] 	c_code;
   input [15:0] reglistmask;
   input        ctrl_en;
   input        exec_abort;
   input        data_valid;
   input        bus_cyc_rdy;
   output 	ctrl_rdy;
   input        init_status;
   input        preset_irq_mask;
   input [15:0] sr_ccr_in;
   input [2:0] 	irq;
   input        irq_save;
   input [4:0] 	xnzvc_in;
   output [15:0] status_reg_out;
   input 	 force_biw2;
   input 	 force_biw3;
   input [1:0] 	 ext_cnt;
   input [1:0] 	 dest_ext_cnt;
   input [2:0] 	 regsel_20;
   output [1:0]  iw_adr;
   output        iw_wr;
   output        src_destn;
   output        ew_wr;
   output 	 ew_adr;
   output        rd_bus;
   output        wr_bus;
   output        tas_lock;
   output        wr_hi;
   output        sel_a_hi;
   output        sel_a_midhi;
   output        sel_a_midlo;
   output        sel_a_lo;
   output        sel_buff_a_lo;
   output        sel_buff_a_hi;
   output        sel_buff_b_lo;
   output        sel_buff_b_hi;
   output [2:0]  fc_out;
   output        fc_en;
   output        pc_init;
   output        pc_wr;
   output        pc_inc;
   output        pc_tmp_clr;
   output        pc_tmp_inc;
   output        pc_add_displ;
   output        usp_inc;
   output        ssp_inc;
   output        usp_dec;
   output        ssp_dec;
   output        usp_cpy;
   output        sp_add_displ;
   output        adr_tmp_clr;
   output        adr_tmp_inc;
   output        ar_inc;
   output        ar_dec;
   output        ar_wr;
   output        ar_dr_exg;
   output        dr_wr;
   output        dr_dec;
   output        scan_traps;
   input 	 trap_priv;
   output        trap_trace;
   input [6:0] 	 op;
   input [2:0] 	 op_mode;
   input [1:0] 	 op_size;
   input [2:0] 	 adr_mode;
   input [2:0] 	 move_d_am;
   input 	 reset_rdy;
   input 	 op_busy;
   input 	 mem_shft;
   input 	 shft_busy;
   input 	 dr;
   input 	 rm;
   input 	 div_mul_32n64;
   input 	 exec_resume;
   input 	 dbcc_cond;
   output        use_sp_adr;
   output        op_start;
   output        trap_chk_en;
   output [2:0]  movem_regsel;
   output        movem_adn;
   output        scc_cond;
   output        shifter_load;
   output        chk_pc;
   output        chk_adr;
   output        sbit;
   output        unlk_sp_an;
   output        reset_en;

`include "wf68k00ip_parms.h"

   reg 		 chk_adr_strb_lock;
   reg 		 predec_ctrl_lock;
   wire [9:0] 	 sreg_new;
   reg [9:0] 	 sreg_mem;
   reg [9:0] 	 sreg_mem_tmp;

   reg [4:0] 	 bit_pnt_r;
   reg [2:0] 	 regsel_tmp_r;

   reg [4:0] 	 bit_pnt;
   reg [2:0] 	 regsel_tmp;

   reg 		 exword_counter_lock;
   reg [1:0] 	 src_tmp;
   reg [1:0] 	 dest_tmp;

   //type exec_states
   parameter IDLE = 5'd0;
   parameter FETCH_BIW_1 = 5'd1;
   parameter FETCH_BIW_2 = 5'd2;
   parameter FETCH_BIW_3 = 5'd3;
   parameter FETCH_EXT = 5'd4;
   parameter FETCH_DEST_EXT = 5'd5;
   parameter RD_SRC_1 = 5'd6;
   parameter RD_SRC_1_LO = 5'd7;
   parameter RD_SRC_1_HI = 5'd8;
   parameter RD_SRC_2 = 5'd9;
   parameter RD_SRC_2_LO = 5'd10;
   parameter RD_SRC_2_HI = 5'd11;
   parameter WR_DEST_1 = 5'd12;
   parameter WR_DEST_1_LO = 5'd13;
   parameter WR_DEST_1_HI = 5'd14;
   parameter WR_DEST_2_LO = 5'd15;
   parameter WR_DEST_2_HI = 5'd16;
   parameter RD_SP_HI = 5'd17;
   parameter RD_SP = 5'd18;
   parameter RD_SP_LO = 5'd19;
   parameter WR_SP_HI = 5'd20;
   parameter WR_SP_LO = 5'd21;
   parameter WAIT_OPERATION = 5'd22;
   parameter MOVEM_TST = 5'd23;
   
   reg [4:0] 	 exec_state;
   reg [4:0] 	 next_exec_state;
   reg [15:0] 	 status_reg;
   wire 	 sr_wr;
   wire 	 ccr_wr;
   wire 	 cc_updt;
   reg 		 got_ext;
   reg 		 got_dest_ext;
   reg 		 movem_en =0; 
   reg 		 movem_cpy;
   reg 		 movem_adn_i =0; 
   reg 		 movem_pi_corr =0; 
   wire 	 cond;
   wire 	 op_end_i;
   wire 	 rd_bus_i;
   wire 	 wr_bus_i;
   wire 	 ar_inc_i;
   reg 		 ar_dec_i; 
   wire 	 updt_cc;
   wire 	 sbit_i;
   reg 		 traplock;
   wire 	 ctrl_rdy;
   reg [15:0] 	 status_reg_out;
   wire [1:0] 	 iw_adr;
   wire 	 iw_wr;
   wire 	 src_destn;
   wire 	 ew_wr;
   reg 		 /* integer transformed. */ ew_adr;
   wire 	 rd_bus;
   wire 	 wr_bus;
   reg 		 tas_lock =0; 
   wire 	 wr_hi;
   wire 	 sel_a_hi;
   wire 	 sel_a_midhi;
   wire 	 sel_a_midlo;
   wire 	 sel_a_lo;
   wire 	 sel_buff_a_lo;
   wire 	 sel_buff_a_hi;
   wire 	 sel_buff_b_lo;
   wire 	 sel_buff_b_hi;
   wire [2:0] 	 fc_out;
   wire 	 fc_en;
   wire 	 pc_init;
   wire 	 pc_wr;
   wire 	 pc_inc;
   wire 	 pc_tmp_clr;
   wire 	 pc_tmp_inc;
   wire 	 pc_add_displ;
   wire 	 usp_inc;
   wire 	 ssp_inc;
   wire 	 usp_dec;
   wire 	 ssp_dec;
   wire 	 usp_cpy;
   wire 	 sp_add_displ;
   wire 	 adr_tmp_clr;
   wire 	 adr_tmp_inc;
   wire 	 ar_inc;
//   reg 		 ar_dec;
   wire 	 ar_wr;
   wire 	 ar_dr_exg;
   wire 	 dr_wr;
   wire 	 dr_dec;
   wire 	 scan_traps;
   wire 	 trap_trace;
   wire 	 use_sp_adr;
   wire 	 op_start;
   wire 	 trap_chk_en;
   reg [2:0] 	 movem_regsel;
   reg 		 movem_adn =0; 
   wire 	 scc_cond;
   wire 	 shifter_load;
   reg 		 chk_pc =0; 
   reg 		 chk_adr =0; 
   wire 	 sbit;
   wire 	 unlk_sp_an;
   wire 	 reset_en;

    
   // OP_START indicates the start condition for the following operations: 
   // Start the computation during MULS, MULU, DIVS or DIVU.
   // Sample the MOVEM address and address index for the special conditions.
   // Sample the effective address during PEA.
   // Sample the respective address register for the LINK operation.
   // Sample the address to be written for MOVE AX,-(Ax).
   // See also process P_AREG_TMP in the address register section.
   
   assign op_start = (op == MOVE & exec_state == FETCH_BIW_1 & bus_cyc_rdy) ? 1'b1 :
                     (op == MOVEM & (exec_state == FETCH_BIW_2 | exec_state == FETCH_EXT) & bus_cyc_rdy) ? 1'b1 :
                     ((op == LINK | op == PEA) & exec_state != WR_SP_LO & next_exec_state == WR_SP_LO) ? 1'b1 :
                     (op != STOP & exec_state != WAIT_OPERATION & next_exec_state == WAIT_OPERATION) ? 1'b1 :
                     1'b0;
   
   // The end of an operation is indicated by the next_exec_state for one clock cycle.
   assign op_end_i = (exec_state != IDLE & exec_state != FETCH_BIW_1 & next_exec_state == FETCH_BIW_1) ? 1'b1 :
                     (exec_state == FETCH_BIW_1 & next_exec_state == FETCH_BIW_1 & bus_cyc_rdy) ? 1'b1 :
                     1'b0;
   
   assign ctrl_rdy = exec_state == IDLE ? 1'b1 :  1'b0;
   
   // Signal to switch the stack pointer addresses to the address bus.
   assign use_sp_adr = (exec_state == RD_SP) ? 1'b1 :
                       (exec_state == RD_SP_HI) ? 1'b1 :
                       (exec_state == RD_SP_LO) ? 1'b1 :
                       (exec_state == WR_SP_HI) ? 1'b1 :
                       (exec_state == WR_SP_LO) ? 1'b1 :
                       1'b0;
   
   assign shifter_load = ((op == ASL | op == ASR) & exec_state != WAIT_OPERATION & next_exec_state == WAIT_OPERATION) ? 1'b1 :
                         ((op == LSL | op == LSR) & exec_state != WAIT_OPERATION & next_exec_state == WAIT_OPERATION) ? 1'b1 :
                         ((op == ROTL | op == ROTR) & exec_state != WAIT_OPERATION & next_exec_state == WAIT_OPERATION) ? 1'b1 :
                         ((op == ROXL | op == ROXR) & exec_state != WAIT_OPERATION & next_exec_state == WAIT_OPERATION) ? 1'b1 :
                         1'b0;
   
   assign trap_trace = (op_end_i & status_reg[15] == 1'b1) ? 1'b1 : 1'b0;
   
   // This process provides strobe controls for checking the adress error in the address register
   // section of this core. The strobes occurs every time a bus cycle starts (read, write or read
   // modify write). If the bus cycle is finished, the strobe locking is released. If there is an
   // address error during a bus cycle, the unlocking is done during the IDLE state.

   always @(posedge clk or negedge resetn)
     if (~resetn)
       begin 
          chk_pc <= 1'b0;
          chk_adr <= 1'b0;
          chk_adr_strb_lock <= 1'b0;
       end
     else 
       begin 
          chk_pc <= 1'b0;
          chk_adr <= 1'b0;
          if (ctrl_en == 1'b0)
            ; // Do nothing during exception handling.
          else if ((exec_state == FETCH_BIW_1 | exec_state == FETCH_BIW_2 | exec_state == FETCH_BIW_3) & ~chk_adr_strb_lock)
            begin 
               chk_adr_strb_lock <= 1'b1;
               chk_pc <= 1'b1;
            end
          else if ((exec_state == FETCH_EXT | exec_state == FETCH_DEST_EXT) & ~chk_adr_strb_lock)
            begin 
               chk_adr_strb_lock <= 1'b1;
               chk_pc <= 1'b1;
            end
          else if (op != TAS & (rd_bus_i | wr_bus_i) & ~chk_adr_strb_lock) // TAS is byte wide.
            begin 
               chk_adr_strb_lock <= 1'b1;
               chk_adr <= 1'b1;
            end
          else if (bus_cyc_rdy | exec_state == IDLE)
            begin 
               chk_adr_strb_lock <= 1'b0;
               chk_adr <= 1'b0;
               chk_pc <= 1'b0;
            end
       end
       
   // This flip flop provides the locking of the TAS operation
   // to work in a  modify write mode. The lock is active just
   // before the first bus access and ends at the next operation.
   
   always @(posedge clk or negedge resetn)
     if (~resetn)
       tas_lock <= 1'b0;
     else 
       if (op == TAS & next_exec_state == RD_SRC_1)
         tas_lock <= 1'b1;
       else if (op == TAS & op_end_i)
         tas_lock <= 1'b0;

   // These signals controls the high word and low word bus access to the 32 bit wide registers.
   assign sel_a_hi = (op == MOVEP & exec_state == RD_SRC_1_HI) ? 1'b1 :
                     (op == MOVEP & exec_state == WR_DEST_1_HI) ? 1'b1 :
                     1'b0;

   assign sel_a_midhi = (op == MOVEP & exec_state == RD_SRC_1_LO) ? 1'b1 : 
                        (op == MOVEP & exec_state == WR_DEST_1_LO) ? 1'b1 :
                        1'b0;

   assign sel_a_midlo = (op == MOVEP & exec_state == RD_SRC_2_HI) ? 1'b1 :
                        (op == MOVEP & exec_state == WR_DEST_2_HI) ? 1'b1 :
                        1'b0;

   assign sel_a_lo = (op == MOVEP & exec_state == RD_SRC_2_LO) ? 1'b1 :
                     (op == MOVEP & exec_state == WR_DEST_2_LO) ? 1'b1 :
                     1'b0;
   
   assign sel_buff_a_lo = (exec_state == RD_SRC_1) ? 1'b1 :
                          (exec_state == RD_SRC_1_LO) ? 1'b1 :
                          (exec_state == RD_SP_LO) ? 1'b1 :
                          1'b0;
   
   assign sel_buff_a_hi = (exec_state == RD_SRC_1_HI) ? 1'b1 :
                          (exec_state == RD_SP_HI) ? 1'b1 :
                          1'b0;
   
   assign sel_buff_b_lo = (exec_state == RD_SRC_2) ? 1'b1 :
                          (exec_state == RD_SRC_2_LO) ? 1'b1 :
                          1'b0;
   
   assign sel_buff_b_hi = (exec_state == RD_SRC_2_HI) ? 1'b1 : 1'b0;
   
   assign scan_traps = (exec_state == FETCH_BIW_1 & bus_cyc_rdy) ? 1'b1 : 1'b0;
   
   assign sbit = sbit_i;
   
   assign sbit_i = status_reg[13] ? 1'b1 :  1'b0;
   
   // The function codes are as follows:
   // 001: User data, 010: User program, 101: Supervisor data, 110: Supervisor program.
   // The default "000" is for example valid during the RESET operation or the busy ALU.
   // This implementation does not affect any drawback because the bus is not driven during
   // these states.
   assign fc_en = (rd_bus_i | wr_bus_i) ? 1'b1 : 1'b0;
   
   assign fc_out = (sbit_i == 1'b0 & (exec_state == FETCH_BIW_1 | exec_state == FETCH_BIW_2 | exec_state == FETCH_BIW_3 | exec_state == FETCH_EXT | exec_state == FETCH_DEST_EXT)) ? 3'b010 :
                   (sbit_i &         (exec_state == FETCH_BIW_1 | exec_state == FETCH_BIW_2 | exec_state == FETCH_BIW_3 | exec_state == FETCH_EXT | exec_state == FETCH_DEST_EXT)) ? 3'b110 :
                   ((rd_bus_i | wr_bus_i) & sbit_i == 1'b0) ? 3'b001 :
                   ((rd_bus_i | wr_bus_i) & sbit_i) ? 3'b101 :
                   3'b000;
   
   // Status register conditions: (STATUS_REG(4) = X, STATUS_REG(3) = N, STATUS_REG(2) = Z,
   //                              STATUS_REG(1) = V, STATUS_REG(0) = C.)
   assign cond = (c_code == 4'h0) ? 1'b1 :
                 (c_code == 4'h2 & ~(status_reg[2] | status_reg[0])) ? 1'b1 : // High.
                 (c_code == 4'h3 &  (status_reg[2] | status_reg[0])) ? 1'b1 : // Low or same.
                 (c_code == 4'h4 & status_reg[0] == 1'b0) ? 1'b1 : // Carry clean
                 (c_code == 4'h5 & status_reg[0] == 1'b1) ? 1'b1 : // Carry set
                 (c_code == 4'h6 & status_reg[2] == 1'b0) ? 1'b1 : // Not equal
                 (c_code == 4'h7 & status_reg[2] == 1'b1) ? 1'b1 : // Equal
                 (c_code == 4'h8 & status_reg[1] == 1'b0) ? 1'b1 : // Overflow clear
                 (c_code == 4'h9 & status_reg[1] == 1'b1) ? 1'b1 : // Overflow set
                 (c_code == 4'hA & status_reg[3] == 1'b0) ? 1'b1 : // Plus
                 (c_code == 4'hB & status_reg[3] == 1'b1) ? 1'b1 : // Minus
                 (c_code == 4'hC & (status_reg[3] ^~ status_reg[1])) ? 1'b1 : // Greater or Equal
                 (c_code == 4'hD & (status_reg[3] ^ status_reg[1])) ? 1'b1 : // Less than 
                 (c_code == 4'hE & (status_reg[3:1] == 3'b101)) ? 1'b1 : // Greater than
                 (c_code == 4'hE & (status_reg[3:1] == 3'b000)) ? 1'b1 : // Greater than
                 (c_code == 4'hF & status_reg[2]) ? 1'b1 : // Less or equal
                 (c_code == 4'hF & (status_reg[3] ^ status_reg[1])) ? 1'b1 : // Less or equal
                 1'b0;
   
   assign scc_cond = cond; // Copy the conditional test result to the output.
   
   assign ew_wr = (exec_state == FETCH_EXT & data_valid) ? 1'b1 :
                  (exec_state == FETCH_DEST_EXT & data_valid) ? 1'b1 :
                  1'b0;
   
   assign iw_adr = (exec_state == FETCH_BIW_3) ? 2'd2 :
                   (exec_state == FETCH_BIW_2) ? 2'd1 :
                   2'd0; // Default during FETCH_BIW_1.
   
   assign iw_wr = (exec_state == FETCH_BIW_1 & data_valid) ? 1'b1 :
                  (exec_state == FETCH_BIW_2 & data_valid) ? 1'b1 :
                  (exec_state == FETCH_BIW_3 & data_valid) ? 1'b1 :
                  1'b0;
   
   // Select stack pointer or address data:
   // '1' means: write address register to stack pointer.
   assign unlk_sp_an = (op == UNLK & exec_state == FETCH_BIW_1) ? 1'b1 :  1'b0;
   
   // Source or destination control for the ABCD, ADDX, CMPM, MOVE, SBCD and SUBX operations:
   assign src_destn = (op == MOVE & exec_state == FETCH_DEST_EXT) ? 1'b0 :
                      ((op == ABCD | op == ADDX | op == CMPM | op == SBCD | op == SUBX) & exec_state == RD_SRC_2) ? 1'b0 :
                      ((op == ADDX | op == CMPM | op == SUBX) & exec_state == RD_SRC_2_HI) ? 1'b0 :
                      ((op == ADDX | op == CMPM | op == SUBX) & exec_state == RD_SRC_2_LO) ? 1'b0 :
                      ((op == ADDX | op == SUBX | op == MOVE) & exec_state == WR_DEST_1_HI) ? 1'b0 :
                      ((op == ADDX | op == SUBX | op == MOVE) & exec_state == WR_DEST_1_LO) ? 1'b0 :
                      ((op == ABCD | op == ADDX | op == MOVE | op == SBCD | op == SUBX) & exec_state == WR_DEST_1) ? 1'b0 :
                      1'b1;
   
   assign ar_dr_exg = (op == EXG & op_end_i) ? 1'b1 :  1'b0;
   
   assign dr_dec = (op == DBCC & next_exec_state == WAIT_OPERATION) ? 1'b1 : 1'b0;
   
   assign dr_wr = ((op == ABCD | op == SBCD) & rm == 1'b0 & op_end_i) ? 1'b1 :
                  ((op == ADD | op == SUB | op == AND_B | op == OR_B) & op_mode == 3'b000 & op_end_i) ? 1'b1 :
                  ((op == ADD | op == SUB | op == AND_B | op == OR_B) & op_mode == 3'b001 & op_end_i) ? 1'b1 :
                  ((op == ADD | op == SUB | op == AND_B | op == OR_B) & op_mode == 3'b010 & op_end_i) ? 1'b1 :
                  ((op == ADDI | op == ADDQ) & adr_mode == 3'b000 & op_end_i) ? 1'b1 :
                  ((op == ANDI | op == ORI) & adr_mode == 3'b000 & op_end_i) ? 1'b1 :
                  ((op == ADDX | op == SUBX) & rm == 1'b0 & op_end_i) ? 1'b1 :
                  ((op == EXTW | op == SWAP) & op_end_i) ? 1'b1 :
                  ((op == EOR | op == EORI) & adr_mode == 3'b000 & op_end_i) ? 1'b1 :
                  ((op == SUBI | op == SUBQ) & adr_mode == 3'b000 & op_end_i) ? 1'b1 :
                  ((op == NEG | op == NEGX) & adr_mode == 3'b000 & op_end_i) ? 1'b1 :
                  ((op == NBCD | op == NOT_B) & adr_mode == 3'b000 & op_end_i) ? 1'b1 :
                  ((op == ASL | op == ASR) & mem_shft == 1'b0 & op_end_i) ? 1'b1 :
                  ((op == LSL | op == LSR) & mem_shft == 1'b0 & op_end_i) ? 1'b1 :
                  ((op == ROTL | op == ROTR) & mem_shft == 1'b0 & op_end_i) ? 1'b1 :
                  ((op == ROXL | op == ROXR) & mem_shft == 1'b0 & op_end_i) ? 1'b1 :
                  ((op == BCHG | op == BCLR | op == BSET | op == CLR) & adr_mode == 3'b000 & op_end_i) ? 1'b1 :
                  ((op == DIVS | op == DIVU) & exec_state == WAIT_OPERATION & op_busy == 1'b0) ? 1'b1 :
                  ((op == MOVE) & move_d_am == 3'b000 & op_end_i) ? 1'b1 :
                  ((op == MOVE_FROM_CCR | op == MOVE_FROM_SR) & adr_mode == 3'b000 & op_end_i) ? 1'b1 :
                  ((op == MOVEQ) & op_end_i) ? 1'b1 :
                  ((op == MOVEP) & (op_mode == 3'b101 | op_mode == 3'b100) & op_end_i) ? 1'b1 :
                  ((op == MOVEM) & next_exec_state == MOVEM_TST & movem_cpy & dr & movem_adn_i == 1'b0) ? 1'b1 :
                  ((op == MULS | op == MULU) & exec_state == WAIT_OPERATION & op_busy == 1'b0) ? 1'b1 :
                  ((op == SCC) & adr_mode == 3'b000 & op_end_i) ? 1'b1 :
                  ((op == TAS) & adr_mode == 3'b000 & op_end_i) ? 1'b1 :
                  1'b0;
   
   assign ar_wr = ((op == ADDA | op == SUBA | op == LEA) & op_end_i) ? 1'b1 :
                  ((op == MOVEA) & op_end_i) ? 1'b1 :
                  ((op == ADDQ | op == SUBQ) & adr_mode == 3'b001 & op_end_i) ? 1'b1 :
                  ((op == LINK) & op_end_i) ? 1'b1 :
                  ((op == UNLK) & exec_state == FETCH_BIW_1 & bus_cyc_rdy) ? 1'b1 :
                  ((op == UNLK) & op_end_i) ? 1'b1 :
                  ((op == MOVEM) & next_exec_state == MOVEM_TST & movem_cpy & dr & movem_adn_i) ? 1'b1 :
                  1'b0;
   
   // Postincrement mode:
   // The immediate operations and the read modify write operations require only one increment 
   // per read write pair in the end of the operation.
   assign ar_inc = ar_inc_i;
   
   assign ar_inc_i = ((op == ADD | op == ADDA | op == ADDI | op == ADDQ) & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == AND_B | op == ANDI) & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == ASL | op == ASR) & mem_shft & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == BCHG | op == BCLR | op == BSET | op == BTST) & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == CHK | op == CLR) & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == CMP | op == CMPA | op == CMPI) & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == CMPM) & exec_state == RD_SRC_1 & bus_cyc_rdy) ? 1'b1 : // Byte.
                     ((op == CMPM) & exec_state == RD_SRC_1_LO & bus_cyc_rdy) ? 1'b1 : //  Word and long.
                     ((op == CMPM) & op_end_i) ? 1'b1 : // Increment the destination address register.
                     ((op == DIVS | op == DIVU) & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == EOR | op == EORI) & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == LSL | op == LSR) & mem_shft & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == MOVE) & exec_state == RD_SRC_1 & adr_mode == 3'b011 & bus_cyc_rdy) ? 1'b1 :
                     ((op == MOVE) & exec_state == RD_SRC_1_LO & adr_mode == 3'b011 & bus_cyc_rdy) ? 1'b1 :
                     ((op == MOVE) & exec_state == WR_DEST_1 & move_d_am == 3'b011 & bus_cyc_rdy) ? 1'b1 :
                     ((op == MOVE) & exec_state == WR_DEST_1_LO & move_d_am == 3'b011 & bus_cyc_rdy) ? 1'b1 :
		     ((op == MOVEA | op == MOVE_FROM_CCR | op == MOVE_FROM_SR) & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == MOVE_TO_CCR | op == MOVE_TO_SR) & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == MOVEM) & adr_mode == 3'b011 & exec_state == RD_SRC_1 & bus_cyc_rdy) ? 1'b1 :
                     ((op == MOVEM) & adr_mode == 3'b011 & exec_state == RD_SRC_1_LO & bus_cyc_rdy) ? 1'b1 :
                     ((op == MOVEM) & movem_pi_corr) ? 1'b1 : // MOVEM postincrement correction
                     ((op == MULS | op == MULU) & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == NBCD | op == NEG | op == NEGX) & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == NOT_B | op == OR_B | op == ORI) & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == ROTL | op == ROTR) & mem_shft & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == ROXL | op == ROXR) & mem_shft & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == SUB | op == SUBA | op == SUBI | op == SUBQ) & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     ((op == SCC | op == TAS | op == TST) & adr_mode == 3'b011 & op_end_i) ? 1'b1 :
                     1'b0;
   
   // Predecrement mode: the address register is decremented right in the beginning of
   // the respective execution states. The AR_DEC control is modelled by an edge detector.
   // This is necessary because predecrementing before entering the states is not possible
   // due to the multiplexing of the destination data set by SRC_DESTn which occurs exactly
   // during these execution states.
   // Note: the immediate operations and the read modify write operations require only one
   // increment per read write arrangement at the beginning of the operation.
   // Note: This process uses a complex interaction between the modelling with the variable
   // LOCK and the prioritization of the 'if - elsif - end if' construction. Provide changes
   // with care!
   always @(posedge clk or negedge resetn)
     begin 
	if (~resetn)
          begin 
             predec_ctrl_lock <= 1'b0;
             ar_dec_i <= 1'b0;
          end
	else 
          begin 
             ar_dec_i <= 1'b0;
             if ((op == ABCD | op == SBCD) & (exec_state == RD_SRC_1 | exec_state == RD_SRC_1_HI) & bus_cyc_rdy)
               predec_ctrl_lock <= 1'b0;
             else if ((op == ADDX | op == SUBX) & (exec_state == RD_SRC_1 | exec_state == RD_SRC_1_HI) & bus_cyc_rdy)
               predec_ctrl_lock <= 1'b0;
             else if ((op == MOVE | op == MOVEM) & bus_cyc_rdy)
               predec_ctrl_lock <= 1'b0;
             else if (op_end_i)
               predec_ctrl_lock <= 1'b0;
	     //
	     // All predecrement except the MOVE:
             else if ((exec_state == RD_SRC_1 | exec_state == RD_SRC_1_HI | exec_state == WR_DEST_1 | exec_state == WR_DEST_1_HI) & ~predec_ctrl_lock)
               case (op)
		 // Read modify write operations (in some configurations):
                 ADD,ADDI,ADDQ,AND_B,ANDI,ASL,ASR,BCHG,BCLR,BSET,BTST,EOR,EORI,LSL,LSR,
		 NEG,NEGX,NOT_B,NBCD,OR_B,ORI,ROTL,ROTR,ROXL,ROXR,SUB,SUBI,SUBQ,TAS: 
                   if (adr_mode == 3'b100)
                     begin 
                        ar_dec_i <= 1'b1;
                        predec_ctrl_lock <= 1'b1;
                     end
                 
		 // Write only operations:
                 CLR,MOVE_FROM_CCR,MOVE_FROM_SR,SCC : 
                   if (adr_mode == 3'b100)
                     begin 
                        ar_dec_i <= 1'b1;
                        predec_ctrl_lock <= 1'b1;
                     end

		 // Read only operations:
                 ADDA,CHK,CMP,CMPA,CMPI,DIVS,DIVU,MOVE_TO_CCR,MOVE_TO_SR,MOVEA,MOVEM,MULS,MULU,SUBA,TST : 
                   if (adr_mode == 3'b100)
                     begin 
                        ar_dec_i <= 1'b1;
                        predec_ctrl_lock <= 1'b1;
                     end
                 
		 // Special operations:
                 ABCD,ADDX,SBCD,SUBX : 
                   if (adr_mode == 3'b100)
                     begin 
                        ar_dec_i <= 1'b1;
                        predec_ctrl_lock <= 1'b1;
                     end

		 // MOVE operation:
                 MOVE : 
                   if ((exec_state == RD_SRC_1 | exec_state == RD_SRC_1_HI) & adr_mode == 3'b100) // Read from source.
                     begin 
                        ar_dec_i <= 1'b1;
                        predec_ctrl_lock <= 1'b1;
                     end
                   else if ((exec_state == WR_DEST_1 | exec_state == WR_DEST_1_HI) & move_d_am == 3'b100) // Write to destination.
                     begin 
                        ar_dec_i <= 1'b1;
                        predec_ctrl_lock <= 1'b1;
                     end
                 
                 default : 
                   ;
               endcase
             
             else if ((exec_state == RD_SRC_2 | exec_state == RD_SRC_2_HI) & ~predec_ctrl_lock)
               case (op)
                 ABCD,ADDX,SBCD,SUBX : 
                   begin 
                      ar_dec_i <= 1'b1;
                      predec_ctrl_lock <= 1'b1;
                   end
                 default : 
                   ;
               endcase
          end // else: !if(~resetn)
     end
   
   assign ar_dec = ar_dec_i;
   
   
   // The conditions for clearing the temporary address offset are as follows:
   // Opereation ends (after a write process).
   // Post increment or pre decrement addressing mode (during increments / decrements).
   // After the end of the respective read periods (take care of the MOVEM).
   // The OP /= MOVEM ... is important for the MOVEM in the non predecrement / postincrement 
   // address modes see also ADR_TMP_INC.
   assign adr_tmp_clr = (op_end_i | ar_inc_i | ar_dec_i) ? 1'b1 :
                        (op != MOVEM & exec_state == RD_SRC_1 & bus_cyc_rdy) ? 1'b1 :
                        (exec_state == RD_SRC_2 & bus_cyc_rdy) ? 1'b1 : 
                        (op != MOVEM & exec_state == RD_SRC_1_LO & bus_cyc_rdy) ? 1'b1 :
                        (exec_state == RD_SRC_2_LO & bus_cyc_rdy) ? 1'b1 :
                        1'b0;
   
   assign adr_tmp_inc = (op == MOVEM & exec_state == RD_SRC_1 & bus_cyc_rdy) ? 1'b1 :
                        (exec_state == RD_SRC_1_HI & bus_cyc_rdy) ? 1'b1 :
                        (exec_state == RD_SRC_1_LO & bus_cyc_rdy) ? 1'b1 :
                        (exec_state == RD_SRC_2_HI & bus_cyc_rdy) ? 1'b1 :
                        (op == MOVEM & exec_state == WR_DEST_1 & bus_cyc_rdy) ? 1'b1 :
                        (exec_state == WR_DEST_1_HI & bus_cyc_rdy) ? 1'b1 :
                        (exec_state == WR_DEST_1_LO & bus_cyc_rdy) ? 1'b1 :
                        (exec_state == WR_DEST_2_HI & bus_cyc_rdy) ? 1'b1 :
                        1'b0;
   
   assign usp_cpy = (op == MOVE_USP & op_end_i) ? 1'b1 :  1'b0;
   
   assign sp_add_displ = (op == LINK & op_end_i) ? 1'b1 :  1'b0;
   
   assign usp_inc = (exec_state == RD_SP & bus_cyc_rdy & sbit_i == 1'b0) ? 1'b1 :
                    (op == UNLK & regsel_20 == 3'b111) ? 1'b0 : // Do not increment the stack during UNLK A7.
                    (exec_state == RD_SP_HI & bus_cyc_rdy & sbit_i == 1'b0) ? 1'b1 :
                    (exec_state == RD_SP_LO & bus_cyc_rdy & sbit_i == 1'b0) ? 1'b1 :
                    1'b0;
   
   assign usp_dec = (exec_state != WR_SP_HI & next_exec_state == WR_SP_HI & sbit_i == 1'b0) ? 1'b1 :
                    (exec_state != WR_SP_LO & next_exec_state == WR_SP_LO & sbit_i == 1'b0) ? 1'b1 :
                    1'b0;
   
   assign ssp_inc = (exec_state == RD_SP & bus_cyc_rdy & sbit_i) ? 1'b1 :
                    (op == UNLK & regsel_20 == 3'b111) ? 1'b0 : // Do not increment the stack during UNLK A7.
                    (exec_state == RD_SP_HI & bus_cyc_rdy & sbit_i) ? 1'b1 :
                    (exec_state == RD_SP_LO & bus_cyc_rdy & sbit_i) ? 1'b1 :
                    1'b0;
   
   // Decrement before use:
   assign ssp_dec = (exec_state != WR_SP_HI & next_exec_state == WR_SP_HI & sbit_i) ? 1'b1 :
                    (exec_state != WR_SP_LO & next_exec_state == WR_SP_LO & sbit_i) ? 1'b1 :
                    1'b0;
   
   assign pc_add_displ = ((op == BRA | op == BSR) & op_end_i) ? 1'b1 :
                         (op == BCC & cond & op_end_i) ? 1'b1 :
                         (op == DBCC & op_end_i & cond == 1'b0 & dbcc_cond == 1'b0) ? 1'b1 :
                         1'b0;
   
   assign pc_inc = op_end_i ? 1'b1 : 1'b0;
   
   assign pc_tmp_clr = (exec_state == IDLE) ? 1'b1 : 1'b0;
   
   // The PC_TMP may increment during the fetch phase but must not increment in the last step of the fetch phase.
   assign pc_tmp_inc = (exec_state == FETCH_BIW_1 & bus_cyc_rdy & next_exec_state == FETCH_BIW_2) ? 1'b1 :
                       (exec_state == FETCH_BIW_1 & bus_cyc_rdy & next_exec_state == FETCH_EXT) ? 1'b1 :
                       (exec_state == FETCH_BIW_1 & bus_cyc_rdy & next_exec_state == FETCH_DEST_EXT) ? 1'b1 :
                       (exec_state == FETCH_BIW_2 & bus_cyc_rdy & next_exec_state == FETCH_BIW_3) ? 1'b1 :
                       (exec_state == FETCH_BIW_2 & bus_cyc_rdy & next_exec_state == FETCH_EXT) ? 1'b1 :
                       (exec_state == FETCH_BIW_3 & bus_cyc_rdy & next_exec_state == FETCH_EXT) ? 1'b1 :
                       (exec_state == FETCH_EXT & bus_cyc_rdy & next_exec_state == FETCH_EXT) ? 1'b1 :
                       (exec_state == FETCH_EXT & bus_cyc_rdy & next_exec_state == FETCH_DEST_EXT) ? 1'b1 :
                       (exec_state == FETCH_DEST_EXT & bus_cyc_rdy & next_exec_state == FETCH_DEST_EXT) ? 1'b1 :
                       1'b0;
   
   assign pc_init = (op == RTE & exec_state == RD_SP_LO & bus_cyc_rdy) ? 1'b1 :
                    (op == RTR & exec_state == RD_SP_LO & bus_cyc_rdy) ? 1'b1 :
                    (op == RTS & exec_state == RD_SP_LO & bus_cyc_rdy) ? 1'b1 :
                    1'b0;
   
   assign pc_wr = ((op == JMP | op == JSR) & op_end_i) ? 1'b1 : 1'b0;
   
   assign sr_wr = ((op == ANDI_TO_SR | op == EORI_TO_SR | op == ORI_TO_SR) & op_end_i) ? 1'b1 :
                  ((op == MOVE_TO_SR | op == RTE) & op_end_i) ? 1'b1 :
                  ((op == STOP) & exec_state == FETCH_BIW_2 & bus_cyc_rdy) ? 1'b1 :
                  1'b0;
   
   assign ccr_wr = ((op == ANDI_TO_CCR | op == EORI_TO_CCR | op == ORI_TO_CCR) & op_end_i) ? 1'b1 :
                   ((op == MOVE_TO_CCR) & op_end_i) ? 1'b1 :
                   ((op == RTR) & exec_state == RD_SP & bus_cyc_rdy) ? 1'b1 :
                   1'b0;
   
   // Test at the end of the CHK operation:
   assign trap_chk_en = (op == CHK) ? op_end_i : 1'b0;
   
   // Enables the reset counter in the bus interface.
   // Assert the RESET_EN before WAIT_OPERATION to initialise the reset logic in the bus controller unit by time.
   assign reset_en = (op == RESET & next_exec_state == WAIT_OPERATION | exec_state == WAIT_OPERATION) ? 1'b1 : 1'b0;
   
   assign updt_cc = (adr_mode != 3'b001) ? op_end_i : 1'b0; // Valid for ADDQ and SUBQ.
   
   assign cc_updt = (op == ADDQ | op == SUBQ) ? updt_cc : 
		    (op == ABCD | op == ADD | op == ADDI | op == ADDX | op == AND_B | op == ANDI | op == ASL |
		     op == ASR | op == BCHG | op == BCLR | op == BSET | op == BTST | op == CHK | op == CLR |
		     op == CMP | op == CMPA | op == CMPI | op == CMPM | op == DIVS | op == DIVU | op == EOR |
		     op == EORI | op == EXTW | op == LSL | op == LSR | op == MOVE | op == MOVEQ | op == MULS |
		     op == MULU | op == NBCD | op == NEG | op == NEGX | op == NOT_B | op == OR_B | op == ORI |
		     op == ROTL | op == ROTR | op == ROXL | op == ROXR | op == SBCD | op == SUB | op == SUBI |
		     op == SUBX | op == SWAP | op == TAS | op == TST) ? op_end_i : 
		    1'b0;
   
   // The 16 bit bus must be written in two portions: hi word and low word. 
   // This control is not valid for MOVEP.
   assign wr_hi = (exec_state == WR_DEST_1_HI | exec_state == WR_DEST_2_HI) ? 1'b1 :
                  (exec_state == WR_SP_HI) ? 1'b1 :
                  1'b0;
   
   assign wr_bus = wr_bus_i;
   assign wr_bus_i = (exec_state == WR_DEST_1) ? 1'b1 :
                     (exec_state == WR_DEST_1_HI) ? 1'b1 :
                     (exec_state == WR_DEST_1_LO) ? 1'b1 :
                     (exec_state == WR_DEST_2_HI) ? 1'b1 :
                     (exec_state == WR_DEST_2_LO) ? 1'b1 :
                     (exec_state == WR_SP_HI) ? 1'b1 :
                     (exec_state == WR_SP_LO) ? 1'b1 :
                     1'b0;
   
   assign rd_bus = rd_bus_i;
   
   assign rd_bus_i = (exec_state == FETCH_BIW_1 & (ctrl_en | traplock))  ? 1'b1 :
                     // The previous condition disables the bus cycle if the controller
                     // is disabled by the exception handler. This condtion occurs, when
                     // an exception is detected during the last clock cycle of an 
                     // instruction. In this case, the EXEC_STATE changes to FETCH_BIW_1
                     // and simultaneously, the EX_STATE machine changes from it's IDLE.
                     (exec_state == FETCH_BIW_2) ? 1'b1 :
                     (exec_state == FETCH_BIW_3) ? 1'b1 :
                     (exec_state == FETCH_EXT) ? 1'b1 :
                     (exec_state == FETCH_DEST_EXT) ? 1'b1 :
                     (exec_state == RD_SRC_1) ? 1'b1 :
                     (exec_state == RD_SRC_1_HI) ? 1'b1 :
                     (exec_state == RD_SRC_1_LO) ? 1'b1 :
                     (exec_state == RD_SRC_2) ? 1'b1 :
                     (exec_state == RD_SRC_2_HI) ? 1'b1 :
                     (exec_state == RD_SRC_2_LO) ? 1'b1 :
                     (exec_state == RD_SP) ? 1'b1 :
                     (exec_state == RD_SP_HI) ? 1'b1 :
                     (exec_state == RD_SP_LO) ? 1'b1 :
                     1'b0;
   
   // This process is the status register with
   // it's related logic.

   assign sreg_new[9:8] =
			 init_status ? 2'b01 :
			 (sr_wr & op == RTE) ? sreg_mem_tmp[9:8] :
			 sr_wr ? {sr_ccr_in[15],sr_ccr_in[13]} :
			 sreg_mem[9:8];

   assign sreg_new[7:5] = 
			  preset_irq_mask ? 3'b111 :
			  irq_save ? irq :
			  (sr_wr & op == RTE) ? sreg_mem_tmp[7:5] :
			  sr_wr ? sr_ccr_in[10:8] :
			  sreg_mem[7:5];

   assign sreg_new[4:0] = cc_updt ? xnzvc_in :
			  (sr_wr & op == RTE) ? sreg_mem_tmp[4:0] :
			  sr_wr ? sr_ccr_in[4:0] :
			  ccr_wr ? sr_ccr_in[4:0] :
			  sreg_mem[4:0];
	  
   always @(posedge clk or negedge resetn)
     if (~resetn)
       begin
	  sreg_mem <= 10'h0f0;
          sreg_mem_tmp <= 10'b0;

	  status_reg <= 16'h2700;
	  status_reg_out <= 16'h2700;
       end
     else 
       begin 
          // *. Store a temporary copy of the status register and restore it
          // in the end of the RTE instruction. This is important to
          // handle the correct stacks when the supervisor bit is modified
          // in the trap handler routine.
          if (op == RTE & exec_state == RD_SP & bus_cyc_rdy)
            sreg_mem_tmp <= {sr_ccr_in[15],sr_ccr_in[13],sr_ccr_in[10:8],sr_ccr_in[4:0]};

	  sreg_mem <= sreg_new;

          status_reg <= {sreg_new[9],1'b0,sreg_new[8],2'b00,sreg_new[7:5],3'b000,sreg_new[4:0]};
          status_reg_out <= status_reg;
       end
       
   // This process provides the temporary counting of the already read extension words.
   // The process is modeled in a way that the counters are incremented before the
   // bus cycle is ready. This kind of realization gives the correct number of counted
   // extension words, every time, when the BUS_CYC_RDY signal appears in the two states
   // FETCH_EXT and FETCH_DEST_EXT.
   always @(posedge clk or negedge resetn)
      if (~resetn)
        begin 
           src_tmp <= 0;
           dest_tmp <= 0;
           exword_counter_lock <= 1'b0;
        end
      else 
        begin 
           if (exec_state == FETCH_BIW_1)
             begin 
                src_tmp <= 0;
                dest_tmp <= 0;
                exword_counter_lock <= 1'b0;
             end
	   // For the extensions:
           else if (exec_state == FETCH_EXT & ~bus_cyc_rdy & ~exword_counter_lock)
             begin 
                src_tmp <= src_tmp + 2'd1;
                exword_counter_lock <= 1'b1;
             end
           else if (exec_state == FETCH_EXT & bus_cyc_rdy)
             exword_counter_lock <= 1'b0;
           else if (exec_state == FETCH_DEST_EXT & ~bus_cyc_rdy & ~exword_counter_lock)
             begin 
                dest_tmp <= dest_tmp + 2'd1;
                exword_counter_lock <= 1'b1;
             end
	   // And for the destination extensions:
           else if (exec_state == FETCH_DEST_EXT & bus_cyc_rdy)
             exword_counter_lock <= 1'b0;
           
	   // The extension word address:
           if (exec_state == FETCH_EXT & src_tmp > 0)
//             ew_adr <= src_tmp - 1;
             ew_adr <= (src_tmp - 2'd1) != 0 ? 1'b1 : 1'b0;
           else if (exec_state == FETCH_DEST_EXT & dest_tmp > 0)
//             ew_adr <= dest_tmp - 1;
             ew_adr <= (dest_tmp - 2'd1) != 0 ? 1'b1 : 1'b0;
           else 
             ew_adr <= 0;
        end
   
   always @(src_tmp or ext_cnt or dest_tmp or dest_ext_cnt)
     begin
        if (src_tmp == ext_cnt)
          got_ext = 1'b1;
        else 
          got_ext = 1'b0;
               
        if (dest_tmp == dest_ext_cnt)
          got_dest_ext = 1'b1;
        else 
          got_dest_ext = 1'b0;
     end 

   // The MOVEM command takes the REGLISTMASK flags to control, which registers
   // have to be written or not. The behavior of the reading or writing depends
   // on the MOVEM operation mode and is controlled in this process.

   always @(posedge clk or negedge resetn)
     begin 
      if (~resetn)
        begin
	   bit_pnt_r <= 5'b0;
	   regsel_tmp_r <= 3'b0;
           movem_pi_corr <= 1'b0;
        end
      else 
        begin 
	   bit_pnt_r <= bit_pnt;
	   regsel_tmp_r <= regsel_tmp;
	   
           case (bit_pnt)
             16 : 
               movem_en <= 1'b0;
             default : 
               movem_en <= 1'b1;
           endcase

           if (bit_pnt <= 7 & adr_mode == 3'b100)
             movem_adn_i <= 1'b1; // Predecrement address mode.
           else if (bit_pnt > 7 & adr_mode != 3'b100)
             movem_adn_i <= 1'b1; // Other addressing modes.
           else 
             movem_adn_i <= 1'b0; // Select data registers.
           
           if (adr_mode == 3'b011 & regsel_tmp == regsel_20 & bit_pnt > 7 & bit_pnt < 16 & reglistmask[bit_pnt[3:0]])
	     // Special case: in the postincrement mode, the addressing register is written with the postincremented 
	     // effective address: suppress the respective memory access.
             movem_pi_corr <= 1'b1;
           else 
             movem_pi_corr <= 1'b0;
           
           movem_adn <= movem_adn_i;
           movem_regsel <= regsel_tmp;
        end
   end

   always @(exec_state or next_exec_state or adr_mode or bit_pnt_r or regsel_tmp_r)
     begin 
	bit_pnt = bit_pnt_r;
	regsel_tmp = regsel_tmp_r;

	// Be aware, that the bit pointer starts always at a value of zero. It points 
	// to the register list mask, which's entries depend on the MOVEM addressing mode.
        if (exec_state == FETCH_BIW_1)
          begin 
             bit_pnt = 5'b0;// Clear at operation start.
             case (adr_mode)
               3'b100 : 
                 regsel_tmp = 3'b111;// Predecrement mode.
               default : 
                 regsel_tmp = 3'b000;
             endcase
          end
	// In the following two conditions, the bit 
	// pointer is modified befor the MOVEM_TST state!
        else if (next_exec_state == MOVEM_TST)
          begin 
             bit_pnt = bit_pnt_r + 5'd1;
             case (adr_mode)
               3'b100 : 
                 regsel_tmp = regsel_tmp_r - 3'd1; // Predecrement mode.
               default : 
                 regsel_tmp = regsel_tmp_r + 3'd1;
             endcase
          end
     end

   always @(adr_mode or regsel_tmp_r or regsel_20 or movem_adn_i or dr or reglistmask or bit_pnt_r)
     begin 
	//
	// The MOVEM_CPY must be asserted asynchronous due to the latency of the REGLISTMASK
	// in the FETCH_BIW_2 control state:
        if (adr_mode == 3'b011 & regsel_tmp_r/*regsel_tmp*/ == regsel_20 & movem_adn_i & dr)
          movem_cpy = 1'b0; // Do not overwrite the addressing register with the value from the stack.
        else 
          movem_cpy = reglistmask[bit_pnt_r/*bit_pnt*/[3:0]];
     end 


   // This flag enables the recognition of exceptions in the first
   // clock cycle of the main state FETCH_BIW_1. During all other
   // clock cycles, the recognition is disabled to avoid breaks of
   // started bus cycles.
   
   always @(posedge clk or negedge resetn)
     if (~resetn)
       traplock <= 1'b0;
     else
       begin 
          if (exec_state != FETCH_BIW_1)
            traplock <= 1'b0;
          else if ((exec_state == FETCH_BIW_1) & bus_cyc_rdy)
            traplock <= 1'b0;
          else if (exec_state == FETCH_BIW_1)
            traplock <= 1'b1;
       end
   
   
   always @(posedge clk or negedge resetn) 
     if (~resetn)
       exec_state <= IDLE;
     else 
       if (exec_abort & bus_cyc_rdy)
         exec_state <= IDLE; // Abort current execution.
       else 
         exec_state <= next_exec_state;
   
   always @(exec_state or ctrl_en or traplock or bus_cyc_rdy or force_biw2 or force_biw3 or
            got_ext or got_dest_ext or shft_busy or op or rm or reset_rdy or op_mode or op_size or
            cond or exec_resume or adr_mode or div_mul_32n64 or op_busy or status_reg or
            move_d_am or movem_en or movem_cpy or dr or mem_shft or dest_ext_cnt or
            reglistmask or regsel_20 or trap_priv )
     begin
	case (exec_state)
	  IDLE : 
            if (ctrl_en)
              next_exec_state = FETCH_BIW_1;
            else 
              next_exec_state = IDLE;

	  //------------------------- Fetch operation and extension words -----------------------------
	  // The FETCH phase is used to simultaneously start several operations. The ADR_MODE and the
	  // OP_SIZE etc. is not required because this information is included implicitely in the
	  // FORCE_BIWx and the FETCH_x_EXT signals.
	  FETCH_BIW_1 : 
            if (ctrl_en == 1'b0 & traplock == 1'b0)
              next_exec_state = IDLE; // Break due to exceptions.
            else if (bus_cyc_rdy & trap_priv)
              next_exec_state = IDLE; // Exception without modifying any registers.
            else if (bus_cyc_rdy & force_biw2)
              next_exec_state = FETCH_BIW_2;
            else if (bus_cyc_rdy & got_ext == 1'b0)
              next_exec_state = FETCH_EXT; // Source extension required.
            else if (bus_cyc_rdy & got_dest_ext == 1'b0)
              next_exec_state = FETCH_DEST_EXT; // Destination extension required.
            else if (bus_cyc_rdy)
              case (op)
		RESET : 
		  next_exec_state = WAIT_OPERATION;
		ILLEGAL,UNIMPLEMENTED,RESERVED : 
		  next_exec_state = IDLE;
		TRAP,TRAPV : 
		  next_exec_state = FETCH_BIW_1;
		ABCD,SBCD,ADDX,SUBX : 
		  if (rm == 1'b0) // Register direct.
                    next_exec_state = FETCH_BIW_1;
		  else if (op_size == LONG) // Memory to memory, long.
                    next_exec_state = RD_SRC_1_HI;
		  else // Memory to memory, word or byte (Byte for ABCD, SBCD).
                    next_exec_state = RD_SRC_1;

		ADD,AND_B,EOR,SUB,OR_B : 
		  if (adr_mode == 3'b000 | adr_mode == 3'b001)
                    next_exec_state = FETCH_BIW_1;
		  else if (op_mode == 3'b010 | op_mode == 3'b110)
                    next_exec_state = RD_SRC_1_HI;
		  else 
                    next_exec_state = RD_SRC_1;

		ADDA,CMPA,SUBA : 
		  if (adr_mode == 3'b000 | adr_mode == 3'b001)
                    next_exec_state = FETCH_BIW_1;
		  else if (op_mode == 3'b111)
                    next_exec_state = RD_SRC_1_HI;
		  else 
                    next_exec_state = RD_SRC_1;
		
		ASL,ASR,LSL,LSR,ROTL,ROTR,ROXL,ROXR : 
		  if (mem_shft == 1'b0) // Register shift.
                    next_exec_state = WAIT_OPERATION;
		  else // Restricted to WORD.
                    next_exec_state = RD_SRC_1;

		BCC,BRA,EXG,EXTW,JMP,LEA,MOVEQ,MOVE_USP,NOP,SWAP : 
		  next_exec_state = FETCH_BIW_1;
		BCHG,BCLR,BSET,BTST : 
		  if (adr_mode == 3'b000)
                    next_exec_state = FETCH_BIW_1;
		  else // Byte wide memory access.
                    next_exec_state = RD_SRC_1;

		BSR,JSR,PEA : 
		  next_exec_state = WR_SP_LO;
		CHK,NEG,NEGX,NOT_B : 
		  if (adr_mode == 3'b000)
                    next_exec_state = FETCH_BIW_1;
		  else if (op_size == LONG)
                    next_exec_state = RD_SRC_1_HI;
		  else 
                    next_exec_state = RD_SRC_1;
		
		CLR : 
		  if (adr_mode == 3'b000)
                    next_exec_state = FETCH_BIW_1;
		  else if (op_size == LONG)
                    next_exec_state = WR_DEST_1_HI;
		  else 
                    next_exec_state = WR_DEST_1;
		
		CMP : 
		  if (adr_mode == 3'b000 | adr_mode == 3'b001)
                    next_exec_state = FETCH_BIW_1;
		  else if (op_mode == 3'b010)
                    next_exec_state = RD_SRC_1_HI;
		  else 
                    next_exec_state = RD_SRC_1;

		
		CMPM : 
		  if (op_size == LONG)
                    next_exec_state = RD_SRC_1_HI;
		  else 
                    next_exec_state = RD_SRC_1;

		
		DIVS,DIVU,MULS,MULU : 
		  if (adr_mode == 3'b000)
                    next_exec_state = WAIT_OPERATION;
		  else 
		    // In this state only OP_SIZE
		    // = WORD is valid.
                    next_exec_state = RD_SRC_1;

		
		MOVE : 
		  if ((adr_mode == 3'b000 | adr_mode == 3'b001) & (move_d_am == 3'b000))
                    next_exec_state = FETCH_BIW_1;
		  else if (adr_mode == 3'b001 | adr_mode == 3'b000)
                    begin 
                       if (op_size == LONG)
			 next_exec_state = WR_DEST_1_HI;
                       else 
			 next_exec_state = WR_DEST_1;
                    end 
		  else 
                    begin 
                       if (op_size == LONG)
			 next_exec_state = RD_SRC_1_HI;
                       else 
			 next_exec_state = RD_SRC_1;
                    end 

		
		MOVEA : 
		  if (adr_mode == 3'b000 | adr_mode == 3'b001)
                    next_exec_state = FETCH_BIW_1;
		  else 
                    case (op_size)
                      LONG : next_exec_state = RD_SRC_1_HI;
                      default : next_exec_state = RD_SRC_1;
                    endcase

		
		MOVE_FROM_CCR,MOVE_FROM_SR,SCC : 
		  if (adr_mode == 3'b000)
                    next_exec_state = FETCH_BIW_1;
		  else 
                    next_exec_state = WR_DEST_1;

		
		NBCD,MOVE_TO_CCR,MOVE_TO_SR,TAS : 
		  if (adr_mode == 3'b000)
                    next_exec_state = FETCH_BIW_1;
		  else 
                    next_exec_state = RD_SRC_1;

		
		RTE,RTR : 
		  next_exec_state = RD_SP;
		RTS : 
		  next_exec_state = RD_SP_HI;
		ADDQ,SUBQ,TST : 
		  if (adr_mode == 3'b000 | adr_mode == 3'b001)
                    next_exec_state = FETCH_BIW_1;
		  else 
                    begin 
                       if (op_size == LONG)
			 next_exec_state = RD_SRC_1_HI;
                       else 
			 next_exec_state = RD_SRC_1;
                    end 
		
		UNLK : 
		  next_exec_state = RD_SP_HI;
		default : 
		  next_exec_state = FETCH_BIW_1;
              endcase
            else 
              next_exec_state = FETCH_BIW_1;

	  
	  FETCH_BIW_2 : 
            if (bus_cyc_rdy & force_biw3)
              next_exec_state = FETCH_BIW_3;
            else if (bus_cyc_rdy & got_ext == 1'b0)
              next_exec_state = FETCH_EXT;
            else if (bus_cyc_rdy)
              case (op)
		ADDI,ANDI,CMPI,EORI,ORI,SUBI : 
		  if (adr_mode == 3'b000)
                    next_exec_state = FETCH_BIW_1;
		  else 
                    case (op_size)
                      LONG : next_exec_state = RD_SRC_1_HI;
                      default : next_exec_state = RD_SRC_1;
                    endcase
		
		BCC,BRA : 
		  next_exec_state = FETCH_BIW_1;
		ANDI_TO_SR,ANDI_TO_CCR,EORI_TO_SR,EORI_TO_CCR,ORI_TO_CCR,ORI_TO_SR : 
		  next_exec_state = FETCH_BIW_1;
		BCHG,BCLR,BSET,BTST : 
		  if (adr_mode == 3'b000)
                    next_exec_state = FETCH_BIW_1;
		  else 
                    next_exec_state = RD_SRC_1;
		
		BSR,LINK : 
		  next_exec_state = WR_SP_LO;
		DBCC : 
		  if (cond)
                    next_exec_state = FETCH_BIW_1;
		  else 
                    next_exec_state = WAIT_OPERATION;
		
		DIVS,DIVU,MULS,MULU : 
		  if (adr_mode == 3'b000)
                    next_exec_state = WAIT_OPERATION;
		  else 
		    // In this state only OP_SIZE
		    // = LONG is valid.
                    next_exec_state = RD_SRC_1_HI;
		
		MOVEM : 
		  if (reglistmask == 16'h0000)
                    next_exec_state = FETCH_BIW_1; // Do nothing.
		  else if (movem_cpy & op_size == LONG & dr)
                    next_exec_state = RD_SRC_1_HI; // Memory to register LONG.
		  else if (movem_cpy & op_size == LONG)
                    next_exec_state = WR_DEST_1_HI; // Register to memory LONG.
		  else if (movem_cpy & dr)
                    next_exec_state = RD_SRC_1; // Memory to register WORD.
		  else if (movem_cpy)
                    next_exec_state = WR_DEST_1; // Register to memory WORD.
		  else // CPY = '0', modify the bit pointer in the MOVEM control logic.
                    next_exec_state = MOVEM_TST; // No transfer.

		
		MOVEP : 
		  if (op_mode == 3'b101)
                    next_exec_state = RD_SRC_1_HI; // Memory to register, long.
		  else if (op_mode == 3'b100)
                    next_exec_state = RD_SRC_2_HI; // Memory to register, word.
		  else if (op_mode == 3'b111)
                    next_exec_state = WR_DEST_1_HI; // Register to memory, long.
		  else // OP_MODE = "110"
                    next_exec_state = WR_DEST_2_HI;

		STOP : 
		  if (status_reg[15]) // Trace condition.
                    next_exec_state = FETCH_BIW_1;
		  else 
                    next_exec_state = WAIT_OPERATION;
		
		default : 
		  next_exec_state = FETCH_BIW_1; // Should never appear.
              endcase
            else 
              next_exec_state = FETCH_BIW_2;

	  
	  FETCH_BIW_3 : 
            if (bus_cyc_rdy & (got_ext == 1'b0))
              next_exec_state = FETCH_EXT;
            else if (bus_cyc_rdy)
              case (op)
		ADDI,ANDI,CMPI,EORI,ORI,SUBI : 
		  if (adr_mode == 3'b000)
                    next_exec_state = FETCH_BIW_1;
		  else 
                    case (op_size)
                      LONG : next_exec_state = RD_SRC_1_HI;
                      default : next_exec_state = RD_SRC_1;
                    endcase
		
		BCC,BRA : 
		  next_exec_state = FETCH_BIW_1;
		BSR,LINK : 
		  next_exec_state = WR_SP_LO;
		default : 
		  next_exec_state = FETCH_BIW_1; // Should never appear.
              endcase
            else 
              next_exec_state = FETCH_BIW_3;

	  
	  FETCH_EXT : 
            if (bus_cyc_rdy & got_ext & got_dest_ext == 1'b0)
              next_exec_state = FETCH_DEST_EXT; // This is for the MOVE operation.
            else if (bus_cyc_rdy & got_ext)
              case (op)
		ADD,AND_B,SUB,OR_B : 
		  if (adr_mode == 3'b111 & regsel_20 == 3'b100) // Immediate data.
                    next_exec_state = FETCH_BIW_1;
		  else 
                    begin 
                       if (op_mode == 3'b010 | op_mode == 3'b110)
			 next_exec_state = RD_SRC_1_HI;
                       else 
			 next_exec_state = RD_SRC_1;
                    end 
		
		EOR : 
		  if (op_mode == 3'b010 | op_mode == 3'b110)
                    next_exec_state = RD_SRC_1_HI;
		  else 
                    next_exec_state = RD_SRC_1;

		ADDA,CMPA,SUBA : 
		  if (adr_mode == 3'b111 & regsel_20 == 3'b100)
                    next_exec_state = FETCH_BIW_1; // Immediate data.
		  else 
                    begin 
                       if (op_mode == 3'b111)
			 next_exec_state = RD_SRC_1_HI;
                       else 
			 next_exec_state = RD_SRC_1;
                    end 

		ADDI,ADDQ,ANDI,CMPI,EORI,NEG,NEGX,NOT_B,ORI,SUBI,SUBQ : 
		  case (op_size)
                    LONG : next_exec_state = RD_SRC_1_HI;
                    default : next_exec_state = RD_SRC_1;
		  endcase
		ASL,ASR,LSL,LSR,ROTL,ROTR,ROXL,ROXR : 
		  next_exec_state = RD_SRC_1;
		BTST,MOVE_TO_CCR,MOVE_TO_SR : 
		  if (adr_mode == 3'b111 & regsel_20 == 3'b100)
                    next_exec_state = FETCH_BIW_1; // Immediate data.
		  else 
                    next_exec_state = RD_SRC_1; // A memory access is always BYTE wide.

		BCHG,BCLR,BSET : 
		  next_exec_state = RD_SRC_1; //  A memory access is always BYTE wide.
		CHK,MOVEA,TST : 
		  if (adr_mode == 3'b111 & regsel_20 == 3'b100)
                    next_exec_state = FETCH_BIW_1; // Immediate data.
		  else 
                    case (op_size)
                      LONG : next_exec_state = RD_SRC_1_HI;
                      default : next_exec_state = RD_SRC_1;
                    endcase

		DIVS,DIVU,MULS,MULU : 
		  if (adr_mode == 3'b111 & regsel_20 == 3'b100)
                    next_exec_state = WAIT_OPERATION; // Immediate data.
		  else 
                    case (op_size)
		      // For DIVS, DIVU, MULS, MULU the OP_SIZE is
		      // always LONG in this state.
                      LONG : next_exec_state = RD_SRC_1_HI;
                      default : next_exec_state = RD_SRC_1;
                    endcase
		
		CLR : 
		  if (op_size == LONG)
                    next_exec_state = WR_DEST_1_HI;
		  else 
                    next_exec_state = WR_DEST_1;
		
		CMP : 
		  if (adr_mode == 3'b111 & regsel_20 == 3'b100)
                    next_exec_state = FETCH_BIW_1; // Immediate data.
		  else 
                    begin 
                       if (op_mode == 3'b010)
			 next_exec_state = RD_SRC_1_HI;
                       else 
			 next_exec_state = RD_SRC_1;
                    end 
		
		MOVE : 
		  if ((adr_mode == 3'b111 & regsel_20 == 3'b100) & (move_d_am == 3'b000))
                    next_exec_state = FETCH_BIW_1; // Immediate data to data registers.
		  else if (adr_mode == 3'b111 & regsel_20 == 3'b100)
                    case (op_size)
                      LONG : next_exec_state = WR_DEST_1_HI; // Immediate long to memory.
                      default : next_exec_state = WR_DEST_1; // Immediate word to memory.
                    endcase
		  else 
                    case (op_size)
                      LONG : next_exec_state = RD_SRC_1_HI;
                      default : next_exec_state = RD_SRC_1;
                    endcase
		
		MOVEM : 
		  if (reglistmask == 16'h0000)
                    next_exec_state = FETCH_BIW_1; // Do nothing.
		  else if (movem_cpy & op_size == LONG & dr)
                    next_exec_state = RD_SRC_1_HI; // Memory to register LONG.
		  else if (movem_cpy & op_size == LONG)
                    next_exec_state = WR_DEST_1_HI; // Register to memory LONG.
		  else if (movem_cpy & dr)
                    next_exec_state = RD_SRC_1; // Memory to register WORD.
		  else if (movem_cpy)
                    next_exec_state = WR_DEST_1; // Register to memory WORD.
		  else // CPY = '0', modify the bit pointer in the MOVEM control logic.
                    next_exec_state = MOVEM_TST; // No transfer.

		
		MOVE_FROM_CCR,MOVE_FROM_SR,SCC : 
		  next_exec_state = WR_DEST_1;
		NBCD,TAS : 
		  next_exec_state = RD_SRC_1; // WORD or BYTE for NBCD, BYTE for TAS.
		JMP,LEA : 
		  next_exec_state = FETCH_BIW_1;
		JSR,PEA : 
		  next_exec_state = WR_SP_LO;
		default : 
		  next_exec_state = FETCH_BIW_1; // Should never appear.
              endcase
            else 
              next_exec_state = FETCH_EXT;
	  
	  FETCH_DEST_EXT : // This state is exclusively used by the MOVE operation.
            if (bus_cyc_rdy & got_dest_ext)
              begin 
		 if ((adr_mode == 3'b000 | adr_mode == 3'b001 | adr_mode == 3'b111) & regsel_20 == 3'b100) // No external source required.
                   begin 
                      if (op_size == LONG)
			next_exec_state = WR_DEST_1_HI;
                      else 
			next_exec_state = WR_DEST_1;
                   end 
		 else 
                   begin 
                      if (op_size == LONG)
			next_exec_state = RD_SRC_1_HI;
                      else 
			next_exec_state = RD_SRC_1;
                   end 
              end 
            else 
              next_exec_state = FETCH_DEST_EXT;
	  //----------------------- End fetch operation and extension words ---------------------------

	  RD_SRC_1 : 
            if (bus_cyc_rdy)
              case (op)
		ABCD,SBCD,ADDX,SUBX,CMPM : 
		  next_exec_state = RD_SRC_2;
		ADD,AND_B,SUB,OR_B : 
		  if (op_mode == 3'b100 | op_mode == 3'b101)
                    next_exec_state = WR_DEST_1;
		  else 
                    next_exec_state = FETCH_BIW_1;

		
		MOVE : 
		  if (move_d_am == 3'b000)
                    next_exec_state = FETCH_BIW_1;
		  else 
                    next_exec_state = WR_DEST_1;

		
		ADDI,ADDQ,ANDI,EOR,EORI,NEG,NEGX,NOT_B,ORI,SUBI,SUBQ : 
		  next_exec_state = WR_DEST_1;
		ADDA,SUBA,BTST,CHK,CMP,CMPA,CMPI,MOVEA,MOVE_TO_CCR,MOVE_TO_SR,TST : 
		  next_exec_state = FETCH_BIW_1;
		ASL,ASR,LSL,LSR,ROTL,ROTR,ROXL,ROXR : 
		  next_exec_state = WAIT_OPERATION;
		BCHG,BCLR,BSET,NBCD,TAS : 
		  next_exec_state = WR_DEST_1;
		DIVS,DIVU,MULS,MULU : 
		  next_exec_state = WAIT_OPERATION;
		MOVEM : 
		  next_exec_state = MOVEM_TST;
		default : 
		  next_exec_state = FETCH_BIW_1; // Should never appear.
              endcase
            else 
              next_exec_state = RD_SRC_1;

	  
	  RD_SRC_1_HI : 
            if (bus_cyc_rdy)
              next_exec_state = RD_SRC_1_LO;
            else 
              next_exec_state = RD_SRC_1_HI;

	  
	  RD_SRC_1_LO : 
            if (bus_cyc_rdy)
              case (op)
		ADDI,ADDQ,ANDI,EOR,EORI,NEG,NEGX,NOT_B,SUBI,SUBQ,ORI : 
		  next_exec_state = WR_DEST_1_HI;
		ADD,AND_B,SUB,OR_B : 
		  if (op_mode == 3'b110)
                    next_exec_state = WR_DEST_1_HI;
		  else 
                    next_exec_state = FETCH_BIW_1;

		
		MOVE : 
		  if (move_d_am == 3'b000)
                    next_exec_state = FETCH_BIW_1;
		  else 
                    next_exec_state = WR_DEST_1_HI;

		
		ADDA,CHK,CMP,CMPA,CMPI,MOVEA,SUBA,TST : 
		  next_exec_state = FETCH_BIW_1;
		ADDX,SUBX,CMPM,MOVEP : 
		  next_exec_state = RD_SRC_2_HI;
		DIVS,DIVU,MULS,MULU : 
		  next_exec_state = WAIT_OPERATION;
		MOVEM : 
		  next_exec_state = MOVEM_TST;
		default : 
		  next_exec_state = FETCH_BIW_1; // Should never appear.
              endcase
            else 
              next_exec_state = RD_SRC_1_LO;
	  
	  RD_SRC_2 : 
            if (op == CMPM & bus_cyc_rdy)
              next_exec_state = FETCH_BIW_1;
            else if (bus_cyc_rdy) // Used by ABCD, ADDX, SBCD, SUBX.
              next_exec_state = WR_DEST_1;
            else 
              next_exec_state = RD_SRC_2;
	  
	  RD_SRC_2_HI : 
            if (bus_cyc_rdy)
              next_exec_state = RD_SRC_2_LO;
            else 
              next_exec_state = RD_SRC_2_HI;
	  
	  RD_SRC_2_LO : 
            if ((op == ADDX | op == SUBX) & bus_cyc_rdy)
              next_exec_state = WR_DEST_1_HI;
            else if ((op == CMPM | op == MOVEP) & bus_cyc_rdy)
              next_exec_state = FETCH_BIW_1;
            else 
              next_exec_state = RD_SRC_2_LO;
	  
	  WR_DEST_1 : 
            if (op == MOVEM & bus_cyc_rdy)
              next_exec_state = MOVEM_TST;
	  // The default state is used by the following commands:
	  // ABCD, ADD, ADDI, ADDQ, ADDX, AND_B, ANDI, ASL, ASR, 
	  // BCHG, BCLR, BSET, CLR, EOR, EORI, LSL, LSR, 
	  // MOVE_FROM_CCR, MOVE_FROM_SR, MOVE, NBCD, NEG, NEGX,
	  // NOT_B, OR_B, ORI, ROTL, ROTR, ROXL, ROXR, SBCD, Scc,
          // SUB, SUBI, SUBQ, SUBX, TAS.
            else if (bus_cyc_rdy)
              next_exec_state = FETCH_BIW_1;
            else 
              next_exec_state = WR_DEST_1;
	  
	  WR_DEST_1_HI : 
	    // This state is used by the following commands:
	    // ADD, ADDI, ADDQ, ADDX, AND_B, ANDI, CLR, EOR,
	    // EORI, MOVE MOVEP, NEG, NEGX, NOT_B, OR_B,
	    // OR_B, ORI, SUB, SUBI, SUBQ, SUBX.
            if (bus_cyc_rdy)
              next_exec_state = WR_DEST_1_LO;
            else 
              next_exec_state = WR_DEST_1_HI;
	  
	  WR_DEST_1_LO : 
	    // The last condition (Others) is used by the following operations:
	    // ADD, AND_B, CLR, EOR, SUB, OR_B, ADDI, ADDQ, ADDX, SUBI, SUBQ, SUBX, 
	    // ANDI, EORI, ORI, MOVE, NEG, NEGX, NOT_B.
            if (op == MOVEP & bus_cyc_rdy) // Long transfer.
              next_exec_state = WR_DEST_2_HI;
            else if (op == MOVEM & bus_cyc_rdy)
              next_exec_state = MOVEM_TST;
            else if (bus_cyc_rdy) // Others.
              next_exec_state = FETCH_BIW_1;
            else 
              next_exec_state = WR_DEST_1_LO;
	  
	  WR_DEST_2_HI : 
	    // Used by MOVEP.
            if (bus_cyc_rdy)
              next_exec_state = WR_DEST_2_LO;
            else 
              next_exec_state = WR_DEST_2_HI;
	  
	  WR_DEST_2_LO : 
	    // Used by MOVEP.
            if (bus_cyc_rdy)
              next_exec_state = FETCH_BIW_1;
            else 
              next_exec_state = WR_DEST_2_LO;

	  
	  //-------------------------------- Special states  -------------------------------------
	  RD_SP : 
	    // In this state, the 16 bit SR or the 8 bit CCR are affected.
            if (bus_cyc_rdy) // Used by RTE, RTR.
              next_exec_state = RD_SP_HI;
            else 
              next_exec_state = RD_SP;
	  
	  RD_SP_HI : 
            if (bus_cyc_rdy) // Used by RTE, RTR, RTS, UNLK.
              next_exec_state = RD_SP_LO;
            else 
              next_exec_state = RD_SP_HI;
	  
	  RD_SP_LO :  // Used by RTE, RTR, RTS, UNLK.
            if (bus_cyc_rdy)
              next_exec_state = FETCH_BIW_1;
            else 
              next_exec_state = RD_SP_LO;
	  
	  WR_SP_LO : // Used by BSR, JSR, LINK, PEA.
            if (bus_cyc_rdy)
              next_exec_state = WR_SP_HI;
            else 
              next_exec_state = WR_SP_LO;
	  
	  WR_SP_HI : // Used by BSR, JSR, LINK, PEA.
            if (bus_cyc_rdy)
              next_exec_state = FETCH_BIW_1;
            else 
              next_exec_state = WR_SP_HI;
	  
	  WAIT_OPERATION : 
            case (op)
              RESET : 
		if (reset_rdy)
		  next_exec_state = FETCH_BIW_1;
		else 
		  next_exec_state = WAIT_OPERATION;

              STOP : 
		// This state is valid until an interrupt, a trace exception or a
		// reset occurs.
		if (exec_resume)
		  next_exec_state = FETCH_BIW_1;
		else 
		  next_exec_state = WAIT_OPERATION;
              
              ASL,ASR,LSL,LSR,ROTL,ROTR,ROXL,ROXR : 
		if (shft_busy)
		  next_exec_state = WAIT_OPERATION;
		else if (mem_shft == 1'b0)
		  next_exec_state = FETCH_BIW_1;
		else 
		  next_exec_state = WR_DEST_1;
              
              DIVS,DIVU,MULS,MULU : 
		if (op_busy)
		  next_exec_state = WAIT_OPERATION;
		else 
		  next_exec_state = FETCH_BIW_1;
              
              DBCC : 
		next_exec_state = FETCH_BIW_1;
              default : 
		next_exec_state = FETCH_BIW_1; // Should never appear.
            endcase

	  MOVEM_TST : 
            if (movem_en == 1'b0) // BSY = '0'.
              next_exec_state = FETCH_BIW_1; // Operation finished.
            else if (movem_cpy & op_size == LONG & dr)
              next_exec_state = RD_SRC_1_HI; // Memory to register LONG.
            else if (movem_cpy & op_size == LONG)
              next_exec_state = WR_DEST_1_HI; // Register to memory LONG.
            else if (movem_cpy & dr)
              next_exec_state = RD_SRC_1; // Memory to register WORD.
            else if (movem_cpy)
              next_exec_state = WR_DEST_1; // Register to memory WORD.
            else // CPY = '0', modify the bit pointer in the MOVEM control logic.
              next_exec_state = MOVEM_TST; // No transfer.

	  default:
	    next_exec_state = IDLE;
	  
	endcase
     end

`ifdef debug
   always @(posedge clk)
     if (exec_state != next_exec_state && resetn && 0)
       case (next_exec_state)
	 IDLE: $display("exec_state: -> IDLE");
	 FETCH_BIW_1: $display("exec_state: -> FETCH_BIW_1");
	 FETCH_BIW_2: $display("exec_state: -> FETCH_BIW_2");
	 FETCH_BIW_3: $display("exec_state: -> FETCH_BIW_3");
	 FETCH_EXT: $display("exec_state: -> FETCH_EXT");
	 FETCH_DEST_EXT: $display("exec_state: -> FETCH_DEST_EXT");
	 RD_SRC_1: $display("exec_state: -> RD_SRC_1");
	 RD_SRC_1_LO: $display("exec_state: -> RD_SRC_1_LO");
	 RD_SRC_1_HI: $display("exec_state: -> RD_SRC_1_HI");
	 RD_SRC_2: $display("exec_state: -> RD_SRC_2");
	 RD_SRC_2_LO: $display("exec_state: -> RD_SRC_2_LO");
	 RD_SRC_2_HI: $display("exec_state: -> RD_SRC_2_HI");
	 WR_DEST_1: $display("exec_state: -> WR_DEST_1");
	 WR_DEST_1_LO: $display("exec_state: -> WR_DEST_1_LO");
	 WR_DEST_1_HI: $display("exec_state: -> WR_DEST_1_HI");
	 WR_DEST_2_LO: $display("exec_state: -> WR_DEST_2_LO");
	 WR_DEST_2_HI: $display("exec_state: -> WR_DEST_2_HI");
	 RD_SP_HI: $display("exec_state: -> RD_SP_HI");
	 RD_SP: $display("exec_state: -> RD_SP");
	 RD_SP_LO: $display("exec_state: -> RD_SP_LO");
	 WR_SP_HI: $display("exec_state: -> WR_SP_HI");
	 WR_SP_LO: $display("exec_state: -> WR_SP_LO");
	 WAIT_OPERATION: $display("exec_state: -> WAIT_OPERATION");
	 MOVEM_TST: $display("exec_state: -> MOVEM_TST");
       endcase // case (next_exec_state)

   always @(posedge clk)
     begin
	if (op == BCC & op_end_i & 0)
	  $display("BCC -> cond %x", cond);
	if (op == BSR & op_end_i & 0)
	  $display("BSR -> cond %x", cond);
     end

   always @(posedge clk)
     begin
        if (op == RTE & exec_state == RD_SP & bus_cyc_rdy)
          $display("sr: sreg_mem_tmp <= %x", {sr_ccr_in[15],sr_ccr_in[13],sr_ccr_in[10:8],sr_ccr_in[4:0]});

        if (preset_irq_mask)
	  $display("sr: sreg_mem [7:5] <= 3'b111 (preset_irq_mask)");
          
        if (irq_save)
	  $display("sr: sreg_mem [7:5] <= %b (irq_save)", irq);
          
        if (sr_wr & op == RTE)
	  $display("sr: sreg_mem <= %x (sr_wr & RTE)", sreg_mem_tmp);
        else if (sr_wr)
	  $display("sr: sreg_mem <= %x (sr_wr)", {sr_ccr_in[15],sr_ccr_in[13],sr_ccr_in[10:8],sr_ccr_in[4:0]});

	if (status_reg[10:8] != sreg_mem[7:5])
          $display("sr: status_reg <= %x", {sreg_mem[9],1'b0,sreg_mem[8],2'b00,sreg_mem[7:5],3'b000,sreg_mem[4:0]});
     end
`endif

//brad
`ifdef never
/* verilator lint_off CASEINCOMPLETE */
   always @(posedge clk)
     if (exec_state != next_exec_state && resetn && $time > 5747100)
       case (next_exec_state)
	 IDLE: $display("exec_state: -> IDLE");
	 FETCH_BIW_1: $display("exec_state: -> FETCH_BIW_1");
	 FETCH_BIW_2: $display("exec_state: -> FETCH_BIW_2");
	 FETCH_BIW_3: $display("exec_state: -> FETCH_BIW_3");
	 FETCH_EXT: $display("exec_state: -> FETCH_EXT");
	 FETCH_DEST_EXT: $display("exec_state: -> FETCH_DEST_EXT");
	 RD_SRC_1: $display("exec_state: -> RD_SRC_1");
	 RD_SRC_1_LO: $display("exec_state: -> RD_SRC_1_LO");
	 RD_SRC_1_HI: $display("exec_state: -> RD_SRC_1_HI");
	 RD_SRC_2: $display("exec_state: -> RD_SRC_2");
	 RD_SRC_2_LO: $display("exec_state: -> RD_SRC_2_LO");
	 RD_SRC_2_HI: $display("exec_state: -> RD_SRC_2_HI");
	 WR_DEST_1: $display("exec_state: -> WR_DEST_1");
	 WR_DEST_1_LO: $display("exec_state: -> WR_DEST_1_LO");
	 WR_DEST_1_HI: $display("exec_state: -> WR_DEST_1_HI");
	 WR_DEST_2_LO: $display("exec_state: -> WR_DEST_2_LO");
	 WR_DEST_2_HI: $display("exec_state: -> WR_DEST_2_HI");
	 RD_SP_HI: $display("exec_state: -> RD_SP_HI");
	 RD_SP: $display("exec_state: -> RD_SP");
	 RD_SP_LO: $display("exec_state: -> RD_SP_LO");
	 WR_SP_HI: $display("exec_state: -> WR_SP_HI");
	 WR_SP_LO: $display("exec_state: -> WR_SP_LO");
	 WAIT_OPERATION: $display("exec_state: -> WAIT_OPERATION");
	 MOVEM_TST: $display("exec_state: -> MOVEM_TST");
       endcase // case (next_exec_state)
/* verilator lint_on CASEINCOMPLETE */

   always @(posedge clk)
     if (cc_updt == 1'b1)
       $display("sreg_mem[4:0] <= %x", xnzvc_in);
`endif

endmodule
