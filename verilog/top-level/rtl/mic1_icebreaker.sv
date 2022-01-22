`timescale 1 ns / 1 ps

`include "verilog/top-level/rtl/defines_add.sv"

module mic1_icebreaker (
	input CLK,

    // On-board
	input  RX,
	output TX,

    input  BTN_N, // Resetn
	output LEDR_N, // LED idle
	output LEDG_N, // LED run
	
	// PMOD 2
	input BTN1, // Start button
	input BTN2, // Step button
	input BTN3, // Stop button
	
	output LED1, 
	output LED2, 
	output LED3,
	output LED4,
	output LED5
);
    logic RX_sync;
    synchronizer synchronizer1 (
        .clk    (clk    ),
        .resetn (resetn ),
        .in     (RX     ),

        .out    (RX_sync    )
    );
    
    logic BTN_N_sync;
    synchronizer synchronizer2 (
        .clk    (clk    ),
        .resetn (1'd1 ),
        .in     (BTN_N     ),

        .out    (BTN_N_sync    )
    );
    
    logic BTN1_sync;
    synchronizer synchronizer3 (
        .clk    (clk    ),
        .resetn (resetn ),
        .in     (BTN1     ),

        .out    (BTN1_sync    )
    );
    
    logic BTN2_sync;
    synchronizer synchronizer4 (
        .clk    (clk    ),
        .resetn (resetn ),
        .in     (BTN2     ),

        .out    (BTN2_sync    )
    );
    
    logic BTN3_sync;
    synchronizer synchronizer5 (
        .clk    (clk    ),
        .resetn (resetn ),
        .in     (BTN3     ),

        .out    (BTN3_sync    )
    );
    
    `ifdef SYNTHESIS
    
    logic clk;

    // Initialize the high speed oscillator
    // Divide the oscillator down to 48Mhz/8=6 MHz
    SB_HFOSC #(.CLKHF_DIV("0b11")) clock (
        .CLKHFEN(1'b1), // Enable the output  
        .CLKHFPU(1'b1), // Power up the oscillator  
        .CLKHF(clk) // Oscillator output  
    );
    
    `else
    
    // 12 MHz to 6 Mhz
    logic clk = 0;
    always_ff @(posedge CLK) begin
        clk <= !clk;
    end

    `endif

    // Reset signal
    logic resetn;
    assign resetn = BTN_N_sync;

    // BTN1
    debouncer #(.MAX_COUNT(511)) debouncer1 (
        .resetn (resetn),
        .clk(clk),
        .in(BTN1_sync),
        .out(button_run)
    );
    
    // BTN2
    debouncer #(.MAX_COUNT(511)) debouncer2 (
        .resetn (resetn),
        .clk(clk),
        .in(BTN2_sync),
        .out(button_step)
    );
    
    edge_detection edge_detection (
        .clk(clk),
        .in(button_step),
        .out(button_step_edge)
    );
    
    // BTN3
    debouncer #(.MAX_COUNT(511)) debouncer3 (
        .resetn (resetn),
        .clk(clk),
        .in(BTN3_sync),
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
		
		.ser_tx       (TX  ),
		.ser_rx       (RX_sync  ),
		
		.out (out)
    );
    
    // Control signals
    logic mic1_run;
    logic led_idle;
    logic led_run;
    
    logic button_run;
    logic button_step;
    logic button_step_edge;
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
		        if(button_step_edge) next_state = STEP;		  
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

    assign LED1 = out[0];
    assign LED2 = out[1];
    assign LED3 = out[2];
    assign LED4 = out[31];
    assign LED5 = |out;


    assign LEDR_N = !led_idle;
    assign LEDG_N = !led_run;

endmodule
