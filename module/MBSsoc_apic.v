`include "../cpu/MBScore_const.v"
module MBSsoc_apic(
    input                           clk,
    input                           rst_n,
    input  [`INT_SEL_WIDTH-1:0]     int_vec,
    input  [`CORE_NUM-1:0]          int_able,
    output [`CORE_NUM-1:0]          int,
    output [`CORE_NUM-1:0]          int_num_out,
    output [`INT_SEL_WIDTH-1:0]     int_ack
);

    reg [`INT_SEL_WIDTH-1:0]        int_vec_r;

    reg [`DATA_WIDTH-1:0]           conf_r;
    reg [`ADDR_WIDTH-1:0]           cpu0_pc,cpu1_pc;

    always @(posedge clk)
    if(int_vec)
        int_vec_r <= int_vec;  
    else
        int_vec_r <= 0;

    always @(negedge clk)
    if(int_vec_r)
    begin
        if(int_able[1] && !conf_r[1])
        begin
            if(int_vec_r[`INT_SYSCALL])
            begin
                int_num_out[1]        <= `INT_SYSCALL;
                int_ack[`INT_SYSCALL] <= 1'b1;
            end
            else
            if(int_vec_r[`INT_KEYBOARD])
            begin
                int_num_out[1]          <= `INT_KEYBOARD;
                int_ack[`INT_KEYBOARD]  <= 1'b1;
            end
            else
            if(int_vec_r[`INT_MOUSE])
                int_num_out[1]          <= `INT_MOUSE;
                int_ack[`INT_MOUSE]     <= 1'b1;
            end
            else
            if(int_vec_r[`INT_UART])
                int_num_out[1]          <= `INT_UART;
                int_ack[`INT_UART]      <= 1'b1;
            end
            else
            if(int_vec_r[`INT_STORAGE])
                int_num_out[1]          <= `INT_STORAGE;
                int_ack[`INT_STORAGE]   <= 1'b1;
            end
            else
            if(int_vec_r[`INT_ETHERNET])
                int_num_out[1]          <= `INT_ETHERNET;
                int_ack[`INT_ETHERNET]  <= 1'b1;
            end
            else
            if(int_vec_r[`INT_CF])
                int_num_out[1]          <= `INT_CF;
                int_ack[`INT_CF]        <= 1'b1;
            end

            int[1]                      <= 1'b1;
        end
        else
        if(int_able[0] && !conf_r[0])
        begin
            if(int_vec_r[`INT_SYSCALL])
            begin
                int_num_out[0]          <= `INT_SYSCALL;
                int_ack[`INT_SYSCALL] <= 1'b1;
            end
            else
            if(int_vec_r[`INT_KEYBOARD])
            begin
                int_num_out[0]          <= `INT_KEYBOARD;
                int_ack[`INT_KEYBOARD]  <= 1'b1;
            end
            else
            if(int_vec_r[`INT_MOUSE])
                int_num_out[0]          <= `INT_MOUSE;
                int_ack[`INT_MOUSE]     <= 1'b1;
            end
            else
            if(int_vec_r[`INT_UART])
                int_num_out[0]          <= `INT_UART;
                int_ack[`INT_UART]      <= 1'b1;
            end
            else
            if(int_vec_r[`INT_STORAGE])
                int_num_out[0]          <= `INT_STORAGE;
                int_ack[`INT_STORAGE]   <= 1'b1;
            end
            else
            if(int_vec_r[`INT_ETHERNET])
                int_num_out[0]          <= `INT_ETHERNET;
                int_ack[`INT_ETHERNET]  <= 1'b1;
            end
            else
            if(int_vec_r[`INT_CF])
                int_num_out[0]          <= `INT_CF;
                int_ack[`INT_CF]        <= 1'b1;
            end

            int[0]                      <= 1'b1;
        end        
    end
    else
    begin
        int         <= 2'd0;
        int_num_out <= 2'd0;
        int_ack     <= `INT_SEL_WIDTH'd0;
    end

endmodule