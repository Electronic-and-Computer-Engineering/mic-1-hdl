`timescale 1 ns / 1 ps

module main_memory (
    input clk, wen, ren,    
    input [8:0] waddr, raddr, wdata,
    
    output reg [8:0] rdata
    );

reg [8:0] test_memory [0:10];
always @(posedge clk) begin
    $readmemh("init_memory_test.mem", test_memory);
       
    end
endmodule