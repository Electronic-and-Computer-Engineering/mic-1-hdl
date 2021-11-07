module uart_tb();

logic RX;
logic TX;

uart_top DUT(   .RX(RX),
                .TX(TX));
            
            
        
endmodule