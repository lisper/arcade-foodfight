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


module  wf68k00ip_top_soc ( clk, reset_coren, adr_out, adr_en, data_in, data_out, data_en, berrn, reset_inn, reset_out_en, halt_inn, halt_out_en, fc_out, fc_out_en, avecn, ipln, dtackn, as_outn, as_out_en, rwn_out, rw_out_en, uds_outn, uds_out_en, lds_outn, lds_out_en, e, vma_outn, vma_out_en, vpan, brn, bgn, bgackn );
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
    input  [0:0] reset_coren;
    output [23:1]  adr_out ;
    output  [0:0] adr_en;
    input [15:0]  data_in ;
    output [15:0]  data_out ;
    output  [0:0] data_en;
    input  [0:0] berrn;
    input  [0:0] reset_inn;
    output  [0:0] reset_out_en;
    input halt_inn;
    output  [0:0] halt_out_en;
    output [2:0]  fc_out ;
    output  [0:0] fc_out_en;
    input  [0:0] avecn;
    input [2:0]  ipln ;
    input  [0:0] dtackn;
    output  [0:0] as_outn;
    output  [0:0] as_out_en;
    output  [0:0] rwn_out;
    output  [0:0] rw_out_en;
    output  [0:0] uds_outn;
    output  [0:0] uds_out_en;
    output  [0:0] lds_outn;
    output  [0:0] lds_out_en;
    output  [0:0] e;
    output  [0:0] vma_outn;
    output  [0:0] vma_out_en;
    input  [0:0] vpan;
    input  [0:0] brn;
    output  [0:0] bgn;
    input  [0:0] bgackn;


    wire [31:0] adr_eff_i;
wire [0:0] adr_en_i;
wire [0:0] adr_en_vector_i;
    wire [31:0] adr_i;
    wire [2:0] adr_mode_i;
wire [0:0] adr_tmp_clr_i;
wire [0:0] adr_tmp_inc_i;
    wire [31:0] alu_op_in_s;
    wire [31:0] alu_op_in_d_hi;
    wire [31:0] alu_op_in_d_lo;
wire [0:0] ar_inc_i;
wire [0:0] ar_dec_i;
wire [0:0] ar_wr_i;
wire [0:0] ar_dr_exg_i;
    wire [31:0] areg_data_in;
wire [0:0] as_en_i;
wire [0:0] as_in;
reg /* conflict */avec_in_=1'bz;
    wire /* conflict */[0:0] avec_in;
reg [0:0] berr_in =0; 
wire [0:0] berr_i;
reg [0:0] bgack_in =0; 
    wire [4:0] bit_pos_i;
    wire [4:0] bit_pos_op;
wire [0:0] bitpos_im_i;
    wire [15:0] biw_0_i;
reg [0:0] br_in =0; 
    wire [31:0] bus_buffer_a;
    wire [31:0] bus_buffer_b;
wire [0:0] bus_cyc_rdy_i;
wire [0:0] byten_word_i;
    wire [3:0] c_code_i;
wire [0:0] chk_adr_i;
wire [0:0] chk_pc_i;
    wire [5:0] cnt_nr_i;
wire [0:0] ctrl_en_i;
wire [0:0] ctrl_rdy_i;
    wire [15:0] data_core;
    wire [31:0] data_immediate_i;
    wire [31:0] data_out_i;
wire [0:0] data_valid_i;
wire [0:0] dbcc_cond_i;
    wire [15:0] dest_exword_i [0:1];
    wire [31:0] dest_ext_cnt_i;
    wire [31:0] displace_biw_i;
wire [0:0] div_mul_32n64_i;
wire [0:0] dr_i;
wire [0:0] dr_dec_i;
wire [0:0] dr_wr_i;
    wire [31:0] dreg_data_in_a;
    wire [31:0] dreg_data_in_b;
wire [0:0] dtack_in;
wire [0:0] ew_wr_i;
    wire [31:0] ew_adr_i;
wire [0:0] exec_abort_i;
wire [0:0] exec_resume_i;
    wire [31:0] ext_cnt_i;
wire [1:0] ext_dsize_i;
    wire [15:0] exword_i [0:1];
wire [0:0] fc_en_ctrl;
wire [0:0] fc_en_i;
wire [0:0] fc_en_irq;
    wire [2:0] fc_out_ctrl;
    wire [2:0] fc_out_i;
    wire [2:0] fc_out_irq;
wire [0:0] force_biw2_i;
wire [0:0] force_biw3_i;
    reg halt_in;
wire [0:0] hi_byte_en_i;
wire [0:0] hi_word_en_i;
    wire [9:0] int_vect_i;
wire [0:0] init_status_i;
    reg /* conflict */[2:0] ipl_in_=3'bz;
    wire /* conflict */[2:0] ipl_in;
    reg [2:0] ipl_tmpn;
wire [0:0] ir_i;
wire [0:0] irq_data_en;
    wire [15:0] irq_dout;
    wire [2:0] irq_exhdl;
wire [0:0] irq_save_i;
    wire [31:0] iw_adr_i;
wire [0:0] iw_wr_i;
wire [0:0] lds_en_i;
wire [0:0] lds_in;
wire [0:0] lo_byte_en_i;
    wire [2:0] move_d_am_i;
wire [0:0] mem_shft_i;
wire [0:0] movem_adn_i;
    wire [2:0] movem_regsel_i;
wire [0:0] pc_add_displ_i;
wire [0:0] op_busy_i;
wire [6:0] op_i;
    wire [4:0] op_mode_i;
wire [1:0] op_size_i;
wire [0:0] op_start_i;
wire [0:0] pc_inc_i;
wire [0:0] pc_init_i;
wire [0:0] pc_init_ctrl;
wire [0:0] pc_init_irq;
    wire [31:0] pc_out;
wire [0:0] pc_tmp_clr_i;
wire [0:0] pc_tmp_inc_i;
wire [0:0] pc_wr_i;
wire [0:0] preset_irq_mask_i;
    wire [31:0] q_areg_a;
    wire [31:0] q_areg_b;
    wire [31:0] q_dreg_a;
    wire [31:0] q_dreg_b;
    wire [31:0] q_dreg_c;
wire [0:0] rd_bus_ctrl;
wire [0:0] rd_bus_irq;
wire [0:0] rd_bus_i;
    wire [15:0] reglistmask_i;
    wire [2:0] regsel_119_i;
    wire [2:0] regsel_20_i;
    wire [2:0] regsel_adr_a;
    wire [2:0] regsel_adr_b;
    wire [2:0] regsel_data_a;
    wire [2:0] regsel_data_b;
    wire [2:0] regsel_data_c;
    wire [2:0] regsel_dhr;
    wire [2:0] regsel_dlq;
    wire [2:0] regsel_index;
wire [0:0] reset_cpu_in;
wire [0:0] reset_en_i;
reg [0:0] reset_in_in =0; 
wire [0:0] reset_rdy_i;
    wire [31:0] result_alu_hi;
    wire [31:0] result_alu_lo;
    wire [31:0] result_shft;
wire [0:0] rm_i;
wire [0:0] rw_en_i;
wire [0:0] rwn_i;
wire [0:0] sbit_i;
wire [0:0] scan_traps_i;
wire [0:0] scc_cond_i;
wire [0:0] sel_a_lo;
wire [0:0] sel_a_hi;
wire [0:0] sel_a_midhi;
wire [0:0] sel_a_midlo;
wire [0:0] sel_buf_a_lo_i;
wire [0:0] sel_buf_a_hi_i;
wire [0:0] sel_buf_a_lo_ctrl_i;
wire [0:0] sel_buf_a_hi_ctrl_i;
wire [0:0] sel_buf_a_lo_irq_i;
wire [0:0] sel_buf_a_hi_irq_i;
wire [0:0] sel_buf_b_lo_i;
wire [0:0] sel_buf_b_hi_i;
wire [0:0] sel_displace_biw_i;
wire [0:0] shft_busy_i;
    wire [31:0] shft_op_in;
wire [0:0] shifter_load_i;
wire [0:0] sp_add_displ_i;
    wire [15:0] sr_ccr_mux;
wire [0:0] src_destn_i;
wire [0:0] ssp_dec_ctrl;
wire [0:0] ssp_dec_i;
wire [0:0] ssp_dec_irq;
wire [0:0] ssp_inc_i;
wire [0:0] ssp_init_i;
    wire [31:0] ssp_out;
    wire [15:0] status_reg_i;
wire [0:0] sys_init_i;
wire [0:0] tas_lock_i;
wire [0:0] trap_1010_i;
wire [0:0] trap_1111_i;
wire [0:0] trap_aerr_i;
wire [0:0] trap_chk_i;
wire [0:0] trap_chk_en_i;
wire [0:0] trap_divzero_i;
wire [0:0] trap_illegal_i;
wire [0:0] trap_op_i;
wire [0:0] trap_priv_i;
wire [0:0] trap_trace_i;
wire [0:0] trap_v_i;
    wire [3:0] trap_vector_i;
wire [0:0] uds_en_i;
wire [0:0] uds_in;
wire [0:0] unlk_sp_an_i;
wire [0:0] usp_cpy_i;
wire [0:0] usp_dec_i;
wire [0:0] usp_inc_i;
wire [0:0] use_int_vect_i;
    wire [31:0] usp_out;
wire [0:0] use_sp_adr_i;
wire [0:0] use_ssp_adr_i;
wire [0:0] vma_en_i;
wire [0:0] vma_in;
reg [0:0] vpa_in =0; 
wire [0:0] wr_bus_ctrl;
wire [0:0] wr_bus_i;
wire [0:0] wr_bus_irq;
wire [0:0] wr_hi_i;
    wire [4:0] xnzvc_alu;
    wire [4:0] xnzvc_i;
    wire [4:0] xnzvc_shft;
    wire [23:1] adr_out;
wire [0:0] adr_en;
    wire [15:0] data_out;
wire [0:0] data_en;
wire [0:0] reset_out_en;
wire [0:0] halt_out_en;
    wire [2:0] fc_out;
wire [0:0] fc_out_en;
wire [0:0] as_outn;
wire [0:0] as_out_en;
wire [0:0] rwn_out;
wire [0:0] rw_out_en;
wire [0:0] uds_outn;
wire [0:0] uds_out_en;
wire [0:0] lds_outn;
wire [0:0] lds_out_en;
wire [0:0] e;
wire [0:0] vma_outn;
wire [0:0] vma_out_en;
wire [0:0] bgn;


    
   always begin
       begin 
           @(negedge clk );
           berr_in <= berrn;
           halt_in <= halt_inn;
           vpa_in <= vpan;
           br_in <= brn;
           bgack_in <= bgackn;
           reset_in_in <= reset_inn;
           avec_in_ <= avecn;
       end
    end
   
   always begin
       begin 
           @(negedge clk );
           ipl_tmpn <= ipln;
           if ((ipl_tmpn == ipln)) 
                   ipl_in_ <= ipln;
           else 
                   ipl_in_ <= 3'b111;

           
       end
    end
   
   assign {berr_i}=(berr_in == 1'b0) ? 
                       1'b1
                    : ((((berr_in == 1'b0) & (halt_in == 1'b0)) & (rd_bus_i == 1'b1)) & (op_i == tas__op_68k00)) ? 
                       1'b1
                    : ((((berr_in == 1'b0) & (halt_in == 1'b0)) & (wr_bus_i == 1'b1)) & (op_i == tas__op_68k00)) ? 
                       1'b1
                    :  1'b0;
   
   assign {dtack_in}=dtackn;
   
   assign {data_en}=((hi_byte_en_i | lo_byte_en_i) | hi_word_en_i);
   
   assign {data_out}=(irq_data_en == 1'b1) ? 
                         irq_dout
                      : ((sel_a_hi == 1'b1) & (hi_byte_en_i == 1'b1)) ? 
                         {data_out_i[31:24],8'b00000000}
                      : ((sel_a_hi == 1'b1) & (lo_byte_en_i == 1'b1)) ? 
                         {8'b00000000,data_out_i[31:24]}
                      : ((sel_a_midhi == 1'b1) & (hi_byte_en_i == 1'b1)) ? 
                         {data_out_i[23:16],8'b00000000}
                      : ((sel_a_midhi == 1'b1) & (lo_byte_en_i == 1'b1)) ? 
                         {8'b00000000,data_out_i[23:16]}
                      : ((sel_a_midlo == 1'b1) & (hi_byte_en_i == 1'b1)) ? 
                         {data_out_i[15:8],8'b00000000}
                      : ((sel_a_midlo == 1'b1) & (lo_byte_en_i == 1'b1)) ? 
                         {8'b00000000,data_out_i[15:8]}
                      : ((sel_a_lo == 1'b1) & (hi_byte_en_i == 1'b1)) ? 
                         {data_out_i[7:0],8'b00000000}
                      : ((sel_a_lo == 1'b1) & (lo_byte_en_i == 1'b1)) ? 
                         {8'b00000000,data_out_i[7:0]}
                      : (hi_word_en_i == 1'b1) ? 
                         data_out_i[31:16]
                      : ((hi_byte_en_i == 1'b1) & (lo_byte_en_i == 1'b1)) ? 
                         data_out_i[15:0]
                      : (hi_byte_en_i == 1'b1) ? 
                         {data_out_i[7:0],8'b00000000}
                      : (lo_byte_en_i == 1'b1) ? 
                         {8'b00000000,data_out_i[7:0]}
                      :  {(15-0+1- 0){1'b0}};
   
   assign {as_outn}=as_in;
   
   assign {as_out_en}=as_en_i;
   
   assign {rwn_out}=rwn_i;
   
   assign {rw_out_en}=rw_en_i;
   
   assign {uds_outn}=uds_in;
   
   assign {uds_out_en}=uds_en_i;
   
   assign {lds_outn}=lds_in;
   
   assign {lds_out_en}=lds_en_i;
   
   assign {vma_outn}=vma_in;
   
   assign {vma_out_en}=vma_en_i;
   
   assign {fc_out_en}=fc_en_i;
   
   assign {fc_out}=fc_out_i;
   
   assign {fc_out_i}=(fc_en_ctrl == 1'b1) ? 
                         fc_out_ctrl
                      : (fc_en_irq == 1'b1) ? 
                         fc_out_irq
                      :  {(2-0+1- 0){1'b0}};
   
   assign {sys_init_i}=((sel_buf_a_hi_irq_i == 1'b1) | (sel_buf_a_lo_irq_i == 1'b1)) ? 
                           1'b1
                        :  1'b0;
   
   assign {byten_word_i}=(fc_out_i == 3'b110) ? 
                             1'b1
                          : (fc_out_i == 3'b010) ? 
                             1'b1
                          : (use_sp_adr_i == 1'b1) ? 
                             1'b1
                          : (use_ssp_adr_i == 1'b1) ? 
                             1'b1
                          : (use_int_vect_i == 1'b1) ? 
                             1'b1
                          : (op_size_i == byte__op_sizetype) ? 
                             1'b0
                          : (op_i == movep__op_68k00) ? 
                             1'b0
                          :  1'b1;
   
   assign {sel_buf_a_hi_i}=(sel_buf_a_hi_ctrl_i | sel_buf_a_hi_irq_i);
   
   assign {sel_buf_a_lo_i}=(sel_buf_a_lo_ctrl_i | sel_buf_a_lo_irq_i);
   
   assign {ssp_dec_i}=(ssp_dec_ctrl | ssp_dec_irq);
   
   assign {rd_bus_i}=(rd_bus_ctrl | rd_bus_irq);
   
   assign {wr_bus_i}=(wr_bus_ctrl | wr_bus_irq);
   
   assign {pc_init_i}=(pc_init_ctrl | pc_init_irq);
   
   assign {cnt_nr_i}=(mem_shft_i == 1'b1) ? 
                         6'b000001
                      : ((ir_i == 1'b0) & (regsel_119_i > 3'b000)) ? 
                         {3'b000,regsel_119_i}
                      : (ir_i == 1'b0) ? 
                         6'b001000
                      :  q_dreg_a[5:0];
   
   assign {bit_pos_i}=((bitpos_im_i == 1'b1) & (adr_mode_i == 3'b000)) ? 
                          bit_pos_op
                       : (adr_mode_i == 3'b000) ? 
                          q_dreg_a[4:0]
                       : (bitpos_im_i == 1'b1) ? 
                          {2'b00,bit_pos_op[2:0]}
                       :  {2'b00,q_dreg_a[2:0]};
   
   assign xnzvc_i=op_i==bchg__op_68k00 ? xnzvc_shft : 
           op_i==bclr__op_68k00 ? xnzvc_shft : 
           op_i==bset__op_68k00 ? xnzvc_shft : 
           op_i==btst__op_68k00 ? xnzvc_shft : 
           op_i==asl__op_68k00 ? xnzvc_shft : 
           op_i==asr__op_68k00 ? xnzvc_shft : 
           op_i==lsl__op_68k00 ? xnzvc_shft : 
           op_i==lsr__op_68k00 ? xnzvc_shft : 
           op_i==rotl__op_68k00 ? xnzvc_shft : 
           op_i==rotr__op_68k00 ? xnzvc_shft : 
           op_i==roxl__op_68k00 ? xnzvc_shft : 
           op_i==roxr__op_68k00 ? xnzvc_shft : 
           xnzvc_alu;
   
   assign {adr_out}=adr_i[23:1];
   
   assign {adr_en}=adr_en_i;
   
   assign {adr_i}=(adr_en_vector_i == 1'b1) ? 
                      {{28'hFFFFFFF,status_reg_i[10:8]},1'b1}
                   : (use_ssp_adr_i == 1'b1) ? 
                      ssp_out
                   : (use_int_vect_i == 1'b1) ? 
                      {{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0/*aggregate*/},int_vect_i}
                   : ((use_sp_adr_i == 1'b1) & (sbit_i == 1'b1)) ? 
                      ssp_out
                   : ((use_sp_adr_i == 1'b1) & (sbit_i == 1'b0)) ? 
                      usp_out
                   : ((fc_out_ctrl == 3'b010) | (fc_out_ctrl == 3'b110)) ? 
                      pc_out
                   :  adr_eff_i;
   
   assign {sr_ccr_mux}=(((op_i == andi_to_sr__op_68k00) | (op_i == eori_to_sr__op_68k00)) | (op_i == ori_to_sr__op_68k00)) ? 
                           result_alu_lo[15:0]
                        : (((op_i == andi_to_ccr__op_68k00) | (op_i == eori_to_ccr__op_68k00)) | (op_i == ori_to_ccr__op_68k00)) ? 
                           result_alu_lo[15:0]
                        : (((op_i == move_to_ccr__op_68k00) | (op_i == move_to_sr__op_68k00)) & (adr_mode_i == 3'b000)) ? 
                           q_dreg_b[15:0]
                        : (((op_i == move_to_ccr__op_68k00) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                           data_immediate_i[15:0]
                        : (((op_i == move_to_sr__op_68k00) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                           data_immediate_i[15:0]
                        : (op_i == stop__op_68k00) ? 
                           data_immediate_i[15:0]
                        :  data_core;
   
   assign {regsel_adr_a}=(((op_i == addq__op_68k00) | (op_i == subq__op_68k00)) & (adr_mode_i == 3'b001)) ? 
                             regsel_20_i
                          : ((op_i == link__op_68k00) | (op_i == move__op_68k00)) ? 
                             regsel_20_i
                          : ((op_i == unlk__op_68k00) & (unlk_sp_an_i == 1'b0)) ? 
                             regsel_20_i
                          : (op_i == movem__op_68k00) ? 
                             movem_regsel_i
                          :  regsel_119_i;
   
   assign {regsel_adr_b}=(src_destn_i == 1'b0) ? 
                             regsel_119_i
                          :  regsel_20_i;
   
   assign {regsel_data_a}=((((op_i == abcd__op_68k00) | (op_i == addx__op_68k00)) | (op_i == sbcd__op_68k00)) | (op_i == subx__op_68k00)) ? 
                              regsel_20_i
                           : ((op_i == add__op_68k00) | (op_i == sub__op_68k00)) ? 
                              regsel_20_i
                           : ((op_i == and_b__op_68k00) | (op_i == or_b__op_68k00)) ? 
                              regsel_20_i
                           : (((op_i == muls__op_68k00) | (op_i == mulu__op_68k00)) & (op_size_i == long__op_sizetype)) ? 
                              regsel_dlq
                           : (((op_i == divs__op_68k00) | (op_i == divu__op_68k00)) & (op_size_i == long__op_sizetype)) ? 
                              regsel_dlq
                           :  regsel_119_i;
   
   assign {regsel_data_b}=(op_i == movem__op_68k00) ? 
                              movem_regsel_i
                           : ((((op_i == abcd__op_68k00) | (op_i == addx__op_68k00)) | (op_i == sbcd__op_68k00)) | (op_i == subx__op_68k00)) ? 
                              regsel_119_i
                           : ((op_i == add__op_68k00) | (op_i == sub__op_68k00)) ? 
                              regsel_119_i
                           : ((op_i == and_b__op_68k00) | (op_i == or_b__op_68k00)) ? 
                              regsel_119_i
                           : (((op_i == divs__op_68k00) | (op_i == divu__op_68k00)) & (dr_wr_i == 1'b1)) ? 
                              regsel_dhr
                           : (((op_i == muls__op_68k00) | (op_i == mulu__op_68k00)) & (dr_wr_i == 1'b1)) ? 
                              regsel_dhr
                           : (op_i == moveq__op_68k00) ? 
                              regsel_119_i
                           :  regsel_20_i;
   
   assign {regsel_data_c}=(((op_i == divs__op_68k00) | (op_i == divu__op_68k00)) & (op_start_i == 1'b1)) ? 
                              regsel_dhr
                           :  regsel_index;
   
   assign {data_out_i}=((op_i == abcd__op_68k00) | (op_i == sbcd__op_68k00)) ? 
                           result_alu_lo
                        : (((op_i == addx__op_68k00) | (op_i == negx__op_68k00)) | (op_i == subx__op_68k00)) ? 
                           result_alu_lo
                        : ((op_i == add__op_68k00) | (op_i == sub__op_68k00)) ? 
                           result_alu_lo
                        : ((op_i == addi__op_68k00) | (op_i == subi__op_68k00)) ? 
                           result_alu_lo
                        : ((op_i == addq__op_68k00) | (op_i == subq__op_68k00)) ? 
                           result_alu_lo
                        : ((op_i == and_b__op_68k00) | (op_i == or_b__op_68k00)) ? 
                           result_alu_lo
                        : (((op_i == andi__op_68k00) | (op_i == eori__op_68k00)) | (op_i == ori__op_68k00)) ? 
                           result_alu_lo
                        : ((op_i == asl__op_68k00) | (op_i == asr__op_68k00)) ? 
                           result_shft
                        : ((op_i == lsl__op_68k00) | (op_i == lsr__op_68k00)) ? 
                           result_shft
                        : ((op_i == rotl__op_68k00) | (op_i == rotr__op_68k00)) ? 
                           result_shft
                        : ((op_i == roxl__op_68k00) | (op_i == roxr__op_68k00)) ? 
                           result_shft
                        : (((op_i == bchg__op_68k00) | (op_i == bset__op_68k00)) | (op_i == bclr__op_68k00)) ? 
                           result_shft
                        : (op_i == clr__op_68k00) ? 
                           32'h00000000
                        : ((op_i == move__op_68k00) & (adr_mode_i == 3'b000)) ? 
                           q_dreg_b
                        : ((op_i == move__op_68k00) & (adr_mode_i == 3'b001)) ? 
                           q_areg_a
                        : (((op_i == move__op_68k00) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                           data_immediate_i
                        : (op_i == move__op_68k00) ? 
                           bus_buffer_a
                        : (op_i == move_from_ccr__op_68k00) ? 
                           {{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0/*aggregate*/},status_reg_i[4:0]}
                        : (op_i == move_from_sr__op_68k00) ? 
                           {16'h0000,status_reg_i}
                        : ((op_i == movem__op_68k00) & (movem_adn_i == 1'b0)) ? 
                           q_dreg_b
                        : ((op_i == movem__op_68k00) & (movem_adn_i == 1'b1)) ? 
                           q_areg_a
                        : (op_i == movep__op_68k00) ? 
                           q_dreg_a
                        : (((op_i == nbcd__op_68k00) | (op_i == neg__op_68k00)) | (op_i == not_b__op_68k00)) ? 
                           result_alu_lo
                        : (op_i == pea__op_68k00) ? 
                           q_areg_a
                        : ((op_i == scc__op_68k00) & (scc_cond_i == 1'b1)) ? 
                           32'hFFFFFFFF
                        : (op_i == scc__op_68k00) ? 
                           32'h00000000
                        : ((op_i == jsr__op_68k00) | (op_i == bsr__op_68k00)) ? 
                           (pc_out + 2'b10)
                        : (op_i == link__op_68k00) ? 
                           q_areg_b
                        :  result_alu_lo;
   
   assign {dreg_data_in_b}=((op_i == abcd__op_68k00) | (op_i == sbcd__op_68k00)) ? 
                               result_alu_lo
                            : (((op_i == addx__op_68k00) | (op_i == negx__op_68k00)) | (op_i == subx__op_68k00)) ? 
                               result_alu_lo
                            : ((op_i == add__op_68k00) | (op_i == sub__op_68k00)) ? 
                               result_alu_lo
                            : ((op_i == addi__op_68k00) | (op_i == subi__op_68k00)) ? 
                               result_alu_lo
                            : ((op_i == addq__op_68k00) | (op_i == subq__op_68k00)) ? 
                               result_alu_lo
                            : ((op_i == and_b__op_68k00) | (op_i == or_b__op_68k00)) ? 
                               result_alu_lo
                            : (((op_i == andi__op_68k00) | (op_i == eori__op_68k00)) | (op_i == ori__op_68k00)) ? 
                               result_alu_lo
                            : (((op_i == nbcd__op_68k00) | (op_i == neg__op_68k00)) | (op_i == not_b__op_68k00)) ? 
                               result_alu_lo
                            : ((op_i == divs__op_68k00) | (op_i == divu__op_68k00)) ? 
                               result_alu_hi
                            : ((op_i == muls__op_68k00) | (op_i == mulu__op_68k00)) ? 
                               result_alu_hi
                            : ((op_i == asl__op_68k00) | (op_i == asr__op_68k00)) ? 
                               result_shft
                            : ((op_i == lsl__op_68k00) | (op_i == lsr__op_68k00)) ? 
                               result_shft
                            : ((op_i == rotl__op_68k00) | (op_i == rotr__op_68k00)) ? 
                               result_shft
                            : ((op_i == roxl__op_68k00) | (op_i == roxr__op_68k00)) ? 
                               result_shft
                            : (((op_i == bchg__op_68k00) | (op_i == bset__op_68k00)) | (op_i == bclr__op_68k00)) ? 
                               result_shft
                            : ((op_i == exg__op_68k00) & (op_mode_i == 5'b01000)) ? 
                               q_dreg_b
                            : (op_i == movem__op_68k00) ? 
                               bus_buffer_a
                            : (op_i == moveq__op_68k00) ? 
                               data_immediate_i
                            : ((op_i == scc__op_68k00) & (scc_cond_i == 1'b1)) ? 
                               32'hFFFFFFFF
                            : (op_i == scc__op_68k00) ? 
                               32'h00000000
                            : (op_i == clr__op_68k00) ? 
                               32'h00000000
                            : (op_i == move_from_ccr__op_68k00) ? 
                               {{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0/*aggregate*/},status_reg_i[4:0]}
                            : (op_i == move_from_sr__op_68k00) ? 
                               {16'h0000,status_reg_i}
                            :  result_alu_lo;
   
   assign {dreg_data_in_a}=((op_i == move__op_68k00) & (adr_mode_i == 3'b000)) ? 
                               q_dreg_b
                            : ((op_i == move__op_68k00) & (adr_mode_i == 3'b001)) ? 
                               q_areg_b
                            : ((op_i == exg__op_68k00) & (op_mode_i == 5'b01000)) ? 
                               q_dreg_a
                            : (op_i == exg__op_68k00) ? 
                               q_areg_b
                            : (((op_i == move__op_68k00) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                               data_immediate_i
                            : ((op_i == move__op_68k00) | (op_i == movep__op_68k00)) ? 
                               bus_buffer_a
                            :  result_alu_lo;
   
   assign {areg_data_in}=(ctrl_rdy_i == 1'b1) ? 
                             bus_buffer_a
                          : ((op_i == adda__op_68k00) | (op_i == suba__op_68k00)) ? 
                             result_alu_lo
                          : ((op_i == addq__op_68k00) | (op_i == subq__op_68k00)) ? 
                             result_alu_lo
                          : ((op_i == movea__op_68k00) & (adr_mode_i == 3'b000)) ? 
                             q_dreg_b
                          : ((op_i == exg__op_68k00) & (op_mode_i == 5'b01001)) ? 
                             q_areg_b
                          : (op_i == exg__op_68k00) ? 
                             q_dreg_a
                          : ((op_i == movea__op_68k00) & (adr_mode_i == 3'b001)) ? 
                             q_areg_b
                          : (((op_i == movea__op_68k00) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                             data_immediate_i
                          : ((op_i == link__op_68k00) & (sbit_i == 1'b1)) ? 
                             ssp_out
                          : (op_i == link__op_68k00) ? 
                             usp_out
                          : (((op_i == rte__op_68k00) | (op_i == rtr__op_68k00)) | (op_i == rts__op_68k00)) ? 
                             bus_buffer_a
                          : ((op_i == unlk__op_68k00) & (unlk_sp_an_i == 1'b1)) ? 
                             q_areg_b
                          : ((fc_out_i == 3'b010) | (fc_out_i == 3'b110)) ? 
                             {16'h0000,data_core}
                          :  bus_buffer_a;
   
   assign {alu_op_in_s}=(((op_i == abcd__op_68k00) | (op_i == sbcd__op_68k00)) & (rm_i == 1'b0)) ? 
                            q_dreg_a
                         : ((op_i == abcd__op_68k00) | (op_i == sbcd__op_68k00)) ? 
                            bus_buffer_a
                         : (((op_i == addx__op_68k00) | (op_i == subx__op_68k00)) & (rm_i == 1'b0)) ? 
                            q_dreg_a
                         : ((op_i == addx__op_68k00) | (op_i == subx__op_68k00)) ? 
                            bus_buffer_a
                         : ((((op_i == add__op_68k00) | (op_i == sub__op_68k00)) & (op_mode_i[2] == 1'b0)) & (adr_mode_i == 3'b000)) ? 
                            q_dreg_a
                         : ((((op_i == add__op_68k00) | (op_i == sub__op_68k00)) & (op_mode_i[2] == 1'b0)) & (adr_mode_i == 3'b001)) ? 
                            q_areg_b
                         : ((((op_i == add__op_68k00) | (op_i == sub__op_68k00)) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                            data_immediate_i
                         : (((op_i == add__op_68k00) | (op_i == sub__op_68k00)) & (op_mode_i[2] == 1'b0)) ? 
                            bus_buffer_a
                         : (((op_i == add__op_68k00) | (op_i == sub__op_68k00)) & (op_mode_i[2] == 1'b1)) ? 
                            q_dreg_b
                         : ((((op_i == adda__op_68k00) | (op_i == cmpa__op_68k00)) | (op_i == suba__op_68k00)) & (adr_mode_i == 3'b000)) ? 
                            q_dreg_b
                         : ((((op_i == adda__op_68k00) | (op_i == cmpa__op_68k00)) | (op_i == suba__op_68k00)) & (adr_mode_i == 3'b001)) ? 
                            q_areg_b
                         : (((((op_i == adda__op_68k00) | (op_i == cmpa__op_68k00)) | (op_i == suba__op_68k00)) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                            data_immediate_i
                         : (((op_i == adda__op_68k00) | (op_i == cmpa__op_68k00)) | (op_i == suba__op_68k00)) ? 
                            bus_buffer_a
                         : ((op_i == addi__op_68k00) | (op_i == subi__op_68k00)) ? 
                            data_immediate_i
                         : ((op_i == addq__op_68k00) | (op_i == subq__op_68k00)) ? 
                            data_immediate_i
                         : ((((op_i == and_b__op_68k00) | (op_i == or_b__op_68k00)) & (op_mode_i[2] == 1'b0)) & (adr_mode_i == 3'b000)) ? 
                            q_dreg_a
                         : ((((op_i == and_b__op_68k00) | (op_i == or_b__op_68k00)) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                            data_immediate_i
                         : (((op_i == and_b__op_68k00) | (op_i == or_b__op_68k00)) & (op_mode_i[2] == 1'b0)) ? 
                            bus_buffer_a
                         : (((op_i == and_b__op_68k00) | (op_i == or_b__op_68k00)) & (op_mode_i[2] == 1'b1)) ? 
                            q_dreg_b
                         : ((((op_i == andi__op_68k00) | (op_i == cmpi__op_68k00)) | (op_i == eori__op_68k00)) | (op_i == ori__op_68k00)) ? 
                            data_immediate_i
                         : ((op_i == andi_to_ccr__op_68k00) | (op_i == andi_to_sr__op_68k00)) ? 
                            data_immediate_i
                         : ((op_i == eori_to_ccr__op_68k00) | (op_i == eori_to_sr__op_68k00)) ? 
                            data_immediate_i
                         : ((op_i == ori_to_ccr__op_68k00) | (op_i == ori_to_sr__op_68k00)) ? 
                            data_immediate_i
                         : ((op_i == chk__op_68k00) & (adr_mode_i == 3'b000)) ? 
                            q_dreg_b
                         : (((op_i == chk__op_68k00) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                            data_immediate_i
                         : (op_i == chk__op_68k00) ? 
                            bus_buffer_a
                         : ((op_i == cmp__op_68k00) & (adr_mode_i == 3'b000)) ? 
                            q_dreg_b
                         : ((op_i == cmp__op_68k00) & (adr_mode_i == 3'b001)) ? 
                            q_areg_b
                         : (((op_i == cmp__op_68k00) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                            data_immediate_i
                         : ((op_i == cmp__op_68k00) | (op_i == cmpm__op_68k00)) ? 
                            bus_buffer_a
                         : (op_i == eor__op_68k00) ? 
                            q_dreg_a
                         : ((op_i == extw__op_68k00) | (op_i == swap__op_68k00)) ? 
                            q_dreg_b
                         : ((op_i == move__op_68k00) & (adr_mode_i == 3'b000)) ? 
                            q_dreg_b
                         : ((op_i == move__op_68k00) & (adr_mode_i == 3'b000)) ? 
                            q_dreg_b
                         : ((op_i == move__op_68k00) & (adr_mode_i == 3'b001)) ? 
                            q_areg_a
                         : (op_i == moveq__op_68k00) ? 
                            data_immediate_i
                         : (((op_i == move__op_68k00) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                            data_immediate_i
                         : (op_i == move__op_68k00) ? 
                            bus_buffer_a
                         : (((op_i == divs__op_68k00) | (op_i == divu__op_68k00)) & (adr_mode_i == 3'b000)) ? 
                            q_dreg_b
                         : ((((op_i == divs__op_68k00) | (op_i == divu__op_68k00)) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                            data_immediate_i
                         : ((op_i == divs__op_68k00) | (op_i == divu__op_68k00)) ? 
                            bus_buffer_a
                         : (((op_size_i == word__op_sizetype) & ((op_i == muls__op_68k00) | (op_i == mulu__op_68k00))) & (adr_mode_i == 3'b000)) ? 
                            {16'h0000,q_dreg_b[15:0]}
                         : (((op_i == muls__op_68k00) | (op_i == mulu__op_68k00)) & (adr_mode_i == 3'b000)) ? 
                            q_dreg_b
                         : ((((op_size_i == word__op_sizetype) & ((op_i == muls__op_68k00) | (op_i == mulu__op_68k00))) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                            {16'h0000,data_immediate_i[15:0]}
                         : ((((op_i == muls__op_68k00) | (op_i == mulu__op_68k00)) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                            data_immediate_i
                         : ((op_size_i == word__op_sizetype) & ((op_i == muls__op_68k00) | (op_i == mulu__op_68k00))) ? 
                            {16'h0000,bus_buffer_a[15:0]}
                         : ((op_i == muls__op_68k00) | (op_i == mulu__op_68k00)) ? 
                            bus_buffer_a
                         :  32'h00000000;
   
   assign {alu_op_in_d_lo}=(((op_i == abcd__op_68k00) | (op_i == sbcd__op_68k00)) & (rm_i == 1'b0)) ? 
                               q_dreg_b
                            : ((op_i == abcd__op_68k00) | (op_i == sbcd__op_68k00)) ? 
                               bus_buffer_b
                            : (((op_i == addx__op_68k00) | (op_i == subx__op_68k00)) & (rm_i == 1'b0)) ? 
                               q_dreg_b
                            : ((op_i == addx__op_68k00) | (op_i == subx__op_68k00)) ? 
                               bus_buffer_b
                            : (((op_i == add__op_68k00) | (op_i == sub__op_68k00)) & (op_mode_i[2] == 1'b0)) ? 
                               q_dreg_b
                            : (((op_i == add__op_68k00) | (op_i == sub__op_68k00)) & (op_mode_i[2] == 1'b1)) ? 
                               bus_buffer_a
                            : (((op_i == adda__op_68k00) | (op_i == cmpa__op_68k00)) | (op_i == suba__op_68k00)) ? 
                               q_areg_a
                            : (((op_i == addi__op_68k00) | (op_i == subi__op_68k00)) & (adr_mode_i == 3'b000)) ? 
                               q_dreg_b
                            : ((op_i == addi__op_68k00) | (op_i == subi__op_68k00)) ? 
                               bus_buffer_a
                            : (((op_i == addq__op_68k00) | (op_i == subq__op_68k00)) & (adr_mode_i == 3'b000)) ? 
                               q_dreg_b
                            : (((op_i == addq__op_68k00) | (op_i == subq__op_68k00)) & (adr_mode_i == 3'b001)) ? 
                               q_areg_b
                            : ((op_i == addq__op_68k00) | (op_i == subq__op_68k00)) ? 
                               bus_buffer_a
                            : (((op_i == and_b__op_68k00) | (op_i == or_b__op_68k00)) & (op_mode_i[2] == 1'b0)) ? 
                               q_dreg_b
                            : ((op_i == eor__op_68k00) & (adr_mode_i == 3'b000)) ? 
                               q_dreg_b
                            : ((((op_i == and_b__op_68k00) | (op_i == eor__op_68k00)) | (op_i == or_b__op_68k00)) & (op_mode_i[2] == 1'b1)) ? 
                               bus_buffer_a
                            : (((((op_i == andi__op_68k00) | (op_i == cmpi__op_68k00)) | (op_i == eori__op_68k00)) | (op_i == ori__op_68k00)) & (adr_mode_i == 3'b000)) ? 
                               q_dreg_b
                            : ((((op_i == andi__op_68k00) | (op_i == cmpi__op_68k00)) | (op_i == eori__op_68k00)) | (op_i == ori__op_68k00)) ? 
                               bus_buffer_a
                            : ((op_i == andi_to_ccr__op_68k00) | (op_i == andi_to_sr__op_68k00)) ? 
                               {16'h0000,status_reg_i}
                            : ((op_i == eori_to_ccr__op_68k00) | (op_i == eori_to_sr__op_68k00)) ? 
                               {16'h0000,status_reg_i}
                            : ((op_i == ori_to_ccr__op_68k00) | (op_i == ori_to_sr__op_68k00)) ? 
                               {16'h0000,status_reg_i}
                            : ((op_i == chk__op_68k00) | (op_i == cmp__op_68k00)) ? 
                               q_dreg_a
                            : (op_i == cmpm__op_68k00) ? 
                               bus_buffer_b
                            : ((op_i == divs__op_68k00) | (op_i == divu__op_68k00)) ? 
                               q_dreg_a
                            : ((op_size_i == long__op_sizetype) & ((op_i == muls__op_68k00) | (op_i == mulu__op_68k00))) ? 
                               {16'h0000,q_dreg_a[15:0]}
                            : ((op_i == muls__op_68k00) | (op_i == mulu__op_68k00)) ? 
                               q_dreg_a
                            : (((((op_i == nbcd__op_68k00) | (op_i == neg__op_68k00)) | (op_i == negx__op_68k00)) | (op_i == not_b__op_68k00)) & (adr_mode_i == 3'b000)) ? 
                               q_dreg_b
                            : ((((op_i == nbcd__op_68k00) | (op_i == neg__op_68k00)) | (op_i == negx__op_68k00)) | (op_i == not_b__op_68k00)) ? 
                               bus_buffer_a
                            : ((op_i == tas__op_68k00) & (adr_mode_i == 3'b000)) ? 
                               q_dreg_b
                            : (op_i == tas__op_68k00) ? 
                               bus_buffer_a
                            : ((op_i == tst__op_68k00) & (adr_mode_i == 3'b000)) ? 
                               q_dreg_b
                            : ((op_i == tst__op_68k00) & (adr_mode_i == 3'b001)) ? 
                               q_areg_b
                            : (((op_i == tst__op_68k00) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                               data_immediate_i
                            :  bus_buffer_a;
   
   assign {alu_op_in_d_hi}=q_dreg_c;
   
   assign {shft_op_in}=(((op_i == asl__op_68k00) | (op_i == asr__op_68k00)) & (mem_shft_i == 1'b0)) ? 
                           q_dreg_b
                        : ((op_i == asl__op_68k00) | (op_i == asr__op_68k00)) ? 
                           bus_buffer_a
                        : (((op_i == lsl__op_68k00) | (op_i == lsr__op_68k00)) & (mem_shft_i == 1'b0)) ? 
                           q_dreg_b
                        : ((op_i == lsl__op_68k00) | (op_i == lsr__op_68k00)) ? 
                           bus_buffer_a
                        : (((op_i == rotl__op_68k00) | (op_i == rotr__op_68k00)) & (mem_shft_i == 1'b0)) ? 
                           q_dreg_b
                        : ((op_i == rotl__op_68k00) | (op_i == rotr__op_68k00)) ? 
                           bus_buffer_a
                        : (((op_i == roxl__op_68k00) | (op_i == roxr__op_68k00)) & (mem_shft_i == 1'b0)) ? 
                           q_dreg_b
                        : ((op_i == roxl__op_68k00) | (op_i == roxr__op_68k00)) ? 
                           bus_buffer_a
                        : (((op_i == btst__op_68k00) & (adr_mode_i == 3'b111)) & (regsel_20_i == 3'b100)) ? 
                           data_immediate_i
                        : (((((op_i == bchg__op_68k00) | (op_i == bclr__op_68k00)) | (op_i == bset__op_68k00)) | (op_i == btst__op_68k00)) & (adr_mode_i == 3'b000)) ? 
                           q_dreg_b
                        : ((((op_i == bchg__op_68k00) | (op_i == bclr__op_68k00)) | (op_i == bset__op_68k00)) | (op_i == btst__op_68k00)) ? 
                           bus_buffer_a
                        :  {(31-0+1- 0){1'b0}};
   
   wf68k00ip_control i_ctrl(.clk(clk), .resetn(reset_coren), .sr_ccr_in(sr_ccr_mux), .c_code(c_code_i), .reglistmask(reglistmask_i), .ctrl_en(ctrl_en_i), .exec_abort(exec_abort_i), .data_valid(data_valid_i), .bus_cyc_rdy(bus_cyc_rdy_i), .ctrl_rdy(ctrl_rdy_i), .init_status(init_status_i), .preset_irq_mask(preset_irq_mask_i), .irq(irq_exhdl), .irq_save(irq_save_i), .xnzvc_in(xnzvc_i), .status_reg_out(status_reg_i), .force_biw2(force_biw2_i), .force_biw3(force_biw3_i), .ext_cnt(ext_cnt_i), .dest_ext_cnt(dest_ext_cnt_i), .regsel_20(regsel_20_i), .iw_adr(iw_adr_i), .iw_wr(iw_wr_i), .src_destn(src_destn_i), .ew_wr(ew_wr_i), .ew_adr(ew_adr_i), .rd_bus(rd_bus_ctrl), .wr_bus(wr_bus_ctrl), .tas_lock(tas_lock_i), .wr_hi(wr_hi_i), .sel_a_hi(sel_a_hi), .sel_a_midhi(sel_a_midhi), .sel_a_midlo(sel_a_midlo), .sel_a_lo(sel_a_lo), .sel_buff_a_lo(sel_buf_a_lo_ctrl_i), .sel_buff_a_hi(sel_buf_a_hi_ctrl_i), .sel_buff_b_lo(sel_buf_b_lo_i), .sel_buff_b_hi(sel_buf_b_hi_i), .fc_out(fc_out_ctrl), .fc_en(fc_en_ctrl), .pc_init(pc_init_ctrl), .pc_wr(pc_wr_i), .pc_inc(pc_inc_i), .pc_tmp_clr(pc_tmp_clr_i), .pc_tmp_inc(pc_tmp_inc_i), .pc_add_displ(pc_add_displ_i), .usp_inc(usp_inc_i), .ssp_inc(ssp_inc_i), .usp_dec(usp_dec_i), .ssp_dec(ssp_dec_ctrl), .usp_cpy(usp_cpy_i), .sp_add_displ(sp_add_displ_i), .adr_tmp_clr(adr_tmp_clr_i), .adr_tmp_inc(adr_tmp_inc_i), .ar_inc(ar_inc_i), .ar_dec(ar_dec_i), .ar_wr(ar_wr_i), .ar_dr_exg(ar_dr_exg_i), .dr_wr(dr_wr_i), .dr_dec(dr_dec_i), .scan_traps(scan_traps_i), .trap_priv(trap_priv_i), .trap_trace(trap_trace_i), .op(op_i), .op_mode(op_mode_i[2:0]), .op_size(op_size_i), .adr_mode(adr_mode_i), .move_d_am(move_d_am_i), .reset_rdy(reset_rdy_i), .op_busy(op_busy_i), .mem_shft(mem_shft_i), .shft_busy(shft_busy_i), .dr(dr_i), .rm(rm_i), .div_mul_32n64(div_mul_32n64_i), .exec_resume(exec_resume_i), .dbcc_cond(dbcc_cond_i), .use_sp_adr(use_sp_adr_i), .op_start(op_start_i), .trap_chk_en(trap_chk_en_i), .movem_regsel(movem_regsel_i), .movem_adn(movem_adn_i), .scc_cond(scc_cond_i), .shifter_load(shifter_load_i), .chk_pc(chk_pc_i), .chk_adr(chk_adr_i), .sbit(sbit_i), .unlk_sp_an(unlk_sp_an_i), .reset_en(reset_en_i));
   
   wf68k00ip_interrupt_control i_irq_ctrl(.clk(clk), .resetn(reset_coren), .reset_cpun(reset_cpu_in), .berr(berr_i), .haltn(halt_in), .adr_in(adr_i), .use_ssp_adr(use_ssp_adr_i), .adr_en_vector(adr_en_vector_i), .data_in(data_core[7:0]), .data_out(irq_dout), .data_en(irq_data_en), .rwn[0](rwn_i), .rd_bus(rd_bus_irq), .wr_bus(wr_bus_irq), .halt_en(halt_out_en), .fc_in(fc_out_i), .fc_out(fc_out_irq), .fc_en(fc_en_irq), .sel_buff_a_lo(sel_buf_a_lo_irq_i), .sel_buff_a_hi(sel_buf_a_hi_irq_i), .status_reg_in(status_reg_i), .pc(pc_out), .init_status(init_status_i), .preset_irq_mask(preset_irq_mask_i), .ssp_dec(ssp_dec_irq), .ssp_init(ssp_init_i), .pc_init(pc_init_irq), .biw_0(biw_0_i), .bus_cyc_rdy(bus_cyc_rdy_i), .ctrl_rdy(ctrl_rdy_i), .ctrl_en(ctrl_en_i), .exec_abort(exec_abort_i), .exec_resume(exec_resume_i), .irq_inn(ipl_in), .irq_out(irq_exhdl), .avecn(avec_in), .irq_save(irq_save_i), .int_vect(int_vect_i), .use_int_vect(use_int_vect_i), .trap_aerr(trap_aerr_i), .trap_op(trap_op_i), .trap_vector(trap_vector_i), .trap_v(trap_v_i), .trap_chk(trap_chk_i), .trap_divzero(trap_divzero_i), .trap_illegal(trap_illegal_i), .trap_1010(trap_1010_i), .trap_1111(trap_1111_i), .trap_trace(trap_trace_i), .trap_priv(trap_priv_i));
   
   wf68k00ip_opcode_decoder i_opcode(.clk(clk), .resetn(reset_coren), .data_in(data_in), .sbit(sbit_i), .ov(status_reg_i[1]), .iw_adr(iw_adr_i), .iw_wr(iw_wr_i), .force_biw2(force_biw2_i), .force_biw3(force_biw3_i), .ext_cnt(ext_cnt_i), .dest_ext_cnt(dest_ext_cnt_i), .dr(dr_i), .rm(rm_i), .ir(ir_i), .op(op_i), .op_size(op_size_i), .op_mode(op_mode_i), .biw_0(biw_0_i), .regsel_20(regsel_20_i), .regsel_119(regsel_119_i), .regsel_index(regsel_index), .data_immediate(data_immediate_i), .trap_vector(trap_vector_i), .c_code(c_code_i), .mem_shft(mem_shft_i), .reglistmask(reglistmask_i), .bitpos_im(bitpos_im_i), .bit_pos(bit_pos_op), .div_mul_32n64(div_mul_32n64_i), .reg_dlq(regsel_dlq), .reg_dhr(regsel_dhr), .scan_traps(scan_traps_i), .trap_illegal(trap_illegal_i), .trap_1010(trap_1010_i), .trap_1111(trap_1111_i), .trap_priv(trap_priv_i), .trap_op(trap_op_i), .trap_v(trap_v_i), .ew_wr(ew_wr_i), .ew_adr(ew_adr_i), .src_destn(src_destn_i), .exword(exword_i), .dest_exword(dest_exword_i), .adr_mode(adr_mode_i), .move_d_am(move_d_am_i), .ext_dsize(ext_dsize_i), .sel_displace_biw(sel_displace_biw_i), .displace_biw(displace_biw_i));
   
   wf68k00ip_address_registers i_adrreg(.clk(clk), .resetn(reset_coren), .adata_in(areg_data_in), .regsel_b(regsel_adr_b), .regsel_a(regsel_adr_a), .adr_reg_qb(q_areg_b), .adr_reg_qa(q_areg_a), .usp_out(usp_out), .ssp_out(ssp_out), .pc_out(pc_out), .exword(exword_i), .dest_exword(dest_exword_i), .dr(dr_i), .usp_cpy(usp_cpy_i), .ar_exg(ar_dr_exg_i), .ar_wr(ar_wr_i), .usp_inc(usp_inc_i), .usp_dec(usp_dec_i), .adr_tmp_clr(adr_tmp_clr_i), .adr_tmp_inc(adr_tmp_inc_i), .ar_inc(ar_inc_i), .ar_dec(ar_dec_i), .ssp_inc(ssp_inc_i), .ssp_dec(ssp_dec_i), .ssp_init(ssp_init_i), .sp_add_displ(sp_add_displ_i), .use_sp_adr(use_sp_adr_i), .use_ssp_adr(use_ssp_adr_i), .pc_wr(pc_wr_i), .pc_inc(pc_inc_i), .pc_tmp_clr(pc_tmp_clr_i), .pc_tmp_inc(pc_tmp_inc_i), .pc_init(pc_init_i), .pc_add_displ(pc_add_displ_i), .src_destn(src_destn_i), .sbit(sbit_i), .op(op_i), .op_size(op_size_i), .op_mode(op_mode_i), .op_start(op_start_i), .adr_mode(adr_mode_i), .move_d_am(move_d_am_i), .force_biw2(force_biw2_i), .force_biw3(force_biw3_i), .ext_dsize(ext_dsize_i), .sel_displace_biw(sel_displace_biw_i), .displace_biw(displace_biw_i), .regsel_index(regsel_data_c), .index_d_in(q_dreg_c), .chk_pc(chk_pc_i), .chk_adr(chk_adr_i), .trap_aerr(trap_aerr_i), .adr_eff(adr_eff_i));
   
   wf68k00ip_data_registers i_datareg(.clk(clk), .resetn(reset_coren), .data_in_a(dreg_data_in_a), .data_in_b(dreg_data_in_b), .regsel_a(regsel_data_a), .regsel_b(regsel_data_b), .regsel_c(regsel_data_c), .div_mul_32n64(div_mul_32n64_i), .data_out_a(q_dreg_a), .data_out_b(q_dreg_b), .data_out_c(q_dreg_c), .dr_exg(ar_dr_exg_i), .dr_dec(dr_dec_i), .dr_wr(dr_wr_i), .op(op_i), .op_size(op_size_i), .op_mode(op_mode_i), .dbcc_cond(dbcc_cond_i));
   
   wf68k00ip_alu i_alu(.resetn(reset_coren), .clk(clk), .adr_mode(adr_mode_i), .op_size(op_size_i), .op(op_i), .xnzvc_in(status_reg_i[4:0]), .xnzvc_out(xnzvc_alu), .op_in_s(alu_op_in_s), .op_in_d_hi(alu_op_in_d_hi), .op_in_d_lo(alu_op_in_d_lo), .result_hi(result_alu_hi), .result_lo(result_alu_lo), .op_start(op_start_i), .trap_chk_en(trap_chk_en_i), .div_mul_32n64(div_mul_32n64_i), .op_busy(op_busy_i), .trap_chk(trap_chk_i), .trap_divzero(trap_divzero_i));
   
   wf68k00ip_shifter i_shft(.clk(clk), .resetn(reset_coren), .data_in(shft_op_in), .data_out(result_shft), .op(op_i), .op_size(op_size_i), .bit_pos(bit_pos_i), .cnt_nr(cnt_nr_i), .shifter_load(shifter_load_i), .shft_busy(shft_busy_i), .xnzvc_in(status_reg_i[4:0]), .xnzvc_out(xnzvc_shft));
   
   wf68k00ip_bus_interface i_bus_if(.clk(clk), .resetn(reset_coren), .reset_inn(reset_in_in), .reset_out_en(reset_out_en), .reset_cpun(reset_cpu_in), .reset_en(reset_en_i), .reset_rdy(reset_rdy_i), .data_in(data_in), .sel_a_hi(sel_a_hi), .sel_a_midhi(sel_a_midhi), .sel_a_midlo(sel_a_midlo), .sel_a_lo(sel_a_lo), .sel_buff_a_lo(sel_buf_a_lo_i), .sel_buff_a_hi(sel_buf_a_hi_i), .sel_buff_b_lo(sel_buf_b_lo_i), .sel_buff_b_hi(sel_buf_b_hi_i), .sys_init(sys_init_i), .op_size(op_size_i), .buffer_a(bus_buffer_a), .buffer_b(bus_buffer_b), .data_core_out(data_core), .rd_bus(rd_bus_i), .wr_bus(wr_bus_i), .tas_lock(tas_lock_i), .a0(adr_i[0]), .byten_word(byten_word_i), .bus_cyc_rdy(bus_cyc_rdy_i), .data_valid(data_valid_i), .dtackn(dtack_in), .berrn(berr_in), .avecn(avec_in), .haltn(halt_in), .adr_en(adr_en_i), .wr_hi(wr_hi_i), .hi_word_en(hi_word_en_i), .hi_byte_en(hi_byte_en_i), .lo_byte_en(lo_byte_en_i), .fc_en(fc_en_i), .asn(as_in), .as_en(as_en_i), .udsn(uds_in), .uds_en(uds_en_i), .ldsn(lds_in), .lds_en(lds_en_i), .rwn(rwn_i), .rw_en(rw_en_i), .vpan(vpa_in), .vman(vma_in), .vma_en(vma_en_i), .e(e), .brn(br_in), .bgackn(bgack_in), .bgn(bgn));
        assign avec_in = avec_in_;//Added for Conflict reslover.
    assign ipl_in = ipl_in_;//Added for Conflict reslover.
    

endmodule
