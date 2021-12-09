//`timescale 1 ns / 1 ps

//module Button_Debouncer(input logic clk,
//	                    input logic pushed_button,	// asynchronous, active low
	
//	                    output logic button_pressed);	// 1 if button really pressed

//logic button_sync_0;	always @(posedge clk) button_sync_0 <= ~pushed_button;	// invert button -> sync_0 is active high
//logic button_sync_1;	always @(posedge clk) button_sync_1 <= button_sync_0;

//logic button_state = 0;
//logic [3:0] button_cnt;

//wire button_idle = (button_state == button_sync_1);
//wire button_cnt_max = &button_cnt;

//always @(posedge clk)
//	if(button_idle) begin
//		button_cnt <= 0;
//		//button_state <= 0;
//	end
//	else begin
//		button_cnt <= button_cnt + 4'b1;
//		//if(button_cnt_max) button_state <= 1;
//		if(button_cnt_max) button_state <= ~button_state;
//		//else button_state <= 0;
//	end
	
//assign button_pressed = ~button_idle & button_cnt_max & ~button_state;
//endmodule