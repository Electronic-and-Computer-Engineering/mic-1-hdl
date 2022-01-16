`timescale 1 ns / 1 ps

module mic1_icebreaker_tb;

    initial begin
        $display("Starting MIC-1 simulation...");
        $dumpfile("mic1_icebreaker_tb.vcd");
        $dumpvars(0, mic1_icebreaker_tb);
    end


    logic led_r;
    logic led_g;

    logic ser_tx;
    logic  ser_rx = 0;
    
    logic button_run;
    logic button_step;
    logic button_stop;
    
    logic [4:0] leds;

    logic clk = 0;
    always #1 clk = !clk;
    
    logic resetn;

    initial begin
        resetn = 0;
        button_run = 0;
        button_step = 0;
        button_stop = 0;
        
        #10;
        resetn = 1;
        button_step = 1;
    
        #4000;
        resetn = 0;
        #10;
        resetn = 1;
        #4500;

        $display("Memory contents:");
        for (int i=0; i<131; i++) begin
            $display("mem[%h] = %h", i, mic1_icebreaker.mic1_soc.main_memory.test_memory[i]);
        end
        
        $display("Completed simulation.");
        $finish;
    end
    
    mic1_icebreaker mic1_icebreaker (
        .CLK          (clk   ),

        .TX           (ser_tx   ),
	    .RX           (ser_rx   ),

	    .BTN1         (button_run ),
	    .BTN2         (button_step),
	    .BTN3         (button_stop),

        .LED1         (leds[0] ),
	    .LED2         (leds[1] ),
	    .LED3         (leds[2] ),
	    .LED4         (leds[3] ),
	    .LED5         (leds[4] ),

	    .LEDR_N       (led_r   ),
	    .LEDG_N       (led_g   ),
	    .BTN_N        (resetn  )
    );

endmodule
