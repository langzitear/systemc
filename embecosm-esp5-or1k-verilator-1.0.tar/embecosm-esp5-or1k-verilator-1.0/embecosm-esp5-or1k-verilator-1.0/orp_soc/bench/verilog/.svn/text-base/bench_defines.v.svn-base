//////////////////////////////////////////////////////////////////////
////                                                              ////
////  XESS test bench definitions                                 ////
////                                                              ////
////  This file is part of the OR1K test application              ////
////  http://www.opencores.org/cores/or1k/xess/                   ////
////                                                              ////
////  Description                                                 ////
////  Definitions for the test bench.                             ////
////                                                              ////
////  To Do:                                                      ////
////   - nothing really                                           ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2001 Authors                                   ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS Revision History
//
// $Log: bench_defines.v,v $
// Revision 1.2  2004/04/05 08:46:06  lampret
// Merged branch_qmem into main tree.
//
// Revision 1.1  2002/03/28 19:59:54  lampret
// Added bench directory
//
// Revision 1.2  2002/01/03 08:40:14  lampret
// Added second clock as RISC main clock. Updated or120_monitor.
//
// Revision 1.1.1.1  2001/11/04 18:51:06  lampret
// First import.
//
//

//
// Reset active time for simulation
//
`define BENCH_RESET_TIME	10

//
// Clock half period for simulation
//
`define BENCH_CLK_HALFPERIOD	75

//
// OR1200 clock mode
//
`ifdef OR1200_CLMODE_1TO2
`define CLK2_HALFPERIOD		25
`else 
`ifdef OR1200_CLMODE_1TO4
Unsuppported
`else                   
`define CLK2_HALFPERIOD		50
`endif
`endif

//`define FLASH_GENERIC
