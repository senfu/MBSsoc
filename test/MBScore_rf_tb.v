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
// Generated on "08/12/2017 21:44:51"
                                                                                
// Verilog Test Bench template for design : MBScore_rf
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ns
module MBScore_rf_vlg_tst();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg clk;
reg [31:0] data_in;
reg [4:0] rd_addr;
reg reg_we;
reg [4:0] rs_addr;
reg rst_n;
reg [4:0] rt_addr;
reg spr_sel;
// wires                                               
wire [31:0]  rs_out;
wire [31:0]  rt_out;

// assign statements (if any)                          
MBScore_rf i1 (
// port map - connection between master ports and signals/registers   
	.clk(clk),
	.data_in(data_in),
	.rd_addr(rd_addr),
	.reg_we(reg_we),
	.rs_addr(rs_addr),
	.rs_out(rs_out),
	.rst_n(rst_n),
	.rt_addr(rt_addr),
	.rt_out(rt_out),
	.spr_sel(spr_sel)
);
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin                          
rst_n = 1'b1;
clk = 1'b0;
#1
rst_n = 1'b0;
#5
rst_n = 1'b1;                                                         
// --> end                                             
$display("Running testbench");                       
end

always
begin
	#10
	rs_addr <= 5'd1;
	rt_addr <= 5'd2;
	rd_addr <= 5'd1;
	spr_sel <= 1'b0;

	#50
	data_in <= 32'd12345;
	
	#10
	reg_we  <= 1'b1;
	
		
end


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

