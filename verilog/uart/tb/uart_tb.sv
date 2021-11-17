module uart_tb();

logic RX;
logic TX;
logic clk = 1;
logic baud;

uart_top DUT(   .uart_RX(RX),
                .uart_TX(TX),
                .clk(clk),
                .baudrate(baud));
            

                
always begin
    #10ns
    clk<=~clk;
end        
endmodule