`timescale 1 ns / 1 ps

module tb_button_fsm ();

// inputs
logic tb_clk = 0;
logic tb_resetn = 0;
logic [3:0] tb_button = 0;

// outputs
logic tb_led_run_status;
logic tb_idle = 0;
logic [3:0] tb_led_run_step;

// set clock
always #1ns tb_clk = ~tb_clk;

// link parameters
button_fsm button_fsm(.clk(tb_clk),
                      .resetn(tb_resetn),
                      .button(tb_button),
                      .led_run_status(tb_led_run_status),
                      .led_idle(tb_idle),
                      .led_run_step(tb_led_run_step));

initial
begin
    #10ns
    tb_resetn = 1;
    #40ns
    tb_resetn = 0;
    
    #10ns
    tb_button[0] = 1;
    #40ns   // 2ns for one clk cycle + 4Bit cnt -> 16 cycles = min. 32ns 
    tb_button[0] = 0;
    
    #100ns
    tb_button[2] = 1;
    #40ns
    tb_button[2] = 0;
end
endmodule    