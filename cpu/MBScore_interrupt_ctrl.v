`include "MBScore_const.v"

module MBScore_interrupt_ctrl(
    input                           clk,
    input                           rst_n,
    input                           int_vec,
    input                           int_en_n,
    output reg                      stop,
    output reg                      setINTR,
    output reg [`ADDR_WIDTH-1:0]    int_addr,
    output reg                      int_jump
);

    reg                             int_vec_r;

    always @(int_vec)
    if(int_vec && !int_en_n)
    begin
        int_vec_r   = int_vec;
        stop        = 1'b1;
    end 
    else
    stop = 1'b0;

    always @(posedge clk)
    if(stop)
    begin
        setINTR      = 1'b1;

        if(int_vec_r == `INT_SYSCALL)
            int_addr = `INT_SYSCALL_ADDR;
        else
        if(int_vec_r == `INT_KEYBOARD)
            int_addr = `INT_KEYBOARD_ADDR;
        else
        if(int_vec_r == `INT_MOUSE)
            int_addr = `INT_MOUSE_ADDR;
        else
        if(int_vec_r == `INT_UART)
            int_addr = `INT_UART_ADDR;
        else
        if(int_vec_r[`INT_STORAGE])
            int_addr = `INT_STORAGE_ADDR;
        else
        if(int_vec_r[`INT_ETHERNET])
            int_addr = `INT_ETHERNET_ADDR;
        else
        if(int_vec_r[`INT_CF])
            int_addr = `INT_CF_ADDR;

        int_jump     = 1'b1;
    end
    else
    begin
        setINTR      = 1'b0;
        int_jump     = 1'b0;
        int_addr     = `ADDR_WIDTH'd0;
    end

endmodule 