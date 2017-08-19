`include "MBScore_const.v"

module MBScore_alu_operator_mux(
    input                               clk,
    input                               alu_mux_ack,
    input [`IMM_WIDTH-1:0]              imm,
    input [`ALU_SEL_WIDTH-1:0]			alu_sel_a,
	input [`ALU_SEL_WIDTH-1:0]			alu_sel_b,
    input [`DATA_WIDTH-1:0]             rs,
    input [`DATA_WIDTH-1:0]             rt,
    output [`DATA_WIDTH-1:0]            alu_a,
    output [`DATA_WIDTH-1:0]            alu_b
);

    reg [`DATA_WIDTH-1:0]               alu_a_r,alu_b_r;

    always @(negedge clk)
    begin
        if(alu_mux_ack)
        begin
            alu_a_r <= (alu_sel_a == `ALU_SEL_IMM)? {16'b0,imm} : rs;
            alu_b_r <= (alu_sel_b == `ALU_SEL_IMM)? {16'b0,imm} : rt;
        end
    end

    assign alu_a = alu_a_r;
    assign alu_b = alu_b_r;

endmodule


