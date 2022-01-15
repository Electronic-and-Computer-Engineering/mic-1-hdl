`timescale 1 ns / 1 ps

`include "verilog/top-level/rtl/defines_add.sv"

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
    reg clk;
    
    `ifdef SYNTHESIS

    // Initialize the high speed oscillator
    // Divide the oscillator down to 6 MHz
    SB_HFOSC #(.CLKHF_DIV("0b11")) clock (
        .CLKHFEN(1'b1), // Enable the output  
        .CLKHFPU(1'b1), // Power up the oscillator  
        .CLKHF(clk) // Oscillator output  
    );
    
    `else
    
    assign clk = CLK;

    `endif

    logic ser_tx, ser_rx;
    assign ser_tx = TX;
    assign ser_rx = RX;


    //logic resetn = BTN_N;
    
    logic resetn;

    logic run = 1;
    
    `ifndef SYNTHESIS
    
    initial begin
        resetn = 0;
        #10 resetn = 1;
    
        #5300
        $display("halt");
        run = 0;
        #100;
        $display("run");
        run = 1;
    end
    
    `endif
    
    logic test_debounced;
    logic test_edged;
    logic test_triggered;
    
    debouncer #(.MAX_COUNT(511)) debouncer (
        .resetn (resetn_auto),
        .clk(clk),
        .in(BTN_N),
        .out(test_debounced)
    );
    
    edge_detection edge_detection (
        .clk(clk),
        .in(test_debounced),
        .out(test_triggered)
    );
    
    T_ff T_ff (
        .resetn (resetn_auto),
        .clk(clk),
        .in(test_triggered),
        .out(LEDR_N)
    );

    mic1_soc #(
        .STACKPOINTER_ADDRESS(`STACKPOINTER_ADDRESS),
        .LOCALVARIABLEFRAME_ADDRESS(`LOCALVARIABLEFRAME_ADDRESS),
        .CONSTANTPOOL_ADDRESS(`CONSTANTPOOL_ADDRESS),
        .MIC1_PROGRAM(`MIC1_PROGRAM),
        .MIC1_MICROCODE(`MIC1_MICROCODE)
    ) mic1_soc (
        .clk          (clk   ),
		.resetn       (resetn),
		.run          (run   ),
		
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

    assign LEDG_N = 1;

    assign TX = 1;

endmodule
