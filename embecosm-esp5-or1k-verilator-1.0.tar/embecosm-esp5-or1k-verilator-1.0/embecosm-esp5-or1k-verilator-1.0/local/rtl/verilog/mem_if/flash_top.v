// flash_top.v - Flash memory controller for Verilated ORPSoC
//
// Copyright (C) 2009 Embecosm Limited
//
// Contributor Jeremy Bennett <jeremy.bennett@embecosm.com>
// 
// This file is part of the cycle accurate model of the OpenRISC 1000 based
// system-on-chip, ORPSoC, built using Verilator.
// 
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 3 of the License, or (at your option)
// any later version.
// 
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
// more details.
// 
// You should have received a copy of the GNU General Public License along
// with this program.  If not, see <http://www.gnu.org/licenses/>. */

// WARNING. This module links with the main ORPSoC distribution, which is
// licensed with the GNU Lesser General Public License (LGPL). If you
// distribute software based on the two combined, the General Public License
// (GPL) will take precedence, making the entire system subject to the GPL.

// $Id: flash_top.v 310 2009-02-19 14:54:24Z jeremy $


// This is a hugely simplified version of flash controller with combined
// memory, suitable only for use in cycle accurate simulation/modeling
// environments.

module flash_top ( wb_clk_i,		// Wishbone common
		   wb_rst_i,

		   wb_ack_o,		// Wishbone slave
		   wb_adr_i,
		   wb_cyc_i,
		   wb_dat_i,
		   wb_dat_o,
		   wb_err_o,
		   wb_sel_i,
		   wb_stb_i,
		   wb_we_i   );

   // Common Wishbone signals
   input	 wb_clk_i;
   input 	 wb_rst_i;
   
   // Wishbone slave
   output	 wb_ack_o;
   input [31:0]  wb_adr_i;
   input	 wb_cyc_i;
   input [31:0]  wb_dat_i;
   output [31:0] wb_dat_o;
   output	 wb_err_o;
   input [3:0] 	 wb_sel_i;
   input	 wb_stb_i;
   input	 wb_we_i;

   // Internal wires and regs
   reg [7:0] 	 mem [2097151:0];	// The memory (2MB)
   wire [31:0] 	 adr;			// 24 bit address, word aligned

   // The image is loaded from a file. We'll usually get a moan about not all
   // being there, but there's no point in stuffing zeros into vast amounts of
   // memory.
   initial begin
`ifdef __ICARUS__
      $display("Loading flash image from ../src/flash.in");
      $readmemh("../src/flash.in", mem, 0);
`else
      $display("Loading flash image from sim/src/flash.in");
      $readmemh("sim/src/flash.in", mem, 0);
`endif
   end

   // Work out our 24 bit address (16MB).
   assign adr        = {8'h00, wb_adr_i[23:2], 2'b00};

   // Read the data from the memory onto Wishbone
   assign wb_dat_o[7:0]   = wb_adr_i[23:0] < 65535 ? mem[adr+3] : 8'h00;
   assign wb_dat_o[15:8]  = wb_adr_i[23:0] < 65535 ? mem[adr+2] : 8'h00;
   assign wb_dat_o[23:16] = wb_adr_i[23:0] < 65535 ? mem[adr+1] : 8'h00; 
   assign wb_dat_o[31:24] = wb_adr_i[23:0] < 65535 ? mem[adr+0] : 8'h00; 

   // All the other Wishbone signals. We drive the wishbone error if we try to
   // use more than 2MB (21 bits).
   assign wb_err_o = wb_cyc_i & wb_stb_i & (|wb_adr_i[23:21]);
   assign wb_ack_o = wb_cyc_i & wb_stb_i & ~wb_err_o;

endmodule
