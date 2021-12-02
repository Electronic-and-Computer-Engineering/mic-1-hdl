`timescale 1 ns / 1 ps

module tb_state_machine ();

// inputs
logic tb_clk = 0;
logic tb_reset_ = 0;
logic [5:0] tb_button;

// outputs
logic [4:0] tb_led;

// set clock
always #1ns tb_clk = ~tb_clk;

// link parameters
state_machine state_machine(.clk(tb_clk),
                            .reset_(tb_reset_),
				.button(tb_button);
			.led(tb_led));

initial
begin

    // testing state changing
    #10ns
end
endmodule    