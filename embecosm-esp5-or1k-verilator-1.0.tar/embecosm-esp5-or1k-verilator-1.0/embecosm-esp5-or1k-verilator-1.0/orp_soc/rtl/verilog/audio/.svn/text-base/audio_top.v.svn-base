//////////////////////////////////////////////////////////////////////
////                                                              ////
////  XESS Audio Interface Top Level                              ////
////                                                              ////
////  This file is part of the OR1K test application              ////
////  http://www.opencores.org/cores/or1k/xess/                   ////
////                                                              ////
////  Description                                                 ////
////  Audio interface top level for XSV board instantiating       ////
////  FIFOs, WISHBONE interface and XSV CODEC interface.          ////
////                                                              ////
////  To Do:                                                      ////
////   - DOES NOT WORK RIGHT NOW                                  ////
////                                                              ////
////  Author(s):                                                  ////
////      - Lior Shtram, lior.shtram@flextronicssemi.com          ////
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
// $Log: audio_top.v,v $
// Revision 1.1.1.1  2002/03/21 16:55:44  lampret
// First import of the "new" XESS XSV environment.
//
//
// Revision 1.1.1.1  2001/11/04 19:00:08  lampret
// First import.
//
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

module audio_top (
	wb_clk_i, wb_rst_i,

	wb_dat_i, wb_dat_o, wb_adr_i, wb_sel_i, wb_we_i, wb_cyc_i,
	wb_stb_i, wb_ack_o, wb_err_o,

	m_wb_dat_o, m_wb_dat_i, m_wb_adr_o, m_wb_sel_o, m_wb_we_o, m_wb_cyc_o,
	m_wb_stb_o, m_wb_ack_i, m_wb_err_i,

	mclk, lrclk, sclk, sdin, sdout	
);

input		wb_clk_i;
input		wb_rst_i;

input [31:0]	wb_dat_i;
output [31:0]	wb_dat_o;
input [31:0]	wb_adr_i;
input [3:0]	wb_sel_i;
input		wb_we_i;
input		wb_cyc_i;
input		wb_stb_i;
output		wb_ack_o;
output		wb_err_o;

output [31:0]	m_wb_dat_o;
input [31:0]	m_wb_dat_i;
output [31:0]	m_wb_adr_o;
output [3:0]	m_wb_sel_o;
output		m_wb_we_o;
output		m_wb_cyc_o;
output		m_wb_stb_o;
input		m_wb_ack_i;
input		m_wb_err_i;

output		mclk;
output		lrclk;
output		sclk;
output		sdin;
input		sdout;

parameter fifo_width = 16;

`ifdef UNUSED

wire [fifo_width-1:0]	fifo_data_i;
wire [fifo_width-1:0]	fifo_data_o;
wire 		fifo_clk_wr;
wire		fifo_clk_rd;
wire		fifo_full;
wire		fifo_empty;
wire		fifo_almost_full;
wire		fifo_almost_empty;
wire		fifo_rd_en;
wire		fifo_wr_en;

wire		clk = wb_clk_i;
wire		rstn = ~wb_rst_i;

//assign audio_dreq = fifo_almost_empty;
// assign USB_VPO = fifo_almost_full;
// assign USB_VMO = fifo_almost_empty;

assign m_wb_dat_o = 32'h0000_0000;
assign m_wb_adr_o = 32'h0000_0000;
assign m_wb_sel_o = 4'b0000;
assign m_wb_we_o = 1'b0;
assign m_wb_cyc_o = 1'b0;
assign m_wb_stb_o = 1'b0;


audio_wb_if	i_audio_wb_if(
		.rstn( rstn ),
		.clk( clk ),
		.wb_dat_i( wb_dat_i ),
		.wb_dat_o( wb_dat_o ),
		.wb_adr_i( wb_adr_i ),
		.wb_sel_i( wb_sel_i ),
		.wb_we_i( wb_we_i ),
		.wb_cyc_i( wb_cyc_i ),
		.wb_stb_i( wb_stb_i ),
		.wb_ack_o( wb_ack_o ),
		.wb_err_o( wb_err_o ),
		.fifo_dat_o( fifo_data_i ),
		.fifo_clk_o( fifo_clk_wr ),
		.fifo_wr_en( fifo_wr_en ),
		.fifo_full( fifo_full ),
		.fifo_empty( fifo_empty ),
		.fifo_almost_full( fifo_almost_full ),
		.fifo_almost_empty( fifo_almost_empty )

		);

`ifdef AUDIO_NO_FIFO
fifo_empty_16	i_audio_fifo (
		.AINIT( !rstn ),
		.DIN( fifo_data_i ),
		.DOUT( fifo_data_o ),
//		.WR_CLK( fifo_clk_rd ),
//		.RD_CLK( fifo_clk_wr ),
		.WR_CLK( fifo_clk_wr ),
		.RD_CLK( fifo_clk_rd ),
		.RD_EN( fifo_rd_en ),
		.WR_EN( fifo_wr_en ),
		.EMPTY( fifo_empty ),
		.FULL( fifo_full ),
		.ALMOST_EMPTY( fifo_almost_empty ),
		.ALMOST_FULL( fifo_almost_full )
		);
`else
/*
fifo8kx16 i_audio_fifo (
		.AINIT( !rstn ),
		.DIN( fifo_data_i ),
		.DOUT( fifo_data_o ),
//		.WR_CLK( fifo_clk_rd ),
//		.RD_CLK( fifo_clk_wr ),
		.WR_CLK( fifo_clk_wr ),
		.RD_CLK( fifo_clk_rd ),
		.RD_EN( fifo_rd_en ),
		.WR_EN( fifo_wr_en ),
		.EMPTY( fifo_empty ),
		.FULL( fifo_full ),
		.ALMOST_EMPTY( fifo_almost_empty ),
		.ALMOST_FULL( fifo_almost_full )
		);
*/

fifo_4095_16	i_audio_fifo (
		.AINIT( !rstn ),
		.DIN( fifo_data_i ),
		.DOUT( fifo_data_o ),
//		.WR_CLK( fifo_clk_rd ),
//		.RD_CLK( fifo_clk_wr ),
		.WR_CLK( fifo_clk_wr ),
		.RD_CLK( fifo_clk_rd ),
		.RD_EN( fifo_rd_en ),
		.WR_EN( fifo_wr_en ),
		.EMPTY( fifo_empty ),
		.FULL( fifo_full ),
		.ALMOST_EMPTY( fifo_almost_empty ),
		.ALMOST_FULL( fifo_almost_full )
		);


`endif
/*
fifo_1023_16 i_audio_fifo (
		.AINIT( !rstn ),
		.DIN( fifo_data_i ),
		.DOUT( fifo_data_o ),
		.WR_CLK( clk ),
		.RD_CLK( clk ),
		.RD_EN( fifo_rd_en ),
		.WR_EN( fifo_wr_en ),
		.EMPTY( fifo_empty ),
		.FULL( fifo_full ),
		.ALMOST_EMPTY( fifo_almost_empty ),
		.ALMOST_FULL( fifo_almost_full )
		); // synthesis black_box
*/




`ifdef UNUSED
assign fifo_data_o = fifo_data_i;
assign fifo_full = 1'b0;
assign fifo_empty = 1'b0;
assign fifo_almost_full = 1'b0;
assign fifo_almost_empty = 1'b0;
`endif

audio_codec_if  i_audio_codec_if (
		.rstn( rstn ),
		.clk( clk ),
		.fifo_clk( fifo_clk_rd ),
		.fifo_data( fifo_data_o ),
		.fifo_rd_en( fifo_rd_en ),
		.sclk( sclk ),
		.mclk( mclk ),
		.lrclk( lrclk ),
		.sdout( sdout ),
		.sdin( sdin )
		);

`else
assign wb_dat_o = 32'h0000_0000;
assign wb_ack_o = 1'b0;
assign wb_err_o = 1'b0;

assign m_wb_dat_o = 32'h0000_0000;
assign m_wb_adr_o = 32'h0000_0000;
assign m_wb_sel_o = 4'b0000;
assign m_wb_we_o = 1'b0;
assign m_wb_cyc_o = 1'b0;
assign m_wb_stb_o = 1'b0;           
 
assign mclk = 1'b0;
assign lrclk = 1'b0;
assign sclk = 1'b0;
assign sdin = 1'b0;                 
`endif
endmodule
