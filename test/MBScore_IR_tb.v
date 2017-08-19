`include "../cpu/MBScore_const.v"
`timescale 1ns/1ns
module MBScore_IR_vlg_tst();
	reg clk;
	reg rst_n;
	reg IR_ack;
	reg next;
	reg JAL_or_J;
	reg BEQ_or_BNE;
	reg JR;
	reg hlt;
	reg jump;
	reg	[`DATA_WIDTH-1:0]	next_addr;
	reg	[`DATA_WIDTH-1:0]	inst_in;
	wire [`DATA_WIDTH-1:0]	inst_out;
	wire [`DATA_WIDTH-1:0]	pc_out;
	wire mem_re;

    MBScore_IR i1(
        .clk(clk),
	    .rst_n(rst_n),
	    .IR_ack(IR_ack),
	    .next(next),
	    .JAL_or_J(JAL_or_J),
	    .BEQ_or_BNE(BEQ_or_BNE),
	    .JR(JR),
	    .hlt(hlt),
	    .jump(jump),
	    .next_addr(next_addr),
	    .inst_in(inst_in),
	    .inst_out(inst_out),
	    .pc_out(pc_out),
	    .mem_re(mem_re)
    );

    initial                                                
    begin
        JAL_or_J = 1'b0;
        BEQ_or_BNE = 1'b0;
        JR = 1'b0;
        hlt = 1'b0;
        next = 1'b0;

        IR_ack = 1'b0;                                                                
        rst_n = 1'b1;
        clk = 1'b0;
        #1
        rst_n = 1'b0;
        #5
        rst_n = 1'b1;                                                                                               
        $display("Running testbench");                       
    end

    always
    begin
        forever #10 clk = ~clk;  
    end

    always @(posedge mem_re)
    if(pc_out == 32'd0)
    inst_in = 32'b00010000001000100000000000000001;
    else
    if(pc_out == 32'd8)
    inst_in = 32'b00010000001000100000000000000010;
    else
    inst_in = 32'b00010000001000100000000000000011;

    initial
    begin
        #10
        IR_ack = 1'b1;
        #20
        IR_ack = 1'b0;  
        #40
        next = 1'b1;
        BEQ_or_BNE = 1'b1;
        jump = 1'b0;
        #20
        IR_ack = 1'b1;
        #20
        IR_ack = 1'b0;
    end

endmodule