`timescale 1ns/1ps

module Uart_module(uart_rx,uart_tx,send_state);
	
	input uart_rx;
	output reg uart_tx;
	output reg send_state;
	
	reg Clk;
	reg Rst_n;
	
	wire Mid_Flag_send;
	wire Mid_Flag_Receive;
	
	reg Receive_Baud_Start;
	reg [7:0]rx_data;
	reg [7:0]rx_data_tmp;
		
	initial Clk = 1;
	always#10 Clk = ~Clk;
	
	speed_select speed_select_Send(
		.clk(Clk),
		.rst_n(Rst_n),
		.bps_start(1'b1),
		.clk_bps(Mid_Flag_send)
	);
	
	speed_select speed_select_receive(
		.clk(Clk),
		.rst_n(Rst_n),
		.bps_start(Receive_Baud_Start),
		.clk_bps(Mid_Flag_Receive)
	);
	
	initial begin
		Rst_n = 0;
		uart_tx = 1;
		send_state = 0;
		#300 Rst_n = 1;
		
		$display("Set Baud As 9600bps");	
		#50;Uart_Send(8'hb6);
		#80;Uart_Send(8'he7);
		#40;Uart_Send(8'hf0);
		#50;Uart_Send(8'h02);
		#30;Uart_Send(8'hb4);
		#30;Uart_Send(8'he5);
		#90;Uart_Send(8'hb0);
		#60;Uart_Send(8'h32);
		#2000000;
		$stop;
	end

	task Uart_Send;
		input [7:0]Data;
		begin
			send_state = 1;
			@(posedge Mid_Flag_send) #0.1 uart_tx = 0;
			@(posedge Mid_Flag_send) #0.1 uart_tx = Data[0];
			@(posedge Mid_Flag_send) #0.1 uart_tx = Data[1];
			@(posedge Mid_Flag_send) #0.1 uart_tx = Data[2];
			@(posedge Mid_Flag_send) #0.1 uart_tx = Data[3];
			@(posedge Mid_Flag_send) #0.1 uart_tx = Data[4];
			@(posedge Mid_Flag_send) #0.1 uart_tx = Data[5];
			@(posedge Mid_Flag_send) #0.1 uart_tx = Data[6];
			@(posedge Mid_Flag_send) #0.1 uart_tx = Data[7];
			@(posedge Mid_Flag_send) #0.1 uart_tx = 1;
			$display("Uart_Send Data = %0h",Data);
			send_state = 0;
		end
	endtask
	
	initial begin
	forever begin
		@(negedge uart_rx)
			begin
				Receive_Baud_Start = 1;
				@(posedge Mid_Flag_Receive);
				@(posedge Mid_Flag_Receive)rx_data_tmp[0] = uart_rx;
				@(posedge Mid_Flag_Receive)rx_data_tmp[1] = uart_rx;	
				@(posedge Mid_Flag_Receive)rx_data_tmp[2] = uart_rx;	
				@(posedge Mid_Flag_Receive)rx_data_tmp[3] = uart_rx;
				@(posedge Mid_Flag_Receive)rx_data_tmp[4] = uart_rx;	
				@(posedge Mid_Flag_Receive)rx_data_tmp[5] = uart_rx;
				@(posedge Mid_Flag_Receive)rx_data_tmp[6] = uart_rx;
				@(posedge Mid_Flag_Receive)rx_data_tmp[7] = uart_rx;
				@(posedge Mid_Flag_Receive)begin Receive_Baud_Start = 0;rx_data = rx_data_tmp;end
				$display("Uart_receive Data = %0h",rx_data); 
			end
		end
	end

endmodule
