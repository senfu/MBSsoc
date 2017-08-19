`timescale 1ns/1ns
module MBSsoc_top_tb();
    reg clk,rst_n;

    wire [31:0] data_bus;
    wire [31:0] addr_bus;
    wire [31:0] ctrl_bus;
    wire [31:0] inst;

    MBSsoc_top i1(
        .clk(clk),
        .rst_n(rst_n),
        .data_bus_out(data_bus),
        .addr_bus_out(addr_bus),
        .ctrl_bus_out(ctrl_bus),
        .inst_out(inst)
    );

    initial                                                
    begin                                                                     
        rst_n = 1'b1;
        clk = 1'b0;
        #5
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