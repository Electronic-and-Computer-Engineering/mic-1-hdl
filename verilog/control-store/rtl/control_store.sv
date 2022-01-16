`timescale 1 ns / 1 ps

module control_store #(
    parameter INIT_F=""
    )(
    input clk, ren,

    input wire [8:0] waddr, raddr,
    output reg [35:0] rdata = 0
    );

    reg [35:0] mem [0:511];

    initial begin
        if (INIT_F != 0) begin
            $display("Loading microprogram %s into control_store.", INIT_F);
            $readmemh(INIT_F, mem);
        end
    end

    always_ff @(posedge clk) begin
         if (ren)
            //$display("MPC= %h", raddr);
            rdata <= mem[raddr];
    end
endmodule
