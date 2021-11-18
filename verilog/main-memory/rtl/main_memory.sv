`timescale 1 ns / 1 ps

module main_memory (
    input logic clk, wen_A, ren_A, ren_B,
    input logic [8:0] addr_A, addr_B, wdata_A,

    output reg [8:0] rdata_A,
	output reg [8:0] rdata_B);

   reg [8:0] test_memory [10];

initial $readmemh("init_memory_test.mem", test_memory);


// PORT A - Read/Write
always @(posedge clk) begin
    if (wen_A)
        test_memory[addr_A] <= wdata_A;
    if (ren_A)
        rdata_A <= test_memory[addr_A];
end

// PORT B - Read
always @(posedge clk) begin
    if (ren_B)
        rdata_B <= test_memory[addr_B];
end
endmodule
