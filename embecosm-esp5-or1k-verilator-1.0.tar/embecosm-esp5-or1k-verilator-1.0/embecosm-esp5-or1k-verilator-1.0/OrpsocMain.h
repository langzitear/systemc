// ----------------------------------------------------------------------------

// SystemC system wide declarations

// Copyright (C) 2008  Embecosm Limited <info@embecosm.com>

// Contributor Jeremy Bennett <jeremy.bennett@embecosm.com>

// This file is part of the cycle accurate model of the OpenRISC 1000 based
// system-on-chip, ORPSoC, built using Verilator.

// This program is free software: you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.

// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
// License for more details.

// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// ----------------------------------------------------------------------------

// SystemC declarations that should be visible anywhere. These should be
// consistent with the values used in the Verilog

// $Id: OrpsocMain.h 303 2009-02-16 11:20:17Z jeremy $

#ifndef ORPSOC_MAIN__H
#define ORPSOC_MAIN__H

//! The Verilog timescale unit (as SystemC timescale unit)
#define TIMESCALE_UNIT        SC_NS

//! The number of cycles of reset required
#define BENCH_RESET_TIME      10

//! CPU clock Half period in timescale units
#define BENCH_CLK_HALFPERIOD  50

#endif	// ORPSOC_MAIN__H
