//
// foodfight
// m68000 cpu wrapper
// Brad Parker <brad@heeltoe.com> 5/2014
//

`ifndef no_cpu
`define WF68K
`endif

`ifdef WF68K

//`define CHIPSCOPE_M68K

`include "../m68k/wf68k00ip_address_registers.v"
`include "../m68k/wf68k00ip_alu.v"
`include "../m68k/wf68k00ip_bus_interface.v"
`include "../m68k/wf68k00ip_control.v"
`include "../m68k/wf68k00ip_data_registers.v"
`include "../m68k/wf68k00ip_interrupt_controller.v"
`include "../m68k/wf68k00ip_opcode_decoder.v"
`include "../m68k/wf68k00ip_shifter.v"
`include "../m68k/wf68k00ip_top_soc.v"
`include "../m68k/wf68k00ip_top.v"
`endif

module mc68000(
	       input 	     clk,
	       input 	     reset_n,
	       output [23:0] a_out,
	       input [15:0]  d_in,
	       output [15:0] d_out,
	       input [2:0]   ipl,
	       input 	     bgack_n,
	       output 	     bg_n,
	       input 	     br_n,
	       input 	     dtack_n,
	       output 	     lds_n,
	       output 	     uds_n,
	       output 	     r_w_n,
	       output 	     as_n,
	       input 	     halt_n,
	       input 	     berr_n,
	       input 	     vpa_n,
	       output 	     vma_n,
	       input 	     avec_n,
	       output 	     e,
	       output [2:0]  fc
	       );

`ifdef WF68K
   wire [23:1] adr;
   assign a_out = { adr, 1'b0 };
   
   wf68k00ip_top wf68k00ip_top(
			       .clk(clk),
			       .reset_coren(reset_n),
			       .adr(adr),
			       .datain(d_in),
			       .dataout(d_out),
			       .berrn(berr_n),
			       .resetinn(reset_n),
			       .resetoutn(),
			       .haltinn(halt_n),
			       .haltoutn(),
			       .fc(fc),
			       .avecn(avec_n),
			       .ipln(ipl),
			       .dtackn(dtack_n),
			       .asn(as_n),
			       .rwn(r_w_n),
			       .udsn(uds_n),
			       .ldsn(lds_n),
			       .e(e),
			       .vman(vma_n),
			       .vpan(vpa_n),
			       .brn(br_n),
			       .bgn(bg_n),
			       .bgackn(bgack_n)
			       );
`else
   assign a_out = 0;
   assign d_out = 0;
   assign lds_n = 1;
   assign uds_n = 1;
   assign r_w_n = 1;
   assign e = 0;
   assign fc = 0;
`endif

endmodule // mc68000
