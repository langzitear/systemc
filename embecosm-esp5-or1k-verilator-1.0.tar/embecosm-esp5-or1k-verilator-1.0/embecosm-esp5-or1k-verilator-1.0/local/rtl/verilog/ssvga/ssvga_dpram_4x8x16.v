// ssvga_dpram_4x8x16.v - generic dual ported RAM for VGA
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

// $Id: ssvga_dpram_4x8x16.v 310 2009-02-19 14:54:24Z jeremy $

// This is a generic, synthesizable 4Kb block RAM with dual 8/16-bit access,
// for use in cycle accurate simulation scenarios.

// Port A is 8-bit access, for a total addressibility of 512 bytes
// Port B is 16-bit access, for a total addressibility of 256 half-words


module ssvga_dpram_4x8x16 (clka,		// Port A
			   rsta,
			   addra,
			   dia,
			   doa,
			   ena,
			   wea,

			   clkb,		// PortB
			   rstb,
			   addrb,
			   dib,
			   dob,
			   enb,
			   web);

   input         clka;			// Port A clock
   input 	 rsta;			// Port A reset

   input [8:0] 	 addra;			// Port A address (9 bits, 512 bytes)
   input [7:0] 	 dia;			// Port A data in
   output [7:0]  doa;			// Port A data out
   input 	 ena;			// Port A enable
   input 	 wea;			// Port A write enable
   
   input 	 clkb;			// Port B clock
   input 	 rstb;			// Port B reset

   input [7:0]   addrb;			// Port B address (8 bits, 256 hwords)
   input [15:0]  dib;			// Port B data in
   output [15:0] dob;			// Port B data out
   input 	 enb;			// Port B enable
   input 	 web;			// Port B write enable

   reg [7:0] 	 doa;			// Register the data outputs
   reg [15:0] 	 dob;

   reg [7:0] 	 mem [511:0];		// 4096 bits, held as bytes

   // Read on port A (byte)
   always @(posedge clka) begin
      if (ena == 1'b1) begin
	 if (rsta == 1'b1) begin
	    doa <= 8'b0;
	 end
	 else if (wea == 0) begin
	    doa <= mem[addra];
	 end
	 else begin
	    doa <= dia;
	 end
      end
   end

   // Write on port A (byte)
   always @(posedge clka) begin
      if (ena == 1'b1 && wea == 1'b1) begin
	 mem[addra] <= dia;
      end
   end

   // Read on port B (half word)
   always @(posedge clkb) begin
      if (enb == 1'b1) begin
	 if (rstb == 1'b1) begin
	    dob <= 16'b0;
	 end
	 else if (web == 0) begin
	    dob[7:0]  <= mem[{addrb,1'b0}];
	    dob[15:8] <= mem[{addrb,1'b1}];
	 end
	 else begin
	    dob <= dib;
	 end
      end
   end

   // Write on port B (half word)
   always @(posedge clkb) begin
      if (enb == 1'b1 && web == 1'b1) begin
	 mem[{addrb,1'b0}] <= dib[7:0];
	 mem[{addrb,1'b1}] <= dib[15:8];
      end
   end

endmodule
