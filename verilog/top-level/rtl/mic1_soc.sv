`timescale 1 ns / 1 ps

module mic1_soc (
    input clk,
    input resetn,

    input ser_tx,
    input ser_rx,

    output [31:0] out
);

     // Main memory
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    reg  [31:0] mem_rdata;

    // Microprogram memory
    wire [8:0]  mp_mem_addr;
    wire [35:0] mp_mem_wdata;
    reg  [35:0] mp_mem_rdata;


    mic1 mic1 (
        .clk          (clk   ),
        .resetn       (resetn),

        .mem_addr     (mem_addr   ),
        .mem_wdata    (mem_wdata  ),
        .mem_rdata    (mem_rdata  ),

        .mp_mem_addr     (mp_mem_addr   ),
        .mp_mem_wdata    (mp_mem_wdata  ),
        .mp_mem_rdata    (mp_mem_rdata  ),

        .out(out)
    );

endmodule
