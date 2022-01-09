`timescale 1 ns / 1 ps

module tb_button_fsm ();

// inputs
logic tb_clk = 0;
logic tb_resetn = 0;
logic [3:0] tb_button = 0;

// outputs
logic tb_led_run_status;
logic tb_idle;
logic [3:0] tb_led_run_step;

// set clock
always #83ns tb_clk = ~tb_clk;   //6MHz

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
    #42ms
    tb_resetn = 0;
    
    // RUN
    #100ns
    tb_button[0] = 1;
    #42ms
    tb_button[0] = 0;
    
    #400ns
    tb_button[3] = 1;
    #42ms
    tb_button[3] = 0;
    
    #1ms
    tb_button[2] = 1;
    #42ms
    tb_button[2] = 0;
    
    #50ms
    tb_button[2] = 1;
    #300ms
    tb_button[2] = 0;
    
    #50ms
    tb_button[2] = 1;
    #42ms
    tb_button[2] = 0;
    
    #1ms
    tb_button[0] = 1;
    #42ms
    tb_button[0] = 0;
    
    #1ms
    tb_button[3] = 1;
    #42ms
    tb_button[3] = 0;
end
endmodule    