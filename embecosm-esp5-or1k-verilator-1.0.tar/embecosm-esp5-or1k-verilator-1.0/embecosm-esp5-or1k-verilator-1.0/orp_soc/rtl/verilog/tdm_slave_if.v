//////////////////////////////////////////////////////////////////////
////                                                              ////
////  TDM slave controller, high speed version                    ////
////                                                              ////
////  This file is part of the OR1K test application              ////
////  http://www.opencores.org/cores/or1k/                        ////
////                                                              ////
////  Description                                                 ////
////  This block connectes the FPGA and CPLD on XESS XSV board    ////
////  using high speed time division multiplexing over serial     ////
////  connection. This block implements the slave part.           ////
////                                                              ////
////  To Do:                                                      ////
////   - nothing really                                           ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
////      - Simon Srot, simons@opencores.org                      ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2002 OpenCores                                 ////
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



// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module tdm_slave_if(
	clk, rst, tdmfrm, tdmrx, tdmtx,
	din, dout
);

//
// I/O ports
//

//
// Global signals
//
input		clk;
input 		rst;

//
// External CPLD signals
//
input		tdmfrm;
input		tdmrx;
output		tdmtx;

//
// Internal demuxed 8-bit buses
//
input	[7:0]	din;
output	[7:0]	dout;

//
// Internal regs and wires
//
reg	[2:0]	clk_cnt;
reg	[7:0]	dout;
reg             tdmtx;

//
// Counter for low speed clock and incoming JTAG data slots
// 
always @(posedge clk or posedge rst)
	if (rst)
		clk_cnt <= #1 3'b000;
	else if (tdmfrm)
		clk_cnt <= #1 3'b001;
	else
		clk_cnt <= #1 clk_cnt + 1;

//
// RX Data slot extraction
//
always @(posedge clk or posedge rst)
	if (rst) begin
		dout <= #1 8'b0000_0000;
	end else
	case (clk_cnt[2:0])
		3'd0:	dout[0] <= #1 tdmrx;
		3'd1:	dout[1] <= #1 tdmrx;
		3'd2:	dout[2] <= #1 tdmrx;
		3'd3:	dout[3] <= #1 tdmrx;
		3'd4:	dout[4] <= #1 tdmrx;
		3'd5:	dout[5] <= #1 tdmrx;
		3'd6:	dout[6] <= #1 tdmrx;
		3'd7:	dout[7] <= #1 tdmrx;
	endcase

//
// TX Data slot insertion
//
always @(clk_cnt or din)
	case (clk_cnt[2:0])
		3'd0:	tdmtx = din[0];
		3'd1:	tdmtx = din[1];
		3'd2:	tdmtx = din[2];
		3'd3:	tdmtx = din[3];
		3'd4:	tdmtx = din[4];
		3'd5:	tdmtx = din[5];
		3'd6:	tdmtx = din[6];
		3'd7:	tdmtx = din[7];
	endcase

endmodule

