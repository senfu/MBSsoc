`include "cpu/MBScore_const.v"
module MBSsoc_top(
    input clk,rst_n,
/*********DEBUG*********/
    output [`DATA_WIDTH-1:0]        data_bus_out,
    output [`ADDR_WIDTH-1:0]        addr_bus_out,
    output [`CTRL_BUS_WIDTH-1:0]    ctrl_bus_out,
    output [`DATA_WIDTH-1:0]        inst_out
/***********************/
);

    wire [`DATA_WIDTH-1:0]          data_bus;
    wire [`ADDR_WIDTH-1:0]          addr_bus0,addr_bus1,ram_addr;
    wire [`CTRL_BUS_WIDTH-1:0]      ctrl_bus;

    wire [`CORE_NUM-1:0]            int_num;
    wire [`CORE_NUM-1:0]            int_able;
    wire [`CORE_NUM-1:0]            cpu_pause;

    wire                            ram_re,ram_we;

    reg                             bus_clk;
    always @(clk)
    bus_clk = clk;

/********DEBUG***********/
    assign data_bus_out = data_bus;
    assign addr_bus_out = addr_bus;
    assign ctrl_bus_out = ctrl_bus;
/***********************/

    MBScore_cpu_top CPU0(
        .clk(clk),
        .rst_n(rst_n),
        .pause(cpu_pause[0]),
        .data_bus(data_bus),
        .addr_bus(addr_bus0),
        .ram_re(ctrl_bus[0]),
        .ram_we(ctrl_bus[1]),
        .int_vec(int_num[0]),
        .int_able(int_able[0]),
//        .syscall(),
//        .syscall_code()
//        .inst_out(inst_out)
    );

    MBScore_cpu_top CPU1(
        .clk(clk),
//        .rst_n(rst_n),
        .pause(cpu_pause[1]),
        .data_bus(data_bus),
        .addr_bus(addr_bus1),
        .ram_re(ctrl_bus[2]),
        .ram_we(ctrl_bus[3]),
        .int_vec(int_num[1]),
        .int_able(int_able[1]),
//        .syscall(),
//        .syscall_code()
//        .inst_out(inst_out)
    );

    MBSsoc_ram RAM(
        .clk(clk),
        .ram_we(ram_we),
        .ram_re(ram_re),
        .addr(ram_addr),
        .data(data_bus)
    );

    MBSsoc_apic APIC(
        .clk(clk),
        .rst_n(rst_n),
        .int_vec(),
        .int_able(int_able),
        .int_num_out(int_num),
//        .int_ack()
//        .int
    );

    MBSsoc_bus_ctrl BUS_CTRL(
        .clk(bus_clk),
        .rst_n(rst_n),
        .ctrl_bus(ctrl_bus),
        .addr_bus0(addr_bus0),
        .addr_bus1(addr_bus1),
        .cpu_pause(cpu_pause),
        .ram_re(ram_re),
        .ram_we(ram_we),
        .ram_addr(ram_addr)
    );

endmodule