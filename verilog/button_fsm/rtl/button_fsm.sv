`timescale 1 ns / 1 ps

// 0/Button_Up    -> RUN
// 1/Button_Left  -> 
// 2/Button_Right -> STEP_FW
// 3/Button_Down  -> STOP
// 4/Button_Center-> RESET_SYNC

// led_0 -> RUN
// led_1 -> STOP
// led_2 -> STATE_1
// led_3 -> STATE_2
// led_4 -> STATE_3
// led_5 -> STATE_4

module state_machine (  input logic clk, reset_,
                        input logic [5:0] button,
    
                        output logic [4:0] led);
 
localparam IDLE = 0;
localparam RUN =  1;
localparam STOP =  2;

reg [1:0] current_state, next_state;
reg [4:0] db_button = 0;

Button_Debouncer (.clk(clk), .pushed_button[0](button[0]),.button_state(db_button[0]));
Button_Debouncer (.clk(clk), .pushed_button[1](button[1]),.button_state(db_button[1]));
Button_Debouncer (.clk(clk), .pushed_button[2](button[2]),.button_state(db_button[2]));
Button_Debouncer (.clk(clk), .pushed_button[3](button[3]),.button_state(db_button[3]));
Button_Debouncer (.clk(clk), .pushed_button[4](button[4]),.button_state(db_button[4]));

always_comb begin
    next_state = current_state;
   
	// BUTTON DETECTION
	if(db_button[4]) reset_ = 1;	// RESET
	else reset_ = 0;

	if(db_button[3]) current_state = IDLE;	// STOP


    case(current_state)
        IDLE: begin
		led = b'10000;
    	end
        
	RUN: begin
		led = b'01000;
        end
        
        STOP: begin
		led = b'01010;
        end
         
        default: begin
		led = 00000;
    endcase
end

always @(posedge clk) begin
    current_state <= next_state;

    if(!reset_) begin
        current_state <= IDLE;
    end
end

`ifndef SYNTHESIS
    reg [255:0] cur_state_text;

    always_comb begin
        case(current_state)
            IDLE:       cur_state_text  = "IDLE";
        endcase
    end
`endif

endmodule
