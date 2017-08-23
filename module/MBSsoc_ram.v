`include "../cpu/MBScore_const.v"
module MBSsoc_ram(
    input                       clk,
    input                       ram_we,ram_re,wr_invalid,
    input [`ADDR_WIDTH-1:0]     addr,
    inout [`DATA_WIDTH-1:0]     data
);

    reg [`DATA_WIDTH-1:0] ram [0:`MEM_LEN-1];
    initial $readmemb("D:/lijunyan/MBSsoc/init/mem_init.txt",ram);  

    reg [`ADDR_WIDTH-1:0] addr_r;

    assign data = (ram_re == 1'b1) ? ram[addr_r] : `DATA_WIDTH'bz;

    always @(posedge clk)
    addr_r = addr >> 2;

    always @(posedge clk)
    if(ram_we && ~wr_invalid)
    ram[addr >> 2] = data;

endmodule