`include "../cpu/MBScore_const.v"
module MBSsoc_bus_ctrl(
    input                           clk,
    input                           rst_n,
    input [`CTRL_BUS_WIDTH-1:0]     ctrl_bus,
    input [`ADDR_WIDTH-1:0]         addr_bus0,addr_bus1
/*CPU总线控制*/
    output [`CORE_NUM-1:0]          cpu_pause,
/************/
/*RAM*/
    output                          ram_re,ram_we,
    output [`ADDR_WIDTH-1:0]        ram_addr
/**/
);

    reg     cpu_sel;
    assign  ram_addr = (cpu_sel == 1'b1) ? addr_bus1 : addr_bus0;
    assign  ram_re   = (cpu_sel == 1'b1) ? ctrl_bus[2] : ctrl_bus[0];
    assign  ram_we   = (cpu_sel == 1'b1) ? ctrl_bus[3] : ctrl_bus[1];

    always @(negedge clk)
    if( (ctrl_bus[0] && ctrl_bus[2]) || (ctrl_bus[1] && ctrl_bus[3]) || 
        (ctrl_bus[0] && ctrl_bus[3]) || (ctrl_bus[1] && ctrl_bus[2]) )
    begin
        cpu_pause[0] <= 1'b1;  
        cpu_sel      <= 1'b1;
    end
    else
    if(ctrl_bus[0] || ctrl_bus[1])
    begin
        cpu_pause    <= 2'b00;
        cpu_sel      <= 1'b0;
    end
    else
    if(ctrl_bus[2] || ctrl_bus[3])
    begin
        cpu_pause    <= 2'b00;
        cpu_sel      <= 1'b1;    
    end
    else
    begin
        cpu_pause    <= 2'b00;
        cpu_sel      <= 1'b0;            
    end

    