//////////////////////////////////////////////////////////////////////
////                                                              ////
////  MP3 demo WISHBONE i/f of Audio block                        ////
////                                                              ////
////  This file is part of the MP3 demo application               ////
////  http://www.opencores.org/cores/or1k/mp3/                    ////
////                                                              ////
////  Description                                                 ////
////  Connect the audio block to the WISHBONE bus.                ////
////                                                              ////
////  To Do:                                                      ////
////   - nothing really                                           ////
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
// $Log: audio_wb_if.v,v $
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

module audio_wb_if (
	rstn,
	clk,
	wb_dat_i,
	wb_dat_o,
	wb_adr_i,
	wb_sel_i,
	wb_we_i,
	wb_cyc_i,
	wb_stb_i,
	wb_ack_o,
	wb_err_o,

	fifo_dat_o,
	fifo_clk_o,
	fifo_wr_en,
	fifo_full,
	fifo_empty,
	fifo_almost_full,
	fifo_almost_empty
);

parameter fifo_width = 16;

input   	rstn;
input		clk;
input [31:0]	wb_dat_i;
output [31:0] 	wb_dat_o;
input [31:0]	wb_adr_i;
input [3:0]	wb_sel_i;
input		wb_we_i;
input		wb_cyc_i;
input		wb_stb_i;
output		wb_ack_o;
output		wb_err_o;

output [fifo_width-1:0]	fifo_dat_o;
output		fifo_clk_o;
output		fifo_wr_en;
input		fifo_full;
input		fifo_empty;
input		fifo_almost_full;
input		fifo_almost_empty;

reg [3:0]	fifo_status;
reg		f_wr_en;

always @(posedge clk or negedge rstn)
if (!rstn) fifo_status <= 4'b0;
else
   fifo_status <= #1 { fifo_full, fifo_empty, 
			fifo_almost_full, fifo_almost_empty };

assign fifo_dat_o = wb_dat_i[fifo_width-1:0];
assign wb_dat_o = { 28'b0, fifo_status };
//assign wb_ack_o = wb_cyc_i & !fifo_almost_full;
assign wb_err_o = 1'b0;
assign fifo_clk_o = clk;

always @(posedge clk or negedge rstn)
begin
  if(!rstn)
    f_wr_en <= 1'b0;
  else
  if(wb_cyc_i & wb_we_i & !fifo_almost_full & ~f_wr_en)
    f_wr_en  <= #1 1'b1;
	else 
	  f_wr_en <= #1 1'b0;
end

assign fifo_wr_en = f_wr_en;
//assign wb_ack_o = f_wr_en;
assign wb_ack_o = f_wr_en | (wb_cyc_i & wb_stb_i & ~wb_we_i);

endmodule
