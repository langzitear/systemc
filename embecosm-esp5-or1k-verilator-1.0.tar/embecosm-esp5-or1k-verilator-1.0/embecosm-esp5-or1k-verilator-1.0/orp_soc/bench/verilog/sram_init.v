//////////////////////////////////////////////////////////////////////
////                                                              ////
////  MP3 demo SRAM init                                          ////
////                                                              ////
////  This file is part of the MP3 demo application               ////
////  http://www.opencores.org/cores/or1k/mp3/                    ////
////                                                              ////
////  Description                                                 ////
////  Optional SRAM content initialization (for debugging         ////
////  purposes)                                                   ////
////                                                              ////
////  To Do:                                                      ////
////   - nothing really                                           ////
////                                                              ////
////  Author(s):                                                  ////
////      - Damjan Lampret, lampret@opencores.org                 ////
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
// $Log: sram_init.v,v $
// Revision 1.1  2002/03/28 19:59:55  lampret
// Added bench directory
//
// Revision 1.1.1.1  2001/11/04 18:51:07  lampret
// First import.
//
//
`ifdef SRAM_INIT

module sram_init;

reg [7:0] mem [135005:0];
reg [31:0] tmp;

task init_sram;
integer i;
begin
	#1;

	$display("Initializing SRAM ...");
	$readmemh("../src/flash.in", mem);
	for (i=0; i < 135000; i=i+4) begin
		xess_top.Sram_r1.mem_array[i/4] = mem[i];
		xess_top.Sram_r0.mem_array[i/4] = mem[i+1];
		xess_top.Sram_l1.mem_array[i/4] = mem[i+2];
		xess_top.Sram_l0.mem_array[i/4] = mem[i+3];
	end

`ifdef UNUSED

	for (i=0; i < 135000; i=i+4) begin
		tmp[31:24] = xess_top.Sram_r1.temp_array[i/4];
		tmp[23:16] = xess_top.Sram_r0.temp_array[i/4];
		tmp[15:8] = xess_top.Sram_l1.temp_array[i/4];
		tmp[7:0] = xess_top.Sram_l0.temp_array[i/4];
		$display("%h %h", i, tmp);
		tmp[31:24] = xess_top.Sram_r1.mem_array[i/4];
		tmp[23:16] = xess_top.Sram_r0.mem_array[i/4];
		tmp[15:8] = xess_top.Sram_l1.mem_array[i/4];
		tmp[7:0] = xess_top.Sram_l0.mem_array[i/4];
		$display("%h %h", i, tmp);
	end

`endif

end
endtask

endmodule

`endif
