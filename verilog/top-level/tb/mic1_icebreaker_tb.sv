`timescale 1 ns / 1 ps

module mic1_icebreaker_tb;

    initial begin
        $display("Starting MIC-1 simulation...");
        $dumpfile("mic1_icebreaker_tb.vcd");
        $dumpvars(0, mic1_icebreaker_tb);
    end

    wire [4:0] leds = 0;
    wire led_r = 0;
    wire led_g = 0;
    
    wire ser_tx = 0;
    reg  ser_rx = 0;

    reg clk = 0;
    always #1 clk = !clk;

    initial #1000 $finish;

    mic1_icebreaker mic1_icebreaker (
        .clk          (clk   ),
        
        .ser_tx       (ser_tx   ),
	    .ser_rx       (ser_rx   ),

        .led1         (leds[0] ),
	    .led2         (leds[1] ),
	    .led3         (leds[2] ),
	    .led4         (leds[3] ),
	    .led5         (leds[4] ),

	    .ledr_n       (led_r   ),
	    .ledg_n       (led_g   )
    );  

endmodule
