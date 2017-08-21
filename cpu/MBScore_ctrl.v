`timescale 1ns/1ns
`include "MBScore_const.v"

module MBScore_ctrl(
	input 									clk,
	input 									rst_n,
	input									stop,pause,
	input 		[`DATA_WIDTH-1:0] 			inst,
	output reg								IR_ack,
	output reg 	[`ALU_SEL_WIDTH-1:0]		alu_sel_a,
	output reg 	[`ALU_SEL_WIDTH-1:0]		alu_sel_b,
	output reg	[`ALU_OP_WIDTH-1:0]			alu_op_type,
	output reg								alu_mux_ack,
	output 		[`REG_ADDR_WIDTH-1:0]		rs_addr,
	output 		[`REG_ADDR_WIDTH-1:0]		rd_addr,
	output 		[`REG_ADDR_WIDTH-1:0]		rt_addr,
	output reg								reg_we,spr_sel,pc_we,
	output 		[`IMM_WIDTH-1:0]			imm,
	output reg								JAL_or_J,BEQ_or_BNE,JR,hlt,next,LUI,
	output reg								mem_we,mem_re,mem_to_reg_we,
	output reg								syscall,
	output reg								rf_clk,bus_clk,
	output [3:0]							state
);
	reg [3:0] curState,nextState;
	reg [3:0] lastState;
	assign state = curState;

	assign rs_addr = inst[25:21];
	assign rt_addr = inst[20:16];	
	assign rd_addr = ( inst[31:26] == `OPCODE_ADDI || inst[31:26] == `OPCODE_ADDIU ||
						inst[31:26] == `OPCODE_ANDI || inst[31:26] == `OPCODE_SLTI ||
						inst[31:26] == `OPCODE_SLTIU || inst[31:26] == `OPCODE_ORI ||
						inst[31:26] == `OPCODE_XORI || inst[31:26] == `OPCODE_LUI ||
						inst[31:26] == `OPCODE_LW || inst[31:26] == `OPCODE_SW)? inst[20:16] : inst[15:11];
	assign imm     = ( inst[31:26] == `OPCODE_CALC && 
						(inst[5:0] == `FUNCT_SLL || inst[5:0] == `FUNCT_SRA || inst[5:0] == `FUNCT_SRL) ) ? {11'd0,inst[10:6]} : inst[15:0];
	
	always @(clk)
	begin
		rf_clk  <= clk;
		bus_clk <= clk;	  
	end


	always @(negedge clk)
	begin
		if( (curState == `EXE || curState == `ID) && inst[31:26] == `OPCODE_LW)
			mem_re = 1'b1;
		else
			mem_re = 1'b0;	 

		if(curState == `ID && inst[31:26] == `OPCODE_SW)
			mem_we = 1'b1;
		else
			mem_we = 1'b0;
	end


	always @(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
		begin
			curState 	<= `IDLE;
		end
		else
		if(stop)
			curState 	<= `IDLE;
		else
		if(pause)
			curState 	<= `WAIT;
		begin
			lastState 	<= curState;
			curState  	<= nextState;		  
		end

		
	end
	
	always @(curState or inst)
	begin
		if(!rst_n)
		begin
			nextState <= `IF;
		end
		else
		begin
			case(curState)
				`WAIT:			nextState <= lastState;
				`IDLE:			nextState <= `IF;
				`IF: 			nextState <= `ID;
				`ID:
				begin
					if(inst[31:26] == `OPCODE_J || inst[31:26] == `OPCODE_HLT
					|| (inst[31:26] == `OPCODE_SPECIAL && inst[5:0] == `FUNCT_SYSCALL) )
								nextState <= `IF;
						else
								nextState <= `EXE;
				end
				`EXE:
				begin
					if( (inst[31:26] == `OPCODE_CALC && inst[5:0] == `FUNCT_JR) 
						|| inst[31:26] == `OPCODE_JAL
						|| (inst[31:26] == `OPCODE_SPECIAL && inst[5:0] == `FUNCT_SPRWR) )
								nextState <= `IF;
						else
				  				nextState <= `WB;
				end			
				`WB: 			nextState <= `IF;
			default: 			nextState <= nextState;
			endcase
		end
	end
	
	always @(curState)
	begin
		if(!rst_n)
		begin
			IR_ack		<= 0;
			alu_sel_a 	<= 0;
			alu_sel_b	<= 0;
			alu_op_type <= 0;
			JAL_or_J	<= 0;
			BEQ_or_BNE	<= 0;
			JR			<= 0;
			hlt			<= 0;
			next		<= 0;
			reg_we		<= 0;
			spr_sel	    <= 0;
			alu_mux_ack <= 0;
			pc_we		<= 0;
			mem_to_reg_we<=0;
			LUI			<= 0;
			syscall     <= 0;
		end
		begin
			IR_ack		<= 0;  
			alu_sel_a 	<= 0;
			alu_sel_b	<= 0;
			alu_op_type <= 0;
			JAL_or_J	<= 0;
			BEQ_or_BNE	<= 0;
			JR			<= 0;
			hlt			<= 0;
			next		<= 0;
			reg_we		<= 0;
			spr_sel		<= 0;
			alu_mux_ack <= 0;
			pc_we		<= 0;
			mem_to_reg_we<=0;
			LUI			<= 0;
			syscall     <= 0;

			if(curState == `IF)
				IR_ack <= 1'b1;

			if(curState == `ID)
				begin
					case(inst[31:26])
					`OPCODE_CALC:
						begin
							case(inst[5:0])
								`FUNCT_ADD,`FUNCT_ADDU,`FUNCT_SUB,`FUNCT_SUBU,`FUNCT_AND,
								`FUNCT_OR,`FUNCT_XOR,`FUNCT_NOR,`FUNCT_SLT,`FUNCT_SLTU,
								`FUNCT_SLLV,`FUNCT_SRLV,`FUNCT_SRAV:
									begin
										alu_sel_a 	<= `ALU_SEL_RS;
										alu_sel_b 	<= `ALU_SEL_RT;
										alu_mux_ack <= 1'b1;
									end
							
								`FUNCT_SLL,`FUNCT_SRL,`FUNCT_SRA:
									begin
										alu_sel_a 	<= `ALU_SEL_IMM;
										alu_sel_b 	<= `ALU_SEL_RT;
										alu_mux_ack <= 1'b1;
									end
								default: ;
							endcase
						end

					`OPCODE_ADDI,`OPCODE_ADDIU,`OPCODE_ANDI,`OPCODE_ORI,
					`OPCODE_XORI,`OPCODE_SLTI,`OPCODE_SLTI:
						begin
							alu_sel_a 	<= `ALU_SEL_RS;
							alu_sel_b 	<= `ALU_SEL_IMM;
							alu_mux_ack <= 1'b1;
						end
					
					`OPCODE_BEQ,`OPCODE_BNE:
						begin
							alu_sel_a 	<= `ALU_SEL_RS;
							alu_sel_b 	<= `ALU_SEL_RT;
							alu_mux_ack <= 1'b1;
						end

					`OPCODE_LUI:
						begin
							alu_sel_a 	<= `ALU_SEL_RS;
							alu_sel_b   <= `ALU_SEL_IMM;
							alu_mux_ack <= 1'b1;  
						end

					`OPCODE_HLT:
						begin
							hlt  <= 1'b1;
							next <= 1'b1;
						end
					`OPCODE_J:
						begin
							JAL_or_J <= 1'b1;
							next     <= 1'b1;
						end
					`OPCODE_JAL: 
						begin
							reg_we <= 1'b1;
							pc_we  <= 1'b1;
						end

					`OPCODE_SPECIAL:
						begin
							if(inst[5:0] == `FUNCT_SYSCALL)
							begin
								syscall <= 1'b1;
								next    <= 1'b1;  
							end

							if(inst[5:0] == `FUNCT_SPRRD)
							begin
								spr_sel     <= 1'b1;
								alu_sel_a 	<= `ALU_SEL_RS;
								alu_sel_b 	<= `ALU_SEL_RT;
								alu_mux_ack <= 1'b1;
							end

							if(inst[5:0] == `FUNCT_SPRWR)
							begin
								alu_sel_a   <= `ALU_SEL_RS;
								alu_sel_b	<= `ALU_SEL_RT;
								alu_mux_ack <= 1'b1; 
							end
						end
					default: ;
					endcase
				end

			
			if(curState == `EXE)
				begin
					case(inst[31:26])
						`OPCODE_JAL     :
							begin
								JAL_or_J <= 1'b1;
								next <= 1'b1;  
							end
						
						`OPCODE_LW		:
						begin
							mem_to_reg_we <= 1'b1;
						end

						`OPCODE_CALC	:
							begin
								case(inst[5:0])
									`FUNCT_ADD				:	alu_op_type <= `ALU_OP_ADD;
									`FUNCT_ADDU				:	alu_op_type <= `ALU_OP_ADDU;
									`FUNCT_SUB				:	alu_op_type <= `ALU_OP_SUB;
									`FUNCT_SUBU				:	alu_op_type <= `ALU_OP_SUBU;
									`FUNCT_AND				: 	alu_op_type <= `ALU_OP_AND;
									`FUNCT_OR				:	alu_op_type <= `ALU_OP_OR;
									`FUNCT_XOR				:  	alu_op_type <= `ALU_OP_XOR;
									`FUNCT_NOR				:  	alu_op_type <= `ALU_OP_NOR;
									`FUNCT_SLT				:  	alu_op_type <= `ALU_OP_LT;
									`FUNCT_SLTU				:	alu_op_type <= `ALU_OP_LTU;
									`FUNCT_SLLV,`FUNCT_SLL	:	alu_op_type <= `ALU_OP_SLL;
									`FUNCT_SRLV,`FUNCT_SRL	:	alu_op_type <= `ALU_OP_SRL;
									`FUNCT_SRAV,`FUNCT_SRA  :	alu_op_type <= `ALU_OP_SRA;
									`FUNCT_JR:
									begin
										JR 	 <= 1'b1;
										next <= 1'b1;
									end
									default:	;
								endcase
							end
						`OPCODE_ADDI 	: alu_op_type <= `ALU_OP_ADD;
						`OPCODE_ADDIU	: alu_op_type <= `ALU_OP_ADDU;
						`OPCODE_ANDI	: alu_op_type <= `ALU_OP_AND;
						`OPCODE_ORI		: alu_op_type <= `ALU_OP_OR;
						`OPCODE_XORI	: alu_op_type <= `ALU_OP_XOR;
						`OPCODE_BEQ		: alu_op_type <= `ALU_OP_EQ;
						`OPCODE_BNE		: alu_op_type <= `ALU_OP_NE;
						`OPCODE_SLTI	: alu_op_type <= `ALU_OP_LT; 
						`OPCODE_SLTIU	: alu_op_type <= `ALU_OP_LTU;
						`OPCODE_LUI		: alu_op_type <= `ALU_OP_ADDU;

						`OPCODE_SPECIAL : if(inst[5:0] == `FUNCT_SPRRD)
										  alu_op_type <= `ALU_OP_ADDU;
										  else
										  if(inst[5:0] == `FUNCT_SPRWR)
										  begin
										  	spr_sel <= 1'b1;
											reg_we 	<= 1'b1;
											next    <= 1'b1;
										  end
						default:;
					endcase
				end

			if(curState == `WB)
				begin				
					if(inst[31:26] == `OPCODE_BEQ || inst[31:26] == `OPCODE_BNE)
					begin
						BEQ_or_BNE <= 1'b1;
					end
					else
					begin
						if(inst[31:26] == `OPCODE_LUI)
						LUI     <= 1'b1;
						
						if(inst[31:26] != `OPCODE_SW && inst[31:26] != `OPCODE_LW)
						begin
							spr_sel <= 1'b0;
							reg_we  <= 1'b1;
						end
					end

					next <= 1'b1;
				end
		end
	end


endmodule

