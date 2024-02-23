# Top level Linux make file for Verilated ORPSoC
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


# Tools and flags are exported to sub-makes.
export IVERILOG  ?= iverilog
export VVP       ?= vvp

export VERILATOR ?= verilator
export VFLAGS
export OPT_FAST
export OPT_SLOW
export OPT

# All Verilator C++ optimization flags, for use in other compilations
OPT_ALL = $(OPT_SLOW) $(OPT_FAST) $(OPT)

# Branch profiling flags
export PROF_FLAGS ?=
PROF_OPTS ?= -fbranch-probabilities -fvpt -funroll-loops -fpeel-loops -ftracer

# Command files
export COMMAND_FILE ?= cf-baseline.scr

# Location of original source files.
BENCH_DIR      ?= orp_soc/bench/verilog
export RTL_DIR ?= orp_soc/rtl/verilog

# Location of customized source files
BENCH_LOCAL      ?= local/bench/verilog
export RTL_LOCAL ?= local/rtl/verilog
SW_LOCAL         ?= local/sw

# Sub-directories
MODEL_DIR  = verilator-model
MODULE_DIR = sysc-modules

INC_DIRS   = -I$(MODEL_DIR) -I$(MODULE_DIR) \
	     -I$(SYSTEMC)/include -I$(VERILATOR_ROOT)/include
LIB_DIRS   = -L$(MODEL_DIR) -L$(MODULE_DIR) \
	     -L$(SYSTEMC)/lib-linux

# Libraries
MODEL_LIB  = $(VTARGET)
MODULE_LIB = modules

# Get the libraries in the right order!
LIBS       = -l$(MODEL_LIB) -l$(MODULE_LIB) -lsystemc

LIB_TARGETS = model modules

# Local objects
OBJS = OrpsocMain.o
SRCS = $(OBJS:.o=.cpp)
HDRS = $(OBJS:.o=.h)

# Target. Verilator target is exported to sub-makes
ORPSOC_ROOT    = orpsoc_fpga_top
export VTARGET = V$(ORPSOC_ROOT)

# Embedded software to use, and number of runs. The latter is exported to
# sub-makes
PROG             = dhry/dhry-icdc-O2
export NUM_RUNS ?= 1

# Distribution base name
DISTVER  = 1.0
DISTBASE = embecosm-esp5-or1k-verilator-$(DISTVER)


# -----------------------------------------------------------------------------
# Make and run the system model
.PHONY: verilate
verilate: $(VTARGET)
	time -p ./$(VTARGET)

$(VTARGET): software $(LIB_TARGETS) $(OBJS)
	$(CXX) $(CXXFLAGS) $(OPT_ALL) $(PROF_FLAGS) \
		-o $(VTARGET) $(LIB_DIRS) $(OBJS) $(LIBS)

# The main program
$(OBJS): $(SRCS) $(HDRS)
	$(CXX) $(CXXFLAGS) $(INC_DIRS) $(OPT_ALL) $(PROF_FLAGS) -c $<

# The embedded software
.PHONY: software
software:
	cd $(SW_LOCAL) && $(MAKE)
	cd sim/src && $(RM) flash.in
	cd sim/src && ln -s ../../$(SW_LOCAL)/$(PROG).hex flash.in

# The Verilated model, including modules intimately dependent on the model
.PHONY: model
model:
	cd $(MODEL_DIR) && time -p $(MAKE)

# The other SystemC modules library
.PHONY: modules
modules:
	cd $(MODULE_DIR) && $(MAKE)


# -----------------------------------------------------------------------------
# Make and run the system model with branch profiling optimization
.PHONY: verilate-fast
verilate-fast:
	$(MAKE) $(VTARGET) PROF_FLAGS+="-ftest-coverage -fprofile-generate"
	time -p ./$(VTARGET)
	cd $(MODEL_DIR) && $(MAKE) prof-clean
	cd $(MODULE_DIR) && $(MAKE) prof-clean
	$(RM)  *.o $(VTARGET)
	$(MAKE) $(VTARGET) PROF_FLAGS+="$(PROF_OPTS)"
	time -p ./$(VTARGET)


# -----------------------------------------------------------------------------
# Simulate
simulate: software
	@cd sim/run && sed < ../$(COMMAND_FILE) > iv-processed.scr \
		-e s!\$$BENCH_LOCAL!../../$(BENCH_LOCAL)!          \
		-e s!\$$BENCH_DIR!../../$(BENCH_DIR)!              \
		-e s!\$$RTL_LOCAL!../../$(RTL_LOCAL)!              \
		-e s!\$$RTL_DIR!../../$(RTL_DIR)!                  \
		-e \\!^//.*\$$!d -e \\!^\$$!d
	cd sim/run && time -p $(IVERILOG) -c iv-processed.scr $(VFLAGS)
	cd sim/run && time -p $(VVP) a.out


# -----------------------------------------------------------------------------
# Make a distribution file
dist: clean
	mkdir /tmp/$(DISTBASE)
	cp -r * /tmp/$(DISTBASE)
	mv /tmp/$(DISTBASE) .
	tar jcf $(DISTBASE).tar.bz2 ./$(DISTBASE)
	$(RM) -r $(DISTBASE)

# -----------------------------------------------------------------------------
# Tidy up. The model clean will get its knickers in a twist trying to rebuild
# a Verilated make file, but overcome this by running it silently and keeping
# going and ignoring its failure return.
clean:
	-cd $(MODEL_DIR) && $(MAKE) -ks clean
	cd $(MODULE_DIR) && $(MAKE) clean
	cd $(SW_LOCAL)   && $(MAKE) clean
	$(RM) -r sim/run/*
	$(RM) -r sim/src/*
	$(RM) -r $(DISTBASE)
	$(RM) $(DISTBASE).tar.bz2
	$(RM)  *.d *.d.*
	$(RM)  *.o
	$(RM)  *.gcda *.gcno
	$(RM)  *.gcov
	$(RM)  $(VTARGET) v-dump.vcd
	$(RM)  gprof.out gmon.out
	find . -name '*~' -exec $(RM) {} \;
