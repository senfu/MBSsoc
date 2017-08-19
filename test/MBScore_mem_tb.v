// Copyright (C) 2017  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Intel and sold by Intel or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// *****************************************************************************
// This file contains a Verilog test bench template that is freely editable to  
// suit user's needs .Comments are provided in each section to help the user    
// fill out necessary details.                                                  
// *****************************************************************************
// Generated on "08/17/2017 16:47:47"
                                                                                
// Verilog Test Bench template for design : MBScore_mem
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ns
module MBScore_mem_vlg_tst();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg clk;
reg [31:0] data_addr_base;
reg [31:0] data_addr_offset;
reg [31:0] data_in;
reg data_re;
reg data_we;
reg [31:0] inst_addr;
reg inst_re;
// wires                                               
wire [31:0]  data_out;
wire [31:0]  inst_out;

// assign statements (if any)                          
MBScore_mem i1 (
// port map - connection between master ports and signals/registers   
	.clk(clk),
	.data_addr_base(data_addr_base),
	.data_addr_offset(data_addr_offset),
	.data_in(data_in),
	.data_out(data_out),
	.data_re(data_re),
	.data_we(data_we),
	.inst_addr(inst_addr),
	.inst_out(inst_out),
	.inst_re(inst_re)
);
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin                          
clk = 0;
inst_addr = 0;
inst_re = 0;                                                       
// --> end                                             
$display("Running testbench");                       
end

always @(posedge clk)
inst_re = 1'b1;


always                                                 
// optional sensitivity list                           
// @(event1 or event2 or .... eventn)                  
begin                                                  
// code executes for every event on sensitivity list   
// insert code here --> begin                          
forever #10 clk = ~clk;                                                       
@eachvec;                                              
// --> end                                             
end                                                    
endmodule

