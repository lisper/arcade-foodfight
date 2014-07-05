//----------------------------------------------------------------------
//----                                                              ----
//---- MC68000 compatible IP Core				    ----
//----                                                              ----
//---- This file is part of the SUSKA ATARI clone project.          ----
//---- http://www.experiment-s.de                                   ----
//----                                                              ----
//---- Description:                                                 ----
//---- This model provides an opcode and bus timing compatible ip   ----
//---- core compared to Motorola's MC68000 microprocessor.          ----
//----                                                              ----
//---- The following operations are additionally supported by this  ----
//---- core:                                                        ----
//----   - LINK (long).                                             ----
//----   - MOVE FROM CCR.                                           ----
//----   - MULS, MULU: all operation modes word and long.           ----
//----   - DIVS, DIVU: all operation modes word and long.           ----
//----   - DIVSL, DIVUL.                                            ----
//----   - Direct addressing mode enhancements for TST etc.         ----
//----   - PC relative addressing modes for operations like TST.    ----
//----                                                              ----
//---- This file is the top level file of the ip core.              ----
//----                                                              ----
//----                                                              ----
//----                                                              ----
//----                                                              ----
//---- Author(s):                                                   ----
//---- - Wolfgang Foerster, wf@experiment-s.de; wf@inventronik.de   ----
//----                                                              ----
//----------------------------------------------------------------------
//----                                                              ----
//---- Copyright (C) 2008 Wolfgang Foerster                         ----
//----                                                              ----
//---- This source file is free software; you can redistribute it   ----
//---- and/or modify it under the terms of the GNU General Public   ----
//---- License as published by the Free Software Foundation; either ----
//---- version 2 of the License, or (at your option) any later      ----
//---- version.                                                     ----
//----                                                              ----
//---- This program is distributed in the hope that it will be      ----
//---- useful, but WITHOUT ANY WARRANTY; without even the implied   ----
//---- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ----
//---- PURPOSE.  See the GNU General Public License for more        ----
//---- details.                                                     ----
//----                                                              ----
//---- You should have received a copy of the GNU General Public    ----
//---- License along with this program; if not, write to the Free   ----
//---- Software Foundation, Inc., 51 Franklin Street, Fifth Floor,  ----
//---- Boston, MA 02110-1301, USA.                                  ----
//----                                                              ----
//----------------------------------------------------------------------
//-- 
//-- Revision History
//-- 
//-- Revision 2K8B  2008/12/24 WF
//--   Initial Release.
//-- 

module wf68k00ip_top(
    input CLK,
    input RESET_COREn,
    // Address and data:
    output [23:1] ADR,
    inout [15:0]  DATA,

		     // System control:
		     input BERRn,
		     inout RESETn, // Open drain.
		     inout HALTn, // Open drain.
		
		     // Processor status:
		     output [2:0] FC,

		     // Interrupt control:
		     input AVECn, //- Originally 68Ks use VPAn.
		     input [2:0] IPLn,
		
		     // Aynchronous bus control:
		     input DTACKn,
		     output ASn,
		     output RWn,
		     output UDSn,
		     output LDSn,
		
		     // Synchronous peripheral control:
		     output E,
		     output VMAn,
		     input VPAn,
		
		     // Bus arbitration control:
		     input BRn,
		     output BGn,
		     input BGACKn
		     );
	
wire RESET_INn    ;
wire RESET_EN     ;
wire HALT_EN      ;
wire ADR_EN       ;
wire [23:1] ADR_OUT;
wire DATA_EN      ;
wire [15:0] DATA_OUT;
wire FC_EN        ;
wire [2:0] FC_OUT;
wire AS_OUTn      ;
wire AS_EN        ;
wire RWn_OUT      ;
wire RW_EN        ;
wire UDS_OUTn     ;
wire UDS_EN       ;
wire LDS_OUTn     ;
wire LDS_EN       ;
wire [2:9] IPL_INn;
wire VMA_OUTn     ;
wire VMA_EN       ;
wire AVEC_In      ;

   assign ADR = ADR_EN ? ADR_OUT : 0;
   assign DATA = DATA_EN ? DATA_OUT : 0;

   // Inputs:
   assign RESET_INn = RESETn;
   assign IPL_INn = IPLn;
   assign AVEC_In = AVECn & VPAn; // Wired or, use respective weak pull ups.

   // Open drain outputs:
   assign RESETn = RESET_EN ? 0 : 1;
   assign HALTn = HALT_EN ? 0 : 1;

   // Bus controls:
   assign ASn	= ( AS_OUTn & AS_EN) ? 1 :
		  (~AS_OUTn & AS_EN) ? 0 :
		  0;

   assign UDSn <= ( UDS_OUTn & UDS_EN) ? 1 :
		  (~UDS_OUTn & UDS_EN) ? 0 :
		  0;
   
   assign LDSn <= ( LDS_OUTn & LDS_EN) ? 1 :
		  (~LDS_OUTn & LDS_EN) ? 0 :
		  0;

   assign RWn <= ( RWn_OUT & RW_EN) ? 1 :
		 (~RWn_OUT & RW_EN) ? 0 :
		 0;

   assign VMAn <= ( VMA_OUTn & VMA_EN) ? 1 :
		  (~VMA_OUTn & VMA_EN) ? 0 :
		  0;

   // The function code:
   assign FC = FC_EN ? FC_OUT : 0;

   wf68k00ip_top_soc i_68k00(
			     .CLK             (CLK),
			     .RESET_COREn     (RESET_COREn),
			     .ADR_OUT         (ADR_OUT),
			     .ADR_EN          (ADR_EN),
			     .DATA_IN         (DATA),
			     .DATA_OUT        (DATA_OUT),
			     .DATA_EN         (DATA_EN),
			     .BERRn           (BERRn),
			     .RESET_INn       (RESET_INn),
			     .RESET_OUT_EN    (RESET_EN),
			     .HALT_INn        (HALTn),
			     .HALT_OUT_EN     (HALT_EN),
			     .FC_OUT          (FC_OUT),
			     .FC_OUT_EN       (FC_EN),
			     .AVECn           (AVEC_In),
			     .IPLn            (IPL_INn),
			     .DTACKn          (DTACKn),
			     .AS_OUTn         (AS_OUTn),
			     .AS_OUT_EN       (AS_EN),
			     .RWn_OUT         (RWn_OUT),
			     .RW_OUT_EN       (RW_EN),
			     .UDS_OUTn        (UDS_OUTn),
			     .UDS_OUT_EN      (UDS_EN),
			     .LDS_OUTn        (LDS_OUTn),
			     .LDS_OUT_EN      (LDS_EN),
			     .E               (E),
			     .VMA_OUTn        (VMA_OUTn),
			     .VMA_OUT_EN      (VMA_EN),
			     .VPAn            (VPAn),
			     .BRn             (BRn),
			     .BGn             (BGn),
			     .BGACKn          (BGACKn)
            );

endmodule // wf68k00ip_top

