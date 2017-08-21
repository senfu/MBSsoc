`include "MBScore_const.v"
module MBScore_alu(
    input                           clk,
    input                           rst_n,
    input  [`DATA_WIDTH-1:0]        alu_in_a,
    input  [`DATA_WIDTH-1:0]        alu_in_b,
    input  [`ALU_OP_WIDTH-1:0]      alu_op_type,
    output [`DATA_WIDTH-1:0]        alu_out,
    output                          cf
);

    reg                             cf_r;
    reg [`DATA_WIDTH-1:0]           alu_out_r;

    always @(negedge clk)
    begin
        case(alu_op_type)
        `ALU_OP_ADD:    {cf_r,alu_out_r} <= {1'b0 + alu_in_a} + {1'b0 + alu_in_b};
        `ALU_OP_ADDU:   {cf_r,alu_out_r} <= {1'b0,alu_in_a + alu_in_b};
        `ALU_OP_SUB:    {cf_r,alu_out_r} <= {1'b0 + alu_in_a} - {1'b0 + alu_in_b};
        `ALU_OP_SUBU:   {cf_r,alu_out_r} <= {1'b0,alu_in_a - alu_in_b};
        `ALU_OP_AND:    {cf_r,alu_out_r} <= {1'b0,alu_in_a & alu_in_b};
        `ALU_OP_OR:     {cf_r,alu_out_r} <= {1'b0,alu_in_a | alu_in_b};
        `ALU_OP_XOR:    {cf_r,alu_out_r} <= {1'b0,alu_in_a ^ alu_in_b};
        `ALU_OP_NOR:    {cf_r,alu_out_r} <= {1'b0,~(alu_in_a | alu_in_b)};
        `ALU_OP_SLL:    {cf_r,alu_out_r} <= {1'b0,alu_in_b << alu_in_a};
        `ALU_OP_SRL:    {cf_r,alu_out_r} <= {1'b0,alu_in_b >> alu_in_a};
        `ALU_OP_SRA:    {cf_r,alu_out_r} <= {1'b0,$signed(alu_in_b) >>> alu_in_a};
        `ALU_OP_EQ:     {cf_r,alu_out_r} <= {1'b0,(alu_in_a == alu_in_b) ? 32'd1 : 32'd0};
        `ALU_OP_NE:     {cf_r,alu_out_r} <= {1'b0,(alu_in_a != alu_in_b) ? 32'd1 : 32'd0};
        `ALU_OP_LT:     {cf_r,alu_out_r} <= {1'b0,( $signed(alu_in_a) < $signed(alu_in_b) ) ? 32'd1 : 32'd0}; 
        `ALU_OP_LTU:    {cf_r,alu_out_r} <= {1'b0,( alu_in_a < alu_in_b ) ? 32'd1 : 32'd0}; 
        default:        {cf_r,alu_out_r} <= {1'b0,alu_out_r};
        endcase
    end

    assign cf      = cf_r;
    assign alu_out = alu_out_r;

endmodule 