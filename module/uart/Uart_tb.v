`timescale 1ns/1ns

module Uart_tb;
	
	reg Clk;
	reg Rst_n;
	
	wire uart_rx;
	wire uart_tx;
	wire send_state;
	
	my_uart_top u1(
		.clk(Clk),
		.rst_n(Rst_n),
		.rs232_rx(uart_tx),
		.rs232_tx(uart_rx)
	);

	Uart_module u2(
		.uart_rx(uart_rx),
		.uart_tx(uart_tx),
		.send_state(send_state)
	);
	
	initial begin
		Clk = 1;
		Rst_n = 0;
		#200;
		Rst_n = 1;	
	end
	
	always #10 Clk = ~Clk;

endmodule
