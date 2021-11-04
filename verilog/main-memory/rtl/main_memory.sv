`timescale 1 ns / 1 ps

// A - read/write port
// B - read port

module main_memory (
    input clk, wen_A, ren_A, ren_B,   
    input [8:0] addr_A, addr_B, wdata_A,
    
    output reg [8:0] rdata_A,
	output reg [8:0] rdata_B
    );

reg [8:0] test_memory [0:10];

initial $readmemh("init_memory_test.mem", test_memory);

always @(posedge clk) begin	// read/write
    
       
    end

always @(posedge clk) begin	// read
    
       
	end
endmodule