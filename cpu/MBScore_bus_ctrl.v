`include "MBScore_const.v"
module MBScore_bus_ctrl(
    input                       clk,
    input  [`DATA_WIDTH-1:0]    data_wr,
    input  [`ADDR_WIDTH-1:0]    inst_addr,data_addr,
    input                       data_sel,
    input                       inst_re,data_re,data_we,
    output [`ADDR_WIDTH-1:0]    addr,
    output                      ram_re,ram_we,
    output [`DATA_WIDTH-1:0]    data_rd,
    inout  [`DATA_WIDTH-1:0]    data
);

    assign addr = (data_sel == 1'b1)? data_addr : inst_addr;
    assign ram_we = data_we;
    assign ram_re = inst_re | data_re;

    reg [`DATA_WIDTH-1:0]       data_r;
    assign data     = (ram_we == 1'b1) ? data_wr : `DATA_WIDTH'bz;
    assign data_rd  = data;

endmodule