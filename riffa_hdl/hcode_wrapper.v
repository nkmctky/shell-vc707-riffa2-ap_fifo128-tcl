// ----------------------------------------------------------------------
// Copyright (c) 2016, The Regents of the University of California All
// rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
// 
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
// 
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
// 
//     * Neither the name of The Regents of the University of California
//       nor the names of its contributors may be used to endorse or
//       promote products derived from this software without specific
//       prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL REGENTS OF THE
// UNIVERSITY OF CALIFORNIA BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
// OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
// TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
// USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
// DAMAGE.
// ----------------------------------------------------------------------
//----------------------------------------------------------------------------
// Filename:			chnl_tester.v
// Version:				1.00.a
// Verilog Standard:	Verilog-2001
// Description:			Sample RIFFA channel user module. Designed to exercise
// 						the RIFFA TX and RX interfaces. Receives data on the
//						RX interface and saves the last value received. Sends
//						the same amount of data back on the TX interface. The
//						returned data starts with the last value received, 
//						resets and increments to end with a value equal to the
//						number of (4 byte) words sent back on the TX interface.
// Author:				Matt Jacobsen
// History:				@mattj: Version 2.0
//-----------------------------------------------------------------------------
`timescale 1ns/1ns
module hcode_wrapper #(
	parameter C_PCI_DATA_WIDTH = 9'd32
)
(
	input CLK,
	input RST,
	output CHNL_RX_CLK, 
	input CHNL_RX, 
	output CHNL_RX_ACK, 
	input CHNL_RX_LAST, 
	input [31:0] CHNL_RX_LEN, 
	input [30:0] CHNL_RX_OFF, 
	input [C_PCI_DATA_WIDTH-1:0] CHNL_RX_DATA, 
	input CHNL_RX_DATA_VALID, 
	output CHNL_RX_DATA_REN,
	
	output CHNL_TX_CLK, 
	output CHNL_TX, 
	input CHNL_TX_ACK, 
	output CHNL_TX_LAST, 
	output [31:0] CHNL_TX_LEN, 
	output [30:0] CHNL_TX_OFF, 
	output [C_PCI_DATA_WIDTH-1:0] CHNL_TX_DATA, 
	output CHNL_TX_DATA_VALID, 
	input CHNL_TX_DATA_REN
);

wire full;
wire empty;

assign CHNL_RX_CLK = ip_clk;
assign CHNL_RX_ACK = CHNL_RX_DATA_REN;
assign CHNL_RX_DATA_REN = (CHNL_RX_DATA_VALID & (!full));


assign CHNL_TX_CLK = ip_clk;
assign CHNL_TX = CHNL_TX_DATA_VALID;
assign CHNL_TX_LAST = 1'd1;
assign CHNL_TX_OFF = 0;
assign CHNL_TX_DATA_VALID = (!empty);
assign CHNL_TX_LEN = CHNL_RX_LEN;

   //----------START: xillybus_interface signals----------
   wire [127:0] 	 in_r_dout;
   wire 	 in_r_read;
   wire 	 in_r_empty;
   wire [127:0] 	 out_r_din;
   wire 	 out_r_full;
   wire 	 out_r_write;
   //----------END: xillybus_interface signals----------
   
   //----------START: ip clocks----------
   wire 	 ip_clk;
   wire 	 ip_rst_n;
   wire 	 user_clk_100;
   wire 	 user_clk_150;
   wire 	 user_clk_200;
   wire 	 user_clk_250;
   //----------END: ip clocks----------

assign ip_rst_n = ~RST;
assign ip_clk = user_clk_250;//progma_ip_clk
hcode_user_clk user_clk_0
     (
      .clk_in1(CLK),
      .clk_out1(user_clk_100),
      .clk_out2(user_clk_150),
      .clk_out3(user_clk_200),
      .clk_out4(user_clk_250)
      );

hcode_user_fifo_128 user_fifo_in(
    .clk(ip_clk),
    .srst(RST),
    .din(CHNL_RX_DATA),
    .wr_en(CHNL_RX_DATA_REN),
    .full(full),
    .dout(in_r_dout),
    .rd_en(in_r_read),
    .empty(in_r_empty)
);

hcode_user_fifo_128 user_fifo_out(
    .clk(ip_clk),
    .srst(RST),
    .din(out_r_din),
    .wr_en(out_r_write),
    .full(out_r_full),
    .dout(CHNL_TX_DATA),
    .rd_en(CHNL_TX_DATA_REN & CHNL_TX_DATA_VALID),
    .empty(empty)
);

ip_loopback ip_loopback_128bit_0 (.ap_clk(ip_clk), .ap_rst(~ip_rst_n), .in_V_V_dout(in_r_dout), .in_V_V_empty_n(~in_r_empty), .in_V_V_read(in_r_read), .out_V_V_din(out_r_din), .out_V_V_full_n(!out_r_full), .out_V_V_write(out_r_write)); //progma_ip_wrapper
endmodule
