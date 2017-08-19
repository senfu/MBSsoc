`include "../cpu/MBScore_const.v"
`timescale 1 ns/ 1 ns
module MBScore_cpu_top_vlg_tst();
    reg clk,rst_n;
    reg [`DATA_WIDTH-1:0] inst;
    wire [`DATA_WIDTH-1:0] alu_result;

    MBScore_cpu_top i1(
        .clk(clk),
        .rst_n(rst_n),
        .inst(inst),
        .alu_result(alu_result)
    );

    initial                                                
    begin                                                                     
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
        #10
        inst = 32'b00000000001000010000100000100000;
    end

    always
    begin
        forever #10 clk = ~clk;  
    end

endmodule

