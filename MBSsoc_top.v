`timescale 1ns/1ns
`include "cpu/MBScore_const.v"
module MBSsoc_top(
    input clk,rst_n,
/*********DEBUG*********/
    output [`DATA_WIDTH-1:0]        data_bus_out,
    output [`ADDR_WIDTH-1:0]        addr_bus_out,
    output [`CTRL_BUS_WIDTH-1:0]    ctrl_bus_out,
    output                          cpu1_en_out,
    output                          syscall0_out,
    output [2:0]                    state0,state1,
    output [`CORE_NUM-1:0]          cpu_pause_out,
    output                          cpu_sel_out
/***********************/
);

    wire [`DATA_WIDTH-1:0]          data_bus;
    wire [`ADDR_WIDTH-1:0]          addr_bus0,addr_bus1,ram_addr;
    wire [`CTRL_BUS_WIDTH-1:0]      ctrl_bus;

    wire [`INT_SEL_WIDTH-1:0]       int_num0,int_num1;
    wire [`CORE_NUM-1:0]            int_able;
    wire [`CORE_NUM-1:0]            cpu_pause;

    wire                            ram_re,ram_we;
    wire                            syscall0,syscall1;
    wire [`SYSCODE_WIDTH-1:0]       syscall_code0,syscall_code1;
    wire                            cpu1_en;
    wire [`ADDR_WIDTH-1:0]          init_pc_cpu1,init_pc_cpu0;
    wire [3:0]                      cpu_ctrl_bus;

    wire cpu_sel;


    assign cpu1_en_out = cpu1_en;
    assign syscall0_out = syscall0;
    assign cpu_pause_out = cpu_pause;
    assign cpu_sel_out = cpu_sel;

    reg                             bus_clk;
    always @(clk)
    bus_clk = clk;

/********DEBUG***********/
    assign data_bus_out = data_bus;
    assign addr_bus_out = ram_addr;
    assign ctrl_bus_out = ctrl_bus;
/***********************/

    MBScore_cpu_top CPU0(
        .state(state0),
        .clk(clk),
        .rst_n(rst_n),
        .pause(cpu_pause[0]),
        .data_bus(data_bus),
        .addr_bus(addr_bus0),
        .ram_re(cpu_ctrl_bus[0]),
        .ram_we(cpu_ctrl_bus[1]),
        .int_vec(int_num0),
        .int_able(int_able[0]),
        .syscall(syscall0),
        .syscall_code(syscall_code0),
        .init_addr(init_pc_cpu0),
        .cpu_sel(~cpu_sel)
    );

    MBScore_cpu_top CPU1(
        .state(state1),
        .clk(clk),
        .rst_n(~cpu1_en),
        .pause(cpu_pause[1]),
        .data_bus(data_bus),
        .addr_bus(addr_bus1),
        .ram_re(cpu_ctrl_bus[2]),
        .ram_we(cpu_ctrl_bus[3]),
        .int_vec(int_num1),
        .int_able(int_able[1]),
        .syscall(syscall1),
        .syscall_code(syscall_code1),
        .init_addr(init_pc_cpu1),
        .cpu_sel(cpu_sel)
    );

    MBSsoc_ram RAM(
        .clk(clk),
        .ram_we(ctrl_bus[1]),
        .ram_re(ctrl_bus[0]),
        .addr(ram_addr),
        .data(data_bus)
    );

    MBSsoc_apic APIC(
        .clk(clk),
        .rst_n(rst_n),
        .int_vec({8'd0,syscall1,syscall0,1'b0,5'd0}),
        .int_able(int_able),
        .int_num_out0(int_num0),
        .int_num_out1(int_num1),
        .syscall_code1(syscall_code1),
        .syscall_code0(syscall_code0),
        .cpu0_pc(init_pc_cpu0),
        .cpu1_pc(init_pc_cpu1),
        .cpu1_en(cpu1_en),
        .ctrl_in(ctrl_bus[4:2]),
        .data_in(data_bus)
//        .int_ack()
    );

    MBSsoc_bus_ctrl BUS_CTRL(
        .clk(bus_clk),
        .rst_n(rst_n),
        .cpu_ctrl_bus(cpu_ctrl_bus),
        .addr_bus0(addr_bus0),
        .addr_bus1(addr_bus1),
        .cpu_pause(cpu_pause),
        .ram_addr(ram_addr),
        .cpu_sel_out(cpu_sel),
        .ctrl_bus(ctrl_bus)
    );

endmodule