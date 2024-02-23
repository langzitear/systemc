# Make file for application software
#
# Copyright (C) 2009 Embecosm Limited
#
# Contributor Jeremy Bennett <jeremy.bennett@embecosm.com>
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

# The C/C++ parts of this program are commented throughout in a fashion
# suitable for processing with Doxygen.


export NUM_RUNS ?= 1

# -----------------------------------------------------------------------------
# Make the software in each directory in turn
.PHONY: all
all:
	cd utils   && $(MAKE)
	cd support && $(MAKE)
	cd dhry    && $(MAKE)


# -----------------------------------------------------------------------------
# Tidy up each directory in turn
clean:
	cd dhry    && $(MAKE) clean
	cd support && $(MAKE) clean
	cd utils   && $(MAKE) clean
