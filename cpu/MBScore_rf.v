`include "MBScore_const.v"
module MBScore_rf(
    input                           clk,
    input                           rst_n,
    input [`REG_ADDR_WIDTH-1:0]     rs_addr,
    input [`REG_ADDR_WIDTH-1:0]     rd_addr,
    input [`REG_ADDR_WIDTH-1:0]     rt_addr,
    input                           reg_we,mem_to_reg_we,
    input                           pc_we,
    input                           spr_sel,
    input  [`DATA_WIDTH-1:0]        alu_data_in,mem_data_in,
    input  [`DATA_WIDTH-1:0]        pc_in,
    input                           LUI,
    input                           setINTR,
    output [`DATA_WIDTH-1:0]        rs_out,
    output [`DATA_WIDTH-1:0]        rt_out,
    output [`DATA_WIDTH-1:0]        spr_out,spr_in,
    output                          int_en_n      
);

    reg [`REG_ADDR_WIDTH-1:0]     rs_addr_r,rt_addr_r,rd_addr_r;

    reg [31:0] gr  [0:31];
    reg [31:0] spr [0:7];

    assign rs_out = (spr_sel == 1'b1 && !reg_we)? spr[rs_addr_r] : gr[rs_addr_r];
    assign rt_out = gr[rt_addr_r];
    assign spr_out = spr[rd_addr_r];
    
    assign int_en_n = spr[1][0];

    reg [31:0] spr_temp_r;

	 
	initial
	begin
		gr[0] = 32'd0;
        gr[1] = 32'b0;
        gr[2] = 32'b0;
        gr[3] = 32'd0;
        gr[4] = 32'd0;
        gr[5] = 32'd0;
        gr[6] = 32'd0;
        gr[7] = 32'd0;
        gr[8] = 32'd0;
        gr[9] = 32'd0;
    	gr[10] = 32'd0;
        gr[11] = 32'd0;
        gr[12] = 32'd0;
        gr[13] = 32'd0;
        gr[14] = 32'd0;
        gr[15] = 32'd0;
        gr[16] = 32'd0;
        gr[17] = 32'd0;
        gr[18] = 32'd0;
        gr[19] = 32'd0;
    	gr[20] = 32'd0;
        gr[21] = 32'd0;
        gr[22] = 32'd0;
        gr[23] = 32'd0;
        gr[24] = 32'd0;
        gr[25] = 32'd0;
        gr[26] = 32'd0;
        gr[27] = 32'd0;
        gr[28] = 32'd0;
        gr[29] = 32'd0;
        gr[30] = 32'd0;
        gr[31] = 32'd0;

        spr[0] = 32'd0;
        spr[1] = 32'd0;
        spr[2] = 32'd0;
        spr[3] = 32'd0;
        spr[4] = 32'd0;
        spr[5] = 32'd0;
        spr[6] = 32'd0;
        spr[7] = 32'd0;
	end

    always @(negedge clk)
    if(reg_we && !spr_sel && !mem_to_reg_we)
    begin
        if(pc_we)
            gr[31] = pc_in + 4;
        else
        if(rd_addr != 0)
        begin
            if(LUI)
                gr[rd_addr] = {alu_data_in[15:0],16'd0};
            else
                gr[rd_addr] = alu_data_in;
        end    
    end
    else
    if(mem_to_reg_we)
    begin
        if(rd_addr != 0)
        gr[rd_addr] = mem_data_in;      
    end

    always @(posedge clk)
    begin
        rs_addr_r <= rs_addr;
        rt_addr_r <= rt_addr; 
    end


    always @(negedge clk)
    if(reg_we && spr_sel)
        spr[rd_addr] = ( spr_in & rt_out ) | ( rs_out & (~rt_out) );
    else
    if(setINTR)
    begin
        spr[0] = pc_in;
        spr[1][0] = 1'b1;  
    end

    always @(posedge clk)
        rd_addr_r <= rd_addr; 
    
endmodule
