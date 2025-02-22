// orpsoc.v - top level Verilog definitions for Verilated ORPSoC
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

// $Id: orpsoc_fpga_defines.v 310 2009-02-19 14:54:24Z jeremy $

`define FLASH_GENERIC

//
// Interrupts
//
`define APP_INT_RES1	1:0
`define APP_INT_UART	2
`define APP_INT_RES2	3
`define APP_INT_ETH	4
`define APP_INT_PS2	5
`define APP_INT_RES3	19:6

//
// Address map
//
`define APP_ADDR_DEC_W	8
`define APP_ADDR_SRAM	`APP_ADDR_DEC_W'h00
`define APP_ADDR_FLASH	`APP_ADDR_DEC_W'h04
`define APP_ADDR_DECP_W  4
`define APP_ADDR_PERIP  `APP_ADDR_DECP_W'h9
`define APP_ADDR_VGA	`APP_ADDR_DEC_W'h97
`define APP_ADDR_ETH	`APP_ADDR_DEC_W'h92
`define APP_ADDR_AUDIO	`APP_ADDR_DEC_W'h9d
`define APP_ADDR_UART	`APP_ADDR_DEC_W'h90
`define APP_ADDR_PS2	`APP_ADDR_DEC_W'h94
`define APP_ADDR_RES1	`APP_ADDR_DEC_W'h9e
`define APP_ADDR_RES2	`APP_ADDR_DEC_W'h9f
`define APP_ADDR_FAKEMC	4'h6
