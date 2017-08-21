`timescale 1ns/1ns
`include "../cpu/MBScore_const.v"
module MBSsoc_apic(
    input                           clk,
    input                           rst_n,
    input  [`INT_SEL_WIDTH-1:0]     int_vec,
    input  [`CORE_NUM-1:0]          int_able,
    input  [`SYSCODE_WIDTH-1:0]     syscall_code1,syscall_code0,
    output reg[`CORE_NUM-1:0]       int,
    output reg [`INT_SEL_WIDTH-1:0] int_num_out0,int_num_out1,
    output reg [`INT_SEL_WIDTH-1:0] int_ack,
    output [`ADDR_WIDTH-1:0]        cpu0_pc,cpu1_pc,
    output reg                      cpu1_en
);

    reg [`INT_SEL_WIDTH-1:0]        int_vec_r;

    reg [`DATA_WIDTH-1:0]           conf_r;
    reg [`ADDR_WIDTH-1:0]           cpu0_pc_r = 32'd112;
    reg [`ADDR_WIDTH-1:0]           cpu1_pc_r = 32'd0;
    assign cpu0_pc = cpu0_pc_r;
    assign cpu1_pc = cpu1_pc_r;

    reg                             syscall0,syscall1;
    reg [`SYSCODE_WIDTH-1:0]        syscall_code1_r,syscall_code0_r;

    always @(int_vec)
    begin
        int_vec_r <= int_vec;  
        if(int_vec_r[`INT_SYSCALL0] == 1'b1)
        begin
            syscall0 <= 1'b1;
            syscall_code0_r <= syscall0;
        end 

        if(int_vec_r[`INT_SYSCALL1] == 1'b1)
        begin 
            syscall1 <= 1'b1;  
            syscall_code1_r <= syscall1;
        end
    end
        

    always @(negedge clk)
    if(int_vec_r || syscall0 || syscall1)
    begin
        if(syscall0)
        begin
            case (syscall_code0)
            `CHANGE_CPU1_PC: 
            begin
                cpu1_en = 1'b1;
                #1 cpu1_en <= 1'b0;
            end
            endcase
        end


        if(int_able[1] && !conf_r[1])
        begin
            if(int_vec_r[`INT_KEYBOARD])
            begin
                int_num_out1            <= `INT_KEYBOARD;
                int_ack[`INT_KEYBOARD]  <= 1'b1;
            end
            else
            if(int_vec_r[`INT_MOUSE])
            begin
                int_num_out1          <= `INT_MOUSE;
                int_ack[`INT_MOUSE]     <= 1'b1;
            end
            else
            if(int_vec_r[`INT_UART])
            begin
                int_num_out1          <= `INT_UART;
                int_ack[`INT_UART]      <= 1'b1;
            end
            else
            if(int_vec_r[`INT_STORAGE])
            begin
                int_num_out1          <= `INT_STORAGE;
                int_ack[`INT_STORAGE]   <= 1'b1;
            end
            else
            if(int_vec_r[`INT_ETHERNET])
            begin
                int_num_out1          <= `INT_ETHERNET;
                int_ack[`INT_ETHERNET]  <= 1'b1;
            end

            int[1]                      <= 1'b1;
        end
        else
        if(int_able[0] && !conf_r[0])
        begin
            if(int_vec_r[`INT_KEYBOARD])
            begin
                int_num_out0          <= `INT_KEYBOARD;
                int_ack[`INT_KEYBOARD]  <= 1'b1;
            end
            else
            if(int_vec_r[`INT_MOUSE])
            begin
                int_num_out0          <= `INT_MOUSE;
                int_ack[`INT_MOUSE]     <= 1'b1;
            end
            else
            if(int_vec_r[`INT_UART])
            begin
                int_num_out0          <= `INT_UART;
                int_ack[`INT_UART]      <= 1'b1;
            end
            else
            if(int_vec_r[`INT_STORAGE])
            begin
                int_num_out0          <= `INT_STORAGE;
                int_ack[`INT_STORAGE]   <= 1'b1;
            end
            else
            if(int_vec_r[`INT_ETHERNET])
            begin
                int_num_out0          <= `INT_ETHERNET;
                int_ack[`INT_ETHERNET]  <= 1'b1;
            end

            int[0]                      <= 1'b1;
        end        
    end
    else
    begin
        int             <= 2'd0;
        int_num_out0    <= `INT_SEL_WIDTH'd0;
        int_num_out1    <= `INT_SEL_WIDTH'd0;
        int_ack         <= `INT_SEL_WIDTH'd0;
        cpu1_en         <= 1'b0;
    end

endmodule