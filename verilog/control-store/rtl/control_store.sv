`timescale 1 ns / 1 ps

module control_store (
    input clk, wen, ren,

    input [8:0] waddr, raddr,
    input [35:0] wdata,
    output reg [35:0] rdata
    );

    reg [35:0] mem [0:511];
    
    initial begin
        if ("some_values.mem" != 0) begin
            $display("Loading memory file '%s' into bram_basic.", "some_values.mem");
            $readmemh("some_values.mem", mem);
        end
    end
    
    always @(posedge clk) begin
         if (wen)
            mem[waddr] <= wdata;
         if (ren)
            rdata <= mem[raddr];
    end
endmodule