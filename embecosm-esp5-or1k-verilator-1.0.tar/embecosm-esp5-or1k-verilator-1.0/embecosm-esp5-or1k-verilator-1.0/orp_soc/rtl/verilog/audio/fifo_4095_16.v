/*******************************************************************
* This file was created by the Xilinx CORE Generator tool, and     *
* is (c) Xilinx, Inc. 1998, 1999. No part of this file may be      *
* transmitted to any third party (other than intended by Xilinx)   *
* or used without a Xilinx programmable or hardwire device without *
* Xilinx's prior written permission.                               *
*******************************************************************/ 

// The following line must appear at the top of the file in which
// the core instantiation will be made. Ensure that the translate_off/_on
// compiler directives are correct for your synthesis tool(s)

// Your Verilog compiler/interpreter might require the following
// option or it's equivalent to help locate the Xilinx Core Library
// +incdir+${XILINX}/verilog/src
// Here ${XILINX} refers to the XILINX software installation directory.

//----------- Begin Cut here for LIBRARY inclusion --------// LIB_TAG

// synopsys translate_off

//`include "XilinxCoreLib/async_fifo_v3_0.v"

// synopsys translate_on

// LIB_TAG_END ------- End LIBRARY inclusion --------------

// The following code must appear after the module in which it
// is to be instantiated. Ensure that the translate_off/_on compiler
// directives are correct for your synthesis tool(s).

//----------- Begin Cut here for MODULE Declaration -------// MOD_TAG

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module fifo_4095_16 (
	DIN,
	WR_EN,
	WR_CLK,
	RD_EN,
	RD_CLK,
	AINIT,
	DOUT,
	FULL,
	EMPTY,
	ALMOST_FULL,
	ALMOST_EMPTY);

input [15 : 0] DIN;
input WR_EN;
input WR_CLK;
input RD_EN;
input RD_CLK;
input AINIT;
output [15 : 0] DOUT;
output FULL;
output EMPTY;
output ALMOST_FULL;
output ALMOST_EMPTY;

// synopsys translate_off

	ASYNC_FIFO_V3_0 #(
		16,
		0,
		100,
		1,
		1,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		2,
		0,
		1,
		0,
		2,
		0)
	inst (
		.DIN(DIN),
		.WR_EN(WR_EN),
		.WR_CLK(WR_CLK),
		.RD_EN(RD_EN),
		.RD_CLK(RD_CLK),
		.AINIT(AINIT),
		.DOUT(DOUT),
		.FULL(FULL),
		.EMPTY(EMPTY),
		.ALMOST_FULL(ALMOST_FULL),
		.ALMOST_EMPTY(ALMOST_EMPTY));

// synopsys translate_on

endmodule

// MOD_TAG_END ------- End MODULE Declaration -------------
