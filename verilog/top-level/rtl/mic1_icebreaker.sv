`timescale 1 ns / 1 ps

module mic1_icebreaker (
    input clk,
    
    output ser_tx,
	input ser_rx,

    output led1,
	output led2,
	output led3,
	output led4,
	output led5,

	output ledr_n,
	output ledg_n
);    
    
    reg [5:0] reset_cnt = 0;
    wire resetn = &reset_cnt;

    always @(posedge clk) begin
		reset_cnt <= reset_cnt + !resetn;
    end
    
    mic1_soc mic1_soc (
        .clk          (clk   ),
		.resetn       (resetn),
		
		.ser_tx       (ser_tx),
		.ser_rx       (ser_rx)
    );

endmodule
