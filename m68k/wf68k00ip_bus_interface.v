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
//-- This file contains the 68Ks bus interface unit.              ----
//--                                                              ----
//-- This file contains the 68Ks bus interface unit.              ----
//--                                                              ----
//-- Description:                                                 ----
//-- This module provides bus control during read cycles, write   ----
//-- cycles and read modify write cycles. It also provides 2 and  ----
//-- 3 wire bus arbitration control, halt and rerun operation,    ----
//-- bus and address error generation, wait state insertion and   ----
//-- synchronous bus operation (68000).                           ----
//-- In the following there are some remarks on the working       ----
//-- principle of this core.                                      ----
//--                                                              ----
//-- Bus cycle operation:                                         ----
//-- A bus cycle is released by either asserting RD_BUS for       ----
//-- entering a read cycle or WR_BUS for entering a write cycle.  ----
//-- There must not be asserted both signals at the same time.    ----
//-- Once the bus cycle is started, the RD_BUS or the WR_BUS      ----
//-- must be asserted until the cycle finishes. This is indicated ----
//-- by the signal BUS_CYC_RDY, which is valid for one clock      ----
//-- cycle after the bus operation finished.                      ----
//--                                                              ----
//-- Synchronous timing topics:                                   ----
//-- During the synchronous timing, the DTACKn must not be        ----
//-- asserted and due to asynchronous timing, the VPAn must not   ----
//-- be asserted, otherwise unpredictable behavior will result.   ----
//--                                                              ----
//-- Bus arbitration topics:                                      ----
//-- No bus arbitration during read modify write cycle.           ----
//-- In the case of a 2 wire bus arbitration, no re-entry for     ----
//--   another device is possible.                                ----
//--                                                              ----
//-- Bus error topics:                                            ----
//-- During a bus error, the bus cycle finishes also asserting    ----
//-- the BUS_CYC_RDY signal during S7.                            ----
//--                                                              ----
//-- Bus re-run topics:                                           ----
//-- During a re-run condition, the bus cycle finishes also       ----
//-- asserting the BUS_CYC_RDY signal during S7.                  ----
//--                                                              ----
//-- RESET topics:                                                ----
//-- When a reset is released by the CPU due to the RESET_EN      ----
//-- control, the RESET_RDY indicates the finishing of the reset  ----
//-- cycle 124 clock cycles later. The RESET_EN may be asserted   ----
//-- until RESET_RDY indicates 'ready'. The RESET_RDY is a strobe ----
//-- and therefore valid for one clock cycle.                     ----
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
//   Several changes to provide correct bus arbitration.
// Revision 2K9A  2009/06/20 WF
//   Changed the E_TIMER process concerning synchronous reset.
//   ADR_EN logic is now synchronous.
//   Various changes concerning HALTn, RESET_CPUn, RD_BUS and WR_BUS.
// Revision 2K9B  2009/12/24 WF
//   Fixed a timing bug in the bus arbitration state register.
//   Fixed UDSn and LDSn logic not working correct with waitstates in some cases.
// Revision 2K11A 20110620 WF
//   Removed EXEC_ABORT from the entity.
// Revision 2K11B 20111226 WF
//   Some updates concerning inactive signals during HALT assertion.
//   Minor changes in the BERRn logic.
//   Fixed BUS_CYC_RDY logic during the HALT or retry operation.
// Revision 2K13A 20130620 WF
//   Fixed the VMAn timing. Thanks to Igor Majstorovic for the information.
//


module  wf68k00ip_bus_interface ( clk, resetn, reset_inn, reset_out_en, reset_cpun, reset_en, reset_rdy,
				  data_in, sel_a_hi, sel_a_midhi, sel_a_midlo, sel_a_lo, sel_buff_a_lo, sel_buff_a_hi,
				  sel_buff_b_lo, sel_buff_b_hi, sys_init, op_size, buffer_a, buffer_b, data_core_out, 
				  rd_bus, wr_bus, tas_lock, a0, byten_word, bus_cyc_rdy, data_valid, dtackn, berrn,
				  avecn, haltn, adr_en, wr_hi, hi_word_en, hi_byte_en, lo_byte_en, fc_en, asn, as_en,
				  udsn, uds_en, ldsn, lds_en, rwn, rw_en, vpan, vman, vma_en, e, brn, bgackn, bgn );

   // System control:
   input        clk;
   input        resetn;
   input        reset_inn;
   output 	reset_out_en;
   output 	reset_cpun;
   input        reset_en;
   output 	reset_rdy;

   // Data lines:
   input [15:0] data_in ;

   // Receive buffers:
   input        sel_a_hi;
   input        sel_a_midhi;
   input        sel_a_midlo;
   input        sel_a_lo;
   input        sel_buff_a_lo;
   input        sel_buff_a_hi;
   input        sel_buff_b_lo;
   input        sel_buff_b_hi;
   input        sys_init;
   input [1:0] 	op_size;
   output [31:0] buffer_a ;
   output [31:0] buffer_b ;
   output [15:0] data_core_out ;

   // Control signals:
   input 	 rd_bus;
   input 	 wr_bus;
   input 	 tas_lock;
   input 	 a0;
   input 	 byten_word;
   output        bus_cyc_rdy;
   output        data_valid;
   input 	 dtackn;
   input 	 berrn;
   input 	 avecn;
   input 	 haltn;
   output        adr_en;
   input 	 wr_hi;
   output        hi_word_en;
   output        hi_byte_en;
   output        lo_byte_en;
   output        fc_en;
   output        asn;
   output        as_en;
   output        udsn;
   output        uds_en;
   output        ldsn;
   output        lds_en;
   output        rwn;
   output        rw_en;
   input 	 vpan;
   output        vman;
   output        vma_en;
   output        e;
   input 	 brn;
   input 	 bgackn;
   output        bgn;

`include "wf68k00ip_parms.h"

   reg [3:0] 	 e_timer;
   reg [3:0] 	 reset_filter;
   reg [6:0] 	 reset_timer;
   reg 		 reset_timer_lock;

   //type arb_states
   parameter IDLE=2'd0;
   parameter GRANT=2'd1;
   parameter WAIT_RELEASE_3WIRE=2'd2;
   
   //type time_slices
   parameter S0=3'd0;
   parameter S1=3'd1;
   parameter S2=3'd2;
   parameter S3=3'd3;
   parameter S4=3'd4;
   parameter S5=3'd5;
   parameter S6=3'd6;
   parameter S7=3'd7;
   
   reg 		 reset_out_en_i; 
   reg 		 reset_cpu_in; 
   reg [1:0] 	 arb_state;
   reg [1:0] 	 next_arb_state;
   wire [2:0] 	 t_slice;
   reg [1:0] 	 slice_cnt;
   wire 	 berr;
   wire 	 fc_enab;
   reg 		 vma_in; 
   reg 		 uds_rd_en_n; 
   reg 		 uds_rd_en_p; 
   wire 	 uds_rd_en;
   reg 		 lds_rd_en_n; 
   reg 		 lds_rd_en_p; 
   wire 	 lds_rd_en;
   reg 		 uds_wr_en_n; 
   reg 		 uds_wr_en_p; 
   wire 	 uds_wr_en;
   reg 		 lds_wr_en_n; 
   reg 		 lds_wr_en_p; 
   wire 	 lds_wr_en;
   reg 		 as_enab_n; 
   reg 		 as_enab_p; 
   wire 	 as_enab;
   reg 		 adr_en_n; 
   reg 		 adr_en_p; 
   reg 		 data_en_n; 
   reg 		 data_en_p; 
   wire 	 data_en;
   reg 		 wr_enab_p; 
   wire 	 wr_enab;
   reg 		 waitstates; 
   reg 		 syncn; 
   wire 	 reset_out_en;
   wire 	 reset_cpun;
   reg 		 reset_rdy; 
   reg [31:0] 	 buffer_a;
   reg [31:0] 	 buffer_b;
   reg [15:0] 	 data_core_out;
   wire 	 bus_cyc_rdy;
   wire 	 data_valid;
   wire 	 adr_en;
   wire 	 hi_word_en;
   wire 	 hi_byte_en;
   wire 	 lo_byte_en;
   wire 	 fc_en;
   wire 	 asn;
   wire 	 as_en;
   wire 	 udsn;
   wire 	 uds_en;
   wire 	 ldsn;
   wire 	 lds_en;
   wire 	 rwn;
   wire 	 rw_en;
   wire 	 vman;
   wire 	 vma_en;
   reg 		 e; 
   wire 	 bgn;


   
   // Three state controls:
   assign uds_en = (t_slice == S0 & ~haltn) ? 1'b0 : // During halt or retry.
                   (arb_state == IDLE) ? 1'b1 : // Hi-Z during arbitration.
                   1'b0;
   
   assign lds_en = (t_slice == S0 & ~haltn) ? 1'b0 : // During halt or retry.
                   (arb_state == IDLE) ? 1'b1 : // Hi-Z during arbitration.
                   1'b0;
   
   assign as_en = (t_slice == S0 & ~haltn) ? 1'b0 :  // During halt or retry.
                  (arb_state == IDLE) ? 1'b1 : // Hi-Z during arbitration.
                  1'b0;
   
   assign rw_en = (t_slice == S0 & ~haltn) ? 1'b0 :  // During halt or retry.
                  (arb_state == IDLE) ? 1'b1 : // Hi-Z during arbitration.
                  1'b0;
   
   assign fc_en = (t_slice == S0 & ~haltn) ? 1'b0 :  // During halt or retry.
                  (tas_lock) ? 1'b1 :
                  fc_enab;
   
   // Read and write timing:
   assign uds_wr_en = uds_wr_en_n | uds_wr_en_p; // '1' when           S4 | S5 | S6.
   assign lds_wr_en = lds_wr_en_n | lds_wr_en_p; // '1' when           S4 | S5 | S6.
   assign uds_rd_en = uds_rd_en_n | uds_rd_en_p; // '1' when S2 | S3 | S4 | S5 | S6.
   assign lds_rd_en = lds_rd_en_n | lds_rd_en_p; // '1' when S2 | S3 | S4 | S5 | S6.
   assign as_enab = as_enab_n | as_enab_p;       // '1' when S2 | S3 | S4 | S5 | S6.
   assign wr_enab = wr_enab_p;                   // '1' when S2 | S3 | S4 | S5 | S6 | S7.
   assign data_en = data_en_n | data_en_p;       // '1' when      S3 | S4 | S5 | S6 | S7.
   assign adr_en = (arb_state != IDLE) ? 1'b0 :
                   ((t_slice == S0) & (~haltn)) ? 1'b0 : // During HALT or retry.o
                   (tas_lock) ? 1'b1 :
                   (adr_en_n | adr_en_p);        // '1' when S1 | S2 | S3 | S4 | S5 | S6 | S7.
   
   // Timing valid for all modes:
   assign fc_enab = (arb_state != IDLE) ? 1'b0 : // During arbitration.
                    (tas_lock) ? 1'b1 :
                    (((rd_bus == 1'b0) & (wr_bus == 1'b0)) & (t_slice == S0)) ? 1'b0 : // Normal operation.
                    1'b1;
   
   assign vma_en = (arb_state != IDLE) ? 1'b0 : 1'b1;
   assign vman = vma_in;
   
   assign bgn = (arb_state == GRANT) ? 1'b0 : 1'b1;
   
   assign data_valid = (t_slice == S6 || t_slice == S7) ? 1'b1 : 1'b0; // Sample the data during S6.
   
   // This process samples the data from the data bus during the bus phase S6.
   // During S6 the received data from the bus is valid depending on the selection
   // of UDSn and LDSn. This means that the respective byte (high or low) is valid,
   // if wether UDSn or LDSn is asserted. If both are asserted, both bytes are valid.
   // For S6 is followed by a falling clock edge, the process reacts on it.

   always @ (negedge clk or negedge resetn) 
     if (~resetn)
       begin 
          buffer_a <= 32'b0;
          buffer_b <= 32'b0;
       end
     else 
       if (t_slice == S7) 
	 begin 
            if (sel_a_hi & a0 == 1'b0 & rd_bus) // Read Byte from even address.
              buffer_a[31:24] <= data_in[15:8];
            else if (sel_a_hi & rd_bus) // Read Byte from odd address.
              buffer_a[31:24] <= data_in[7:0];
            else if (sel_a_midhi & a0 == 1'b0 & rd_bus)
              buffer_a[23:16] <= data_in[15:8];
            else if (sel_a_midhi & rd_bus)
              buffer_a[23:16] <= data_in[7:0];
            else if (sel_a_midlo & a0 == 1'b0 & rd_bus)
              buffer_a[15:8] <= data_in[15:8];
            else if (sel_a_midlo & rd_bus)
              buffer_a[15:8] <= data_in[7:0];
            else if (sel_a_lo & a0 == 1'b0 & rd_bus)
              buffer_a[7:0] <= data_in[15:8];
            else if (sel_a_lo & rd_bus)
              buffer_a[7:0] <= data_in[7:0];
	    //
            else if (sys_init & sel_buff_a_hi) // During system startup.
              buffer_a[31:16] <= data_in;
            else if (sys_init & sel_buff_a_lo) // During system startup.
              buffer_a[15:0] <= data_in;
            else if (sel_buff_a_lo & op_size == BYTE & a0 == 1'b0) // Byte from an even address.
              buffer_a <= {24'h000000,data_in[15:8]};
            else if (sel_buff_a_lo & op_size == BYTE) // Byte from an odd address.
              buffer_a <= {24'h000000,data_in[7:0]};
            else if (sel_buff_a_lo) // Word or long access.
              buffer_a[15:0] <= data_in;
            else if (sel_buff_a_hi) // Long access.
              buffer_a[31:16] <= data_in;
	    //
            else if (sel_buff_b_lo & op_size == BYTE & a0 == 1'b0) // Byte from an even address.
              buffer_b <= {24'h000000,data_in[15:8]};
            else if (sel_buff_b_lo & op_size == BYTE) // Byte from an odd address.
              buffer_b <= {24'h000000,data_in[7:0]};
            else if (sel_buff_b_lo) // Word or long access.
              buffer_b[15:0] <= data_in;
            else if (sel_buff_b_hi) // Long access.
              buffer_b[31:16] <= data_in;
            
            data_core_out <= data_in; // Transparent buffer.
	 end

   
   // For the condition of the bus error see the 68K family user manual.
   // Bus errors does not occur during S0, S1 and S2.
   // There are no retry cycles in the read modify write mode (during TAS).
   assign berr = (berrn == 1'b0 &  haltn & t_slice != S0 & t_slice != S1 & t_slice != S2) ? 1'b1 :
                 (berrn == 1'b0 & ~haltn & tas_lock & t_slice != S0 & t_slice != S1 & t_slice != S2) ? 1'b1 :
                 1'b0;
   
   assign bus_cyc_rdy = ((t_slice == S6 | t_slice == S7) & (haltn | berrn)) ? 1'b1 : 1'b0;
   
   assign asn = (as_enab) ? 1'b0 : 1'b1;
   
   assign udsn = (rd_bus & uds_rd_en & a0 == 1'b0 & byten_word == 1'b0) ? 1'b0 :
                 (wr_bus & uds_wr_en & a0 == 1'b0 & byten_word == 1'b0) ? 1'b0 :
                 (rd_bus & uds_rd_en & byten_word) ? 1'b0 :
                 (wr_bus & uds_wr_en & byten_word) ? 1'b0 :
                 1'b1;
   
   assign ldsn = (rd_bus & lds_rd_en & a0 & byten_word == 1'b0) ? 1'b0 :
                 (wr_bus & lds_wr_en & a0 & byten_word == 1'b0) ? 1'b0 :
                 (rd_bus & lds_rd_en & byten_word) ? 1'b0 :
                 (wr_bus & lds_wr_en & byten_word) ? 1'b0 :
                 1'b1;
   
   assign rwn = (wr_bus & wr_enab) ? 1'b0 : 1'b1;
   
   // To meet the behavior of the bus during bus error, the HI_WORD_EN must have higher priority than
   // HI_BYTE_EN or LOW_BYTE_EN (using these signals for the bus drivers).
   // Nevertheless during bus error, there will be written invalid data via the HI_WORD_EN signal to the bus.
   assign hi_word_en = (wr_bus & data_en & wr_hi) ? 1'b1 :  1'b0;
   
   assign hi_byte_en = (wr_bus & data_en & a0 == 1'b0 & byten_word == 1'b0) ? 1'b1 :
                       (wr_bus & data_en & byten_word) ? 1'b1 :
                       1'b0;
   
   assign lo_byte_en = (wr_bus & data_en & a0 == 1'b1 & byten_word == 1'b0) ? 1'b1 :
                       (wr_bus & data_en & byten_word) ? 1'b1 :
                       1'b0;
   
   // During read, write or read modify write processes, the read access is delayed by wait 
   // states (slow read, slow write) if there is no DTACKn asserted until the end of S4.
   // This is done by stopping the slice counter. After the halt, in principle a S5 would be
   // possible. This is not correct for not asserted DTACKn. This process provides a locking
   // of this forbidden case and the stop control for the slice counter. For more information
   // see the 68000 processor data sheet (bus cycles).
   // In case of a bus error, the bus cycle is finished by realeasing the WAITSTATES via BERR.
   // In case of a CPU reset, the bus cycle is finished by realeasing the WAITSTATES via RESET_CPUn.
   // The SYNCn controls the synchronous bus timing. The AVECn ends the bus cycle in case of 
   // an autovector interrupt acknowledge cycle.
   // This synchronous process provides clock cycle accurate switching of the T_SLICE information.
   always @ (negedge clk)
     begin 
	if (t_slice == S4 /**/|| t_slice == S5)
          waitstates <= (dtackn & syncn & avecn & ~berr) & reset_cpu_in;
	else 
          waitstates <= 1'b0;
     end
   
   
   // This process provides the central timing for the read, write and read modify write cycle 
   // as also for the bus arbitration procedure.
   always @ (posedge clk or negedge resetn) 
     if (~resetn)
       slice_cnt <= 2'b00;
     else 
       // Cycle reset:
       if (arb_state != IDLE)
         slice_cnt <= 2'b00;
   // Initialization:
       else if (rd_bus == 1'b0 & wr_bus == 1'b0)
         slice_cnt <= 2'b00; // Init.
       else if (slice_cnt == 2'b00 & ~haltn)
         slice_cnt <= 2'b00; // Wait in retry or halt operation until HALTn is deasserted.
       else if (waitstates == 1'b0) // Counting:
         slice_cnt <= slice_cnt + 1'b1; // Cycle active.
   
   
   assign t_slice = (rd_bus == 1'b0 & wr_bus == 1'b0) ? S0 : // IDLE Mode.
                    (slice_cnt == 2'b00 & clk == 1'b1) ? S0 :
                    (slice_cnt == 2'b00 & clk == 1'b0 & ~haltn) ? S0 : // Stay in IDLE when HALTn asserted (Retry or halt operation).
                    (slice_cnt == 2'b00 & clk == 1'b0) ? S1 :
                    (slice_cnt == 2'b01 & clk == 1'b1) ? S2 :
                    (slice_cnt == 2'b01 & clk == 1'b0) ? S3 :
                    (slice_cnt == 2'b10 & clk == 1'b1) ? S4 :
                    (waitstates == 1'b1 & slice_cnt == 2'b10 & clk == 1'b0) ? S4 :
                    (waitstates == 1'b0 & slice_cnt == 2'b10 & clk == 1'b0) ? S5 :
                    (slice_cnt == 2'b11 & clk == 1'b1) ? S6 :
                    S7;

   // The modelling with the two processes working on the positive and negative clock edge
   // is a bit complicated. But it results in rather 'clean' (glitch free) bus control
   // signals. Every signal is modelled with it's own timing to give the core a high degree
   // of freedom.
   always @(negedge clk) 
     begin 
        case (t_slice)
          S3,S5 :   uds_rd_en_n <= 1'b1;
          default : uds_rd_en_n <= 1'b0;
        endcase
        case (t_slice)
          S3,S5 :   lds_rd_en_n <= 1'b1;
          default : lds_rd_en_n <= 1'b0;
        endcase
        case (t_slice)
          S5 :      uds_wr_en_n <= 1'b1;
          default : uds_wr_en_n <= 1'b0;
        endcase
        case (t_slice)
          S5 :      lds_wr_en_n <= 1'b1;
          default : lds_wr_en_n <= 1'b0;
        endcase
        case (t_slice)
          S3,S5 :   as_enab_n <= 1'b1;
          default : as_enab_n <= 1'b0;
        endcase
        case (t_slice)
          S3,S5 :   data_en_n <= 1'b1;
          default : data_en_n <= 1'b0;
        endcase

        if (t_slice == S0 & (rd_bus | wr_bus) & haltn & arb_state == IDLE)
          adr_en_n <= 1'b1;
        else 
          adr_en_n <= 1'b0;
     end

   
   always @(posedge clk)
     begin 
        case (t_slice)
          S2 :      uds_rd_en_p <= 1'b1;
          default : uds_rd_en_p <= 1'b0;
        endcase
        case (t_slice)
          S2 :      lds_rd_en_p <= 1'b1;
          default : lds_rd_en_p <= 1'b0;
        endcase
        case (t_slice)
          S2 :      uds_wr_en_p <= 1'b1; // S4 due to wait states.
          default : uds_wr_en_p <= 1'b0;
        endcase
        case (t_slice)
          S2 :      lds_wr_en_p <= 1'b1; // S4 due to wait states.
          default : lds_wr_en_p <= 1'b0;
        endcase
        case (t_slice)
          S2,S3 :   as_enab_p <= 1'b1;
          default : as_enab_p <= 1'b0;
        endcase
        case (t_slice)
          S3,S4,S5 : data_en_p <= 1'b1; // S4 due to wait states.
          default :  data_en_p <= 1'b0;
        endcase
        case (t_slice)
          S0,S1,S2,S3,S4,S5 : wr_enab_p <= 1'b1; // S4 due to wait states.
          default :           wr_enab_p <= 1'b0;
        endcase
        case (t_slice)
          S0,S1,S2,S3,S4,S5 : adr_en_p <= 1'b1; // S4 due to wait states.
          default :           adr_en_p <= 1'b0;
        endcase
     end

   // Synchronous bus timing:

   // The E clock is a free running clock with a period of 10 times
   // the CLK period. The pulse ratio is 4 CLK high and 6 CLK low.
   // Use a synchronous reset due to FPGA constraints.
   always @(posedge clk)
     begin 
        if (~resetn)
          begin 
             e_timer <= 4'h0;
             vma_in <= 1'b1;
             syncn <= 1'b1;
             e <= 1'b1;
          end
        else if (e_timer < 4'h9)
          e_timer <= e_timer + 4'h1;
        else 
          e_timer <= 4'h0;

	// E logic:
        if (e_timer == 4'h0)
          e <= 1'b1;
        else if (e_timer == 4'h4)
          e <= 1'b0;

	// VMA logic:
        if (vpan == 1'b0 & e_timer >= 4'h4)
          vma_in <= 1'b0;
        else if (vpan)
          vma_in <= 1'b1;

	// SYNCn logic (wait states controlling):
        if (vpan == 1'b0 & vma_in == 1'b0 & e_timer == 4'h2)
          syncn <= 1'b0;
        else if (vpan)
          syncn <= 1'b1;
     end

   // Bus arbitration:
   
   // This is the arbiters state register.
   // It works on the negative clock edge to
   // interfere correctly with the slice timer.
   always @ (negedge clk or negedge resetn) 
     if (~resetn)
       arb_state <= IDLE;
     else 
       arb_state <= next_arb_state;
   
   // This is the bus arbitration state machine's decoder. It can handle two wire arbitration
   // or three wire arbitration. The two wire arbitration is done in the GRANT state.
   always @ (arb_state or tas_lock or brn or rd_bus or wr_bus or slice_cnt or bgackn)
     case (arb_state)
       IDLE : 
         if (tas_lock)
           next_arb_state = IDLE; // No bus arbitration during read modify write cycle.
         else if (brn == 1'b0 & slice_cnt == 2'b00)
           next_arb_state = GRANT; // Bus grant delayed in case of S1, otherwise immediately.
         else 
           next_arb_state = IDLE;
       
       GRANT : 
         if (bgackn == 1'b0)
           next_arb_state = WAIT_RELEASE_3WIRE;
         else if (brn)
           next_arb_state = IDLE; // Resume normal operation.
         else 
           next_arb_state = GRANT;
       
       WAIT_RELEASE_3WIRE : 
         if (bgackn & (brn == 1'b0)) 
           next_arb_state = GRANT; // Re-enter new arbitration.
         else if ((bgackn == 1'b1)) 
           next_arb_state = IDLE;
         else 
           next_arb_state = WAIT_RELEASE_3WIRE;

       default:
	 next_arb_state = IDLE;
       
     endcase
   
   // RESET logic:
   
   // This process filters the incoming reset pin.
   // If RESET_INn and HALTn are asserted together for longer
   // than 10 clock cycles over the execution of a CPU reset
   // command, the CPU reset is released.
   always @ (posedge clk or negedge resetn) 
     if (~resetn)
       begin 
          reset_filter <= 4'hF; // For correct startup.
          reset_cpu_in <= 1'b0;
       end
     else 
       begin 
          if (reset_inn == 1'b0 & ~haltn & reset_out_en_i == 1'b0 & reset_filter < 4'hF)
            reset_filter <= reset_filter + 4'h1;
          else if (reset_inn | haltn | reset_out_en_i)
            reset_filter <= 4'h0;
          
          if (reset_filter > 4'hA)
            reset_cpu_in <= 1'b0; // Release internal reset.
          else 
            reset_cpu_in <= 1'b1;
       end
   
   
   
   // This logic is responsible for the assertion of the
   // reset output for 124 clock cycles, during the reset
   // command. The LOCK variable avoids re-initialisation
   // of the counter in the case that the RESET_EN is no
   // strobe.
   always @ (posedge clk or negedge resetn) 
     if (~resetn)
       begin 
          reset_timer <= 7'b0;
          reset_timer_lock <= 1'b0;
       end
     else 
       begin 
          if (reset_en & reset_timer_lock == 1'b0)
            begin 
               reset_timer <= 7'b1111100; // 124 initial value.
               reset_timer_lock <= 1'b1; // Lock the counter initialisation.
            end
          
          else if (reset_timer > 7'b0000000)
            reset_timer <= reset_timer - 7'h1;
          else if (~reset_en)
            reset_timer_lock <= 1'b0; // Unlock the counter initialisation.
          
          if (reset_timer == 7'b0000001)
            begin 
               reset_out_en_i <= 1'b0;
               reset_rdy <= 1'b1;
            end
          else if (reset_timer <= 7'b0000011)
            begin 
               reset_out_en_i <= 1'b0;
               reset_rdy <= 1'b0;
            end
          else 
            begin 
               reset_out_en_i <= 1'b1;
               reset_rdy <= 1'b0;
            end
       end

   
   assign reset_out_en = reset_out_en_i;
   assign reset_cpun = reset_cpu_in;

`ifdef debug
   always @ (posedge clk or negedge clk)
     begin
	if (arb_state != next_arb_state)
	  case (next_arb_state)
	    IDLE: $display("%t; bus: -> IDLE", $time);
	    GRANT: $display("%t; bus: -> GRANT", $time);
	    WAIT_RELEASE_3WIRE: $display("%t; bus: -> WAIT_RELEASE_3WIRE", $time);
	    default: ;
	  endcase // case (next_arb_state)

	if (rd_bus && 0)
	  $display("%t; rd_bus=%b t_slice=%d", $time, rd_bus, t_slice);
     end

   always @ (negedge clk)
     if (resetn && 0)
       begin
	  if (t_slice == S6) $display("negedge is S6; %t", $time);
	  if (t_slice == S7) $display("negedge is S7; %t", $time);

	  if (t_slice == S6/* & sys_init & sel_buff_a_hi*/)
	    $display("buffer_a hi <- %x", data_in);
          if (t_slice == S7 & sys_init & sel_buff_a_lo)
	    $display("buffer_a lo <- %x", data_in);
       end
`endif
endmodule
