module uart_tb();

logic RX;
logic TX;
logic clk = 1;
logic rst = 1;
logic baud;

uart_top DUT(   .uart_RX(RX),
                .uart_TX(TX),
                .clk(clk),
                .button_rst(rst));
            
logic[23:0] cnt;

always_comb begin
    baud<=DUT.baud_gen.baud;
    cnt<=DUT.baud_gen.cnt;
end       
         
always begin
    #10ns
    clk<=~clk;
end        

initial begin
   RX=1;
   #20ns
   rst =0;
   #20ns
   rst =1;  

end
endmodule