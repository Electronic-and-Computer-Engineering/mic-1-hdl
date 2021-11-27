`timescale 1 ns / 1 ps

module mic1_soc (
    input clk,
    input resetn,

    input ser_tx,
    input ser_rx,

    output [31:0] out
);

    wire mem_read;
    wire mem_write;
    wire mem_fetch;

     // Main memory
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [31:0] mem_rdata;
    
    wire [31:0] mem_addr_instr;
    wire [7:0]  mem_rd_instr;

    // Microprogram memory
    wire [8:0]  mp_mem_addr;
    wire [35:0] mp_mem_wdata;
    wire [35:0] mp_mem_rdata;

    control_store control_store (
        .clk (clk),
        .wen (1'b0), 
        .ren (resetn),

        .waddr (mp_mem_addr),
        .raddr (mp_mem_addr),
        .wdata (mp_mem_wdata),
        .rdata (mp_mem_rdata)
    );
    
    main_memory main_memory (
        .clk (clk),
        .wen_A (mem_write && resetn), 
        .ren_A (mem_read && resetn),
        .ren_B (mem_fetch && resetn),

        .addr_A (mem_addr),
        .addr_B (mem_addr_instr),
        .wdata_A (mem_wdata),
        .rdata_A (mem_rdata),
        .rdata_B (mem_rd_instr)
    );

    mic1 mic1 (
        .clk          (clk   ),
        .resetn       (resetn),

        .mem_read     (mem_read   ),
        .mem_write    (mem_write  ),
        .mem_addr     (mem_addr   ),
        .mem_wdata    (mem_wdata  ),
        .mem_rdata    (mem_rdata  ),
        
        .mem_fetch       (mem_fetch   ),
        .mem_addr_instr  (mem_addr_instr),
        .mem_rd_instr    (mem_rd_instr  ),

        .mp_mem_addr     (mp_mem_addr   ),
        .mp_mem_wdata    (mp_mem_wdata  ),
        .mp_mem_rdata    (mp_mem_rdata  ),

        .out(out)
    );

endmodule
