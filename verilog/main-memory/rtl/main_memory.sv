`timescale 1 ns / 1 ps

module main_memory (
    input logic clk, wen_A, ren_A, ren_B,
    input logic [31:0] addr_A, addr_B, wdata_A,

    output logic [31:0] rdata_A,
    output logic [7:0] rdata_B
    );

    reg [31:0] test_memory [512];

    initial $readmemh("program.mem", test_memory, 0, 39);

    // PORT A - Read/Write
    always @(negedge clk) begin
        if (wen_A)
            test_memory[addr_A] <= wdata_A;
        if (ren_A)
            rdata_A <= test_memory[addr_A];
    end

    reg [31:0] rdata_B_tmp;

    // PORT B - Read
    always @(negedge clk) begin
        if (ren_B)
            rdata_B_tmp <= test_memory[addr_B >> 2];
    end
    
    // Split up into bytes
    always_comb begin
        case (addr_B & 2'b11)
        2'b00:
            rdata_B = (rdata_B_tmp>>0 ) & 8'hFF;
        2'b01:
            rdata_B = (rdata_B_tmp>>8 ) & 8'hFF;
        2'b10:
            rdata_B = (rdata_B_tmp>>16) & 8'hFF;
        2'b11:
            rdata_B = (rdata_B_tmp>>24) & 8'hFF;
        default:
            rdata_B = 'X;
        endcase
    end
    
endmodule
