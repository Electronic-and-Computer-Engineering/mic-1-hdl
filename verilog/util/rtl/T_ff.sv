module T_ff (
    input   resetn,
    input   clk,
    input   in,
    
    output logic out
);
    always_ff @(posedge clk) begin
        if (!resetn) begin
            out <= 1;
        end
        else if (in) begin
            out <= !out;
        end
    end

endmodule
