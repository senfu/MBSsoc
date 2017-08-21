`include "MBScore_const.v"

module MBScore_cpu_top(
    input                           clk,rst_n,
    inout  [`DATA_WIDTH-1:0]        data_bus,
    input  [`INT_SEL_WIDTH-1:0]     int_vec,
    input                           pause,
    input  [`ADDR_WIDTH-1:0]        init_addr,
    output [`ADDR_WIDTH-1:0]        addr_bus,
    output                          ram_re,ram_we,
    output                          int_able,
    output                          syscall,
    output [`SYSCODE_WIDTH-1:0]     syscall_code,

    output [`DATA_WIDTH-1:0]        inst_out
);

    wire [`ALU_SEL_WIDTH-1:0]   alu_sel_a,alu_sel_b;
    wire [`ALU_OP_WIDTH-1:0]    alu_op_type;
    wire                        alu_mux_ack;
    wire [`REG_ADDR_WIDTH-1:0]  rs_addr,rt_addr,rd_addr;
    wire                        reg_we,spr_sel,next,JAL_or_J,BEQ_or_BNE,JR,hlt;
    wire [`IMM_WIDTH-1:0]       imm;
    wire [`DATA_WIDTH-1:0]      rs_data,rt_data,alu_a,alu_b,alu_out;
    wire [`ADDR_WIDTH-1:0]      inst_mem_addr,data_mem_addr,int_addr;
    wire [`DATA_WIDTH-1:0]      inst;
    wire                        IR_ack;
    wire                        pc_we;
    wire                        data_mem_we;
    wire [`DATA_WIDTH-1:0]      rf_data_in;
    wire                        mem_to_reg_we;
    wire                        LUI;
    wire                        stop;
    wire                        setINTR;
    wire                        int_jump;
    wire                        cf;
    wire                        int_en_n;
    wire [`DATA_WIDTH-1:0]      spr_temp;
    wire                        data_mem_re;
    wire                        rf_clk,bus_clk;
    wire                        inst_re;

    wire [`DATA_WIDTH-1:0]      data_from_bus;
    wire [`ADDR_WIDTH-1:0]      inst_addr,data_addr;
    assign data_addr    = rs_data + $signed(inst[15:0]);
    assign inst_out     = inst;
    assign int_able     = ~int_en_n;
    assign syscall_code = inst[25:6];

    MBScore_bus_ctrl bus_ctrl(
        .clk(bus_clk),
        .inst_addr(inst_addr),
        .data_addr(data_addr),
        .data_sel(data_mem_re | data_mem_we),
        .inst_re(inst_re),
        .data_re(data_mem_re),
        .data_we(data_mem_we),
        .addr(addr_bus),
        .data_rd(data_from_bus),
        .data_wr(rt_data),
        .ram_re(ram_re),
        .ram_we(ram_we),
        .data(data_bus)
    );

    MBScore_ctrl ctrl(
        .state(state),
	    .clk(clk),
	    .rst_n(rst_n),
	    .inst(inst),
	    .IR_ack(IR_ack),
	    .alu_sel_a(alu_sel_a),
	    .alu_sel_b(alu_sel_b),
	    .alu_op_type(alu_op_type),
	    .alu_mux_ack(alu_mux_ack),
	    .rs_addr(rs_addr),
	    .rd_addr(rd_addr),
	    .rt_addr(rt_addr),
	    .reg_we(reg_we),
        .spr_sel(spr_sel),
	    .imm(imm),
	    .JAL_or_J(JAL_or_J),
        .BEQ_or_BNE(BEQ_or_BNE),
        .JR(JR),
        .hlt(hlt),
        .next(next),
        .pc_we(pc_we),
        .mem_we(data_mem_we),
        .mem_re(data_mem_re),
        .inst_re(inst_re),
        .mem_to_reg_we(mem_to_reg_we),
        .LUI(LUI),
        .stop(stop),
        .pause(pause),
        .syscall(syscall),
        .rf_clk(rf_clk),
        .bus_clk(bus_clk)
    );

    MBScore_IR IR(
	    .clk(clk),
	    .rst_n(rst_n),
	    .IR_ack(IR_ack),
	    .next(next),
	    .JAL_or_J(JAL_or_J),
	    .BEQ_or_BNE(BEQ_or_BNE),
	    .JR(JR),
	    .hlt(hlt),
	    .jump(alu_out[0]),
	    .next_addr(rs_data),
        .int_addr(int_addr),
	    .inst_in(data_from_bus),
	    .inst_out(inst),
	    .pc_out(inst_addr),
        .int_jump(int_jump),
        .init_addr(init_addr)
    );

    MBScore_rf rf(
        .clk(rf_clk),
        .rst_n(rst_n),
        .rs_addr(rs_addr),
        .rd_addr(rd_addr),
        .rt_addr(rt_addr),
        .reg_we(reg_we),
        .mem_to_reg_we(mem_to_reg_we),
        .spr_sel(spr_sel),
        .alu_data_in(alu_out),
        .mem_data_in(data_from_bus),
        .rs_out(rs_data),
        .rt_out(rt_data),
        .pc_we(pc_we),
        .pc_in(inst_addr),
        .LUI(LUI),
        .setINTR(setINTR),
        .int_en_n(int_en_n),
        .spr_out(spr_temp),
        .spr_in(spr_temp)
    );

    MBScore_alu_operator_mux alu_op_mux(
        .clk(clk),
        .alu_mux_ack(alu_mux_ack),
        .imm(imm),
        .alu_sel_a(alu_sel_a),
	    .alu_sel_b(alu_sel_b),
        .rs(rs_data),
        .rt(rt_data),
        .alu_a(alu_a),
        .alu_b(alu_b)
    );

    MBScore_alu alu(
        .clk(clk),
        .rst_n(rst_n),
        .alu_in_a(alu_a),
        .alu_in_b(alu_b),
        .alu_op_type(alu_op_type),
        .alu_out(alu_out),
        .cf(cf)
    );

    MBScore_interrupt_ctrl int_ctrl(
        .clk(clk),
        .rst_n(rst_n),
        .int_vec(int_vec),
        .int_en_n(int_en_n),  
        .stop(stop),
        .setINTR(setINTR),
        .int_addr(int_addr),
        .int_jump(int_jump)
    );

endmodule
