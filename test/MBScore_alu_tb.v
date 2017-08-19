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
// Generated on "08/12/2017 21:34:10"
                                                                                
// Verilog Test Bench template for design : MBScore_alu
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ns
module MBScore_alu_vlg_tst();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg [31:0] alu_in_a;
reg [31:0] alu_in_b;
reg [3:0] alu_op_type;
reg clk;
reg rst_n;
// wires                                               
wire [31:0]  alu_out;
wire cf;

// assign statements (if any)                          
MBScore_alu i1 (
// port map - connection between master ports and signals/registers   
	.alu_in_a(alu_in_a),
	.alu_in_b(alu_in_b),
	.alu_op_type(alu_op_type),
	.alu_out(alu_out),
	.cf(cf),
	.clk(clk),
	.rst_n(rst_n)
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
#40
alu_in_a = 32'd2;
alu_in_b = 32'b10000000000000000000000000000001;

#10
alu_op_type = 4'd1;	
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

