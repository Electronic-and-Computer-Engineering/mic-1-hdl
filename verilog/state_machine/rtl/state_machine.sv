`timescale 1 ns / 1 ps

module state_machine (  input logic clk, reset_, recv,
                        input logic [7:0] uart_rx,
    
                        output logic send,
                        output logic [7:0] uart_tx);
 
localparam IDLE = 0;
localparam UART_RX =  1;
localparam UART_TX =  2;

localparam CMD_RECV_DATA = 69;
localparam CMD_SEND_DATA = 42;

localparam SERIAL_NUMBER = 111;

reg [1:0] current_state, next_state;

always_comb begin
    next_state = current_state;
    send = 0;   // reset send flag

    case(current_state)
        IDLE: begin
            if (recv && (uart_rx == CMD_RECV_DATA)) begin
                next_state = UART_RX; // jump into UART receive state
            end
            
            if (recv && (uart_rx == CMD_SEND_DATA)) begin
                next_state = UART_TX; // jump into UART send state            
            end
         end
    
         UART_RX: begin
            if (recv) begin
                $display("received data: %d", uart_rx);
                next_state = IDLE; // jump into idle state
             end
         end
        
         UART_TX: begin
            send = 1;
            uart_tx = SERIAL_NUMBER;
            next_state = IDLE; // jump into idle state
         end
         
         default: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    current_state <= next_state;

    if(!reset_) begin
        current_state <= IDLE;
    end
end

`ifndef SYNTHESIS
    reg [255:0] cur_state_text;

    always_comb begin
        case(current_state)
            IDLE:       cur_state_text  = "IDLE";
            UART_RX:    cur_state_text  = "UART_RX";
            UART_TX:    cur_state_text  = "UART_TX";
        endcase
    end
`endif

endmodule
