module uart_tb();

logic RX;
logic TX;
logic clk = 1;
logic rst = 0;
logic baud;

logic [7:0]seg;
logic[3:0]digit;

uart_top DUT(   .uart_RX(RX),
                .uart_TX(TX),
                .clk(clk),
                .button_rst(rst),
                .digit,
                .seg);
            
logic[23:0] cnt;
always_comb begin
    baud<=DUT.baud_gen.baud;
    cnt<=DUT.baud_gen.cnt;
end       
         
always begin
    #5ns
    clk<=~clk;
end        

logic data_rec[0:7] = {1'b0,1'b1,1'b1,1'b0,1'b1,1'b0,1'b1,1'b0};
logic data_send[0:7];
initial begin
   RX=1;
   #20ns
   rst =1;
   #20ns
   rst =0;  
   #100ns
   @(posedge baud) RX<=1'b0; //Startbit
   @(posedge baud) RX<=data_rec[0];
   @(posedge baud) RX<=data_rec[1];
   @(posedge baud) RX<=data_rec[2];
   @(posedge baud) RX<=data_rec[3];
   @(posedge baud) RX<=data_rec[4];
   @(posedge baud) RX<=data_rec[5];
   @(posedge baud) RX<=data_rec[6];
   @(posedge baud) RX<=data_rec[7];
   @(posedge baud) RX<=1'b1; //Stopbit
   @(posedge DUT.tx_busy);
   @(posedge baud)#100ns data_send[0] = TX;
   @(posedge baud)#100ns data_send[1] = TX;
   @(posedge baud)#100ns data_send[2] = TX;
   @(posedge baud)#100ns data_send[3] = TX;
   @(posedge baud)#100ns data_send[4] = TX;
   @(posedge baud)#100ns data_send[5] = TX;
   @(posedge baud)#100ns data_send[6] = TX;
   @(posedge baud)#100ns data_send[7] = TX;
   
   #200us
   data_rec[0:7] = {1'b1,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0,1'b1};
   @(posedge baud) RX<=1'b0; //Startbit
   @(posedge baud) RX<=data_rec[0];
   @(posedge baud) RX<=data_rec[1];
   @(posedge baud) RX<=data_rec[2];
   @(posedge baud) RX<=data_rec[3];
   @(posedge baud) RX<=data_rec[4];
   @(posedge baud) RX<=data_rec[5];
   @(posedge baud) RX<=data_rec[6];
   @(posedge baud) RX<=data_rec[7];
   @(posedge baud) RX<=1'b1; //Stopbit
   @(posedge DUT.tx_busy);
   @(posedge baud)#100ns data_send[0] = TX;
   @(posedge baud)#100ns data_send[1] = TX;
   @(posedge baud)#100ns data_send[2] = TX;
   @(posedge baud)#100ns data_send[3] = TX;
   @(posedge baud)#100ns data_send[4] = TX;
   @(posedge baud)#100ns data_send[5] = TX;
   @(posedge baud)#100ns data_send[6] = TX;
   @(posedge baud)#100ns data_send[7] = TX;

assert (data_rec == data_send) $display ("PASS"); 
end
endmodule