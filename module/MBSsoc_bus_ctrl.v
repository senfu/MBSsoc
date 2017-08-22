`include "../cpu/MBScore_const.v"
module MBSsoc_bus_ctrl(
    input                               clk,
    input                               rst_n,
    input [3:0]                         cpu_ctrl_bus,
    input [`ADDR_WIDTH-1:0]             addr_bus0,addr_bus1,
/*CPU总线控制*/
    output reg [`CORE_NUM-1:0]          cpu_pause,
    output                              cpu_sel_out,
    output [`CTRL_BUS_WIDTH-1:0]        ctrl_bus,
/************/
/*RAM*/
    output reg [`ADDR_WIDTH-1:0]       ram_addr
/**/
);

    reg    cpu_sel;
    wire   we,re;

    reg apic_conf,apic_cpu0_pc,apic_cpu1_pc,ram_re,ram_we;

    wire [`ADDR_WIDTH-1:0] addr;
    assign cpu_sel_out = cpu_sel;
    assign addr = (cpu_sel == 1'b1) ? addr_bus1 : addr_bus0;
    assign re   = (cpu_sel == 1'b1) ? cpu_ctrl_bus[2] : cpu_ctrl_bus[0];
    assign we   = (cpu_sel == 1'b1) ? cpu_ctrl_bus[3] : cpu_ctrl_bus[1];
    assign ctrl_bus[0] = ram_re;
    assign ctrl_bus[1] = ram_we;
    assign ctrl_bus[2] = apic_conf;
    assign ctrl_bus[3] = apic_cpu0_pc;
    assign ctrl_bus[4] = apic_cpu1_pc;

    always @(re or we)
    begin
        ram_re          <= 1'b0;
        ram_we          <= 1'b0;
        ram_addr        <= `ADDR_WIDTH'd0;
        apic_conf       <= 1'b0;
        apic_cpu0_pc    <= 1'b0;
        apic_cpu1_pc    <= 1'b0;

        if(addr < 33554432)
        begin
            ram_re      <= re;
            ram_we      <= we;
            ram_addr    <= addr;  
        end
        else
        case (addr)
        `APIC_CONF_ADDR:         apic_conf       <= we;
        `APIC_CPU0_PC_ADDR:      apic_cpu0_pc    <= we;
        `APIC_CPU1_PC_ADDR:      apic_cpu1_pc    <= we;
//        UART_DATA_ADDR:         
        default:;
        endcase
    end

    always @(negedge clk)
    if( (cpu_ctrl_bus[0] && cpu_ctrl_bus[2]) || (cpu_ctrl_bus[1] && cpu_ctrl_bus[3]) || 
        (cpu_ctrl_bus[0] && cpu_ctrl_bus[3]) || (cpu_ctrl_bus[1] && cpu_ctrl_bus[2]) )
    begin
        cpu_pause[0] <= 1'b1;  
        cpu_sel      <= 1'b1;
    end
    else
    if(cpu_ctrl_bus[0] || cpu_ctrl_bus[1])
    begin
        cpu_pause    <= 2'b00;
        cpu_sel      <= 1'b0;
    end
    else
    if(cpu_ctrl_bus[2] || cpu_ctrl_bus[3])
    begin
        cpu_pause    <= 2'b00;
        cpu_sel      <= 1'b1;    
    end
    else
    begin
        cpu_pause    <= 2'b00;
        cpu_sel      <= 1'b0;            
    end

endmodule
