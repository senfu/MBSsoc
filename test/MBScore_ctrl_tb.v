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
// Generated on "08/12/2017 21:31:46"
                                                                                
// Verilog Test Bench template for design : MBScore_ctrl
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ns
module MBScore_ctrl_vlg_tst();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg clk;
reg [31:0] inst;
reg rst_n;
// wires                                               
wire BEQ_or_BNE;
wire IR_ack;
wire JAL_or_J;
wire JR;
wire alu_mux_ack;
wire [3:0]  alu_op_type;
wire [1:0]  alu_sel_a;
wire [1:0]  alu_sel_b;
wire hlt;
wire [15:0]  imm;
wire next;
wire [4:0]  rd_addr;
wire reg_we;
wire [4:0]  rs_addr;
wire [4:0]  rt_addr;
wire spr_sel;

// assign statements (if any)                          
MBScore_ctrl i1 (
// port map - connection between master ports and signals/registers   
	.BEQ_or_BNE(BEQ_or_BNE),
	.IR_ack(IR_ack),
	.JAL_or_J(JAL_or_J),
	.JR(JR),
	.WB_sel(WB_sel),
	.alu_mux_ack(alu_mux_ack),
	.alu_op_type(alu_op_type),
	.alu_sel_a(alu_sel_a),
	.alu_sel_b(alu_sel_b),
	.clk(clk),
	.hlt(hlt),
	.imm(imm),
	.inst(inst),
	.next(next),
	.rd_addr(rd_addr),
	.reg_we(reg_we),
	.rs_addr(rs_addr),
	.rst_n(rst_n),
	.rt_addr(rt_addr),
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

always @(posedge IR_ack)
begin
inst = 32'b00010000001000100000000000000011;	
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

