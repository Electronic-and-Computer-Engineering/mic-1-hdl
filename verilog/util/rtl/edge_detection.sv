module edge_detection #(
    parameter RISING_EDGE = 1,
    parameter FALLING_EDGE = 0
    )(
    input   clk,
    input   in,
    
    output  out
);

    reg old_in;

    always_ff @(posedge clk) begin
        old_in <= in;
    end

    logic rising_edge;
    logic falling_edge;
    
    assign rising_edge = ~old_in && in;
    assign falling_edge = old_in && ~in;

    generate
        if (RISING_EDGE && FALLING_EDGE) begin
            assign out = rising_edge || falling_edge;
        end else if (RISING_EDGE) begin
            assign out = rising_edge;
        end else if (FALLING_EDGE) begin
            assign out = falling_edge;
        end
    endgenerate

endmodule
