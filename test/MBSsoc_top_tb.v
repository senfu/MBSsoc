`timescale 1ns/1ns
module MBSsoc_top_tb();
    reg clk,rst_n;

    wire [31:0] data_bus;
    wire [31:0] addr_bus;
    wire [6:0] ctrl_bus;
    wire cpu1_en;
    wire syscall0;
    wire [2:0] state0,state1;
    wire [1:0] cpu_pause;
    wire cpu_sel;
    wire cpu0_lock_flag;
    wire [31:0] lock_addr;
    wire [7:0] tx_data;

//    wire rs232_rx,
    wire rs232_tx;
    wire tx_en;

    MBSsoc_top i1(
        .clk(clk),
        .rst_n(rst_n),
        .data_bus_out(data_bus),
        .addr_bus_out(addr_bus),
        .ctrl_bus_out(ctrl_bus),
        .cpu1_en_out(cpu1_en),
        .syscall0_out(syscall0),
        .state0(state0),
        .state1(state1),
        .cpu_pause_out(cpu_pause),
        .cpu_sel_out(cpu_sel),
        .cpu0_lock_flag_out(cpu0_lock_flag),
        .lock_addr_out(lock_addr),
        .rs232_tx(rs232_tx),
        .tx_data_out(tx_data),
        .tx_en_out(tx_en)
    );

    initial                                                
    begin                                                                     
        rst_n = 1'b1;
        clk = 1'b0;
        #50
        rst_n = 1'b0;
        #50
        rst_n = 1'b1;                                                                                                 
        $display("Running testbench");                       
    end

    always
    begin
        forever #10 clk = ~clk;
    end

endmodule