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
//-- This file contains the 68Ks data registers.                  ----
//--                                                              ----
//--                                                              ----
//-- Description:                                                 ----
//-- Contains the 68K00 data registers D0 to D7 and related logic ----
//-- to perform byte, word and long data operations.              ----
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
// 


module  wf68k00ip_data_registers ( clk, resetn, data_in_a, data_in_b, regsel_a, regsel_b, regsel_c, div_mul_32n64, data_out_a, data_out_b, data_out_c, dr_exg, dr_dec, dr_wr, op, op_size, op_mode, dbcc_cond );
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
    input [31:0] data_in_a;
    input [31:0] data_in_b;
    input [2:0]  regsel_a ;
    input [2:0]  regsel_b ;
    input [2:0]  regsel_c ;
    input  [0:0] div_mul_32n64;
    output [31:0]  data_out_a ;
    output [31:0]  data_out_b ;
    output [31:0]  data_out_c ;
    input  [0:0] dr_exg;
    input  [0:0] dr_dec;
    input  [0:0] dr_wr;
    input  [6:0] op;
    input  [1:0] op_size;
    input [4:0]  op_mode ;
    output  [0:0] dbcc_cond;


    reg [31:0] dr [0:7];
    wire [31:0] dr_nr_a;
    wire [31:0] dr_nr_b;
    wire [31:0] dr_nr_c;
    wire [31:0] data_out_a;
    wire [31:0] data_out_b;
    wire [31:0] data_out_c;
reg [0:0] dbcc_cond;


    
   assign {dr_nr_a}=regsel_a;
   assign {dr_nr_b}=regsel_b;
   assign {dr_nr_c}=regsel_c;

assign data_out_a = dr[dr_nr_a];
assign data_out_b = dr[dr_nr_b];
assign data_out_c = dr[dr_nr_c];
   
   //-- This process provides data transfer to the respective registers (write).
   //-- The MOVEM and MOVEQ require a sign extended source data. 
   //-- The BYTE size is not allowed for MOVEM .
   always @ (negedge resetn or posedge clk ) begin 
       if ((resetn == 1'b0)) 
           begin :Block_Name_1
               integer i;
               for (i=0;i<=7;i=i+1) begin 
                  dr[i] <= 0;
               end //for
           end //end Block
           
       else 
           
               if ((dr_wr == 1'b1)) 
                   begin 
                           if (((op == divs__op_68k00) | (op == divu__op_68k00))) 
                                   case (op_size)
                                       word__op_sizetype : 
                                               dr[dr_nr_a] <= data_in_a;
                                       default : // -- LONG.
                                               if (((div_mul_32n64 == 1'b0) & (dr[dr_nr_a] == dr[dr_nr_b])))  //-- Long 1.
                                                       dr[dr_nr_a] <= data_in_a;// -- Quotient returned.
                                               else 
                                                   begin // -- Long 2, 3.
                                                       dr[dr_nr_a] <= data_in_a;
                                                       dr[dr_nr_b] <= data_in_b;
                                                   end

                                               
                                   endcase
                           else if (((op == muls__op_68k00) | (op == mulu__op_68k00))) 
                               begin 
                                       if ((op_size == word__op_sizetype)) 
                                               dr[dr_nr_a] <= data_in_a;
                                       else if ((div_mul_32n64 == 1'b0))  //-- Long 1.
                                               dr[dr_nr_a] <= data_in_a;
                                       else  //-- Long 2.
                                           begin 
                                               dr[dr_nr_a] <= data_in_a;
                                               dr[dr_nr_b] <= data_in_b;
                                           end

                                       
                               end 
                           else if (((op == move__op_68k00) | (op == movep__op_68k00))) 
                                   case (op_size)
                                       long__op_sizetype : 
                                               dr[dr_nr_a] <= data_in_a;
                                       word__op_sizetype : 
                                               dr[dr_nr_a][15:0] <= data_in_a[15:0];
                                       byte__op_sizetype : 
                                               dr[dr_nr_a][7:0] <= data_in_a[7:0];
                                   endcase
                           else if ((op == moveq__op_68k00)) 
                               begin 
                                   begin :Block_Name_2
                                       integer i;
                                       for (i=31;i>=8;i=i-1) begin 
                                           dr[dr_nr_b][i] <= data_in_b[7];
                                           
                                       end //for
                                   end //end Block
                                   dr[dr_nr_b][7:0] <= data_in_b[7:0];
                               end
                           else if ((op == movem__op_68k00)) 
                               begin 
                                       if ((op_size == word__op_sizetype)) 
                                           begin 
                                               begin :Block_Name_3
                                                   integer i;
                                                   for (i=31;i>=16;i=i-1) begin 
                                                       dr[dr_nr_b][i] <= data_in_b[15];
                                                       
                                                   end //for
                                               end //end Block
                                               dr[dr_nr_b][15:0] <= data_in_b[15:0];
                                           end
                                       else 
                                               dr[dr_nr_b] <= data_in_b;

                                       
                               end 
                           else if (((op == extw__op_68k00) | (op == swap__op_68k00))) 
                                   dr[dr_nr_b] <= data_in_b;
                           else 
			     //-- Depending on the size to be written, not all bits of a register
			     //-- are affected.
                                   case (op_size)
                                       long__op_sizetype : 
                                               dr[dr_nr_b] <= data_in_b;
                                       word__op_sizetype : 
                                               dr[dr_nr_b][15:0] <= data_in_b[15:0];
                                       byte__op_sizetype : 
                                               dr[dr_nr_b][7:0] <= data_in_b[7:0];
                                   endcase

                           
                   end
      //-- Exchange the content of data registers:
               else if (((dr_exg == 1'b1) & (op_mode == 5'b01000))) 
                   begin // -- Exchange two data registers.
                       dr[dr_nr_b] <= data_in_a;
                       dr[dr_nr_a] <= data_in_b;
                   end
                   
               else if (((dr_exg == 1'b1) & (op_mode == 5'b10001)))
		 // -- Exchange a data and an address register.
                   dr[dr_nr_a] <= data_in_a;
      //-- And decrement:
               else if ((dr_dec == 1'b1)) 
                   dr[dr_nr_b][15:0] <= dr[dr_nr_b][15:0] - 1;// -- Used by the DBcc operation.
                   
       
    end// always 
       
   always @ (resetn or clk or dr_nr_b or dr_W  ) // begin 
       begin 
           if ((resetn == 1'b0)) 
               begin :Block_Name_4
                   integer i;
                   for (i=0;i<=7;i=i+1) begin 
                       
                   end //for
               end //end Block
               
	  //-- Test condition for the DBcc operation:
           case (dr[dr_nr_b][15:0])
             16'hffff:     dbcc_cond <= 1'b1; //-- This is signed -1.
               default : 
                       dbcc_cond <= 1'b0;
           endcase
       end 
   // end always 
    

    generate 
        begin :Block_Name_5
            wire [0* 32: (7 +1)*32-1 ] dr_W ;
            genvar j;
                for ( j=0; j<=7;j=j+1) begin :Block_Name_6
                      assign dr_W [j * 32 +:32 ]=dr[j];
                end//for 
        end//block
    endgenerate 

endmodule
