`timescale 1 ns / 1 ps

`include "verilog/top-level/rtl/defines_add.sv"

module mic1_icebreaker (
	input CLK,

    // On-board
	input  RX,
	output TX,

    input  BTN_N, // Resetn
	output LEDR_N,
	output LEDG_N,
	
	// PMOD 2
	input BTN1, // Start button
	input BTN2, // Step button
	input BTN3, // Stop button
	
	output LED1, // LED idle
	output LED2, // LED run
	output LED3,
	output LED4,
	output LED5
);
    logic clk;
    
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

    // Reset signal
    logic resetn;
    assign resetn = BTN_N;

    // BTN1
    debouncer #(.MAX_COUNT(511)) debouncer1 (
        .resetn (resetn),
        .clk(clk),
        .in(BTN1),
        .out(button_run)
    );
    
    // BTN2
    debouncer #(.MAX_COUNT(511)) debouncer2 (
        .resetn (resetn),
        .clk(clk),
        .in(BTN2),
        .out(button_step)
    );
    
    // BTN3
    debouncer #(.MAX_COUNT(511)) debouncer3 (
        .resetn (resetn),
        .clk(clk),
        .in(BTN3),
        .out(button_stop)
    );

    mic1_soc #(
        .STACKPOINTER_ADDRESS(`STACKPOINTER_ADDRESS),
        .LOCALVARIABLEFRAME_ADDRESS(`LOCALVARIABLEFRAME_ADDRESS),
        .CONSTANTPOOL_ADDRESS(`CONSTANTPOOL_ADDRESS),
        .MIC1_PROGRAM(`MIC1_PROGRAM),
        .MIC1_MICROCODE(`MIC1_MICROCODE),
        .MEMORY_SIZE(`MEMORY_SIZE)
    ) mic1_soc (
        .clk          (clk     ),
		.resetn       (resetn  ),
		.run          (mic1_run),
		
		.ser_tx       (ser_tx  ),
		.ser_rx       (ser_rx  ),
		
		.out (out)
    );
    
    // Control signals
    logic mic1_run;
    logic led_idle;
    logic led_run;
    
    /*always @(posedge clk) begin
        if(!resetn) begin
            mic1_run <= 1;
            led_run <= 1;
        end
    end*/
    
    logic button_run;
    logic button_step;
    logic button_stop;
    
    assign led_idle = !led_run;

    // Begin of State Machine
    //enum {IDLE, RUN, STEP} current_state, next_state;

    localparam IDLE = 0;
    localparam RUN  = 1;
    localparam STEP = 2;
    
    logic [1:0] current_state, next_state;

    always_comb begin
        next_state = current_state;
        led_run = 0;
        mic1_run = 0;
        
        case (current_state)
            IDLE: begin
		        if(button_run)  next_state = RUN;
		        if(button_step) next_state = STEP;		  
        	end
            
            RUN: begin
		        led_run = 1;
		        mic1_run = 1;		
		          
		        if(button_stop) next_state = IDLE;
            end

            STEP: begin
                led_run = 1;
                mic1_run = 1;

                next_state = IDLE;
            end
		    
		    default: begin
		        next_state = IDLE;

		    end
        endcase
    end

    always @(posedge clk) begin
        current_state <= next_state;

        if(!resetn) begin
            current_state <= IDLE;
        end
    end

    `ifndef SYNTHESIS
    reg [255:0] cur_state_text;

    always_comb begin
        case(current_state)
            IDLE:   cur_state_text  = "IDLE";
            RUN:    cur_state_text  = "RUN";
            STEP:   cur_state_text  = "STEP";
        endcase
    end
    `endif

    logic [31:0] out;

    assign LED1 = led_idle;
    assign LED2 = led_run;
    assign LED3 = out[18];
    assign LED4 = out[19];
    assign LED5 = out[20];

    assign LEDG_N = 1;
    assign LEDR_N = 1;

    assign TX = 1;

endmodule
