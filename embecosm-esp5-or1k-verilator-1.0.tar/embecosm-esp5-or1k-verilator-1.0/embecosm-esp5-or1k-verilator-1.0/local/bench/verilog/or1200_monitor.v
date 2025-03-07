//////////////////////////////////////////////////////////////////////
////                                                              ////
////  OR1200's simulation monitor                                 ////
////                                                              ////
////  This file is part of the OpenRISC 1200 project              ////
////  http://www.opencores.org/cores/or1k/                        ////
////                                                              ////
////  Description                                                 ////
////  Simulation monitor                                          ////
////                                                              ////
////  To Do:                                                      ////
////   - move it to bench                                         ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
////      - Jeremy Bennett <jeremy.bennett@embecosm.com           ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
//// Copyright (C) 2009 Embecosm Limited                          ////
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
// SVN Revision History
//
// $Id: or1200_monitor.v 310 2009-02-19 14:54:24Z jeremy $
//
// 11 Feb 09: Jeremy Bennett. Simplified version to support just a minimal set
//            of l.nop instructions
//
// CVS Revision History
//
// $Log: or1200_monitor.v,v $
// Revision 1.4  2004/04/05 08:46:06  lampret
// Merged branch_qmem into main tree.
//
// Revision 1.3  2003/04/07 01:32:53  lampret
// Added get_gpr support for OR1200_RFRAM_GENERIC
//
// Revision 1.2  2002/08/12 05:38:11  lampret
// Added more WISHBONE protocol checks. Removed nop.log. Added general.log and lookup.log.
//
// Revision 1.1  2002/03/28 19:59:55  lampret
// Added bench directory
//
// Revision 1.9  2002/02/01 19:56:54  lampret
// Fixed combinational loops.
//
// Revision 1.8  2002/01/28 01:25:22  lampret
// Fixed display of new 'void' nop insns.
//
// Revision 1.7  2002/01/19 14:10:39  lampret
// Fixed OR1200_XILINX_RAM32X1D.
//
// Revision 1.6  2002/01/18 07:57:56  lampret
// Added support for reading XILINX_RAM32X1D register file.
//
// Revision 1.5  2002/01/14 06:19:35  lampret
// Added debug model for testing du. Updated or1200_monitor.
//
// Revision 1.4  2002/01/03 08:40:15  lampret
// Added second clock as RISC main clock. Updated or120_monitor.
//
// Revision 1.3  2001/11/23 08:50:35  lampret
// Typos.
//
// Revision 1.2  2001/11/10 04:22:55  lampret
// Modified monitor tu support exceptions.
//
// Revision 1.1.1.1  2001/11/04 18:51:07  lampret
// First import.
//
// Revision 1.1  2001/08/20 18:17:52  damjan
// Initial revision
//
// Revision 1.1  2001/08/13 03:37:07  lampret
// Added monitor.v and timescale.v
//
// Revision 1.1  2001/07/20 00:46:03  lampret
// Development version of RTL. Libraries are missing.
//
//


`include "timescale.v"


// Top of OR1200 FPGA
`define OR1200_TOP orpsoc_bench.i_orpsoc_fpga.or1200_top


// Monitor module
module or1200_monitor;

   integer    r3;

   // Task to get GPR
   task get_gpr;
      input [4:0]   gpr_no;
      output [31:0] gpr;
      integer 	    j;
      
      begin
	 for (j = 0; j < 32; j = j + 1) begin
	    gpr[j] = `OR1200_TOP.or1200_cpu.or1200_rf.rf_a.mem[gpr_no*32+j];
	 end
      end
   endtask

   // Initialization
   initial begin
      $timeformat (-9, 2, " ns", 12);
   end

   // Special l.nop functions
   always @(posedge `OR1200_TOP.or1200_cpu.or1200_ctrl.clk) begin
      if (!`OR1200_TOP.or1200_cpu.or1200_ctrl.wb_freeze) begin
	 #2;

	 // l.nop 1 terminates simulation
	 if (`OR1200_TOP.or1200_cpu.or1200_ctrl.wb_insn == 32'h1500_0001) begin
	    get_gpr(3, r3);
	    $display ("%t: l.nop exit (%h)", $time, r3);
	    $finish;
	 end

	 // l.nop 2 reports the value in GPR3
	 if (`OR1200_TOP.or1200_cpu.or1200_ctrl.wb_insn == 32'h1500_0002) begin
	    get_gpr(3, r3);
	    $display ("%t: l.nop report (%h)", $time, r3);
	 end

	 // l.nop 3 does a printf of the string pointed to by R3, with args
	 // following the OR1200 ABI. Not properly implemented here!
	 if (`OR1200_TOP.or1200_cpu.or1200_ctrl.wb_insn == 32'h1500_0003) begin
	    get_gpr(3, r3);
	    $display ("%t: l.nop printf (%h) - unsupported", $time, r3);
	 end

	 // l.nop 4 prints the character in GPR3. Flush, because we are
	 // typically monitoring this dynamically.
	 if (`OR1200_TOP.or1200_cpu.or1200_ctrl.wb_insn == 32'h1500_0004) begin
	    get_gpr(3, r3);
	    $write ("%c", r3);
	    $fflush ();
	 end
      end // if (!`OR1200_TOP.or1200_cpu.or1200_ctrl.wb_freeze)      
   end // always @ (posedge `OR1200_TOP.or1200_cpu.or1200_ctrl.clk)
   
endmodule
