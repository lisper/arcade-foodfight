#!/bin/sh

#(cd tmp; rm -f *.o ; make OPT="-v -O" -f Vff_verilator.mk)

(cd tmp; rm -f *.o ; make OPT="-O2" -f Vff_verilator.mk)


