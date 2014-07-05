//--------------------------------------------------------------------
//--                                                              ----
//-- MC68000 compatible IP Core				          ----
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
//--   - LINK (long).                                             ----
//--   - MOVE FROM CCR.                                           ----
//--   - MULS, MULU: all operation modes word and long.           ----
//--   - DIVS, DIVU: all operation modes word and long.           ----
//--   - DIVSL, DIVUL.                                            ----
//--   - Direct addressing mode enhancements for TST etc.         ----
//--   - PC relative addressing modes for operations like TST.    ----
//--                                                              ----
//-- This file is the top level file of the ip core.              ----
//--                                                              ----
//--                                                              ----
//--                                                              ----
//--                                                              ----
//-- Author(s):                                                   ----
//-- - Wolfgang Foerster, wf@experiment-s.de; wf@inventronik.de   ----
//--                                                              ----
//--------------------------------------------------------------------
//--                                                              ----
//-- Copyright (C) 2008 Wolfgang Foerster                         ----
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
// Revision 2K8B  2008/12/24 WF
//   Initial Release.
// 

module wf68k00ip_top(
		     input 	   clk,
		     input 	   reset_coren,

		     // Address and data:
		     output [23:1] adr,
		     input [15:0]  datain,
		     output [15:0] dataout,

		     // System control:
		     input 	   berrn,
		     input 	   resetinn,
		     output 	   resetoutn,
		     input 	   haltinn,
		     output 	   haltoutn,
		
		     // Processor status:
		     output [2:0]  fc,

		     // Interrupt control:
		     input 	   avecn, //- Originally 68Ks use VPAn.
		     input [2:0]   ipln,
		
		     // Aynchronous bus control:
		     input 	   dtackn,
		     output 	   asn,
		     output 	   rwn,
		     output 	   udsn,
		     output 	   ldsn,
		
		     // synchronous peripheral control:
		     output 	   e,
		     output 	   vman,
		     input 	   vpan,
		
		     // Bus arbitration control:
		     input 	   brn,
		     output 	   bgn,
		     input 	   bgackn
		     );
	
   wire reset_inn;
   wire reset_en;
   wire halt_en;
   wire adr_en;
   wire [23:1] adr_out;
   wire        data_en;
   wire [15:0] data_in;
   wire [15:0] data_out;
   wire        fc_en;
   wire [2:0]  fc_out;
   wire        as_outn;
   wire        as_en;
   wire        rwn_out;
   wire        rw_en;
   wire        uds_outn;
   wire        uds_en;
   wire        lds_outn;
   wire        lds_en;
   wire [2:0]  ipl_inn;
   wire        vma_outn;
   wire        vma_en;
   wire        avec_in;

   wire        resetn;
   wire        haltn;
   
   assign adr = adr_en ? adr_out : 0;
//   assign data = data_en ? data_out : 0;

   assign data_in = datain;
   assign dataout = data_out;
   
   // Inputs:
   assign reset_inn = resetn;
   assign ipl_inn = ipln;
   assign avec_in = avecn & vpan; // Wired or, use respective weak pull ups.

   // Open drain outputs:
   assign resetn = reset_en ? 0 : 1;
   assign haltn = halt_en ? 0 : 1;

   // Bus controls:
   assign asn	= ( as_outn & as_en) ? 1 :
		  (~as_outn & as_en) ? 0 :
		  0;

   assign udsn = ( uds_outn & uds_en) ? 1 :
		  (~uds_outn & uds_en) ? 0 :
		  0;
   
   assign ldsn = ( lds_outn & lds_en) ? 1 :
		  (~lds_outn & lds_en) ? 0 :
		  0;

   assign rwn = ( rwn_out & rw_en) ? 1 :
		 (~rwn_out & rw_en) ? 0 :
		 0;

   assign vman = ( vma_outn & vma_en) ? 1 :
		  (~vma_outn & vma_en) ? 0 :
		  0;

   // The function code:
   assign fc = fc_en ? fc_out : 0;

   wf68k00ip_top_soc i_68k00(
			     .clk             (clk),
			     .reset_coren     (reset_coren),
			     .adr_out         (adr_out),
			     .adr_en          (adr_en),
			     .data_in         (data_in),
			     .data_out        (data_out),
			     .data_en         (data_en),
			     .berrn           (berrn),
			     .reset_inn       (reset_inn),
			     .reset_out_en    (reset_en),
			     .halt_inn        (haltn),
			     .halt_out_en     (halt_en),
			     .fc_out          (fc_out),
			     .fc_out_en       (fc_en),
			     .avecn           (avec_in),
			     .ipln            (ipl_inn),
			     .dtackn          (dtackn),
			     .as_outn         (as_outn),
			     .as_out_en       (as_en),
			     .rwn_out         (rwn_out),
			     .rw_out_en       (rw_en),
			     .uds_outn        (uds_outn),
			     .uds_out_en      (uds_en),
			     .lds_outn        (lds_outn),
			     .lds_out_en      (lds_en),
			     .e               (e),
			     .vma_outn        (vma_outn),
			     .vma_out_en      (vma_en),
			     .vpan            (vpan),
			     .brn             (brn),
			     .bgn             (bgn),
			     .bgackn          (bgackn)
			     );

endmodule // wf68k00ip_top

