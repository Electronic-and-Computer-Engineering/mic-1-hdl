// Project F Library - UART 8N1 Transmitter
// (C)2021 Will Green, Open source hardware released under the MIT License
// Learn more at https://projectf.io

`default_nettype none
`timescale 1ns / 1ps

module uart_tx (
    input  wire logic clk,
    input  wire logic rst,
    input  wire logic stb_baud,       // baud strobe
    input  wire logic tx_start,       // start transmission
    input  wire logic [7:0] data_in,  // data to transmit
    output      logic data_out,       // serial data out
    output      logic tx_busy,        // busy with transmission
    output      logic tx_next         // ready for next data in
    );

    //enum {IDLE, START, DATA, STOP} state, state_next;
    
    localparam IDLE  = 0;
    localparam START = 1;
    localparam DATA  = 2;
    localparam STOP  = 3;
    localparam WAITING_FOR_BAUD  = 4;
    
    logic [2:0] state, state_next;
    
    
    logic [2:0] data_idx, data_idx_next;  // eight data bits: 0-7
    logic [7:0] data_in_buffered;
    localparam LAST_BIT = 3'd7;

    always_ff @(posedge clk) begin
        if (tx_start && state == IDLE) begin
            data_in_buffered <= data_in;
        end

        state <= state_next;
        
        if (stb_baud && state == DATA) data_idx <= data_idx_next;

        if (rst) begin
            state <= IDLE;
            data_idx <= 0;
        end
    end

    always_comb begin
        data_out = 1'b1;
        state_next = state;
        data_idx_next = 0;

        case(state)
            IDLE: begin
                if (tx_start) begin
                    state_next = WAITING_FOR_BAUD;
                end
            end
            WAITING_FOR_BAUD: begin
                if (stb_baud) begin
                    state_next = START;
                end
            end
            

            START: begin
                data_out = 0;
                if (stb_baud) state_next = DATA;
            end
            DATA: begin
                data_out = data_in_buffered[data_idx];
                data_idx_next = data_idx + 1;
                
                if (data_idx == LAST_BIT) begin
                    if (stb_baud) state_next = STOP;
                end else begin
                    state_next = DATA;
                end
            end
            
            STOP: begin
                if (stb_baud) state_next = IDLE;
            end
        endcase
    end

    always_comb begin
        tx_busy = (state != IDLE);
        tx_next = (state == STOP);  // safe to update data_in
    end
endmodule
