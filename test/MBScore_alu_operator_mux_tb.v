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
// Generated on "08/12/2017 21:35:10"
                                                                                
// Verilog Test Bench template for design : MBScore_alu_operator_mux
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ns
module MBScore_alu_operator_mux_vlg_tst();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg alu_mux_ack;
reg [1:0] alu_sel_a;
reg [1:0] alu_sel_b;
reg clk;
reg [15:0] imm;
reg [31:0] rs;
reg [31:0] rt;
// wires                                               
wire [31:0]  alu_a;
wire [31:0]  alu_b;

// assign statements (if any)                          
MBScore_alu_operator_mux i1 (
// port map - connection between master ports and signals/registers   
	.alu_a(alu_a),
	.alu_b(alu_b),
	.alu_mux_ack(alu_mux_ack),
	.alu_sel_a(alu_sel_a),
	.alu_sel_b(alu_sel_b),
	.clk(clk),
	.imm(imm),
	.rs(rs),
	.rt(rt)
);
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin                          
alu_mux_ack = 1'b0;
alu_sel_a = 2'd0;
alu_sel_b = 2'd0;
clk = 1'b0;                                                      
// --> end                                             
$display("Running testbench");                       
end

always
begin
#10
imm = 16'b0001100000100000;

#20
alu_mux_ack = 1'b1;	
alu_sel_a = 2'b01;
alu_sel_b = 2'b10;
rs = 32'd1;
rt = 32'd2;
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

