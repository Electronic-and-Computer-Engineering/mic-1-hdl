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

module button_fsm (input logic clk, resetn,
                   input logic [4:0] button,

                   output logic [5:0] led);
 
localparam IDLE = 0;
localparam RUN =  1;
localparam STEP = 2;

logic [1:0] current_state, next_state;
logic [4:0] db_button;

Button_Debouncer Button_Debouncer_0 (.clk(clk), .pushed_button(button[0]),.button_state(db_button[0]));
Button_Debouncer Button_Debouncer_1 (.clk(clk), .pushed_button(button[1]),.button_state(db_button[1]));
Button_Debouncer Button_Debouncer_2 (.clk(clk), .pushed_button(button[2]),.button_state(db_button[2]));
Button_Debouncer Button_Debouncer_3 (.clk(clk), .pushed_button(button[3]),.button_state(db_button[3]));
Button_Debouncer Button_Debouncer_4 (.clk(clk), .pushed_button(button[4]),.button_state(db_button[4]));

always_comb begin
    next_state = current_state;
   
	// BUTTON DETECTION
	if(db_button[0]) next_state = RUN;	// STOP
	
	//if(db_button[2]) next_state = ;	// STOP
	//if(db_button[3]) next_state = IDLE;	// STOP
	//if(db_button[4]) next_state = ;	// STOP


    case(current_state)
        IDLE: begin
		  led = 'b010000;
    	end
        
        RUN: begin
		  led = 'b000001;
		  if(db_button[1]) next_state = IDLE;	// STOP
        end
                 
        STEP: begin
            next_state = IDLE;
        end
                 
        default: begin
		  led = 'b011111;
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
            IDLE:       cur_state_text  = "IDLE";
        endcase
    end
`endif

endmodule
