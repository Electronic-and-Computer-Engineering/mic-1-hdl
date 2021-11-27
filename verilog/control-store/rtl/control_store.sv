`timescale 1 ns / 1 ps

module control_store (
    input clk, wen, ren,

    input wire [8:0] waddr, raddr,
    input wire [35:0] wdata,
    output reg [35:0] rdata = 0
    );

    reg [35:0] mem [512];

    initial begin
        $display("Loading microprogram into control_store.");
        $readmemb("microcode.mem", mem, 0, 15);
    end

    always @(posedge clk) begin
         if (wen)
            mem[waddr] <= wdata;
         if (ren)
            rdata <= mem[raddr];
    end
endmodule
