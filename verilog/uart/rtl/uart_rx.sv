module uart_rx(
    //INPUTS
    input logic clk,
    input logic baud,
    input logic rst,
    input logic data_in,
    //OUTPUTS
    output logic [7:0]data_out,
    output logic rx_done);
    
enum {IDLE, START, DATA, STOP} state, next_state;

logic rx_0, rx;
always_ff @(posedge clk) begin
    rx_0 <= data_in;
    rx <= rx_0;
    if(rst) begin  // default of UART is HIGH
        rx_0 <= 1;
        rx <= 1;
    end
end

logic[3:0] idx;///////2
logic[3:0] next_idx;////////2
localparam LAST_BIT = 4'd8;///////////3'd7
logic bit_done, bit_done_next;
logic sample, sample_next;
logic rx_done_next;
logic first_bit;

always_ff @(posedge clk) begin
        state <= next_state;
        idx <= next_idx;
        sample <= sample_next;
        bit_done <= bit_done_next;
        rx_done <= rx_done_next;

        if (rst) begin
            state <= IDLE;
            idx <= 0;
            sample <= 0;
        end
end

always_comb begin
    next_state = state; //remains in existing state
    next_idx = idx;
    sample_next = sample;
    bit_done_next = 0;
    rx_done_next = 0;
    
    case(state)
        IDLE: begin
            if(rx == 0) begin //start bit
               next_state = START;
               next_idx = 0;
               first_bit <= 1;
            end            
        end
        START: begin
            if(baud) begin
                next_state = DATA;
                next_idx = 0;
            end               
        end
        DATA: begin
            if(baud) begin
                sample_next = rx;
                if(idx==LAST_BIT) next_state=STOP;
                else bit_done_next = 1;
                if(first_bit) first_bit <= 0;
                else next_idx = idx+1;
            end
        end
        STOP: begin
            if(baud) begin
                next_state = IDLE;
                rx_done_next = 1;
            end
        end
    endcase
end   
 
always @(posedge clk) begin
    if (bit_done) data_out[idx-1] <= (sample) ? 1 : 0;
end
endmodule