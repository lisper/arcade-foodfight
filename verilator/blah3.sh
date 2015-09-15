#!/bin/sh

(cd tmp; \
g++  -I. -MMD -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd -DVL_PRINTF=printf -DVM_TRACE=1 -DVM_COVERAGE=0      -O -DCOSIM=1 -I../../emu/famec   -c ../cosim.cpp; \
g++  -I. -MMD -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd -DVL_PRINTF=printf -DVM_TRACE=1 -DVM_COVERAGE=0      -O -DCOSIM=1 -I../../emu/famec   -c ../ff_verilator.cpp; \
g++    cosim.o ff_verilator.o vga.o verilated.o verilated_dpi.o verilated_vcd_c.o Vff_verilator__ALL.a   -L../../emu/famec -lSDL -lpthread -lfame  -o Vff_verilator -lm -lstdc++)
