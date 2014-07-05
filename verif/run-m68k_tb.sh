#!/bin/sh

RTL="../m68k/wf68k00ip_address_registers.v  ../m68k/wf68k00ip_interrupt_controller.v \
     ../m68k/wf68k00ip_alu.v                ../m68k/wf68k00ip_opcode_decoder.v \
     ../m68k/wf68k00ip_bus_interface.v      ../m68k/wf68k00ip_shifter.v \
     ../m68k/wf68k00ip_control.v            ../m68k/wf68k00ip_top_soc.v \
     ../m68k/wf68k00ip_data_registers.v     ../m68k/wf68k00ip_top.v"

INC="+incdir+../m68k"

cver +define+debug=1 $INC $RTL m68k_tb.v
