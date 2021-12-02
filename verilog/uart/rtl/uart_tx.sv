module uart_tx(
    //INPUTS
    input logic clk,
    input logic baud,
    input logic [7:0]data_in,
    input logic rst,
    input logic tx_start,
    //OUTPUTS
    output logic data_out,
    output logic tx_busy,
    output logic tx_done);
    
    enum {IDLE, START, TRANSMIT, STOP}state, next_state;
    logic[2:0] index;
    logic[2:0] next_index; //index 0-7
    localparam LAST_BIT = 3'd7; //8 data bits: last index = 7
    
    always_ff@(posedge clk)
    begin
        if(baud) begin
            state <= next_state;
            index <= next_index;
        end    
        if(rst) begin
            state = IDLE;
            index = 0;
        end                
    end
    
    always_comb
    begin
        data_out = 1'b1;
        next_state = IDLE;
        next_index = 0;
        tx_busy = (state != IDLE);
        tx_done = (state == STOP);//next data
        
        case(state)
            IDLE: next_state = tx_start ? START : IDLE;
            START: begin
                data_out = 1'b0; 
                next_state = TRANSMIT;
            end
            TRANSMIT: begin
                data_out = data_in[index];
                next_index = index + 1;
                next_state = (index == LAST_BIT) ? STOP : TRANSMIT;
            end
            STOP: next_state = IDLE;
        endcase             
    end
endmodule