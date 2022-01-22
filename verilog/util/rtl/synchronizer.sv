module synchronizer #(
    parameter FF_COUNT = 3
    )(
    input   clk,
    input   resetn,
    input   in,
    
    output logic out
);

    reg [FF_COUNT-1:0] pipe;
    reg [$clog2(FF_COUNT):0] i;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            pipe <= 0;
        end else begin

            pipe[0] <= in;
            for (i=0; i<FF_COUNT-1; i++) begin : loopName
                pipe[i+1] <= pipe[i];
            end
            out <= pipe[FF_COUNT-1];
        end
    end

endmodule
