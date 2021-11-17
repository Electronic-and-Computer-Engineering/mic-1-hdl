module uart_top(
    //INPUTS
    input logic clk,
    input logic uart_RX,
    input logic button_rst,
    //OUTPUTS
    output logic uart_TX,
    output logic baudrate);
    
    localparam CLOCK=100000000;        //Depending on baud rate and clock
    localparam BAUDRATE=9600;   //Depending on baud rate and clock
    logic baud;
    logic sample;
    uart_baud #(
                .CLOCK(CLOCK),
                .BAUDRATE(BAUDRATE)
                )baud_gen(
                .clk(clk),
                .rst(button_rst),
                .baud(baud));

    uart_rx RX();
    
    uart_tx TX();

endmodule