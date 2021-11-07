module uart_baud #(
    parameter CNT_WIDTH = 16,       //Depending on baud rate and clock
    parameter CNT_INC = 16'd30000)  //Depending on baud rate and clock
    (//INPUTS
    input logic clk,
    input logic rst,
    //OUTPUTS   
    output logic baud);
    
    logic [CNT_WIDTH:0]cnt;
        
    always_ff @(posedge clk)
    begin
        {baud,cnt} <= cnt + {1'b0, CNT_INC};
        
        if (rst) begin
            baud <= 1'b0;
            cnt <= {CNT_WIDTH+1{1'b0}};
        end          
    end
endmodule