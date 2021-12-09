`timescale 1 ns / 1 ps

module Button_Debouncer(input logic clk,
	input logic pushed_button,	// asynchronous, active low
	
	output logic button_state);	// 1 until button is pushed - active high

reg button_sync_0;	always @(posedge clk) button_sync_0 <= ~pushed_button;	// invert button -> sync_0 is active high
reg button_sync_1;	always @(posedge clk) button_sync_1 <= button_sync_0;

reg [3:0] button_cnt;

wire button_idle = (button_state == button_sync_1);
wire button_cnt_max = &button_cnt;

always @(posedge clk)
	if(button_idle) begin
		button_cnt <= 0;
		button_state <= 0;
	end
	else begin
		button_cnt <= button_cnt + 4'd1;
		if(button_cnt_max) button_state <= 1;
		else button_state <= 0;
	end
endmodule