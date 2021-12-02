`timescale 1 ns / 1 ps

module tb_button_fsm ();

// inputs
logic tb_clk = 0;
logic tb_resetn = 0;
logic [4:0] tb_button;

// outputs
logic [5:0] tb_led;

// set clock
always #1ns tb_clk = ~tb_clk;

// link parameters
button_fsm button_fsm(.clk(tb_clk),
                      .resetn(tb_resetn),
                      .button(tb_button),
                      .led(tb_led));

initial
begin

    #10ns
    tb_button[0] = 1;
    #10ns
    tb_button[0] = 0;
end
endmodule    