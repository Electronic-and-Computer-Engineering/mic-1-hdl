`timescale 1 ns / 1 ps

module control_store (
    input clk, wen, ren,

    input [8:0] waddr, raddr,
    input [35:0] wdata,
    output reg [35:0] rdata
    );

    reg [35:0] mem [0:511];

    initial begin
        $display("Loading memory file into bram_basic.");
        $readmemh("some_values.mem", mem);

        for (int i = 0; i <= 511; i++) begin
            $display ("%h", mem[i]);
        end
    end

    always @(posedge clk) begin
         if (wen)
            mem[waddr] <= wdata;
         if (ren)
            rdata <= mem[raddr];
    end
endmodule