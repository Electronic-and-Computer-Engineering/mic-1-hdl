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

    initial begin
        #2000

        $display("Memory contents:");
        for (int i=0; i<20; i++) begin
            $display("mem[%4d] = %h", i, mic1_icebreaker.mic1_soc.main_memory.test_memory[i]);
        end
        
        
        
        $display("Completed simulation.");
        $finish;
    end
    
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
