`include "MBScore_const.v"
module MBScore_IR(
	input							clk,
	input 							rst_n,
	input							IR_ack,
	input 							next,
	input							JAL_or_J,
	input							BEQ_or_BNE,
	input							JR,
	input							hlt,
	input							jump,int_jump,
	input		[`ADDR_WIDTH-1:0]	next_addr,int_addr,
	input  		[`DATA_WIDTH-1:0]	inst_in,
	output  	[`DATA_WIDTH-1:0]	inst_out,
	output 		[`DATA_WIDTH-1:0]	pc_out
);

	reg [`DATA_WIDTH-1:0]			pc = 32'd0;
	reg [`DATA_WIDTH-1:0]           inst;

	assign pc_out = pc;
	assign inst_out = inst;


	always @(negedge clk)
	if(IR_ack)
	inst = inst_in;

	always @(negedge clk)
	if(next || int_jump)
	begin
		if(hlt == 1'b1)
		pc = pc;
		else
		if(JAL_or_J)
		pc = (inst[25:0] << 2);
		else
		if(BEQ_or_BNE && jump)
		pc = pc + 4 + ($signed(inst[15:0]) << 2);
		else
		if(JR)
		pc = next_addr;
		else
		if(int_jump)
		pc = int_addr;
		else
		pc = pc + 4;
	end
	
endmodule
