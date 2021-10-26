`timescale 1 ns / 1 ps

module main_memory (
    input clk, wen, ren,

    input [8:0] waddr, raddr,
    input [31:0] wdata,
    output reg [31:0] rdata
    );

    reg [35:0] mem [0:511];
    always @(posedge clk) begin
         if (wen)
            mem[waddr] <= wdata;
         if (ren)
            rdata <= mem[raddr]

endmodule