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

    wire [`DATA_WIDTH-1:0]        data_bus;
    wire [`ADDR_WIDTH-1:0]        addr_bus;
    wire [`CTRL_BUS_WIDTH-1:0]    ctrl_bus;

/********DEBUG***********/
    assign data_bus_out = data_bus;
    assign addr_bus_out = addr_bus;
    assign ctrl_bus_out = ctrl_bus;
/***********************/

    MBScore_cpu_top CPU(
        .clk(clk),
        .rst_n(rst_n),
        .data_bus(data_bus),
        .addr_bus(addr_bus),
        .ctrl_bus(ctrl_bus),
        .inst_out(inst_out)
    );

    MBSsoc_ram RAM(
        .clk(clk),
        .ram_we(ctrl_bus[1]),
        .ram_re(ctrl_bus[0]),
        .addr(addr_bus),
        .data(data_bus)
    );

endmodule