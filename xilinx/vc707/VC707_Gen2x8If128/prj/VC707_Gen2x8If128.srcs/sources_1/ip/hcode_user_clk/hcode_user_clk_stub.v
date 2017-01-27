// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.4 (lin64) Build 1412921 Wed Nov 18 09:44:32 MST 2015
// Date        : Thu Jul 14 10:15:39 2016
// Host        : Bluemountain running 64-bit Ubuntu 14.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/cho/hCODE/hFPGA/shell-vc707-riffa2-ap_fifo128/xilinx/vc707/VC707_Gen2x8If128/prj/VC707_Gen2x8If128.srcs/sources_1/ip/hcode_user_clk/hcode_user_clk_stub.v
// Design      : hcode_user_clk
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx485tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module hcode_user_clk(clk_in1, clk_out1, clk_out2, clk_out3, clk_out4)
/* synthesis syn_black_box black_box_pad_pin="clk_in1,clk_out1,clk_out2,clk_out3,clk_out4" */;
  input clk_in1;
  output clk_out1;
  output clk_out2;
  output clk_out3;
  output clk_out4;
endmodule
