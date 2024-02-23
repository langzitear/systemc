//////////////////////////////////////////////////////////////////////
////                                                              ////
////  dbg_if_model.v                                              ////
////                                                              ////
////                                                              ////
////  This file is part of the OpenRISC test bench.               ////
////  http://www.opencores.org/                                   ////
////                                                              ////
////                                                              ////
////  Author(s):                                                  ////
////       Damjan Lampret                                         ////
////       lampret@opencores.org                                  ////
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
// $Log: dbg_if_model.v,v $
// Revision 1.3  2004/04/05 08:46:06  lampret
// Merged branch_qmem into main tree.
//
// Revision 1.2  2003/04/07 01:30:57  lampret
// Changed location of debug test code to 0.
//
// Revision 1.1  2002/03/28 19:59:54  lampret
// Added bench directory
//
// Revision 1.2  2002/01/18 07:57:21  lampret
// Added test case for testing NPC read bug when doing single-step.
//
// Revision 1.1  2002/01/14 06:19:35  lampret
// Added debug model for testing du. Updated or1200_monitor.
//
//
//

`include "dbg_defines.v"

// Top module
module dbg_if_model(
                // JTAG pins
                tms_pad_i, tck_pad_i, trst_pad_i, tdi_pad_i, tdo_pad_o, 

                // Boundary Scan signals
                capture_dr_o, shift_dr_o, update_dr_o, extest_selected_o, bs_chain_i,
                
                // RISC signals
                risc_clk_i, risc_addr_o, risc_data_i, risc_data_o, wp_i, 
                bp_i, opselect_o, lsstatus_i, istatus_i, risc_stall_o, reset_o, 
                
                // WISHBONE common signals
                wb_rst_i, wb_clk_i, 

                // WISHBONE master interface
                wb_adr_o, wb_dat_o, wb_dat_i, wb_cyc_o, wb_stb_o, wb_sel_o,
                wb_we_o, wb_ack_i, wb_cab_o, wb_err_i


              );

parameter Tp = 1;

// JTAG pins
input         tms_pad_i;                  // JTAG test mode select pad
input         tck_pad_i;                  // JTAG test clock pad
input         trst_pad_i;                 // JTAG test reset pad
input         tdi_pad_i;                  // JTAG test data input pad
output        tdo_pad_o;                  // JTAG test data output pad


// Boundary Scan signals
output capture_dr_o;
output shift_dr_o;
output update_dr_o;
output extest_selected_o;
input  bs_chain_i;


// RISC signals
input         risc_clk_i;                 // Master clock (RISC clock)
input  [31:0] risc_data_i;                // RISC data inputs (data that is written to the RISC registers)
input  [10:0] wp_i;                       // Watchpoint inputs
input         bp_i;                       // Breakpoint input
input  [3:0]  lsstatus_i;                 // Load/store status inputs
input  [1:0]  istatus_i;                  // Instruction status inputs
output [31:0] risc_addr_o;                // RISC address output (for adressing registers within RISC)
output [31:0] risc_data_o;                // RISC data output (data read from risc registers)
output [`OPSELECTWIDTH-1:0] opselect_o;   // Operation selection (selecting what kind of data is set to the risc_data_i)
output                      risc_stall_o; // Stalls the RISC
output                      reset_o;      // Resets the RISC


// WISHBONE common signals
input         wb_rst_i;                   // WISHBONE reset
input         wb_clk_i;                   // WISHBONE clock

// WISHBONE master interface
output [31:0] wb_adr_o;
output [31:0] wb_dat_o;
input  [31:0] wb_dat_i;
output        wb_cyc_o;
output        wb_stb_o;
output  [3:0] wb_sel_o;
output        wb_we_o;
input         wb_ack_i;
output        wb_cab_o;
input         wb_err_i;

reg	[31:0]	risc_addr_o;
reg	[31:0]	risc_data_o;
reg	[`OPSELECTWIDTH-1:0] opselect_o;
reg		risc_stall_a;
reg		risc_stall_r;
reg		dbg_if_test_go;
integer		i, npc, ppc, r1, insn, result, npc_saved;

assign tdo_pad_o = 1'b0;
assign capture_dr_o = 1'b0;
assign shift_dr_o = 1'b0;
assign update_dr_o = 1'b0;
assign extest_selected_o = 1'b0;
assign reset_o = 1'b0;
assign risc_stall_o = risc_stall_r | risc_stall_a;
assign wb_cab_o = 1'b0;

always @(posedge wb_rst_i or posedge bp_i)
	if (wb_rst_i)
		risc_stall_r <= #1 1'b0;
	else if (bp_i)
		risc_stall_r <= #1 1'b1;
initial begin
	risc_addr_o = 0;
	risc_data_o = 0;
	opselect_o = 0;
	risc_stall_a = 1'b0;
end

always @(posedge dbg_if_test_go)
begin
	$display("%t: dbg_if_test\n", $time);

	stall;

	wb_master.wr(32'h0000_0004, 32'h9c200000, 4'b1111);	/* l.addi  r1,r0,0x0       */
	wb_master.wr(32'h0000_0008, 32'h18400008, 4'b1111);	/* l.movhi r2,0x0008       */
	wb_master.wr(32'h0000_000c, 32'h9c210001, 4'b1111);	/* l.addi  r1,r1,1         */
	wb_master.wr(32'h0000_0010, 32'h9c210001, 4'b1111);	/* l.addi  r1,r1,1         */
	wb_master.wr(32'h0000_0014, 32'hd4020800, 4'b1111);	/* l.sw    0(r2),r1        */
	wb_master.wr(32'h0000_0018, 32'h9c210001, 4'b1111);	/* l.addi  r1,r1,1         */
	wb_master.wr(32'h0000_001c, 32'h84620000, 4'b1111);	/* l.lwz   r3,0(r2)        */
	wb_master.wr(32'h0000_0020, 32'h03fffffb, 4'b1111);	/* l.j     loop2           */
	wb_master.wr(32'h0000_0024, 32'he0211800, 4'b1111);	/* l.add   r1,r1,r3        */
	wb_master.wr(32'h0000_0028, 32'he0211800, 4'b1111);	/* l.add   r1,r1,r3        */

	// Save NPC for restoring program
	// flow after finish of debug if test case
	rd_reg((0 << 11) + 16, npc_saved);

	// Enable exceptions in SR
	wr_reg(17, 3);

	// Set trap bit in DSR
	wr_reg((6 << 11) + 20, 32'h2000);

	// Set NPC
	wr_npc(32'h0000_0004);

	// Set step-bit (DMR1[ST])
	wr_reg((6 << 11) + 16, 1 << 22);

	// Read NPC
	rd_reg((0 << 11) + 16, npc);

	// Read PPC
	rd_reg((0 << 11) + 18, ppc);

	// Read R1
	rd_reg(32'h401, r1);

	$display("%t:", $time);
	$display("Read      npc = %h ppc = %h r1 = %h", npc, ppc, r1);
	$display("Expected  npc = %h ppc = %h r1 = %h\n", 32'h00000000, 32'h040001c4, 32'h0000313c);


	// Single-step
	for (i = 1; i < 10; i = i + 1)
		unstall;

	// Read NPC
	rd_reg((0 << 11) + 16, npc);

	// Read PPC
	rd_reg((0 << 11) + 18, ppc);

	// Read R1
	rd_reg(32'h401, r1);

	$display("%t:", $time);
	$display("Read      npc = %h ppc = %h r1 = %h", npc, ppc, r1);
	$display("Expected  npc = %h ppc = %h r1 = %h\n", 32'h0000000c, 32'h00000024, 5);
	result = npc + ppc + r1;


	/* Reset step bit */
	wr_reg ((6 << 11) + 16, 0);

	/* Set trap insn in delay slot */
	wb_master.rd (32'h0000_0024, insn);
	wb_master.wr (32'h0000_0024, 32'h21000001, 4'b1111);

	/* Unstall */
	unstall;

	/* Read NPC */
	rd_reg((0 << 11) + 16, npc);

	/* Read PPC */
	rd_reg((0 << 11) + 18, ppc);

	/* Read R1 */
	rd_reg(32'h401, r1);

	/* Set back original insn */
	wb_master.wr (32'h0000_0024, insn, 4'b1111);

	$display("%t:", $time);
	$display("Read      npc = %h ppc = %h r1 = %h", npc, ppc, r1);
	$display("Expected  npc = %h ppc = %h r1 = %h\n", 32'h0000000c, 32'h00000024, 8);
	result = npc + ppc + r1 + result;


	/* Set trap insn in place of branch insn */
	wb_master.rd (32'h0000_0020, insn);
	wb_master.wr (32'h0000_0020, 32'h21000001, 4'b1111);

	/* Set PC */
	wr_npc(32'h0000_000c);

	/* Unstall */
	unstall;

	/* Read NPC */
	rd_reg((0 << 11) + 16, npc);

	/* Read PPC */
	rd_reg((0 << 11) + 18, ppc);

	/* Read R1 */
	rd_reg(32'h401, r1);

	/* Set back original insn */
	wb_master.wr (32'h0000_0020, insn, 4'b1111);

	$display("%t:", $time);
	$display("Read      npc = %h ppc = %h r1 = %h", npc, ppc, r1);
	$display("Expected  npc = %h ppc = %h r1 = %h\n", 32'h00000024, 32'h00000020, 11);
	result = npc + ppc + r1 + result;

	/* Set trap insn before branch insn */
	wb_master.rd (32'h0000_001c, insn);
	wb_master.wr (32'h0000_001c, 32'h21000001, 4'b1111);

	/* Set PC */
	wr_npc(32'h0000_0020);

	/* Unstall */
	unstall;

	/* Read NPC */
	rd_reg((0 << 11) + 16, npc);

	/* Read PPC */
	rd_reg((0 << 11) + 18, ppc);

	/* Read R1 */
	rd_reg(32'h401, r1);

	/* Set back original insn */
	wb_master.wr (32'h0000_001c, insn, 4'b1111);

	$display("Read      npc = %h ppc = %h r1 = %h", npc, ppc, r1);
	$display("Expected  npc = %h ppc = %h r1 = %h\n", 32'h00000020, 32'h0000001c, 24);
	result = npc + ppc + r1 + result;


	/* Set trap insn behind lsu insn */
	wb_master.rd (32'h0000_0018, insn);
	wb_master.wr (32'h0000_0018, 32'h21000001, 4'b1111);

	/* Set PC */
	wr_npc(32'h0000_001c);

	/* Unstall */
	unstall;

	/* Read NPC */
	rd_reg((0 << 11) + 16, npc);

	/* Read PPC */
	rd_reg((0 << 11) + 18, ppc);

	/* Read R1 */
	rd_reg(32'h401, r1);

	/* Set back original insn */
	wb_master.wr (32'h0000_0018, insn, 4'b1111);

	$display("%t:", $time);
	$display("Read      npc = %h ppc = %h r1 = %h", npc, ppc, r1);
	$display("Expected  npc = %h ppc = %h r1 = %h\n", 32'h0000001c, 32'h00000018, 49);
	result = npc + ppc + r1 + result;

	/* Set trap insn very near previous one */
	wb_master.rd (32'h0000_001c, insn);
	wb_master.wr (32'h0000_001c, 32'h21000001, 4'b1111);

	/* Set PC */
	wr_npc(32'h0000_0018);

	/* Unstall */
	unstall;

	/* Read NPC */
	rd_reg((0 << 11) + 16, npc);

	/* Read PPC */
	rd_reg((0 << 11) + 18, ppc);

	/* Read R1 */
	rd_reg(32'h401, r1);

	/* Set back original insn */
	wb_master.wr (32'h0000_001c, insn, 4'b1111);

	$display("%t:", $time);
	$display("Read      npc = %h ppc = %h r1 = %h", npc, ppc, r1);
	$display("Expected  npc = %h ppc = %h r1 = %h\n", 32'h00000020, 32'h0000001c, 50);
	result = npc + ppc + r1 + result;

	/* Set trap insn to the start */
	wb_master.rd (32'h0000_000c, insn);
	wb_master.wr (32'h0000_000c, 32'h21000001, 4'b1111);

	/* Set PC */
	wr_npc(32'h0000_001c);

	/* Unstall */
	unstall;

	/* Read NPC */
	rd_reg((0 << 11) + 16, npc);

	/* Read PPC */
	rd_reg((0 << 11) + 18, ppc);

	/* Read R1 */
	rd_reg(32'h401, r1);

	/* Set back original insn */
	wb_master.wr (32'h0000_000c, insn, 4'b1111);

	$display("%t:", $time);
	$display("Read      npc = %h ppc = %h r1 = %h", npc, ppc, r1);
	$display("Expected  npc = %h ppc = %h r1 = %h\n", 32'h00000010, 32'h0000000c, 99);
	result = npc + ppc + r1 + result;

	// Set step-bit (DMR1[ST])
	wr_reg((6 << 11) + 16, 1 << 22);

	// Single-step
	for (i = 0; i < 5; i = i + 1)
		unstall;

	/* Read NPC */
	rd_reg((0 << 11) + 16, npc);

	/* Read PPC */
	rd_reg((0 << 11) + 18, ppc);

	/* Read R1 */
	rd_reg(32'h401, r1);

	$display("%t:", $time);
	$display("Read      npc = %h ppc = %h r1 = %h", npc, ppc, r1);
	$display("Expected  npc = %h ppc = %h r1 = %h\n", 32'h00000024, 32'h00000020, 101);
	result = npc + ppc + r1 + result;

	/* Set PC */
	wr_npc(32'h0000_0020);

	// Single-step
	for (i = 0; i < 2; i = i + 1)
		unstall;

	/* Read NPC */
	rd_reg((0 << 11) + 16, npc);

	/* Read PPC */
	rd_reg((0 << 11) + 18, ppc);

	/* Read R1 */
	rd_reg(32'h401, r1);

	$display("%t:", $time);
	$display("Read      npc = %h ppc = %h r1 = %h", npc, ppc, r1);
	$display("Expected  npc = %h ppc = %h r1 = %h\n", 32'h0000000c, 32'h00000024, 201);
	result = npc + ppc + r1 + result;

	// Restore NPC from beginning of test case
	wr_npc(npc_saved);

	/* Write R3 with result */
	wr_reg(32'h403, result + + 32'hdeaddaa9);

	// Don't trap anymore - clear DSR
	wr_reg((6 << 11) + 20, 32'h0000_0000);

	// Clear step-bit DMR1[ST] - clear DMR1)
	wr_reg((6 << 11) + 16, 0);

	unstall;
end

task stall;
begin
	risc_stall_r = 1'b1;
	@(posedge risc_clk_i);
	@(posedge risc_clk_i);
end
endtask

task unstall;
begin
	risc_stall_r = 1'b0;
	@(posedge risc_clk_i);
	while (!bp_i) @(posedge risc_clk_i);
end
endtask

task wr_npc;
input	[31:0]	npc;
begin
	npc = npc - 0;
	wr_reg((0 << 11) + 16, npc);
end
endtask

task wr_reg;
input 	[31:0]	addr;
input	[31:0]	data;
begin
	risc_stall_a = 1'b1;
	@(posedge risc_clk_i);
	risc_addr_o = addr;
	risc_data_o = data;
	opselect_o = 5;
	@(posedge risc_clk_i);
	risc_addr_o = 0;
	risc_data_o = 0;
	opselect_o = 0;
	@(posedge risc_clk_i);
	@(posedge risc_clk_i);
	@(posedge risc_clk_i);
	risc_stall_a = 1'b0;
end
endtask

task rd_reg;
input 	[31:0]	addr;
output	[31:0]	data;
begin
	risc_stall_a = 1'b1;
	@(posedge risc_clk_i);
	risc_addr_o = addr;
	opselect_o = 4;
	@(posedge risc_clk_i);
	@(posedge risc_clk_i);
	data = risc_data_i;
	@(posedge risc_clk_i);
	risc_addr_o = 0;
	risc_data_o = 0;
	opselect_o = 0;
	@(posedge risc_clk_i);
	@(posedge risc_clk_i);
	@(posedge risc_clk_i);
	risc_stall_a = 1'b0;
end
endtask

//
// Instantiation of Master WISHBONE BFM
//
wb_master wb_master(
        // WISHBONE Interface
        .CLK_I(wb_clk_i),
        .RST_I(wb_rst_i),
        .CYC_O(wb_cyc_o),
        .ADR_O(wb_adr_o),
        .DAT_O(wb_dat_o),
        .SEL_O(wb_sel_o),
        .WE_O(wb_we_o),
        .STB_O(wb_stb_o),
        .DAT_I(wb_dat_i),
        .ACK_I(wb_ack_i),
        .ERR_I(wb_err_i),
        .RTY_I(1'b0),
        .TAG_I(4'b0),
	.TAG_O()
);

endmodule
