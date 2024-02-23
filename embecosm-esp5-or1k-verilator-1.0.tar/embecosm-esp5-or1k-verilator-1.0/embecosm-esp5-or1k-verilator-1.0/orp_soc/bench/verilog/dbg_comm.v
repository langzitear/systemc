//////////////////////////////////////////////////////////////////////
////                                                              ////
////  File_communication.v                                        ////
////                                                              ////
////                                                              ////
////  This file is part of the SoC/OpenRISC Development Interface ////
////  http://www.opencores.org/cores/DebugInterface/              ////
////                                                              ////
////                                                              ////
////  Author(s):                                                  ////
////       Igor Mohor                                             ////
////       igorm@opencores.org                                    ////
////                                                              ////
////                                                              ////
////  All additional information is avaliable in the README.txt   ////
////  file.                                                       ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000,2001 Authors                              ////
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
// $Log: dbg_comm.v,v $
// Revision 1.1  2002/03/28 19:59:54  lampret
// Added bench directory
//
// Revision 1.1.1.1  2001/11/04 18:51:07  lampret
// First import.
//
// Revision 1.3  2001/09/24 14:06:13  mohor
// Changes connected to the OpenRISC access (SPR read, SPR write).
//
// Revision 1.2  2001/09/20 10:10:30  mohor
// Working version. Few bugs fixed, comments added.
//
// Revision 1.1.1.1  2001/09/13 13:49:19  mohor
// Initial official release.
//
//
//
//
//

`ifdef DBG_IF_COMM

`include "timescale.v"
`include "dbg_defines.v"
`include "dbg_tb_defines.v"

`define GDB_IN	"/projects/xess-damjan/sim/run/gdb_in.dat"
`define GDB_OUT	"/projects/xess-damjan/sim/run/gdb_out.dat"
//`define GDB_IN	"/tmp/gdb_in.dat"
//`define GDB_OUT	"/tmp/gdb_out.dat"
//`define GDB_IN	"../src/gdb_in.dat"
//`define GDB_OUT	"../src/gdb_out.dat"

module dbg_comm(P_TMS, P_TCK, P_TRST, P_TDI, P_TDO);

parameter Tp = 1;

output		P_TMS;
output		P_TCK;
output		P_TRST;
output		P_TDI;
input		P_TDO;

integer handle1, handle2;
reg [4:0] memory[0:0];
reg Mclk;
reg wb_rst_i;

reg alternator;

reg StartTesting;
wire P_TCK;
wire P_TRST;
wire P_TDI;
wire P_TMS;
wire P_TDO;

reg [3:0] in_word_r;
wire [4:0] in_word;
wire [3:0] Temp;

initial
begin
  alternator = 0;
  StartTesting = 0;
  wb_rst_i = 0;
  #500;
  wb_rst_i = 1;
  #500;
  wb_rst_i = 0;
  
  #2000;
  StartTesting = 1;
  $display("StartTesting = 1");


end

initial
begin
  wait(StartTesting);
  while(1)
  begin
    #1;
    $readmemh(`GDB_OUT, memory);
    //#1000;
    if(!(memory[0] & 5'b10000))
    begin
      handle1 = $fopen(`GDB_OUT);
      $fwrite(handle1, "%h", 5'b10000 | memory[0]);  // To ack to jp1 that we read dgb_out.dat
      $fclose(handle1);
    end
  end
end

assign in_word = memory[0];
assign Temp = in_word_r;

always @ (posedge in_word[4] or posedge wb_rst_i)
begin
  if(wb_rst_i)
    in_word_r<=#Tp 5'b0;
  else
    in_word_r<=#Tp in_word[3:0];
end


//always alternator = #100 ~alternator;

always @ (posedge P_TCK or alternator)
begin
  handle2 = $fopen(`GDB_IN);
  $fdisplay(handle2, "%b", P_TDO);  // Vriting output data to file (TDO)
  $fclose(handle2);
end


assign P_TCK  = Temp[0];
assign P_TRST = Temp[1];
assign P_TDI  = Temp[2];
assign P_TMS  = Temp[3];



// Generating master clock (RISC clock) 10 MHz
initial
begin
  Mclk<=#Tp 0;
  #1 forever #`RISC_CLOCK Mclk<=~Mclk;
end

// Generating random number for use in DATAOUT_RISC[31:0]
reg [31:0] RandNumb;
always @ (posedge Mclk or posedge wb_rst_i)
begin
  if(wb_rst_i)
    RandNumb[31:0]<=#Tp 0;
  else
    RandNumb[31:0]<=#Tp RandNumb[31:0] + 1;
end

wire [31:0] DataIn = RandNumb;

// Connecting dbgTAP module
`ifdef UNUSED
dbg_top dbg1  (.tms_pad_i(P_TMS), .tck_pad_i(P_TCK), .trst_pad_i(P_TRST), .tdi_pad_i(P_TDI), .tdo_pad_o(P_TDO), 
               .wb_rst_i(wb_rst_i), .risc_clk_i(Mclk), .risc_addr_o(), .risc_data_i(DataIn),
               .risc_data_o(), .wp_i(11'h0), .bp_i(1'b0), 
               .opselect_o(), .lsstatus_i(4'h0), .istatus_i(2'h0), 
               .risc_stall_o(), .reset_o() 
              );
`endif

endmodule // TAP

`endif
