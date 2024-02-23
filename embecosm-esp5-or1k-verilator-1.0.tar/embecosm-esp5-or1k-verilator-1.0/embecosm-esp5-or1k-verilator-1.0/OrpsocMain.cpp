// ----------------------------------------------------------------------------

// SystemC main program

// Copyright (C) 2008  Embecosm Limited <info@embecosm.com>

// Contributor Jeremy Bennett <jeremy.bennett@embecosm.com>

// This file is part of the cycle accurate model of the OpenRISC 1000 based
// system-on-chip, ORPSoC, built using Verilator.

// This program is free software: you can redistribute it and/or modify it
// under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.

// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
// License for more details.

// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// ----------------------------------------------------------------------------

// SystemC main program

// $Id: OrpsocMain.cpp 303 2009-02-16 11:20:17Z jeremy $


#include "OrpsocMain.h"

#include "Vorpsoc_fpga_top.h"
#include "OrpsocAccess.h"
#include "TraceSC.h"
#include "ResetSC.h"
#include "Or1200MonitorSC.h"


int sc_main (int   argc,
	     char *argv[] )
{
  // CPU clock (also used as JTAG TCK) and reset (both active high and low)
  sc_time  clkPeriod (BENCH_CLK_HALFPERIOD * 2.0, TIMESCALE_UNIT);

  sc_clock             clk ("clk", clkPeriod);
  sc_signal<bool>      rst;
  sc_signal<bool>      rstn;

  sc_signal<bool>      jtag_tdi;		// JTAG interface
  sc_signal<bool>      jtag_tdo;
  sc_signal<bool>      jtag_tms;
  sc_signal<bool>      jtag_trst;

  sc_signal<bool>      codec_lrclk;	// External codec
  sc_signal<bool>      codec_mclk;
  sc_signal<bool>      codec_sclk;
  sc_signal<bool>      codec_sdin;
  sc_signal<bool>      codec_sdout;

  sc_signal<bool>      eth_col;		// External Ethernet
  sc_signal<bool>      eth_crs;
  sc_signal<bool>      eth_fds_mdint;
  sc_signal<bool>      eth_mdc;
  sc_signal<bool>      eth_mdi;
  sc_signal<bool>      eth_mdo;
  sc_signal<bool>      eth_mdoe;

  sc_signal<bool>      eth_rx_clk;
  sc_signal<bool>      eth_rx_dv;
  sc_signal<bool>      eth_rx_er;
  sc_signal<uint32_t>  eth_rxd;

  sc_signal<bool>      eth_tx_clk;
  sc_signal<bool>      eth_tx_en;
  sc_signal<bool>      eth_tx_er;
  sc_signal<uint32_t>  eth_txd;

  sc_signal<bool>      ps2_clk_i;	// External PS/2 keyboard
  sc_signal<bool>      ps2_clk_o;
  sc_signal<bool>      ps2_clk_oe;
  sc_signal<bool>      ps2_data_i;
  sc_signal<bool>      ps2_data_o;
  sc_signal<bool>      ps2_data_oe;

  sc_signal<bool>      uart_rx;		// External UART
  sc_signal<bool>      uart_tx;

  sc_signal<uint32_t>  vga_b;		// External VGA
  sc_signal<uint32_t>  vga_g;
  sc_signal<uint32_t>  vga_r;

  sc_signal<bool>      vga_blank;
  sc_signal<bool>      vga_hsyncn;
  sc_signal<bool>      vga_pclk;
  sc_signal<bool>      vga_vsyncn;

  // Verilator accessor
  OrpsocAccess    *accessor;

  // Modules
  Vorpsoc_fpga_top *orpsoc;		// Verilated ORPSoC
  TraceSC          *trace;		// Drive VCD

  ResetSC          *reset;		// Generate a RESET signal
  Or1200MonitorSC  *monitor;		// Handle l.nop x instructions

  // Instantiate the Verilator model, VCD trace handler and accessor
  orpsoc     = new Vorpsoc_fpga_top ("orpsoc");
  trace      = new TraceSC ("trace", orpsoc, "v-dump.vcd");
  accessor   = new OrpsocAccess (orpsoc);

  // Instantiate the SystemC modules
  reset         = new ResetSC ("reset", BENCH_RESET_TIME);
  monitor       = new Or1200MonitorSC ("monitor", accessor);

  // Connect up ORPSoC
  orpsoc->clk (clk);
  orpsoc->rstn (rstn);

  orpsoc->jtag_tck  (clk);		// JTAG interface
  orpsoc->jtag_tdi  (jtag_tdi);
  orpsoc->jtag_tdo  (jtag_tdo);
  orpsoc->jtag_tms  (jtag_tms);
  orpsoc->jtag_trst (jtag_trst);

  orpsoc->codec_lrclk (codec_lrclk);    // External codec
  orpsoc->codec_mclk  (codec_mclk);
  orpsoc->codec_sclk  (codec_sclk);
  orpsoc->codec_sdin  (codec_sdin);
  orpsoc->codec_sdout (codec_sdout);

  orpsoc->eth_col       (eth_col);      // External Ethernet
  orpsoc->eth_crs       (eth_crs);
  orpsoc->eth_fds_mdint (eth_fds_mdint);
  orpsoc->eth_mdc       (eth_mdc);
  orpsoc->eth_mdi       (eth_mdi);
  orpsoc->eth_mdo       (eth_mdo);
  orpsoc->eth_mdoe      (eth_mdoe);

  orpsoc->eth_rx_clk (eth_rx_clk);
  orpsoc->eth_rx_dv  (eth_rx_dv);
  orpsoc->eth_rx_er  (eth_rx_er);
  orpsoc->eth_rxd    (eth_rxd);

  orpsoc->eth_tx_clk (eth_tx_clk);
  orpsoc->eth_tx_en  (eth_tx_en);
  orpsoc->eth_tx_er  (eth_tx_er);
  orpsoc->eth_txd    (eth_txd);

  orpsoc->ps2_clk_i   (ps2_clk_i);      // External PS/2 keyboard
  orpsoc->ps2_clk_o   (ps2_clk_o);
  orpsoc->ps2_clk_oe  (ps2_clk_oe);
  orpsoc->ps2_data_i  (ps2_data_i);
  orpsoc->ps2_data_o  (ps2_data_o);
  orpsoc->ps2_data_oe (ps2_data_oe);

  orpsoc->uart_rx (uart_rx);		// External UART
  orpsoc->uart_tx (uart_tx);

  orpsoc->vga_b (vga_b);		// External VGA
  orpsoc->vga_g (vga_g);
  orpsoc->vga_r (vga_r);

  orpsoc->vga_blank  (vga_blank);
  orpsoc->vga_hsyncn (vga_hsyncn);
  orpsoc->vga_pclk   (vga_pclk);
  orpsoc->vga_vsyncn (vga_vsyncn);

  // Connect up the VCD trace handler
  trace->clk (clk);			// Trace

  // Connect up the SystemC  modules
  reset->clk (clk);			// Reset
  reset->rst (rst);
  reset->rstn (rstn);

  monitor->clk (clk);			// Monitor

  // Tie off signals
  jtag_tdi      = 1;			// Tie off the JTAG inputs
  jtag_tms      = 1;

  codec_sdout   = 0;			// Tie off the codec

  eth_col       = 0;			// Tie off the Ethernet
  eth_crs       = 0;
  eth_fds_mdint = 0;
  eth_mdi       = 1;

  eth_rx_er     = 0;
  eth_rx_clk    = 0;
  eth_rx_dv     = 0;
  eth_rxd       = 0;

  eth_tx_clk    = 0;

  ps2_clk_i     = 1;			// Tie off the PS/2 keyboard
  ps2_data_i    = 1;

  uart_rx       = 0;			// Tie off the UART

  // Execute until we stop
  sc_start ();

  // Free memory
  delete monitor;
  delete reset;

  delete accessor;

  delete trace;
  delete orpsoc;

  return 0;

}	/* sc_main() */
