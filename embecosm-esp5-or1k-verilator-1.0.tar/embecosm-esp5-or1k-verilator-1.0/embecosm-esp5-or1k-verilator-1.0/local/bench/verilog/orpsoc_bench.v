// orpsoc.v - top level Verilog module for Verilated ORPSoC
//
// Copyright (C) 2009 Embecosm Limited
//
// Contributor Jeremy Bennett <jeremy.bennett@embecosm.com>
// Inspired by Damjan Lampret, lampret@opencores.org
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

// $Id: orpsoc_bench.v 310 2009-02-19 14:54:24Z jeremy $

// This is the top level module for the ORPSoC. Rewritten from scratch, but
// inspired by Damjan Lampret's xess_top.v.

`include "timescale.v"
`include "bench_defines.v"


module orpsoc_bench ();

   // For simulation we must generate the clock
   reg		r_rstn;
   reg		r_clk;	
   wire		rstn;
   wire		clk;

   // JTAG [ins
   wire        jtag_tck;
   wire        jtag_tdi;
   wire        jtag_tdo;
   wire        jtag_tms;
   wire        jtag_trst;

   // Connection to the code model
   wire        codec_mclk;
   wire        codec_lrclk;
   wire        codec_sclk;
   wire        codec_sdin;
   wire        codec_sdout;

   // Connection to the Ethernet model
   wire        eth_tx_er;
   wire        eth_tx_clk;
   wire        eth_tx_en;
   wire [3:0]  eth_txd;
   wire        eth_rx_er;
   wire        eth_rx_clk;
   wire        eth_rx_dv;
   wire [3:0]  eth_rxd;
   wire        eth_col;
   wire        eth_crs;
   wire        eth_fds_mdint;
   wire        eth_mdi;
   wire        eth_mdo;
   wire        eth_mdoe;
   wire        eth_mdc;

   // Connection to the PS/2 keyboard model
   wire        ps2_clk_i;
   wire        ps2_clk_o;
   wire        ps2_clk_oe;
   wire        ps2_data_i;
   wire        ps2_data_o;
   wire        ps2_data_oe;

   // Connection the UART model
   wire        uart_rx;
   wire        uart_tx;

   // Connection to the VGA model
   wire        vga_hsyncn;
   wire        vga_vsyncn;
   wire [3:0]  vga_r;
   wire [3:0]  vga_g;
   wire [3:0]  vga_b;


   // The core FPGA instantiation.
   orpsoc_fpga_top  i_orpsoc_fpga (.clk(           clk           ),
				   .rstn(          rstn          ),
				   
				   .codec_mclk(    codec_mclk    ),
				   .codec_lrclk(   codec_lrclk   ),
				   .codec_sclk(    codec_sclk    ),
				   .codec_sdin(    codec_sdin    ),
				   .codec_sdout(   codec_sdout   ),
				   
				   .vga_blank(                   ),
				   .vga_pclk(                    ),
				   .vga_hsyncn(    vga_hsyncn    ),
				   .vga_vsyncn(    vga_vsyncn    ),
				   .vga_r(         vga_r         ),
				   .vga_g(         vga_g         ),
				   .vga_b(         vga_b         ),
				   
				   .eth_col(       eth_col       ),
				   .eth_crs(       eth_crs       ),
				   .eth_tx_clk(    eth_tx_clk    ),
				   .eth_tx_en(     eth_tx_en     ),
				   .eth_tx_er(     eth_tx_er     ),
				   .eth_txd(       eth_txd       ),
				   .eth_rx_clk(    eth_rx_clk    ),
				   .eth_rx_dv(     eth_rx_dv     ),
				   .eth_rx_er(     eth_rx_er     ),
				   .eth_rxd(       eth_rxd       ),
				   .eth_fds_mdint( eth_fds_mdint ),
				   .eth_mdc(       eth_mdc       ),
				   .eth_mdi(       eth_mdi       ),
				   .eth_mdo(       eth_mdo       ),
				   .eth_mdoe(      eth_mdoe      ),
				   
				   .ps2_clk_i(     ps2_clk_i     ),
				   .ps2_clk_o(     ps2_clk_o     ),
				   .ps2_clk_oe(    ps2_clk_oe    ),
				   .ps2_data_i(    ps2_data_i    ),
				   .ps2_data_o(    ps2_data_o    ),
				   .ps2_data_oe(   ps2_data_oe   ),

				   .uart_rx(       uart_rx       ),
				   .uart_tx(       uart_tx       ),

				   .jtag_tck(      jtag_tck      ),
				   .jtag_tdi(      jtag_tdi      ),
				   .jtag_tdo(      jtag_tdo      ),
				   .jtag_tms(      jtag_tms      ),
				   .jtag_trst(     jtag_trst     ));

   // Tie off the codec
   assign codec_sdout = 1'b0;

   // Tie off the Ethernet
   assign eth_col       = 1'b0;
   assign eth_crs       = 1'b0;
   assign eth_fds_mdint = 1'b0;
   assign eth_mdi       = 1'b1;

   assign eth_rx_er     = 1'b0;
   assign eth_rx_clk    = 1'b0;
   assign eth_rx_dv     = 1'b0;
   assign eth_rxd       = 4'b0;

   assign eth_tx_clk    = 1'b0;

   // Tie off the PS/2 keyboard
   assign ps2_clk_i     = 1'b1;
   assign ps2_data_i    = 1'b1;

   // Tie off the UART
   assign uart_rx       = 1'b0;

   // Assign and tie off the JTAG inputs
   assign jtag_tck      = clk;
   assign jtag_tdi      = 1'b1;
   assign jtag_tms      = 1'b1;
   assign jtag_trst     = ~rstn;

   // For simulation we must generate the reset and clock. First the reset
   initial begin
      #0 r_rstn = 1;
      #1 r_rstn = 0;
      repeat (`BENCH_RESET_TIME) @(negedge r_clk);
      r_rstn = 1;
   end

   assign rstn = r_rstn;

   // Generate the clock
   initial begin
      r_clk = 1'b0;
   end

   always begin
      #`BENCH_CLK_HALFPERIOD r_clk <= ~r_clk;
   end

   assign clk = r_clk;

`ifdef ORPSOC_DUMP

   // Optional dump
   initial begin
      $dumpfile("dump.vcd");
      $dumpvars(0);
   end

`endif // !`ifdef ORPSOC_DUMP

endmodule
