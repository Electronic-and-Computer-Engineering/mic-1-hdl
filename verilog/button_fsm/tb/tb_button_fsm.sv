`timescale 1 ns / 1 ps

module tb_button_fsm ();

// inputs
logic tb_clk = 0;
logic tb_resetn = 0;
logic [4:0] tb_button;

// outputs
logic tb_led_start_stop;
logic tb_led_step;
logic [3:0] tb_led_run;

// set clock
always #1ns tb_clk = ~tb_clk;

// link parameters
button_fsm button_fsm(.clk(tb_clk),
                      .resetn(tb_resetn),
                      .button(tb_button),
                      .led_start_stop(tb_led_start_stop),
                      .led_step(tb_led_step),
                      .led_run(tb_led_run));

initial
begin
    #10ns
    tb_resetn = 1;
    #10ns
    tb_button[0] = 1;
    #100ns
    tb_button[0] = 0;
    
    #100ns
    tb_button[2] = 1;
    #100ns
    tb_button[2] = 0;
end
endmodule    