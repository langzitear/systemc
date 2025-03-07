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

// $Id: sram_top.v 310 2009-02-19 14:54:24Z jeremy $

// This is a hugely simplified version of the SRAM controller with combined
// memory, suitable only for use in simulation/modeling environments.

module sram_top ( wb_clk_i,		// Wishbone common
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

   // Paraneter giving address width (default 512Kwords = 2MB)
   parameter	 aw = 19;

   // Wishbone common
   input	 wb_clk_i;
   input 	 wb_rst_i;

   // Wishbone slave
   output 	 wb_ack_o;
   input [31:0]  wb_adr_i;
   input 	 wb_cyc_i;
   input [31:0]  wb_dat_i;
   output [31:0] wb_dat_o;
   output 	 wb_err_o;
   input [3:0] 	 wb_sel_i;
   input 	 wb_stb_i;
   input 	 wb_we_i;

   // Internal wires and regs
   reg [7:0] 	 mem [2097151:0];	// The memory (2MB)
   wire [31:0] 	 adr;			// 24 bit address, word aligned
   integer 	 i;
   wire 	 wb_err;

   // Work out our 24 bit address (16MB)
   assign adr = {8'h00, wb_adr_i[23:2], 2'b00};
   
   // Read data from memory onto Wishbone
   assign wb_dat_o[7:0]   = mem[adr+3];
   assign wb_dat_o[15:8]  = mem[adr+2];
   assign wb_dat_o[23:16] = mem[adr+1];
   assign wb_dat_o[31:24] = mem[adr+0];

   // Write data from Wishbone into memory at the appropriate signals
   always @(posedge wb_rst_i or posedge wb_clk_i) begin
      if (wb_cyc_i & wb_stb_i & wb_we_i) begin
         if (wb_sel_i[0]) begin
            mem[adr+3] <= #1 wb_dat_i[7:0];
	 end
         if (wb_sel_i[1]) begin
            mem[adr+2] <= #1 wb_dat_i[15:8];
	 end
         if (wb_sel_i[2]) begin
            mem[adr+1] <= #1 wb_dat_i[23:16];
	 end
         if (wb_sel_i[3]) begin
            mem[adr+0] <= #1 wb_dat_i[31:24];
	 end
      end // if (wb_cyc_i & wb_stb_i & wb_we_i)
   end

   // All the other Wishbone signals. We drive the wishbone error if we try to
   // use more than 2MB (21 bits).
   assign wb_err_o = wb_cyc_i & wb_stb_i & (|wb_adr_i[23:21]);
   assign wb_ack_o = wb_cyc_i & wb_stb_i & ~wb_err_o;

endmodule
