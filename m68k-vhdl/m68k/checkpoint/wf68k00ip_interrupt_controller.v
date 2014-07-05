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
//-- This file contains the interrupt control unit.               ----
//--                                                              ----
//--                                                              ----
//-- Description:                                                 ----
//-- The interrupt control module is responsible for the inter-   ----
//-- rupt management of the external and internal interrupts and  ----
//-- for EXCEPTIONs processing. It manages auto-vectored inter-   ----
//-- rupt cycles, priority resolving and correct vector numbers   ----
//-- creation.                                                    ----
//-- There are different kinds of interrupt sources which require ----
//-- some special treatment: the RESET_CPU is released by exter-  ----
//-- nal logic. The exception state machine therefore has to      ----
//-- wait, once released, until this interrupt is released again. ----
//-- Interrupts, allowing the operation processing to finish the  ----
//-- current operation, have to wait for the CTRL_RDY signal.     ----
//-- The bus error exception starts the exception handler state   ----
//-- machine. In this case, there is no need to wait for the  bus ----
//-- error to withdrawn. It is assumed, that the bus error is     ----
//-- released by the bus interface logic during the exception     ----
//-- processing takes place. Double bus errors / address errors   ----
//-- cause the processor to enter the 'HALT' state.               ----
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
// Revision 2K7A  2007/05/31 WF
//   Updated all modules.
// Revision 2K7B  2007/12/24 WF
//   See the 68K00 top level file.
// Revision 2K8A  2008/07/14 WF
//   See the 68K00 top level file.
// Revision 2K8B  2008/12/24 WF
//   Pending IPLn is now stored for processing, thanks to T. Gubener for the info.
// Revision 2K9A  2009/06/20 WF
//   Fixed a bug concerning the pending flags. They are now cleared during
//   execution of the reset exception.
// Revision 2K13B  20131224 WF
//   Changed the sequence for sampling the interrupt vector. It is now sampled before stacking.


module  wf68k00ip_interrupt_control ( clk, resetn, reset_cpun, berr, haltn, adr_in,
				      use_ssp_adr, adr_en_vector, data_in, data_out, data_en,
				      rwn, rd_bus, wr_bus, halt_en, fc_in, fc_out, fc_en,
				      sel_buff_a_lo, sel_buff_a_hi, status_reg_in, pc, init_status,
				      preset_irq_mask, ssp_dec, ssp_init, pc_init, biw_0,
				      bus_cyc_rdy, ctrl_rdy, ctrl_en, exec_abort, exec_resume,
				      irq_inn, irq_out, avecn, irq_save, int_vect, use_int_vect,
				      trap_aerr, trap_op, trap_vector, trap_v, trap_chk, trap_divzero,
				      trap_illegal, trap_1010, trap_1111, trap_trace, trap_priv );
    
   input        clk;
   input        resetn;
   input        reset_cpun;
   input        berr;
   input 	haltn;
   input [31:0] adr_in;
   output 	use_ssp_adr;
   output 	adr_en_vector;
   input [7:0] 	data_in;
   output [15:0] data_out;
   output        data_en;
   input 	 rwn;
   output        rd_bus;
   output        wr_bus;
   output        halt_en;
   input [2:0] 	 fc_in;
   output [2:0]  fc_out;
   output        fc_en;
   output        sel_buff_a_lo;
   output        sel_buff_a_hi;
   input [15:0]  status_reg_in;
   input [31:0]  pc;
   output        init_status;
   output        preset_irq_mask;
   output        ssp_dec;
   output        ssp_init;
   output        pc_init;
   input [15:0]  biw_0 ;
   input 	 bus_cyc_rdy;
   input 	 ctrl_rdy;
   output        ctrl_en;
   output        exec_abort;
   output        exec_resume;
   input [2:0] 	 irq_inn;
   output [2:0]  irq_out;
   input 	 avecn;
   output        irq_save;
   output [9:0]  int_vect;
   output        use_int_vect;
   input 	 trap_aerr;
   input 	 trap_op;
   input [3:0] 	 trap_vector;
   input 	 trap_v;
   input 	 trap_chk;
   input 	 trap_divzero;
   input 	 trap_illegal;
   input 	 trap_1010;
   input 	 trap_1111;
   input 	 trap_trace;
   input 	 trap_priv;


   wire [9:0] 	 sr_mem;
   reg [7:0] 	 vector_no;
   reg [1:0] 	 vect_tmp;

   //type ex_states
   parameter IDLE = 5'd0;
   parameter WAIT_CTRL_RDY = 5'd1;
   parameter INIT = 5'd2;
   parameter VECT_NR = 5'd3;
   parameter GET_VECTOR = 5'd4;
   parameter STACK_MISC = 5'd5;
   parameter STACK_ACCESS_ADR_HI = 5'd6;
   parameter STACK_ACCESS_ADR_LO = 5'd7;
   parameter STACK_INSTRUCTION = 5'd8;
   parameter STACK_STATUS = 5'd9;
   parameter STACK_PC_HI = 5'd10;
   parameter STACK_PC_LO = 5'd11;
   parameter UPDATE_SSP_HI = 5'd12;
   parameter UPDATE_SSP_LO = 5'd13;
   parameter UPDATE_PC_HI = 5'd14;
   parameter UPDATE_PC_LO = 5'd15;
   parameter HALT = 5'd16;
   
   //type exceptions
   parameter EX_RESET=4'd0;
   parameter EX_BUS_ERR=4'd1;
   parameter EX_ADR_ERR=4'd2;
   parameter EX_ILLEGAL=4'd3;
   parameter EX_DIVZERO=4'd4;
   parameter EX_CHK=4'd5;
   parameter EX_TRAPV=4'd6;
   parameter EX_PRIV=4'd7;
   parameter EX_TRACE=4'd8;
   parameter EX_1010=4'd9;
   parameter EX_1111=4'd10;
   parameter EX_TRAP=4'd11;
   parameter EX_INT=4'd12;
   parameter EX_NONE=4'd13;
   
   reg [4:0] 	 ex_state;
   reg [4:0] 	 next_ex_state;
   reg [3:0] 	 exception_q;
   reg 		 tmp_cpy =0; 
   reg [15:0] 	 status_reg_tmp;
   reg 		 rwn_tmp;
   reg [2:0] 	 fc_tmp;
   wire [2:0] 	 irq_in;
   wire 	 instrn;
   reg [31:0] 	 adr_tmp;
   reg 		 inc_tmp_vector =0; 
   reg 		 ex_p_reset =0; 
   reg 		 ex_p_adr_err =0; 
   reg 		 ex_p_bus_err =0; 
   reg 		 ex_p_trace =0; 
   reg 		 ex_p_int =0; 
   reg 		 ex_p_illegal =0; 
   reg 		 ex_p_1010 =0; 
   reg 		 ex_p_1111 =0; 
   reg 		 ex_p_priv =0; 
   reg 		 ex_p_trap =0; 
   reg 		 ex_p_trapv =0; 
   reg 		 ex_p_chk =0; 
   reg 		 ex_p_divzero =0; 
   wire 	 force_halt;
   reg 		 preset_irq_mask_i =0; 
   wire 	 use_ssp_adr;
   wire 	 adr_en_vector;
   wire [15:0] 	 data_out;
   wire 	 data_en;
   wire 	 rd_bus;
   wire 	 wr_bus;
   wire 	 halt_en;
   wire [2:0] 	 fc_out;
   wire 	 fc_en;
   wire 	 sel_buff_a_lo;
   wire 	 sel_buff_a_hi;
   reg 		 init_status =0; 
   wire 	 preset_irq_mask;
   reg 		 ssp_dec =0; 
   reg 		 ssp_init =0; 
   reg 		 pc_init =0; 
   wire 	 ctrl_en;
   reg 		 exec_abort =0; 
   wire 	 exec_resume;
   reg [2:0] 	 irq_out;
   reg 		 irq_save =0; 
   reg [9:0] 	 int_vect;
   reg 		 use_int_vect =0; 


   // The processor gets halted, if a bus error occurs in the stacking or updating states during
   // the exception processing of a bus error, an address error or a reset.
   assign halt_en = ex_state == HALT ? 1'b1 :  1'b0;
   assign force_halt = ex_state != IDLE & (berr | trap_aerr) &
		       (exception_q == EX_RESET | exception_q == EX_ADR_ERR | exception_q == EX_BUS_ERR) ? 1'b1 : 1'b0;
   
   // This is the flag which enables the main execution processing state machine. It is enabled, if there
   // is no pending interrupt and if the interrupt exception handler state machine is inactive.
   assign ctrl_en = (ex_state == IDLE &
		     ex_p_reset == 1'b0 & ex_p_adr_err == 1'b0 & ex_p_bus_err == 1'b0 &
		     ex_p_trace == 1'b0 & ex_p_int == 1'b0 & ex_p_illegal == 1'b0 & ex_p_1010 == 1'b0 &
		     ex_p_1111 == 1'b0 & ex_p_priv == 1'b0 & ex_p_trap == 1'b0 & ex_p_trapv == 1'b0 &
		     ex_p_chk == 1'b0 & ex_p_divzero == 1'b0) ? 1'b1 : 1'b0;
   
   // Flag, if the processor is executing an instruction or a type 0 or 1 exception.
   // 0: instruction, 1: exception.
   assign instrn = (exception_q == EX_RESET | exception_q == EX_ADR_ERR | exception_q == EX_BUS_ERR) ? 1'b1 : 1'b0;
   
   // IACK cycle resides in the CPU space, the RESET resides in the supervisor 
   // program space and all others reside in the supervisor data space.
   assign fc_out = (ex_state == GET_VECTOR) ? 3'b111 :
                   (ex_state == UPDATE_SSP_HI | ex_state == UPDATE_SSP_LO) ? 3'b110 :
                   (ex_state == UPDATE_PC_HI | ex_state == UPDATE_PC_LO) ? 3'b110 :
                   3'b101;
   
   assign fc_en = (ex_state == IDLE) ? 1'b0 :
                  (ex_state == WAIT_CTRL_RDY ) ? 1'b0 :
                  (ex_state == INIT ) ? 1'b0 :
                  (ex_state == VECT_NR ) ? 1'b0 :
                  1'b1;
   
   assign use_ssp_adr = (ex_state == STACK_MISC ) ? 1'b1 :
                        (ex_state == STACK_ACCESS_ADR_HI ) ? 1'b1 :
                        (ex_state == STACK_ACCESS_ADR_LO ) ? 1'b1 :
                        (ex_state == STACK_INSTRUCTION ) ? 1'b1 :
                        (ex_state == STACK_STATUS ) ? 1'b1 :
                        (ex_state == STACK_PC_HI ) ? 1'b1 :
                        (ex_state == STACK_PC_LO ) ? 1'b1 :
                        1'b0;
   
   assign sel_buff_a_lo = (ex_state == UPDATE_SSP_LO ) ? 1'b1 :
                          (ex_state == UPDATE_PC_LO ) ? 1'b1 :
                          1'b0;
   
   assign sel_buff_a_hi = (ex_state == UPDATE_SSP_HI ) ? 1'b1 :
                          (ex_state == UPDATE_PC_HI ) ? 1'b1 :
                          1'b0;
   
   assign adr_en_vector = (ex_state == GET_VECTOR ) ? 1'b1 :
                          1'b0; // IACK space cycle.
   
   assign rd_bus = ex_state == GET_VECTOR  ? 1'b1 : 
		   ex_state == UPDATE_SSP_HI  ? 1'b1 : 
		   ex_state == UPDATE_SSP_LO  ? 1'b1 : 
		   ex_state == UPDATE_PC_HI  ? 1'b1 : 
		   ex_state == UPDATE_PC_LO  ? 1'b1 : 
		   1'b0;
   
   assign wr_bus = ex_state == STACK_MISC  ? 1'b1 : 
		   ex_state == STACK_ACCESS_ADR_HI  ? 1'b1 : 
		   ex_state == STACK_ACCESS_ADR_LO  ? 1'b1 : 
		   ex_state == STACK_INSTRUCTION  ? 1'b1 : 
		   ex_state == STACK_STATUS  ? 1'b1 : 
		   ex_state == STACK_PC_HI  ? 1'b1 : 
		   ex_state == STACK_PC_LO  ? 1'b1 : 
		   1'b0;
   
   assign data_out = (ex_state == STACK_MISC ) ? {11'b00000000000,rwn_tmp,instrn,fc_tmp} :
                     (ex_state == STACK_ACCESS_ADR_HI ) ? adr_tmp[31:16] :
                     (ex_state == STACK_ACCESS_ADR_LO ) ? adr_tmp[15:0] :
                     (ex_state == STACK_INSTRUCTION ) ? biw_0 :
                     (ex_state == STACK_STATUS ) ? status_reg_tmp :
                     (ex_state == STACK_PC_HI ) ? pc[31:16] :
                     (ex_state == STACK_PC_LO ) ? pc[15:0] :
		     16'b0;
      
   assign data_en = (ex_state == STACK_MISC ) ? 1'b1 :
                    (ex_state == STACK_ACCESS_ADR_HI ) ? 1'b1 :
                    (ex_state == STACK_ACCESS_ADR_LO ) ? 1'b1 :
                    (ex_state == STACK_INSTRUCTION ) ? 1'b1 :
                    (ex_state == STACK_STATUS ) ? 1'b1 :
                    (ex_state == STACK_PC_HI ) ? 1'b1 :
                    (ex_state == STACK_PC_LO ) ? 1'b1 :
                    1'b0;
   
   // Resume the STOP operation, when an external interrupt is going 
   // to be processed.
   assign exec_resume = ex_p_int ? 1'b1 : 1'b0;
   
   assign preset_irq_mask = preset_irq_mask_i;
   
   assign irq_in = ~irq_inn;
   
   // The exceptions which occurs are stored in this pending register until the
   // interrupt handler handled the respective exception.
   // The TRAP_PRIV, TRAP_1010, TRAP_1111, TRAP_ILLEGAL, TRAP_OP and TRAP_V may be a strobe
   // of 1 clock period. All others must be strobes of 1 clock period.
       
   always @(negedge resetn or posedge clk )
     if (~resetn)
       begin 
          ex_p_reset <= 1'b0;
          ex_p_adr_err <= 1'b0;
          ex_p_bus_err <= 1'b0;
          ex_p_trace <= 1'b0;
          ex_p_int <= 1'b0;
          ex_p_illegal <= 1'b0;
          ex_p_1010 <= 1'b0;
          ex_p_1111 <= 1'b0;
          ex_p_priv <= 1'b0;
          ex_p_trap <= 1'b0;
          ex_p_trapv <= 1'b0;
          ex_p_chk <= 1'b0;
          ex_p_divzero <= 1'b0;
       end
     else 
       begin 
          if (~reset_cpun)
            ex_p_reset <= 1'b1;
          else if (ex_state == UPDATE_PC_HI & bus_cyc_rdy & exception_q == EX_RESET) 
            ex_p_reset <= 1'b0;

          if ((trap_aerr == 1'b1)) 
            ex_p_adr_err <= 1'b1;
          else if (ex_state == UPDATE_PC_HI & bus_cyc_rdy & exception_q == EX_ADR_ERR) 
            ex_p_adr_err <= 1'b0;
          else if (preset_irq_mask_i)
            ex_p_adr_err <= 1'b0;
                           
          if ((berr & haltn) & ex_state != GET_VECTOR) 
	    // Do not store the bus error during the interrupt acknowledge
	    // cycle (GET_VECTOR).
            ex_p_bus_err <= 1'b1;
          else if (ex_state == UPDATE_PC_HI & bus_cyc_rdy & exception_q == EX_BUS_ERR) 
            ex_p_bus_err <= 1'b0;
          else if (preset_irq_mask_i)
            ex_p_bus_err <= 1'b0;
                       
          if (trap_trace)
            ex_p_trace <= 1'b1;
          else if (ex_state == UPDATE_PC_HI & bus_cyc_rdy & exception_q == EX_TRACE)
            ex_p_trace <= 1'b0;
          else if (preset_irq_mask_i)
            ex_p_trace <= 1'b0;
                           
          if (irq_in == 3'b111) // Level 7 is nonmaskable ...
            begin 
               ex_p_int <= 1'b1;
               irq_out <= irq_in;
            end
          else if (status_reg_in[10:8] < irq_in) 
            begin 
               ex_p_int <= 1'b1;
               irq_out <= irq_in;
            end
          else if ((ex_state == GET_VECTOR) & bus_cyc_rdy) 
            ex_p_int <= 1'b0;
          else if (preset_irq_mask_i) // Reset when disabling the interrupts.
            ex_p_int <= 1'b0;
                           
	  // The following six traps never appear at the same time:
          if (trap_1010)
            ex_p_1010 <= 1'b1;
          else if (trap_1111)
            ex_p_1111 <= 1'b1;
          else if (trap_illegal)
            ex_p_illegal <= 1'b1;
          else if (trap_priv)
            ex_p_priv <= 1'b1;
          else if (trap_op)
            ex_p_trap <= 1'b1;
          else if (trap_v)
            ex_p_trapv <= 1'b1;
          else if ((ex_state == UPDATE_PC_HI) & bus_cyc_rdy) 
            case (exception_q)
              EX_PRIV,EX_1010,EX_1111,EX_ILLEGAL,EX_TRAP,EX_TRAPV : 
                begin 
                   ex_p_priv <= 1'b0;
                   ex_p_1010 <= 1'b0;
                   ex_p_1111 <= 1'b0;
                   ex_p_illegal <= 1'b0;
                   ex_p_trap <= 1'b0;
                   ex_p_trapv <= 1'b0;
                end
              default : 
                ;
            endcase
	  // Clear all possible traps during reset exception because the
	  // signal EXCEPTION_Q is not valid at this time:
          else if (preset_irq_mask_i) 
            begin 
               ex_p_priv <= 1'b0;
               ex_p_1010 <= 1'b0;
               ex_p_1111 <= 1'b0;
               ex_p_illegal <= 1'b0;
               ex_p_trap <= 1'b0;
               ex_p_trapv <= 1'b0;
            end
 
          if (trap_chk)
            ex_p_chk <= 1'b1;
          else if (ex_state == UPDATE_PC_HI & bus_cyc_rdy & (exception_q == EX_CHK))
            ex_p_chk <= 1'b0;
          else if (preset_irq_mask_i) 
            ex_p_chk <= 1'b0;
                       
          if (trap_divzero)
            ex_p_divzero <= 1'b1;
          else if ((ex_state == UPDATE_PC_HI) & bus_cyc_rdy & (exception_q == EX_DIVZERO))
            ex_p_divzero <= 1'b0;
          else if (preset_irq_mask_i) 
            ex_p_divzero <= 1'b0;
       end
   
       
   // The exceptions which occurs are stored in the following flags until the
   // interrupt handler handled the respective exception.
   // This process also stores the current processed exception for further use. 
   // The update takes place in the IDLE EX_STATE.
   always @(negedge resetn or posedge clk )
     if (~resetn)
       exception_q <= EX_NONE;
     else 
       if ((ex_state == IDLE ) & ex_p_reset) 
         exception_q <= EX_RESET;
       else if ((ex_state == IDLE ) & ex_p_adr_err)
         exception_q <= EX_ADR_ERR;
       else if ((ex_state == IDLE ) & ex_p_bus_err & berr)
         exception_q <= EX_NONE; // Wait until BERR is negated.
       else if ((ex_state == IDLE ) & ex_p_bus_err)
         exception_q <= EX_BUS_ERR;
       else if ((ex_state == WAIT_CTRL_RDY ) & ctrl_rdy & ex_p_illegal) 
         exception_q <= EX_ILLEGAL;
       else if ((ex_state == WAIT_CTRL_RDY ) & ctrl_rdy & ex_p_1010) 
         exception_q <= EX_1010;
       else if ((ex_state == WAIT_CTRL_RDY ) & ctrl_rdy & ex_p_1111) 
         exception_q <= EX_1111;
       else if ((ex_state == WAIT_CTRL_RDY ) & ctrl_rdy & ex_p_priv) 
         exception_q <= EX_PRIV;
       else if ((ex_state == WAIT_CTRL_RDY ) & ctrl_rdy & ex_p_trap) 
         exception_q <= EX_TRAP;
       else if ((ex_state == WAIT_CTRL_RDY ) & ctrl_rdy & ex_p_trapv) 
         exception_q <= EX_TRAPV;
       else if ((ex_state == WAIT_CTRL_RDY ) & ctrl_rdy & ex_p_chk) 
         exception_q <= EX_CHK;
       else if ((ex_state == WAIT_CTRL_RDY ) & ctrl_rdy & ex_p_divzero) 
         exception_q <= EX_DIVZERO;
       else if ((ex_state == WAIT_CTRL_RDY ) & ctrl_rdy & ex_p_trace) 
         exception_q <= EX_TRACE;
       else if ((ex_state == WAIT_CTRL_RDY ) & ctrl_rdy & ex_p_int)
         exception_q <= EX_INT;
       else if (next_ex_state == IDLE)
         exception_q <= EX_NONE;
       
   // For the most interrupts, a status register copy is necessary.
   // This is the register for a temporary copy of the status register
   // made in the first step of the exception processing. This copy is
   // in the third step written to the stack pointer, together with the
   // other information.
   // In the same manner the read write, the function code and the 
   // address information is saved.
   // The temporary copies are necessary to give the bus controller in
   // case of a bus error enough time to terminate the current bus cycle, 
   // means, no other bus access like status register stacking should 
   // appear immediately after the bus error occurs.

   always @(posedge clk )
     begin 
        if (tmp_cpy)
          begin 
             rwn_tmp <= rwn;
             fc_tmp <= fc_in;
             adr_tmp <= adr_in;
          end
               
        status_reg_tmp <= {sr_mem[9], 1'b0, sr_mem[8], 2'b00, sr_mem[7:5], 3'b000, sr_mem[4:0]};
     end 
   
   assign sr_mem = {status_reg_in[15], status_reg_in[13], status_reg_in[10:8], status_reg_in[4:0]};
       
   // This process provides the interrupt vector number INT_VECT, which
   // is determined during interrupt processing.
   always @(negedge resetn or posedge clk )
     begin 
        if (~resetn)
          vector_no = 8'b0; // Dummy assignement.
        else 
          if ((ex_state == VECT_NR ) | (ex_state == GET_VECTOR)) 
            begin 
               case (exception_q)
                 EX_RESET : 
                   vector_no = 8'h00;
                 EX_BUS_ERR : 
                   vector_no = 8'h02;
                 EX_ADR_ERR : 
                   vector_no = 8'h03;
                 EX_ILLEGAL : 
                   vector_no = 8'h04;
                 EX_DIVZERO : 
                   vector_no = 8'h05;
                 EX_CHK : 
                   vector_no = 8'h06;
                 EX_TRAPV : 
                   vector_no = 8'h07;
                 EX_PRIV : 
                   vector_no = 8'h08;
                 EX_TRACE : 
                   vector_no = 8'h09;
                 EX_1010 : 
                   vector_no = 8'h0A;
                 EX_1111 : 
                   vector_no = 8'h0B;
		 // The uninitialized interrupt vector number x"0F"
		 // is provided by the peripheral interrupt source
		 // during the auto vector bus cycle.
                 EX_INT : 
                   if (bus_cyc_rdy & berr) 
                     vector_no = 8'h18; // Spurious interrupt.
                   else if (bus_cyc_rdy & ~avecn) 
                     vector_no = 8'h18 + {5'b0,status_reg_in[10:8]}; // Autovector.
                   else if (bus_cyc_rdy) 
		     // This is the vector number provided by the device.
		     // If the returned Vector Number is x"0F" then it is the
		     // uninitialized interrupt vector due to non initia-
		     // lized vector register of the peripheral device.
                     vector_no = data_in; // Non autovector.
                 
                 EX_TRAP : 
                   vector_no = {4'h2,trap_vector};
                 default : 
                   vector_no = {8'bx}; // Don't care.
               endcase
               vect_tmp = 2'b00;
            end
          else if (inc_tmp_vector)
	    // Offset for the next two initial bytes during system initialisation.
            vect_tmp = vect_tmp + 1'b1; // Increment.
        
        int_vect <= {vector_no,2'b00} + {7'b0,vect_tmp,1'b0};
     end 
   
   // This is the register portion of the exception control state machine.

   always @(negedge resetn or posedge clk)
     if (~resetn)
       ex_state <= IDLE;
     else 
       if (~reset_cpun)
         ex_state <= IDLE; // Wait until the reset condition is released.
       else if (force_halt)
         ex_state <= HALT;
       else 
         ex_state <= next_ex_state;
                       
   // This is the decoder portion of the exception control state machine.
       
   always @(ex_state or ex_p_reset or ex_p_adr_err or ex_p_bus_err or ex_p_trace or ex_p_int or
            ex_p_illegal or ex_p_1010 or ex_p_1111 or ex_p_priv or ex_p_trap or ex_p_trapv or ex_p_chk or
            ex_p_divzero or exception_q or bus_cyc_rdy or ctrl_rdy or berr )
     begin 
	// Default assignements:
        exec_abort = 1'b0;
        tmp_cpy = 1'b0;
        irq_save = 1'b0;
        init_status = 1'b0;
        preset_irq_mask_i = 1'b0;
        ssp_init = 1'b0;
        pc_init = 1'b0;
        ssp_dec = 1'b0;
        use_int_vect = 1'b0;
        inc_tmp_vector = 1'b0;

        case (ex_state)
          IDLE: 
	    // The priority of the exception execution is given by the
	    // following construct. Although type 3 commands do not require
	    // a prioritization, there is no drawback using these conditions.
	    // The spurious interrupt and uninitialized interrupt never appear
	    // as basic interrupts and therefore are not an interrupt source.
	    // During IDLE, when an interrupt occurs, the status register copy
	    // control is asserted and the current interrupt controll is given
	    // to the STORE_EXCEPTION process. During bus or address errors,
	    // the status register must be copied immediately to recognize
	    // the current status for RWn etc. (before the faulty bus cycle is
	    // finished).
            if (ex_p_reset)
              begin 
                 exec_abort = 1'b1;
                 next_ex_state = INIT;
              end
            else if (ex_p_adr_err)
              begin 
                 exec_abort = 1'b1;
                 tmp_cpy = 1'b1; // Immediate copy of the status register.
                 next_ex_state = INIT;
              end
            else if (ex_p_bus_err & berr) // Wait until BERR is negated.
              next_ex_state = IDLE;
            else if (ex_p_bus_err) // Enter after BERR is negated.
              begin 
                 exec_abort = 1'b1;
                 tmp_cpy = 1'b1; // Immediate copy of the status register.
                 next_ex_state = INIT;
              end
            else if (ex_p_trap | ex_p_trapv | ex_p_chk | ex_p_divzero | ex_p_trace)
              next_ex_state = WAIT_CTRL_RDY;
            else if (ex_p_int | ex_p_illegal | ex_p_1010 | ex_p_1111 | ex_p_priv)
              next_ex_state = WAIT_CTRL_RDY;
            else // No exception.
              next_ex_state = IDLE;
          
          WAIT_CTRL_RDY: 
	    // In this state, the interrupt machine waits until the current 
	    // operation execution has finished. The copy of the status register
	    // is made after the excecution has finished.
            if (ctrl_rdy)
              begin 
                 tmp_cpy = 1'b1; // Copy the status register.
                 next_ex_state = INIT;
              end
            else 
              next_ex_state = WAIT_CTRL_RDY;

          
          INIT: 
	    // In this state, the supervisor mode is switched on (the S bit is set)
	    // and the trace mode is switched off (the T bit is cleared).
            begin 
               init_status = 1'b1;
               case (exception_q)
                 EX_RESET: 
                   begin 
                      preset_irq_mask_i = 1'b1;
                      next_ex_state = VECT_NR;
                   end
                 EX_INT: 
                   begin 
                      irq_save = 1'b1;
                      ssp_dec = 1'b1;
                      next_ex_state = GET_VECTOR;
                   end
                 default:
                   next_ex_state = VECT_NR;
               endcase
            end

          VECT_NR: 
	    // This state is introduced to control the generation of the vector number
	    // for all exceptions except the external interrupts.
            case (exception_q)
              EX_RESET : 
                next_ex_state = UPDATE_SSP_HI; // Do not stack anything but update the SSP and PC.
              default : 
                begin 
                   ssp_dec = 1'b1;
                   next_ex_state = STACK_PC_LO;
                end
            endcase

	  // The following states provide writing to the stack pointer or reading
	  // the exception vector address from the memory. If there is a bus error
	  // or an address error during the read or write cycles, the processor
	  // proceeds in two different ways:
	  // If the errors occur during a reset, bus error or address error
	  // exception processing, there is the case of a double bus fault. In
	  // consequence, the processor halts due to catastrophic system failure.
	  // If the errors occur during other exception processings, the current
	  // processing is aborted and this exception handler state machine will
	  // immediately begin with the bus error exception handling.

          GET_VECTOR: 
	    // This state is intended to determine the vector number for the current process.
	    // See also the process EX_VECTOR for the handling of the vector determination.
	    // The bus cycle for the vector access is located after the stack cycles due to
	    // correct prefetch behaviour.
            if (bus_cyc_rdy) 
              next_ex_state = STACK_PC_LO;
            else 
              next_ex_state = GET_VECTOR;
          
          STACK_PC_LO: 
            if (bus_cyc_rdy) 
              begin 
                 ssp_dec = 1'b1;
                 next_ex_state = STACK_PC_HI;
              end
            else 
              next_ex_state = STACK_PC_LO;
          
          STACK_PC_HI: 
            if (bus_cyc_rdy) 
              begin 
                 ssp_dec = 1'b1;
                 next_ex_state = STACK_STATUS;
              end
            else 
              next_ex_state = STACK_PC_HI;
          
          STACK_STATUS: 
            if (bus_cyc_rdy) 
              case (exception_q)
                EX_BUS_ERR,EX_ADR_ERR : 
                  begin 
                     ssp_dec = 1'b1;
                     next_ex_state = STACK_INSTRUCTION;
                  end
                default : 
                  next_ex_state = UPDATE_PC_HI;
              endcase
            else 
              next_ex_state = STACK_STATUS;
          
          STACK_INSTRUCTION  : 
            if (bus_cyc_rdy) 
              begin 
                 ssp_dec = 1'b1;
                 next_ex_state = STACK_ACCESS_ADR_LO;
              end
            else 
              next_ex_state = STACK_INSTRUCTION;

          STACK_ACCESS_ADR_LO: 
            if (bus_cyc_rdy) 
              begin 
                 ssp_dec = 1'b1;
                 next_ex_state = STACK_ACCESS_ADR_HI;
              end
            else 
              next_ex_state = STACK_ACCESS_ADR_LO;
          
          STACK_ACCESS_ADR_HI: 
            if (bus_cyc_rdy) 
              begin 
                 ssp_dec = 1'b1;
                 next_ex_state = STACK_MISC;
              end
            else 
              next_ex_state = STACK_ACCESS_ADR_HI;
          
          STACK_MISC: 
            if (bus_cyc_rdy) 
              next_ex_state = UPDATE_PC_HI;
            else 
              next_ex_state = STACK_MISC;
          
          UPDATE_SSP_HI: 
            begin 
               if (bus_cyc_rdy) 
                 begin 
                    inc_tmp_vector = 1'b1;
                    next_ex_state = UPDATE_SSP_LO;
                 end
               else 
                 next_ex_state = UPDATE_SSP_HI;

               use_int_vect = 1'b1;
            end

          UPDATE_SSP_LO: 
            begin 
               if (bus_cyc_rdy) 
                 begin 
                    inc_tmp_vector = 1'b1;
                    ssp_init = 1'b1;
                    next_ex_state = UPDATE_PC_HI;
                 end
               else 
                 next_ex_state = UPDATE_SSP_LO;

               use_int_vect = 1'b1;
            end

	  UPDATE_PC_HI: 
            begin 
               if (bus_cyc_rdy) 
                 begin 
                    inc_tmp_vector = 1'b1;
                    next_ex_state = UPDATE_PC_LO;
                 end
               else 
                 next_ex_state = UPDATE_PC_HI;

               use_int_vect = 1'b1;
            end

          UPDATE_PC_LO: 
            begin 
               if (bus_cyc_rdy) 
                 begin 
                    pc_init = 1'b1;
                    next_ex_state = IDLE;
                 end
               else 
                 next_ex_state = UPDATE_PC_LO;

               use_int_vect = 1'b1;
            end

          HALT: 
	    // Processor halted, Double bus error!
            next_ex_state = HALT;

	  default:
            next_ex_state = IDLE;
	    
        endcase
     end 

`ifdef debug
   always @(posedge clk)
     if (resetn)
       begin
          if (ex_state != next_ex_state)
	    case (next_ex_state)
	      IDLE: $display("ex_state -> IDLE");
	      WAIT_CTRL_RDY: $display("ex_state -> WAIT_CTRL_RDY");
	      INIT: $display("ex_state -> INIT");
	      VECT_NR: $display("ex_state -> VECT_NR");
	      GET_VECTOR: $display("ex_state -> GET_VECTOR");
	      STACK_MISC: $display("ex_state -> STACK_MISC");
	      STACK_ACCESS_ADR_HI: $display("ex_state -> STACK_ACCESS_ADR_HI");
	      STACK_ACCESS_ADR_LO: $display("ex_state -> STACK_ACCESS_ADR_LO");
	      STACK_INSTRUCTION: $display("ex_state -> STACK_INSTRUCTION");
	      STACK_STATUS: $display("ex_state -> STACK_STATUS");
	      STACK_PC_HI: $display("ex_state -> STACK_PC_HI");
	      STACK_PC_LO: $display("ex_state -> STACK_PC_LO");
	      UPDATE_SSP_HI: $display("ex_state -> UPDATE_SSP_HI");
	      UPDATE_SSP_LO: $display("ex_state -> UPDATE_SSP_LO");
	      UPDATE_PC_HI: $display("ex_state -> UPDATE_PC_HI");
	      UPDATE_PC_LO: $display("ex_state -> UPDATE_PC_LO");
	      HALT: $display("ex_state -> HALT");
	      default: ;
	    endcase
       end
`endif
    
endmodule
