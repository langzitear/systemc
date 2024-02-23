//////////////////////////////////////////////////////////////////////
////                                                              ////
////  MP3 demo Audio CODEC interface                              ////
////                                                              ////
////  This file is part of the MP3 demo application               ////
////  http://www.opencores.org/cores/or1k/mp3/                    ////
////                                                              ////
////  Description                                                 ////
////  Connects Audio block to XSV board AK4520 codec chip.        ////
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
// $Log: audio_codec_if.v,v $
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

module audio_codec_if (
  rstn,
  clk,
  fifo_clk,
  fifo_data,
  fifo_rd_en,

  sclk,
  mclk,
  lrclk,
  sdout,
  sdin
);  

parameter fifo_width = 16;
parameter count_bits = 11;

input   rstn;
input   clk;
output  fifo_clk;
input [fifo_width-1:0]  fifo_data;
output    fifo_rd_en;

output    sclk;
output    mclk;
output    lrclk;
input   sdout;
output    sdin;


reg [count_bits-1:0]  counter;
reg [16:0]  shift_reg;
reg     f_rd_en;
reg     sd_sig;

always @(posedge clk or negedge rstn)
begin
  if(!rstn)
    counter <= 0;
  else
    counter <= #1 counter + 1;
end

assign fifo_clk = clk ;
assign fifo_rd_en = f_rd_en ;
assign mclk = counter[0]; // mclk = clk/2 = 256fs
assign sclk = counter[2]; // sclk = mclk/4 = 64fs
assign lrclk = counter[8]; //lrclk = sclk/64

always @(posedge clk or negedge rstn)
begin
  if(!rstn)
    begin
      sd_sig <= 1'b0;
      shift_reg <= 0;
    end
  else
    begin
      if(counter[7:3] < 5'd16)
        begin
          if( counter[2:0] == 3'b101)
            shift_reg[fifo_width:1] <= #1 shift_reg[fifo_width-1:0];
          else
            shift_reg <= #1 shift_reg;
          sd_sig <= #1 shift_reg[16];
        end
      else
        begin
          sd_sig <= #1 1'b0;
          if(counter[7:0] == 8'h80)
            shift_reg[16:0] <= { fifo_data[fifo_width-1:0], 1'b0 };
        end
    end
end

// To je nase. Sve ostalo je garbidz.
always @(posedge clk or negedge rstn)
begin
  if(!rstn)
    f_rd_en <= 1'b0;
  else
  if(counter[9:0] == 10'h200)
    f_rd_en <= #1 1'b1;
  else
    f_rd_en <= #1 1'b0;
end


assign sdin = sd_sig;


endmodule 
