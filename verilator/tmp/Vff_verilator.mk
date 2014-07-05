# Verilated -*- Makefile -*-
# DESCRIPTION: Verilator output: Makefile for building Verilated archive or executable
#
# Execute this makefile from the object directory:
#    make -f Vff_verilator.mk

default: Vff_verilator

### Constants...
# Perl executable (from $PERL)
PERL = perl
# Path to Verilator kit (from $VERILATOR_ROOT)
VERILATOR_ROOT = /usr/local/share/verilator
# Path to SystemPerl kit top (from $SYSTEMPERL)
SYSTEMPERL = 
# Path to SystemPerl kit includes (from $SYSTEMPERL_INCLUDE)
SYSTEMPERL_INCLUDE = 

### Switches...
# SystemPerl output mode?  0/1 (from --sp)
VM_SP = 0
# SystemC output mode?  0/1 (from --sc)
VM_SC = 0
# SystemPerl or SystemC output mode?  0/1 (from --sp/--sc)
VM_SP_OR_SC = 0
# Deprecated
VM_PCLI = 1
# SystemC architecture to find link library path (from $SYSTEMC_ARCH)
VM_SC_TARGET_ARCH = linux

### Vars...
# Design prefix (from --prefix)
VM_PREFIX = Vff_verilator
# Module prefix (from --prefix)
VM_MODPREFIX = Vff_verilator
# User CFLAGS (from -CFLAGS on Verilator command line)
VM_USER_CFLAGS = \
	-DCOSIM=1 \

# User LDLIBS (from -LDFLAGS on Verilator command line)
VM_USER_LDLIBS = \
	-L../../emu/fame/x86/linux -lSDL -lpthread -lfame \

# User .cpp files (from .cpp's on Verilator command line)
VM_USER_CLASSES = \
	cosim \
	ff_verilator \
	vga \

# User .cpp directories (from .cpp's on Verilator command line)
VM_USER_DIR = \
	. \


### Default rules...
# Include list of all generated classes
include Vff_verilator_classes.mk
# Include global rules
include $(VERILATOR_ROOT)/include/verilated.mk

### Executable rules... (from --exe)
VPATH += $(VM_USER_DIR)

cosim.o: cosim.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
ff_verilator.o: ff_verilator.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<
vga.o: vga.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) $(OPT_FAST) -c -o $@ $<

### Link rules... (from --exe)
Vff_verilator: $(VK_USER_OBJS) $(VK_GLOBAL_OBJS) $(VM_PREFIX)__ALL.a
	$(LINK) $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS) -o $@ $(LIBS) $(SC_LIBS) 2>&1 | c++filt


# Verilated -*- Makefile -*-
