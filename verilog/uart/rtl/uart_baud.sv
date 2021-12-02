module uart_baud #(
    parameter CNT_INC = 24'd1611,//2^24 /(100MHz/9600)
    parameter CNT_WIDTH = 24)
    (//INPUTS
    input logic clk,
    input logic rst,
    //OUTPUTS   
    output logic baud);
     
    logic [CNT_WIDTH-2:0]cnt;
        
    always_ff @(posedge clk) begin
       {baud, cnt} <= cnt + CNT_INC;
                          
        if (rst) begin
            baud <= 1'b0;
            cnt <= {CNT_WIDTH+1{1'b0}};
        end          
    end
endmodule