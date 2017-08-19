`include "../cpu/MBScore_const.v"
`timescale 1 ns/ 1 ns
module MBScore_cpu_top_vlg_tst();
    reg clk,rst_n;
    wire [`DATA_WIDTH-1:0] alu_result,pc_out,inst;
//    wire pc_we;
    wire [3:0] state;
    wire [`INT_SEL_WIDTH-1:0] int_vec;

    MBScore_cpu_top i1(
        .clk(clk),
        .rst_n(rst_n),
        .alu_result(alu_result),
        .pc_out(pc_out),
        .inst_out(inst),
//        .pc_we_out(pc_we),
        .state(state),
        .int_vec_out(int_vec)
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
        forever #10 clk = ~clk;  
    end

endmodule

