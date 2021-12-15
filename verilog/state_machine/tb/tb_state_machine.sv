`timescale 1 ns / 1 ps

module tb_state_machine ();

// inputs
logic tb_clk = 0;
logic tb_reset_ = 0;
logic tb_recv = 0;
logic [7:0] tb_uart_rx;

// outputs
logic tb_send;
logic [7:0] tb_uart_tx;

// set clock
always #1ns tb_clk = ~tb_clk;

// link parameters
state_machine state_machine(.clk(tb_clk),
                            .reset_(tb_reset_),
                            .recv(tb_recv),
                            .uart_rx(tb_uart_rx),
                            .send(tb_send),
                            .uart_tx(tb_uart_tx));

initial
begin

    // testing state changing
    #10ns
    tb_reset_ = 1;	// start state machine
    
    // testing TX
    #10ns
    tb_uart_rx = 42;
    #1ns
    
    // trigger state changing
    tb_recv = 1;
    #2ns
    tb_recv = 0;
    // UART_TX
        
    // IDLE
    #10ns
    
    // testing RX
    tb_uart_rx = 69;
    #10ns
    
    // trigger state changing
    tb_recv = 1;
    #2ns
    tb_recv = 0;
    
    #5ns
    
    // UART_RX
    
    // set data which is being received
    tb_uart_rx = 222;    
    #10ns
    
    // trigger data reading
    tb_recv = 1;
    #2ns
    tb_recv = 0;
        
    // DISPLAY
    
    // IDLE
end
endmodule    
