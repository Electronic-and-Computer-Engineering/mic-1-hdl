`timescale 1 ns / 1 ps

module mic1_basys3_tb;

    parameter CLOCK_PERIOD_NS = 10; //100MHz
    parameter BIT_PERIOD_NS   = 104167;

    initial begin
        $display("Starting MIC-1 simulation...");
//        $dumpfile("mic1_basys3_tb.vcd");
//        $dumpvars(0, mic1_basys3_tb);
    end

    logic led_r;
    logic led_g;

    logic ser_tx;
    logic ser_rx;
    
    logic button_run;
    logic button_step;
    logic button_stop;
    
    logic [4:0] leds;

    logic clk = 0;
    always #(CLOCK_PERIOD_NS/2) clk = !clk; // 6 Mhz clock
    
    logic resetn;

    initial begin
        resetn = 1;
        button_run = 0;
        button_step = 0;
        button_stop = 0;
        ser_rx = 1;
        
        #830;
        resetn = 0;
        button_run = 1;
    
        #(BIT_PERIOD_NS*10); // Wait for space
        #(BIT_PERIOD_NS*10);
        send_byte("4");
        #BIT_PERIOD_NS;
        #BIT_PERIOD_NS;
        send_byte("2");
        #BIT_PERIOD_NS;
        #BIT_PERIOD_NS;
        send_byte('h0A);
        #BIT_PERIOD_NS;
        #BIT_PERIOD_NS;
        #BIT_PERIOD_NS;
        #BIT_PERIOD_NS;        
        #BIT_PERIOD_NS;
        send_byte("1");
        #BIT_PERIOD_NS;
        #BIT_PERIOD_NS;
        send_byte("6");
        #BIT_PERIOD_NS;
        #BIT_PERIOD_NS;
        send_byte('h0A);
        #BIT_PERIOD_NS;
        #BIT_PERIOD_NS;
        #BIT_PERIOD_NS;
        #BIT_PERIOD_NS;
        #BIT_PERIOD_NS;
        
        #25000000;

        /*$display("Memory contents:");
        for (int i=0; i<131; i++) begin
            $display("mem[%h] = %h", i, mic1_icebreaker.mic1_soc.main_memory.test_memory[i]);
        end*/
        
        $display("Completed simulation.");
        $finish;
    end
    
    mic1_basys3 mic1_basys3 (
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

	    .LEDR       (led_r   ),
	    .LEDG       (led_g   ),
	    .BTN        (resetn  )
    );
    
    logic [7:0] recv_byte = 0;
    
    always @(negedge ser_tx) begin
            read_byte;
    end
    
    task read_byte;
        #(BIT_PERIOD_NS/2); // Wait half baud
        if((ser_tx == 0)) begin
        
        #BIT_PERIOD_NS;
        
        // Read data LSB first
        for (int j=0; j<8; j++) begin
            recv_byte[j] = ser_tx;
            #BIT_PERIOD_NS;
        end
        
        if((ser_tx == 1)) begin
        $display("Received data from host: %h %c", recv_byte, recv_byte);
        end
        end
    endtask
    
    task send_byte (input [7:0] data);
        $display("Sending data to host: %h %c", data, data);
        
        // Start bit
        ser_rx = 0;
        #BIT_PERIOD_NS;
        
        // Send data LSB first
        for (int i=0; i<8; i++) begin
            ser_rx = data[i];
            #BIT_PERIOD_NS;
        end

        // Stop bit
        ser_rx = 1;
        #BIT_PERIOD_NS;
    endtask

endmodule
