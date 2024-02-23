# Make file for ORPSoC Dhrystone Application
#
# Copyright (C) 2009 Embecosm Limited
#
# Contributor Jeremy Bennett <jeremy.bennett@embecosm.com>
#
# Based on the ORPSoC makefile, which is part of the open source distribution,
# but contains no attribution of authorship.
#
# This file is part of the test bench for the Embecosm cycle accurate SystemC
# JTAG library.
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


# Make unoptimized no-cache programs and optimzed no-cache and cache programs
cases = dhry-nocache-O0 dhry-nocache-O2 dhry-icdc-O2
common = ../support/libsupport.a

# Number of loops to use
NUM_RUNS ?= 1

# tools and flags
CC       = or32-uclinux-gcc
CPPFLAGS = -I../support -DNUM_RUNS=$(NUM_RUNS)
CFLAGS   = -mhard-div

LD      = or32-uclinux-ld
LDFLAGS = -T ../support/orp.ld

OBJCOPY      = or32-uclinux-objcopy
OBJCOPYFLAGS = -O binary

# Make everything
all: $(cases)

# No cache, unoptimized
dhry-nocache-O0: dhry-O0.o ../support/reset-nocache.o $(common)
	$(LD) $(LDFLAGS) $? -o $@.or32
	$(OBJCOPY) $(OBJCOPYFLAGS) $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex

# No cache, optimized
dhry-nocache-O2: dhry-O2.o ../support/reset-nocache.o $(common)
	$(LD) $(LDFLAGS) $? -o $@.or32
	$(OBJCOPY) $(OBJCOPYFLAGS) $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex

# I&D cache, optimized
dhry-icdc-O2: dhry-O2.o ../support/reset-icdc.o $(common)
	$(LD) $(LDFLAGS) $? -o $@.or32
	$(OBJCOPY) $(OBJCOPYFLAGS) $@.or32 $@.bin
	../utils/bin2hex $@.bin > $@.hex

# Dhrystone unoptimized
dhry-O0.o: dhry.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -O0 -c $? -o $@

# Dhrystone optimized
dhry-O2.o: dhry.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -O2 -c $? -o $@

# General clean up
clean:
	$(RM) *.o *.or32 *.log *.bin *.srec *.hex *.log stdout.txt
