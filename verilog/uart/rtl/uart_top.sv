module uart_top(
    //INPUTS
    input logic clk,
    input logic uart_RX,
    input logic button_rst,
    //OUTPUTS
    output logic uart_TX);
    
    localparam CNT_WIDTH=24;        //Depending on baud rate and clock
    localparam CNT_INC=24'd30000;   //Depending on baud rate and clock
    logic baud, sample;
    uart_baud #(
                .CNT_WIDTH(CNT_WIDTH),
                .CNT_INC(CNT_INC)
                )baud_gen(
                .clk(clk),
                .rst(button_rst),
                .baud(baud));

    uart_rx RX();
    
    uart_tx TX();
    

endmodule