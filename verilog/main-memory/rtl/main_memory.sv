`timescale 1 ns / 1 ps

module main_memory (
    input clk, wen, ren,    
    input [8:0] waddr, raddr,
    input [8:0] wdata,
    
    output reg [8:0] rdata
    );

reg [8:0] mem [0:16000];
always @(posedge clk)
begin
     if (wen)
        mem[waddr] <= wdata;
     if (ren)
        rdata <= mem[raddr];
end
endmodule