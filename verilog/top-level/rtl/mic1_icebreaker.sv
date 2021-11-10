`timescale 1 ns / 1 ps

module mic1_icebreaker (
	input CLK,

	input  RX,
	output TX,

	output LED1,
	output LED2,
	output LED3,
	output LED4,
	output LED5,

    input  BTN_N,
	output LEDR_N,
	output LEDG_N
);
    // TODO PLL


    wire clk;
    assign clk = CLK;

    wire ser_tx, ser_rx;
    assign ser_tx = TX;
    assign ser_rx = RX;

    reg [5:0] reset_cnt = 0;
    wire resetn = &reset_cnt;

    always @(posedge clk) begin
		reset_cnt <= reset_cnt + !resetn;
    end

    mic1_soc mic1_soc (
        .clk          (clk   ),
		.resetn       (resetn),
		
		.ser_tx       (ser_tx),
		.ser_rx       (ser_rx),
		
		.out (out)
    );

    wire [31:0] out;

    assign LED1 = out[16];
    assign LED2 = out[17];
    assign LED3 = out[18];
    assign LED4 = out[19];
    assign LED5 = out[20];

    assign LEDR_N = 0;
    assign LEDG_N = 1;

    assign TX = 1;

endmodule
