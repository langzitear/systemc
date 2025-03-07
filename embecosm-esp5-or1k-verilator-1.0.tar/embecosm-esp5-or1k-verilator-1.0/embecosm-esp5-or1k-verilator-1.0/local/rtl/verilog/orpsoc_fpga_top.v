// orpsoc_fpga.v - core functional FPGA for Verilated ORPSoC
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

// $Id: orpsoc_fpga_top.v 310 2009-02-19 14:54:24Z jeremy $

// This is a simplified FPGA, for which the Flash and SRAM are treated as an
// internal entity.

`include "orpsoc_fpga_defines.v"

module orpsoc_fpga_top ( clk,		// Global signals
			 rstn,

			 jtag_tck,	// External JTAG
			 jtag_tdi,
			 jtag_tdo,
			 jtag_tms,
			 jtag_trst,

			 codec_lrclk,	// External codec
			 codec_mclk,
			 codec_sclk,
			 codec_sdin,
			 codec_sdout,
			 
			 eth_col,	// External Ethernet
			 eth_crs,
			 eth_fds_mdint,
			 eth_mdc,
			 eth_mdi,
			 eth_mdo,
			 eth_mdoe,

			 eth_rx_clk,
			 eth_rx_dv,
			 eth_rx_er,
			 eth_rxd,

			 eth_tx_clk,
			 eth_tx_en,
			 eth_tx_er,
			 eth_txd,

			 ps2_clk_i,	// External PS/2 keyboard
			 ps2_clk_o,
			 ps2_clk_oe,
			 ps2_data_i,
			 ps2_data_o,
			 ps2_data_oe,

			 uart_rx,	// External UART
			 uart_tx,

			 vga_b,		// External VGA
			 vga_g,
			 vga_r,

			 vga_blank,
			 vga_hsyncn,
			 vga_pclk,
			 vga_vsyncn );

   // Global signals
   input        clk;
   input 	rstn;

   // External JTAG
   input 	jtag_tck;
   input        jtag_tdi;
   output 	jtag_tdo;
   input        jtag_tms;
   input        jtag_trst;

   // External VGA
   output [3:0] vga_b;			// Colour signals
   output [3:0] vga_g;
   output [3:0] vga_r;

   output 	vga_blank;		// Control signals
   output 	vga_hsyncn;
   output 	vga_pclk;
   output 	vga_vsyncn;
   
   // External codec
   output 	codec_lrclk;
   output 	codec_mclk;
   output 	codec_sclk;
   output 	codec_sdin;
   input 	codec_sdout;
   
   // External Ethernet
   input 	eth_col;		// Control/management signals
   input 	eth_crs;
   input 	eth_fds_mdint;
   output 	eth_mdc;
   input 	eth_mdi;
   output 	eth_mdo;
   output 	eth_mdoe;
   
   input 	eth_rx_clk;		// Rx signals
   input 	eth_rx_dv;
   input 	eth_rx_er;
   input [3:0] 	eth_rxd;

   input 	eth_tx_clk;		// Tx signals
   output 	eth_tx_en;
   output 	eth_tx_er;
   output [3:0] eth_txd;

   // External PS/2 keyboard
   input 	ps2_clk_i;
   output 	ps2_clk_o;
   output 	ps2_clk_oe;
   input 	ps2_data_i;
   output 	ps2_data_o;
   output 	ps2_data_oe;

   // External UART
   input        uart_rx;
   output       uart_tx;

   // Registered outputs

   reg [3:0] 	vga_b;			// Colour signals
   reg [3:0] 	vga_g;
   reg [3:0] 	vga_r;

   reg 		vga_hsyncn;		// Sync
   reg 		vga_vsyncn;

   // OR1200 data Wishbone master
   wire         wb_rdm_ack_i;
   wire [31:0]  wb_rdm_adr_o;
   wire         wb_rdm_cab_o;
   wire         wb_rdm_cyc_o;
   wire [31:0]  wb_rdm_dat_i;
   wire [31:0]  wb_rdm_dat_o;
   wire         wb_rdm_err_i;
   wire         wb_rdm_rty_i = 1'b0;
   wire [3:0]   wb_rdm_sel_o;
   wire         wb_rdm_stb_o;
   wire         wb_rdm_we_o;

   // OR1200 instruction Wishbone master
   wire         wb_rim_ack_i;
   wire [31:0]  wb_rim_adr_o;
   wire         wb_rim_cab_o;
   wire         wb_rim_cyc_o;
   wire [31:0]  wb_rim_dat_i;
   wire [31:0]  wb_rim_dat_o;
   wire         wb_rim_err_i;
   wire         wb_rim_rty_i = 1'b0;
   wire [3:0]   wb_rim_sel_o;
   wire         wb_rim_stb_o;
   wire         wb_rim_we_o;

   // OR12000 interrupt vector
   wire [19:0]  pic_ints;

   // Debug unit Wishbone master
   wire         wb_dm_ack_i;
   wire [31:0]  wb_dm_adr_o;
   wire         wb_dm_cab_o;
   wire         wb_dm_cyc_o;
   wire [31:0]  wb_dm_dat_i;
   wire [31:0]  wb_dm_dat_o;
   wire         wb_dm_err_i;
   wire [3:0]   wb_dm_sel_o;
   wire         wb_dm_stb_o;
   wire         wb_dm_we_o;
   
   // Debug unit OR1200 control
   wire [31:0]  dbg_adr;
   wire         dbg_bp;
   wire [31:0]  dbg_dat_dbg;
   wire [31:0]  dbg_dat_risc;
   wire         dbg_ewt;
   wire [1:0]   dbg_is;
   wire [3:0]   dbg_lss;
   wire [2:0]   dbg_op;
   wire         dbg_stall;
   wire [10:0]  dbg_wp;

   // Flash controller Wishbone slave
   wire         wb_fs_ack_o;
   wire [31:0]  wb_fs_adr_i;
   wire         wb_fs_cab_i;
   wire         wb_fs_cyc_i;
   wire [31:0]  wb_fs_dat_i;
   wire [31:0]  wb_fs_dat_o;
   wire         wb_fs_err_o;
   wire [3:0]   wb_fs_sel_i;
   wire         wb_fs_stb_i;
   wire         wb_fs_we_i;

   // Flag indicating use of flash before real memory is availble
   reg          prefix_flash;		// Flag to use flash, not real mem
   wire [31:0]  wb_rif_adr;		// Instr addr modified pre-real mem

   // SRAM controller Wishbone slave
   wire         wb_ss_ack_o;
   wire [31:0]  wb_ss_adr_i;
   wire         wb_ss_cab_i;
   wire         wb_ss_cyc_i;
   wire [31:0]  wb_ss_dat_i;
   wire [31:0]  wb_ss_dat_o;
   wire         wb_ss_err_o;
   wire [3:0]   wb_ss_sel_i;
   wire         wb_ss_stb_i;
   wire         wb_ss_we_i;

   // Patched Wishbone ack to deal with missing memory controller
   wire         wb_rdm_ack;		// Data ack modified pre-real mem

   // Audio Wishbone master
   wire         wb_am_ack_i;
   wire [31:0]  wb_am_adr_o;
   wire         wb_am_cab_o;
   wire         wb_am_cyc_o;
   wire [31:0]  wb_am_dat_o;
   wire [31:0]  wb_am_dat_i;
   wire         wb_am_err_i;
   wire [3:0]   wb_am_sel_o;
   wire         wb_am_stb_o;
   wire         wb_am_we_o;

   // Audio Wishbone slave
   wire         wb_as_ack_o;
   wire [31:0]  wb_as_adr_i;
   wire         wb_as_cab_i;
   wire         wb_as_cyc_i;
   wire [31:0]  wb_as_dat_i;
   wire [31:0]  wb_as_dat_o;
   wire         wb_as_err_o;
   wire [3:0]   wb_as_sel_i;
   wire         wb_as_stb_i;
   wire         wb_as_we_i;

   // Ethernet Wishbone master
   wire         wb_em_ack_i;
   wire [31:0]  wb_em_adr_o;
   wire         wb_em_cab_o;
   wire         wb_em_cyc_o;
   wire [31:0]  wb_em_dat_i;
   wire [31:0]  wb_em_dat_o;
   wire         wb_em_err_i;
   wire [3:0]   wb_em_sel_o;
   wire         wb_em_stb_o;
   wire         wb_em_we_o;

   // Ethernet Wishbone slave
   wire         wb_es_ack_o;
   wire [31:0]  wb_es_adr_i;
   wire         wb_es_cab_i;
   wire         wb_es_cyc_i;
   wire [31:0]  wb_es_dat_i;
   wire [31:0]  wb_es_dat_o;
   wire         wb_es_err_o;
   wire [3:0]   wb_es_sel_i;
   wire         wb_es_stb_i;
   wire         wb_es_we_i;

   // Ethernet external outputs
   wire         eth_mdo;
   wire         eth_mdoe;

   // PS/2 Wishbone slave
   wire         wb_ps_ack_o;
   wire [31:0]  wb_ps_adr_i;
   wire         wb_ps_cab_i;
   wire         wb_ps_cyc_i;
   wire [31:0]  wb_ps_dat_i;
   wire [31:0]  wb_ps_dat_o;
   wire         wb_ps_err_o;
   wire [3:0]   wb_ps_sel_i;
   wire         wb_ps_stb_i;
   wire         wb_ps_we_i;
   
   // UART Wishbone slave
   wire         wb_us_ack_o;
   wire [31:0]  wb_us_adr_i;
   wire         wb_us_cab_i;
   wire         wb_us_cyc_i;
   wire [31:0]  wb_us_dat_i;
   wire [31:0]  wb_us_dat_o;
   wire         wb_us_err_o;
   wire [3:0]   wb_us_sel_i;
   wire         wb_us_stb_i;
   wire         wb_us_we_i;

   // VGA Wishbone master
   wire         wb_vm_ack_i;
   wire [31:0]  wb_vm_adr_o;
   wire         wb_vm_cab_o;
   wire         wb_vm_cyc_o;
   wire [31:0]  wb_vm_dat_i;
   wire         wb_vm_err_i;
   wire [3:0]   wb_vm_sel_o;
   wire         wb_vm_stb_o;
   wire         wb_vm_we_o;

   // VGA Wishbone slave
   wire         wb_vs_ack_o;
   wire [31:0]  wb_vs_adr_i;
   wire         wb_vs_cab_i;
   wire         wb_vs_cyc_i;
   wire [31:0]  wb_vs_dat_i;
   wire [31:0]  wb_vs_dat_o;
   wire         wb_vs_err_o;
   wire [3:0]   wb_vs_sel_i;
   wire         wb_vs_stb_i;
   wire         wb_vs_we_i;

   // VGA CRT
   wire         crt_hsync;
   wire         crt_vsync;
   wire [15:0]  vga_int;		// [15:12] R, [10-7] G, [4:1] B

   // Global Wishbone clock
   wire         wb_clk;

   // Reset debounce registers
   reg          rst_r;
   reg          wb_rst;

   // Reset debounce
   always @ (posedge wb_clk or negedge rstn) begin
      if (~rstn) begin
         rst_r <= 1'b1;
      end
      else begin
         rst_r <= #1 1'b0;
      end
   end

   // Wishbone reset debounce
   always @ (posedge wb_clk) begin
      wb_rst <= #1 rst_r;
   end

   // Wishbone clock
   assign wb_clk = clk;

   // Patch flash memory location. Initially flash is located at location 0x0
   // (so it contains the boot vector). This allows the reset code to copy
   // itself down.
   //
   // The first time the real flash location (APP_ADDR_FLASH) is accessed, the
   // patching to location 0 is turned off, allowing SRAM to appear at
   // location 0x0.
   
   always @ (posedge wb_clk or negedge rstn) begin
      if (!rstn) begin
         prefix_flash <= #1 1'b1;
      end
      else begin
         if (wb_rim_cyc_o &&
             (wb_rim_adr_o[31:32-`APP_ADDR_DEC_W] == `APP_ADDR_FLASH)) begin
            prefix_flash <= #1 1'b0;
         end
      end
   end

   assign wb_rif_adr = prefix_flash ?
     {`APP_ADDR_FLASH, wb_rim_adr_o[31-`APP_ADDR_DEC_W:0]} :
     wb_rim_adr_o;

   // The standard boot code believes there is a memory controller at location
   // APP_ADDR_FAKEMC, and writes several values to its registers. This
   // ensures that they are acknowledged as successful, so the machine does
   // not hang.
   assign wb_rdm_ack_i = ((wb_rdm_adr_o[31:28] == `APP_ADDR_FAKEMC) &&
                          wb_rdm_cyc_o && wb_rdm_stb_o) ? 1'b1 : wb_rdm_ack;

   // Clear unused interrupts
   assign pic_ints[`APP_INT_RES1] = 'b0;
   assign pic_ints[`APP_INT_RES2] = 'b0;
   assign pic_ints[`APP_INT_RES3] = 'b0;

   // Tie off unused Wishbone signals
   assign wb_am_cab_o = 1'b0;		// Audio master CAB signal
   assign wb_em_cab_o = 1'b0;		// Ethernet master CAB signal
   assign wb_ps_err_o = 1'b0;		// PS/2 slave error
   assign wb_us_err_o = 1'b0;		// UART slave error

   // OR1200 CPU
   or1200_top or1200_top (.clk_i          ( clk          ),  // System clk/rst
			  .rst_i          ( wb_rst       ),
			  .clmode_i       ( 2'b00        ),

			  .dwb_clk_i      ( wb_clk       ),  // WB instr common
			  .dwb_rst_i      ( wb_rst       ),
			  
			  .dwb_ack_i      ( wb_rdm_ack_i ),  // WB instr master
			  .dwb_adr_o      ( wb_rdm_adr_o ),
			  .dwb_cab_o      ( wb_rdm_cab_o ),
			  .dwb_cyc_o      ( wb_rdm_cyc_o ),
			  .dwb_dat_i      ( wb_rdm_dat_i ),
			  .dwb_dat_o      ( wb_rdm_dat_o ),
			  .dwb_err_i      ( wb_rdm_err_i ),
			  .dwb_rty_i      ( wb_rdm_rty_i ),
			  .dwb_sel_o      ( wb_rdm_sel_o ),
			  .dwb_stb_o      ( wb_rdm_stb_o ),
			  .dwb_we_o       ( wb_rdm_we_o  ),

			  .iwb_clk_i      ( wb_clk       ),  // WB data common
			  .iwb_rst_i      ( wb_rst       ),
			  
			  .iwb_ack_i      ( wb_rim_ack_i ),  // WB data master
			  .iwb_adr_o      ( wb_rim_adr_o ),
			  .iwb_cab_o      ( wb_rim_cab_o ),
			  .iwb_cyc_o      ( wb_rim_cyc_o ),
			  .iwb_dat_i      ( wb_rim_dat_i ),
			  .iwb_dat_o      ( wb_rim_dat_o ),
			  .iwb_err_i      ( wb_rim_err_i ),
			  .iwb_rty_i      ( wb_rim_rty_i ),
			  .iwb_sel_o      ( wb_rim_sel_o ),
			  .iwb_stb_o      ( wb_rim_stb_o ),
			  .iwb_we_o       ( wb_rim_we_o  ),

			  .dbg_ack_o      (              ),  // Debug i/f
			  .dbg_adr_i      ( dbg_adr      ),
			  .dbg_bp_o       ( dbg_bp       ),
			  .dbg_dat_i      ( dbg_dat_dbg  ),
			  .dbg_dat_o      ( dbg_dat_risc ),
			  .dbg_ewt_i      ( 1'b0         ),
			  .dbg_is_o       ( dbg_is       ),
			  .dbg_lss_o      ( dbg_lss      ),
			  .dbg_stall_i    ( dbg_stall    ),
			  .dbg_stb_i      ( dbg_op[2]    ),
			  .dbg_we_i       ( dbg_op[0]    ),
			  .dbg_wp_o       ( dbg_wp       ),

			  .pm_clksd_o     (              ),  // Power mgmt
			  .pm_cpu_gate_o  (              ),
			  .pm_cpustall_i  ( 1'b0         ),
			  .pm_dc_gate_o   (              ),
			  .pm_dmmu_gate_o (              ),
			  .pm_ic_gate_o   (              ),
			  .pm_immu_gate_o (              ),
			  .pm_lvolt_o     (              ),
			  .pm_tt_gate_o   (              ),
			  .pm_wakeup_o    (              ),

			  .pic_ints_i     ( pic_ints     ));  // Interrupts

   // Debug unit
   dbg_top dbg_top  (.wb_clk_i          ( wb_clk      ),  // Wishbone common
		     .wb_rst_i          ( wb_rst      ),
		     
		     .wb_ack_i          ( wb_dm_ack_i ),  // Wishbone master
		     .wb_adr_o          ( wb_dm_adr_o ),
		     .wb_cab_o          ( wb_dm_cab_o ),
		     .wb_cyc_o          ( wb_dm_cyc_o ),
		     .wb_dat_i          ( wb_dm_dat_i ),
		     .wb_dat_o          ( wb_dm_dat_o ),
		     .wb_err_i          ( wb_dm_err_i ),
		     .wb_sel_o          ( wb_dm_sel_o ),
		     .wb_stb_o          ( wb_dm_stb_o ),
		     .wb_we_o           ( wb_dm_we_o  ),

		     .tck_pad_i         ( jtag_tck    ),  // JTAG pins
		     .tdi_pad_i         ( jtag_tdi    ),
		     .tdo_pad_o         ( jtag_tdo    ),
		     .tdo_padoen_o      (             ),
		     .tms_pad_i         ( jtag_tms    ),
		     .trst_pad_i        ( jtag_trst   ),
		     
		     .bs_chain_i        ( 1'b0        ),  // Boundary scan
		     .bs_chain_o        (             ),
		     .capture_dr_o      (             ), 
		     .extest_selected_o (             ), 
		     .shift_dr_o        (             ), 
		     .update_dr_o       (             ), 
		     
		     .bp_i              ( dbg_bp      ),  // OR1200 control
		     .istatus_i         ( dbg_is      ),
		     .lsstatus_i        ( dbg_lss     ),
		     .opselect_o        ( dbg_op      ),
		     .reset_o           (             ),
		     .risc_clk_i        ( wb_clk      ),
		     .risc_addr_o       ( dbg_adr     ),
		     .risc_data_i       ( dbg_dat_risc),
		     .risc_data_o       ( dbg_dat_dbg ),
		     .risc_stall_o      ( dbg_stall   ),
		     .wp_i              ( dbg_wp      ));

   // Flash controller (includes memory)
   flash_top flash_top (.wb_clk_i ( wb_clk      ),	// Wishbone common
			.wb_rst_i ( wb_rst      ),

			.wb_ack_o ( wb_fs_ack_o ),	// Wishbone slave
			.wb_adr_i ( wb_fs_adr_i ),
			.wb_cyc_i ( wb_fs_cyc_i ),
			.wb_dat_i ( wb_fs_dat_i ),
			.wb_dat_o ( wb_fs_dat_o ),
			.wb_err_o ( wb_fs_err_o ),
			.wb_sel_i ( wb_fs_sel_i ),
			.wb_stb_i ( wb_fs_stb_i ),
			.wb_we_i  ( wb_fs_we_i  ));

   // SRAM controller (includes memory)
   sram_top sram_top (.wb_clk_i ( wb_clk      ),	// Wishbone common
		      .wb_rst_i ( wb_rst      ),
   
		      .wb_ack_o ( wb_ss_ack_o ),	// Wishbone slave
		      .wb_adr_i ( wb_ss_adr_i ),
		      .wb_cyc_i ( wb_ss_cyc_i ),
		      .wb_dat_i ( wb_ss_dat_i ),
		      .wb_dat_o ( wb_ss_dat_o ),
		      .wb_err_o ( wb_ss_err_o ),
		      .wb_sel_i ( wb_ss_sel_i ),
		      .wb_stb_i ( wb_ss_stb_i ),
		      .wb_we_i  ( wb_ss_we_i  ));

   // Audio controller
   audio_top audio_top (.wb_clk_i   ( wb_clk      ),	// Wishbone common
			.wb_rst_i   ( wb_rst      ),

			.m_wb_ack_i ( wb_am_ack_i ),	// Wishbone master
			.m_wb_adr_o ( wb_am_adr_o ),
			.m_wb_cyc_o ( wb_am_cyc_o ),
			.m_wb_dat_o ( wb_am_dat_o ),
			.m_wb_dat_i ( wb_am_dat_i ),
			.m_wb_err_i ( wb_am_err_i ),
			.m_wb_sel_o ( wb_am_sel_o ),
			.m_wb_stb_o ( wb_am_stb_o ),
			.m_wb_we_o  ( wb_am_we_o  ),

			.wb_ack_o   ( wb_as_ack_o ),	// Wishbone slave
			.wb_adr_i   ( wb_as_adr_i ),
			.wb_cyc_i   ( wb_as_cyc_i ),
			.wb_dat_i   ( wb_as_dat_i ),
			.wb_dat_o   ( wb_as_dat_o ),
			.wb_err_o   ( wb_as_err_o ),
			.wb_sel_i   ( wb_as_sel_i ),
			.wb_stb_i   ( wb_as_stb_i ),
			.wb_we_i    ( wb_as_we_i  ),
   
			.lrclk      ( codec_lrclk ),	// External codec
			.mclk       ( codec_mclk  ),
			.sclk       ( codec_sclk  ),
			.sdin       ( codec_sdin  ),
			.sdout      ( codec_sdout ));

   // Ethernet MAC
   eth_top eth_top (.wb_clk_i      ( wb_clk                 ),  // WB common
		    .wb_rst_i      ( wb_rst                 ),

		    .m_wb_ack_i    ( wb_em_ack_i            ),  // WB master
		    .m_wb_adr_o    ( wb_em_adr_o            ),
		    .m_wb_cyc_o    ( wb_em_cyc_o            ), 
		    .m_wb_dat_i    ( wb_em_dat_i            ),
		    .m_wb_dat_o    ( wb_em_dat_o            ),
		    .m_wb_err_i    ( wb_em_err_i            ), 
		    .m_wb_sel_o    ( wb_em_sel_o            ),
		    .m_wb_stb_o    ( wb_em_stb_o            ),
		    .m_wb_we_o     ( wb_em_we_o             ), 

		    .wb_ack_o      ( wb_es_ack_o            ),  // WB slave
		    .wb_adr_i      ( wb_es_adr_i[11:2]      ),
		    .wb_cyc_i      ( wb_es_cyc_i            ),
		    .wb_dat_i      ( wb_es_dat_i            ),
		    .wb_dat_o      ( wb_es_dat_o            ),
		    .wb_err_o      ( wb_es_err_o            ), 
		    .wb_sel_i      ( wb_es_sel_i            ),
		    .wb_stb_i      ( wb_es_stb_i            ),
		    .wb_we_i       ( wb_es_we_i             ),

		    .int_o         ( pic_ints[`APP_INT_ETH] ), // Interrupt

		    .mcoll_pad_i   ( eth_col                ),  // Eth common
		    .mcrs_pad_i    ( eth_crs                ),

		    .mdc_pad_o     ( eth_mdc                ),  // Eth mgmt
		    .md_pad_i      ( eth_mdi                ),
		    .md_pad_o      ( eth_mdo                ),
		    .md_padoe_o    ( eth_mdoe               ),

		    .mrx_clk_pad_i ( eth_rx_clk             ),  // Eth Tx
		    .mrxdv_pad_i   ( eth_rx_dv              ),
		    .mrxerr_pad_i  ( eth_rx_er              ),
		    .mrxd_pad_i    ( eth_rxd                ),
  
		    .mtx_clk_pad_i ( eth_tx_clk             ),  // Eth Rx
		    .mtxen_pad_o   ( eth_tx_en              ),
		    .mtxerr_pad_o  ( eth_tx_er              ),
		    .mtxd_pad_o    ( eth_txd                ));

   // PS/2 Keyboard Controller
   ps2_top ps2_top (.wb_clk_i              ( wb_clk                 ), // WB cm
		    .wb_rst_i              ( wb_rst                 ),

		    .wb_ack_o              ( wb_ps_ack_o            ), // WB sl
		    .wb_adr_i              ( wb_ps_adr_i[3:0]       ),
		    .wb_cyc_i              ( wb_ps_cyc_i            ),
		    .wb_dat_i              ( wb_ps_dat_i            ),
		    .wb_dat_o              ( wb_ps_dat_o            ),
		    .wb_sel_i              ( wb_ps_sel_i            ),
		    .wb_stb_i              ( wb_ps_stb_i            ),
		    .wb_we_i               ( wb_ps_we_i             ),

		    .wb_int_o              ( pic_ints[`APP_INT_PS2] ), // Int

		    .ps2_kbd_clk_pad_i     ( ps2_clk_i              ), // Ext
		    .ps2_kbd_clk_pad_o     ( ps2_clk_o              ),
		    .ps2_kbd_clk_pad_oe_o  ( ps2_clk_oe             ),
		    .ps2_kbd_data_pad_i    ( ps2_data_i             ),
		    .ps2_kbd_data_pad_o    ( ps2_data_o             ),
		    .ps2_kbd_data_pad_oe_o ( ps2_data_oe            ));

   // UART
   uart_top uart_top (.wb_clk_i ( wb_clk                  ),  // WB common
		      .wb_rst_i ( wb_rst                  ),

		      .wb_ack_o ( wb_us_ack_o             ),  // WB slave
		      .wb_adr_i ( wb_us_adr_i[4:0]        ),
		      .wb_cyc_i ( wb_us_cyc_i             ),
		      .wb_dat_i ( wb_us_dat_i             ),
		      .wb_dat_o ( wb_us_dat_o             ),
		      .wb_sel_i ( wb_us_sel_i             ),
		      .wb_stb_i ( wb_us_stb_i             ),
		      .wb_we_i  ( wb_us_we_i              ),

		      .int_o    ( pic_ints[`APP_INT_UART] ),  // IRQ

		      .srx_pad_i ( uart_rx                ),  // Serial pins
		      .stx_pad_o ( uart_tx                ),
		      
		      .cts_pad_i ( 1'b0                   ),  // Modem signals
		      .dcd_pad_i ( 1'b0                   ),
		      .dtr_pad_o (                        ),
		      .dsr_pad_i ( 1'b0                   ),
		      .ri_pad_i  ( 1'b0                   ),
		      .rts_pad_o (                        ));

   // VGA controller
   ssvga_top ssvga_top (.wb_clk_i    ( wb_clk      ),	// Wishbone common
			.wb_rst_i    ( wb_rst      ),
  
			.wbm_ack_i   ( wb_vm_ack_i ),	// Wishbone master 
			.wbm_adr_o   ( wb_vm_adr_o ), 
			.wbm_cab_o   ( wb_vm_cab_o ),
			.wbm_cyc_o   ( wb_vm_cyc_o ),
			.wbm_dat_i   ( wb_vm_dat_i ), 
			.wbm_dat_o   (             ), 
			.wbm_err_i   ( wb_vm_err_i ), 
			.wbm_rty_i   ( 1'b0        ),
			.wbm_stb_o   ( wb_vm_stb_o ), 
			.wbm_sel_o   ( wb_vm_sel_o ), 
			.wbm_we_o    ( wb_vm_we_o  ),
			
			.wbs_ack_o   ( wb_vs_ack_o ),	// Wishbone slave
			.wbs_adr_i   ( wb_vs_adr_i ), 
			.wbs_cab_i   ( 1'b0        ),
			.wbs_cyc_i   ( wb_vs_cyc_i ), 
			.wbs_dat_i   ( wb_vs_dat_i ), 
			.wbs_dat_o   ( wb_vs_dat_o ), 
			.wbs_err_o   ( wb_vs_err_o ), 
			.wbs_rty_o   (             ),
			.wbs_sel_i   ( wb_vs_sel_i ), 
			.wbs_stb_i   ( wb_vs_stb_i ), 
			.wbs_we_i    ( wb_vs_we_i  ),
			
			.led_o       (             ),	// VGA display signals
			.pad_hsync_o ( crt_hsync   ),
			.pad_rgb_o   ( vga_int     ),
			.pad_vsync_o ( crt_vsync   ));

   // Sync up the VGA output
   always @ (posedge wb_clk or posedge wb_rst) begin
      if (wb_rst) begin
         vga_hsyncn <= #1 1'b0;
         vga_vsyncn <= #1 1'b0;
	 vga_r      <= #1 4'b0;
	 vga_g      <= #1 4'b0;
	 vga_b      <= #1 4'b0;
      end
      else begin
         vga_hsyncn <= #1 crt_hsync;
         vga_vsyncn <= #1 crt_vsync;
         vga_r      <= #1 vga_int[15:12];
         vga_g      <= #1 vga_int[10:7];
         vga_b      <= #1 vga_int[4:1];
      end
   end

   // Traffic COP (bus switch)
   tc_top #( `APP_ADDR_DEC_W,             // t0_addr_w
             `APP_ADDR_SRAM,		  // t0_addr
             `APP_ADDR_DEC_W,		  // t1_addr_w
             `APP_ADDR_FLASH,		  // t1_addr
             `APP_ADDR_DECP_W,		  // t28c_addr_w
             `APP_ADDR_PERIP,		  // t28_addr
             `APP_ADDR_DEC_W,		  // t28i_addr_w
             `APP_ADDR_VGA,		  // t2_addr
             `APP_ADDR_ETH,		  // t3_addr
             `APP_ADDR_AUDIO,		  // t4_addr
             `APP_ADDR_UART,		  // t5_addr
             `APP_ADDR_PS2,		  // t6_addr
             `APP_ADDR_RES1,		  // t7_addr
             `APP_ADDR_RES2 )		  // t8_addr
         tc_top ( .wb_clk_i    ( wb_clk        ),	// Wishbone common
		  .wb_rst_i    ( wb_rst        ),
		  
		  .i0_wb_ack_o ( wb_vm_ack_i   ),	// I0 to VGA
		  .i0_wb_adr_i ( wb_vm_adr_o   ),
		  .i0_wb_cab_i ( wb_vm_cab_o   ),
		  .i0_wb_cyc_i ( wb_vm_cyc_o   ),
		  .i0_wb_dat_i ( 32'h0000_0000 ),
		  .i0_wb_dat_o ( wb_vm_dat_i   ),
		  .i0_wb_err_o ( wb_vm_err_i   ),
		  .i0_wb_sel_i ( wb_vm_sel_o   ),
		  .i0_wb_stb_i ( wb_vm_stb_o   ),
		  .i0_wb_we_i  ( wb_vm_we_o    ),

		  .i1_wb_ack_o ( wb_em_ack_i   ),	// I1 to Ethernet
		  .i1_wb_adr_i ( wb_em_adr_o   ),
		  .i1_wb_cab_i ( wb_em_cab_o   ),
		  .i1_wb_cyc_i ( wb_em_cyc_o   ),
		  .i1_wb_dat_i ( wb_em_dat_o   ),
		  .i1_wb_dat_o ( wb_em_dat_i   ),
		  .i1_wb_err_o ( wb_em_err_i   ),
		  .i1_wb_sel_i ( wb_em_sel_o   ),
		  .i1_wb_stb_i ( wb_em_stb_o   ),
		  .i1_wb_we_i  ( wb_em_we_o    ),

		  .i2_wb_ack_o ( wb_am_ack_i   ),	// I2 to audio
		  .i2_wb_adr_i ( wb_am_adr_o   ),
		  .i2_wb_cab_i ( wb_am_cab_o   ),
		  .i2_wb_cyc_i ( wb_am_cyc_o   ),
		  .i2_wb_dat_i ( wb_am_dat_o   ),
		  .i2_wb_dat_o ( wb_am_dat_i   ),
		  .i2_wb_err_o ( wb_am_err_i   ),
		  .i2_wb_sel_i ( wb_am_sel_o   ),
		  .i2_wb_stb_i ( wb_am_stb_o   ),
		  .i2_wb_we_i  ( wb_am_we_o    ),

		  .i3_wb_ack_o ( wb_dm_ack_i   ),	// I3 to debug unit
		  .i3_wb_adr_i ( wb_dm_adr_o   ),
		  .i3_wb_cyc_i ( wb_dm_cyc_o   ),
		  .i3_wb_cab_i ( wb_dm_cab_o   ),
		  .i3_wb_dat_i ( wb_dm_dat_o   ),
		  .i3_wb_dat_o ( wb_dm_dat_i   ),
		  .i3_wb_err_o ( wb_dm_err_i   ),
		  .i3_wb_sel_i ( wb_dm_sel_o   ),
		  .i3_wb_stb_i ( wb_dm_stb_o   ),
		  .i3_wb_we_i  ( wb_dm_we_o    ),

		  .i4_wb_ack_o ( wb_rdm_ack    ),	// I4 to OR1200 data
		  .i4_wb_adr_i ( wb_rdm_adr_o  ),
		  .i4_wb_cab_i ( wb_rdm_cab_o  ),
		  .i4_wb_cyc_i ( wb_rdm_cyc_o  ),
		  .i4_wb_dat_i ( wb_rdm_dat_o  ),
		  .i4_wb_dat_o ( wb_rdm_dat_i  ),
		  .i4_wb_err_o ( wb_rdm_err_i  ),
		  .i4_wb_sel_i ( wb_rdm_sel_o  ),
		  .i4_wb_stb_i ( wb_rdm_stb_o  ),
		  .i4_wb_we_i  ( wb_rdm_we_o   ),

		  .i5_wb_ack_o ( wb_rim_ack_i  ),	// I5 to OR1200 instr
		  .i5_wb_adr_i ( wb_rif_adr    ),
		  .i5_wb_cab_i ( wb_rim_cab_o  ),
		  .i5_wb_cyc_i ( wb_rim_cyc_o  ),
		  .i5_wb_dat_i ( wb_rim_dat_o  ),
		  .i5_wb_dat_o ( wb_rim_dat_i  ),
		  .i5_wb_err_o ( wb_rim_err_i  ),
		  .i5_wb_sel_i ( wb_rim_sel_o  ),
		  .i5_wb_stb_i ( wb_rim_stb_o  ),
		  .i5_wb_we_i  ( wb_rim_we_o   ),

		  .i6_wb_ack_o (               ),	// I6 unused
		  .i6_wb_adr_i ( 32'h0000_0000 ),
		  .i6_wb_cab_i ( 1'b0          ),
		  .i6_wb_cyc_i ( 1'b0          ),
		  .i6_wb_dat_i ( 32'h0000_0000 ),
		  .i6_wb_dat_o (               ),
		  .i6_wb_err_o (               ),
		  .i6_wb_sel_i ( 4'b0000       ),
		  .i6_wb_stb_i ( 1'b0          ),
		  .i6_wb_we_i  ( 1'b0          ),

		  .i7_wb_ack_o (               ),	// I8 unused
		  .i7_wb_adr_i ( 32'h0000_0000 ),
		  .i7_wb_cab_i ( 1'b0          ),
		  .i7_wb_cyc_i ( 1'b0          ),
		  .i7_wb_dat_i ( 32'h0000_0000 ),
		  .i7_wb_dat_o (               ),
		  .i7_wb_err_o (               ),
		  .i7_wb_sel_i ( 4'b0000       ),
		  .i7_wb_stb_i ( 1'b0          ),
		  .i7_wb_we_i  ( 1'b0          ),

		  .t0_wb_ack_i ( wb_ss_ack_o   ),	// T0 from SRAM
		  .t0_wb_adr_o ( wb_ss_adr_i   ),
		  .t0_wb_cab_o ( wb_ss_cab_i   ),
		  .t0_wb_cyc_o ( wb_ss_cyc_i   ),
		  .t0_wb_dat_i ( wb_ss_dat_o   ),
		  .t0_wb_dat_o ( wb_ss_dat_i   ),
		  .t0_wb_err_i ( wb_ss_err_o   ),
		  .t0_wb_sel_o ( wb_ss_sel_i   ),
		  .t0_wb_stb_o ( wb_ss_stb_i   ),
		  .t0_wb_we_o  ( wb_ss_we_i    ),

		  .t1_wb_ack_i ( wb_fs_ack_o   ),	// T1 from flash
		  .t1_wb_adr_o ( wb_fs_adr_i   ),
		  .t1_wb_cab_o ( wb_fs_cab_i   ),
		  .t1_wb_cyc_o ( wb_fs_cyc_i   ),
		  .t1_wb_dat_i ( wb_fs_dat_o   ),
		  .t1_wb_dat_o ( wb_fs_dat_i   ),
		  .t1_wb_err_i ( wb_fs_err_o   ),
		  .t1_wb_sel_o ( wb_fs_sel_i   ),
		  .t1_wb_stb_o ( wb_fs_stb_i   ),
		  .t1_wb_we_o  ( wb_fs_we_i    ),

		  .t2_wb_ack_i ( wb_vs_ack_o   ),	// T2 from VGA
		  .t2_wb_adr_o ( wb_vs_adr_i   ),
		  .t2_wb_cab_o ( wb_vs_cab_i   ),
		  .t2_wb_cyc_o ( wb_vs_cyc_i   ),
		  .t2_wb_dat_i ( wb_vs_dat_o   ),
		  .t2_wb_dat_o ( wb_vs_dat_i   ),
		  .t2_wb_err_i ( wb_vs_err_o   ),
		  .t2_wb_sel_o ( wb_vs_sel_i   ),
		  .t2_wb_stb_o ( wb_vs_stb_i   ),
		  .t2_wb_we_o  ( wb_vs_we_i    ),

		  .t3_wb_ack_i ( wb_es_ack_o   ),	// T3 from Ethernet
		  .t3_wb_adr_o ( wb_es_adr_i   ),
		  .t3_wb_cab_o ( wb_es_cab_i   ),
		  .t3_wb_cyc_o ( wb_es_cyc_i   ),
		  .t3_wb_dat_i ( wb_es_dat_o   ),
		  .t3_wb_dat_o ( wb_es_dat_i   ),
		  .t3_wb_err_i ( wb_es_err_o   ),
		  .t3_wb_sel_o ( wb_es_sel_i   ),
		  .t3_wb_stb_o ( wb_es_stb_i   ),
		  .t3_wb_we_o  ( wb_es_we_i    ),

		  .t4_wb_ack_i ( wb_as_ack_o   ),	// T4 from audio
		  .t4_wb_adr_o ( wb_as_adr_i   ),
		  .t4_wb_cab_o ( wb_as_cab_i   ),
		  .t4_wb_cyc_o ( wb_as_cyc_i   ),
		  .t4_wb_dat_i ( wb_as_dat_o   ),
		  .t4_wb_dat_o ( wb_as_dat_i   ),
		  .t4_wb_err_i ( wb_as_err_o   ),
		  .t4_wb_sel_o ( wb_as_sel_i   ),
		  .t4_wb_stb_o ( wb_as_stb_i   ),
		  .t4_wb_we_o  ( wb_as_we_i    ),

		  .t5_wb_ack_i ( wb_us_ack_o   ),	// T5 from UART
		  .t5_wb_adr_o ( wb_us_adr_i   ),
		  .t5_wb_cab_o ( wb_us_cab_i   ),
		  .t5_wb_cyc_o ( wb_us_cyc_i   ),
		  .t5_wb_dat_i ( wb_us_dat_o   ),
		  .t5_wb_dat_o ( wb_us_dat_i   ),
		  .t5_wb_err_i ( wb_us_err_o   ),
		  .t5_wb_sel_o ( wb_us_sel_i   ),
		  .t5_wb_stb_o ( wb_us_stb_i   ),
		  .t5_wb_we_o  ( wb_us_we_i    ),

		  .t6_wb_ack_i ( wb_ps_ack_o   ),	// T6 from PS/2
		  .t6_wb_adr_o ( wb_ps_adr_i   ),
		  .t6_wb_cab_o ( wb_ps_cab_i   ),
		  .t6_wb_cyc_o ( wb_ps_cyc_i   ),
		  .t6_wb_dat_i ( wb_ps_dat_o   ),
		  .t6_wb_dat_o ( wb_ps_dat_i   ),
		  .t6_wb_err_i ( wb_ps_err_o   ),
		  .t6_wb_sel_o ( wb_ps_sel_i   ),
		  .t6_wb_stb_o ( wb_ps_stb_i   ),
		  .t6_wb_we_o  ( wb_ps_we_i    ),

		  .t7_wb_ack_i ( 1'b0          ),	// T7 unused
		  .t7_wb_adr_o (               ),
		  .t7_wb_cab_o (               ),
		  .t7_wb_cyc_o (               ),
		  .t7_wb_dat_i ( 32'h0000_0000 ),
		  .t7_wb_dat_o (               ),
		  .t7_wb_err_i ( 1'b1          ),
		  .t7_wb_sel_o (               ),
		  .t7_wb_stb_o (               ),
		  .t7_wb_we_o  (               ),

		  .t8_wb_ack_i ( 1'b0          ),	// T8 unused
		  .t8_wb_adr_o (               ),
		  .t8_wb_cab_o (               ),
		  .t8_wb_cyc_o (               ),
		  .t8_wb_dat_i ( 32'h0000_0000 ),
		  .t8_wb_dat_o (               ),
		  .t8_wb_err_i ( 1'b1          ),
		  .t8_wb_sel_o (               ),
		  .t8_wb_stb_o (               ),
		  .t8_wb_we_o  (               ));

endmodule
