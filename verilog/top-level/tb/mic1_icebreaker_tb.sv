`timescale 1 ns / 1 ps

module mic1_icebreaker_tb;

    initial begin
        $display("Starting MIC-1 simulation...");
        $dumpfile("mic1_icebreaker_tb.vcd");
        $dumpvars(0, mic1_icebreaker_tb);
    end

    wire [4:0] leds;
    wire led_r;
    wire led_g;
    
    wire ser_tx;
    reg  ser_rx = 0;

    reg clk = 0;
    always #1 clk = !clk;

    initial #1000 $finish;

    mic1_icebreaker mic1_icebreaker (
        .CLK          (clk   ),
        
        .TX       (ser_tx   ),
	    .RX       (ser_rx   ),

        .LED1         (leds[0] ),
	    .LED2         (leds[1] ),
	    .LED3         (leds[2] ),
	    .LED4         (leds[3] ),
	    .LED5         (leds[4] ),

	    .LEDR_N       (led_r   ),
	    .LEDG_N       (led_g   )
    );  

endmodule
