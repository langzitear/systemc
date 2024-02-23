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
// $Log: dbg_comm2.v,v $
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

`include "dbg_timescale.v"
`include "dbg_defines.v"
//`include "dbg_tb_defines.v"



`define GDB_IN	"/projects/xess-damjan/sim/run/gdb_in.dat"
`define GDB_OUT	"/projects/xess-damjan/sim/run/gdb_out.dat"
//`define GDB_IN	"/tmp/gdb_in.dat"
//`define GDB_OUT	"/tmp/gdb_out.dat"
//`define GDB_IN	"../src/gdb_in.dat"
//`define GDB_OUT	"../src/gdb_out.dat"

module dbg_comm2(P_TMS, P_TCK, P_TRST, P_TDI, P_TDO);

parameter Tp = 1;
parameter Tclk = 50;   // Clock half period (Clok period = 100 ns => 10 MHz)

output		P_TMS;
output		P_TCK;
output		P_TRST;
output		P_TDI;
input		P_TDO;

integer handle1, handle2;
reg [87:0] memory[0:0];
reg [87:0] file;
reg Mclk;
reg wb_rst_i;

reg alternator;

reg StartTesting;
reg P_TCK;
reg  P_TRST;
reg  P_TDI;
reg  P_TMS;
wire P_TDO;

reg transition_detected;
reg update_state;
reg latchedbit;
reg [31:0] data_out;


initial
begin
  P_TCK = 0;
  P_TMS = 0;
  P_TDI = 0;
  alternator = 0;
  StartTesting = 0;
  wb_rst_i = 0;
  P_TRST = 1;
  #500;
  wb_rst_i = 1;
  P_TRST = 0;
  #500;
  wb_rst_i = 0;
  P_TRST = 1;
  
  #2000;
  StartTesting = 1;
  $display("StartTesting = 1");


end

initial
begin
  wait(StartTesting);
  while(1)
  begin
//    while(~transition_detected)
//      begin
        #1000;
        $readmemh(`GDB_OUT, memory);
//        $readmemh(`GDB_OUT, file);
//      end
//    wait(update_state);
    handle1 = $fopen(`GDB_OUT);
//    $fwrite(handle1, "%h", memory[0]);  // To ack to jp1 that we read dgb_out.dat
    $fwrite(handle1, "%h", {Temp[15:1], 1'b1});  // To ack to jp1 that we read dgb_out.dat
    $fclose(handle1);
//    end
  end
end

//always alternator = #100 ~alternator;

//always @ (posedge P_TCK or alternator)
always @ (posedge Mclk)
begin
  handle2 = $fopen(`GDB_IN);
  wait(update_state);
  $fdisplay(handle2, "%h", data_out);  // Writing output data to file
  $fclose(handle2);
end

wire [87:0]word = memory[0];

always @ (posedge Mclk or posedge wb_rst_i)
begin
  if(wb_rst_i)
    begin
      transition_detected <= 1'b0;
    end 
  else if(!word[0]) 
    begin
      file = word;
      transition_detected = 1'b1;
    end
  else
    transition_detected = 1'b0;
end

wire [87:0]Temp = file;
/*
always @ (posedge Mclk or posedge wb_rst_i)
begin
  if(wb_rst_i)
    begin
      transition_detected <= 1'b0;
      latchedbit <= 1'b0;
    end
  else
  if(~latchedbit & Temp[2])
    transition_detected = 1'b1;
  else    
    transition_detected = 1'b0;
  latchedbit <= Temp[2];
end
*/



reg [3:0]  chain     ;
reg [7:0]  chain_crc ;
reg [31:0] address   ;
reg        rw        ;
reg [31:0] data      ;
reg [7:0]  data_crc  ;

always @ (posedge Mclk or posedge wb_rst_i)
begin
  if(wb_rst_i)
    begin
      chain     = 'h0;
      chain_crc = 'h0;
      address   = 'h0;
      rw        = 'h0;
      data      = 'h0;
      data_crc  = 'h0;
    end
  else
  if(transition_detected)
  begin
    chain     = Temp[87:84];
    chain_crc = Temp[83:76];
    address   = Temp[75:44];
    rw        = Temp[43];
    data      = Temp[42:11];
    data_crc  = Temp[10:3];
  end
end




// assign P_TCK  = Temp[0];
// assign P_TRST = Temp[1];
// assign P_TDI  = Temp[2];
// assign P_TMS  = Temp[3];



always @ (posedge Mclk or posedge wb_rst_i)
begin
  if(wb_rst_i)
    update_state <= 1'b0;
  else
  if(transition_detected)
    begin
      update_state <= 1'b0;
        begin
          SetInstruction(`CHAIN_SELECT);
          ChainSelect(chain, chain_crc);                  // {chain, crc}
          SetInstruction(`DEBUG);
          if(rw)
            begin
              WriteRISCRegister(data, address, data_crc);   // {data, addr, crc}
              update_state <= 1'b1;
            end
          else
            begin
              ReadRISCRegister(address, data_crc, data_out);          // {addr, crc, read_data}
              ReadRISCRegister(address, data_crc, data_out);          // {addr, crc, read_data}
              update_state <= 1'b1;
            end
        end
    end
end


























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



// Generation of the TCLK signal
task GenClk;
  input [7:0] Number;
  integer i;
  begin
    for(i=0; i<Number; i=i+1)
      begin
        #Tclk P_TCK<=1;
        #Tclk P_TCK<=0;
      end
  end
endtask



// sets the instruction to the IR register and goes to the RunTestIdle state
task SetInstruction;
  input [3:0] Instr;
  integer i;
  
  begin
    P_TMS<=#Tp 1;
    GenClk(2);
    P_TMS<=#Tp 0;
    GenClk(2);  // we are in shiftIR

    for(i=0; i<`IR_LENGTH-1; i=i+1)   // error?
    begin
      P_TDI<=#Tp Instr[i];
      GenClk(1);
    end
    
    P_TDI<=#Tp Instr[i]; // last shift
    P_TMS<=#Tp 1;        // going out of shiftIR
    GenClk(1);
      P_TDI<=#Tp 'hz;    // tri-state
    GenClk(1);
    P_TMS<=#Tp 0;
    GenClk(1);       // we are in RunTestIdle
  end
endtask


// sets the selected scan chain and goes to the RunTestIdle state
task ChainSelect;
  input [3:0] Data;
  input [7:0] Crc;
  integer i;
  
  begin
    P_TMS<=#Tp 1;
    GenClk(1);
    P_TMS<=#Tp 0;
    GenClk(2);  // we are in shiftDR

    for(i=0; i<`CHAIN_ID_LENGTH; i=i+1)
    begin
      P_TDI<=#Tp Data[i];
      GenClk(1);
    end

    for(i=0; i<`CRC_LENGTH-1; i=i+1)
    begin
      P_TDI<=#Tp Crc[i];
      GenClk(1);
    end

    P_TDI<=#Tp Crc[i]; // last shift
    P_TMS<=#Tp 1;        // going out of shiftIR
    GenClk(1);
      P_TDI<=#Tp 'hz; // tri-state
    GenClk(1);
    P_TMS<=#Tp 0;
    GenClk(1);       // we are in RunTestIdle
  end
endtask


// Write the RISC register
task WriteRISCRegister;
  input [31:0] Data;
  input [31:0] Address;
  input [`CRC_LENGTH-1:0] Crc;
  integer i;
  
  begin
    P_TMS<=#Tp 1;
    GenClk(1);
    P_TMS<=#Tp 0;
    GenClk(2);  // we are in shiftDR

    for(i=0; i<32; i=i+1)
    begin
      P_TDI<=#Tp Address[i];  // Shifting address
      GenClk(1);
    end

    P_TDI<=#Tp 1;             // shifting RW bit = write
    GenClk(1);

    for(i=0; i<32; i=i+1)
    begin
      P_TDI<=#Tp Data[i];     // Shifting data
      GenClk(1);
    end

    for(i=0; i<`CRC_LENGTH-1; i=i+1)
    begin
      P_TDI<=#Tp Crc[i];     // Shifting CRC
      GenClk(1);
    end

    P_TDI<=#Tp Crc[i];        // shifting last bit of CRC
    P_TMS<=#Tp 1;        // going out of shiftIR
    GenClk(1);
      P_TDI<=#Tp 'hz;        // tristate TDI
    GenClk(1);

    P_TMS<=#Tp 0;
    GenClk(1);       // we are in RunTestIdle

    GenClk(10);      // Generating few clock cycles needed for the write operation to accomplish
  end
endtask


// Reads the RISC register and latches the data so it is ready for reading
task ReadRISCRegister;
  input [31:0] Address;
  input [7:0] Crc;
  output [31:0] read_data;
  integer i;
  
  begin
    P_TMS<=#Tp 1;
    GenClk(1);
    P_TMS<=#Tp 0;
    GenClk(2);  // we are in shiftDR

    for(i=0; i<32; i=i+1)
    begin
      P_TDI<=#Tp Address[i];  // Shifting address
      GenClk(1);
    end

    P_TDI<=#Tp 0;             // shifting RW bit = read
    GenClk(1);

    for(i=0; i<32; i=i+1)
    begin
      P_TDI<=#Tp 0;     // Shifting data. Data is not important in read cycle.
      read_data[i]<=#Tp P_TDO;    // Assembling data to read_data
      GenClk(1);
    end

    for(i=0; i<`CRC_LENGTH-1; i=i+1)
    begin
      P_TDI<=#Tp Crc[i];     // Shifting CRC.
      GenClk(1);
    end

    P_TDI<=#Tp Crc[i];   // Shifting last bit of CRC.
    P_TMS<=#Tp 1;        // going out of shiftIR
    GenClk(1);
      P_TDI<=#Tp 'hz;   // Tristate TDI.
    GenClk(1);

    P_TMS<=#Tp 0;
    GenClk(1);       // we are in RunTestIdle
  end
endtask







endmodule // TAP

`endif
