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
always_ff @(posedge clk)
begin
    rx_0 <= data_in;
    rx <= rx_0;
    if(rst) begin  // default of UART is HIGH
        rx_0 <= 1;
        rx <= 1;
    end
end

logic [2:0] idx, next_idx;
localparam LAST_BIT = 3'd7;
logic bit_done, bit_done_next;
logic sample, sample_next;
logic rx_done_next;

always_ff @(posedge clk) 
begin
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
            if(rx == 0) //start bit
            begin
               next_state = DATA;
               idx=0;
            end            
        end
        START: begin
            if(baud)begin
            next_state = DATA;
            next_idx =0;
            end               
        end
        
        DATA: begin
            if(baud) begin
                sample_next =rx;
                bit_done_next = 1;
                next_idx = idx+1;
                if(idx==LAST_BIT) next_state=STOP;
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
    if (bit_done) data_out[idx] <= (sample) ? 1 : 0;
end
endmodule