module uart_top(
    //INPUTS
    input logic clk,
    input logic uart_RX,
    input logic button_rst,
    //OUTPUTS
    output logic uart_TX,
    
    output logic [7:0]seg,
    output logic[3:0]digit);
    
    localparam CNT_INC = 24'd1611;   //Depending on baud rate and clock
    localparam CNT_WIDTH = 24;   //Depending on baud rate and clock
    logic baud;

    uart_baud #(.CNT_INC(CNT_INC),
                .CNT_WIDTH(CNT_WIDTH)
                )baud_gen(
                .clk(clk),
                .rst(button_rst), //!
                .baud(baud));
    
    logic rx_done;
    logic [7:0] received;
    uart_rx RX(
                .clk(clk),
                .baud(baud),
                .rst(button_rst),  //!
                .data_in(uart_RX),
                .data_out(received),
                .rx_done);

    logic tx_start, tx_busy, tx_done;
    uart_tx TX(
                .clk(clk),
                .baud(baud),
                .rst(button_rst),  //!
                .tx_start,
                .data_in(received),
                .data_out(uart_TX),
                .tx_busy,
                .tx_done);
                                
    // buffer RX done signal for TX start
    always_ff @(posedge clk) begin
        if (rx_done) tx_start <= 1;
        if (baud) tx_start <= 0;
    end

    //************* OUTPUT RECEIVED DATA *************
    logic[3:0] digit_0, digit_1,digit_2 = 0, digit_3 = 0;        
    assign {digit_0, digit_1} = received;
    
    siebensegment_display_logik display(
        .digit_0,
        .digit_1,
        .digit_2,
        .digit_3,
        .s_rst(button_rst),
        .clk,
        .seg,
        .digit);
endmodule