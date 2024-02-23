# Make file for Verilated ORPSoC
#
# Copyright (C) 2009 Embecosm Limited
#
# Contributor Jeremy Bennett <jeremy.bennett@embecosm.com>
# 
# This file is part of the cycle accurate model of the OpenRISC 1000 based
# system-on-chip, ORPSoC, built using Verilator.
# 
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3 of the License, or (at your option)
# any later version.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
# 
# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>. */

# The C/C++ parts of this program are commented throughout in a fashion
# suitable for processing with Doxygen.

# Tools and flags
export OPT_FAST
export OPT_SLOW
export OPT

# Branch profiling flags should be used when compiling and linking
export USER_CPPFLAGS += $(PROF_FLAGS)
export USER_LDFLAGS += $(PROF_FLAGS)

ARFLAGS = rcs

# Custom flags


# Location of source files
OR1K_ROOT   ?= $(HOME)/partners/OpenCores/cvstrees/or1k
RTL_DIR     ?= $(OR1K_ROOT)/orp/orp_soc/rtl/verilog
RTL_LOCAL   ?= ../rtl/verilog
MEM_DIR     ?= $(OR1K_ROOT)/orp/orp_soc/lib/xilinx/unisims
MEM_LOCAL   ?= ../lib/memory


# Only need the trace target if we are tracing
ifneq (,$(findstring -trace, $(VFLAGS)))
TRACEOBJ = SpTraceVcdC.o
endif

# Object files
OBJS  = OrpsocAccess.o TraceSC.o
VOBJS = $(TRACEOBJ) verilated.o 

# Verilator ependency files
VDEPS = $(VTARGET)__ALLcls.d $(VTARGET)__ALLsup.d $(VTARGET)__ver.d

# Protection
VTARGET ?= "VTARGET has not been set"

# -----------------------------------------------------------------------------
# Rule to make dependency files
%.d: %.cpp
	@set -e; rm -f $@; \
		$(CXX) -MM $(CPPFLAGS) -I$(SYSTEMC)/include \
		-I$(VERILATOR_ROOT)/include $< > $@.$$$$; \
		sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
		rm -f $@.$$$$

# Rule to make object files
%.o: %.cpp
	$(MAKE) -f $(VTARGET).mk $@


# -----------------------------------------------------------------------------
# Make the complete library and all the associated components
lib$(VTARGET).a: $(VTARGET)__ALL.a $(VDEPS) $(VOBJS) $(OBJS)
	cp $(VTARGET)__ALL.a $@
	$(AR) $(ARFLAGS) $@ $(VOBJS) $(OBJS)

# Make the Verilator library and all the associated components
$(VTARGET)__ALL.a:
	make -f $(VTARGET).mk $(VTARGET)__ALL.a

# Verilator binaries have their own rule
$(VOBJS):
	$(MAKE) -f $(VTARGET).mk $@

# Verilate the RTL
$(VTARGET).mk:
	@sed < $(COMMAND_FILE) > v-processed.scr   \
		-e s!\$$RTL_DIR!../$(RTL_DIR)!     \
		-e s!\$$RTL_LOCAL!../$(RTL_LOCAL)! \
		-e \\!^//.*\$$!d -e \\!^\$$!d
	$(VERILATOR) $(VFLAGS) -Mdir . -sc -f v-processed.scr


# -----------------------------------------------------------------------------
# Tidy up
.PHONY: clean
clean:
	$(RM)  $(VTARGET)*
	$(RM)  *.d *.d.*
	$(RM)  *.o *.gcno *.gcda
	$(RM)  v-processed.scr
	$(RM)  lib$(VTARGET).a


# -----------------------------------------------------------------------------
# More modest tidy up for branch profiling
.PHONY: prof-clean
prof-clean:
	$(RM) *.o
	$(RM) $(VTARGET)__ALL.a lib$(VTARGET).a


# -----------------------------------------------------------------------------
# Include the dependency files
include $(OBJS:.o=.d)
include $(VDEPS)

# Verilator dependencies have their own rule
$(VDEPS): $(VTARGET).mk
