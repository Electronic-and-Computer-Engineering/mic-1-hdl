module debouncer #(
    parameter MAX_COUNT = 512
    )(
    input   clk,
    input   resetn,
    input   in,
    
    output  out
);

    logic [$clog2(MAX_COUNT+1)-1:0] counter;

    always_ff @(posedge clk) begin
        if (!resetn || !in) begin
            counter <= 0;
        end else begin
            if (counter < MAX_COUNT) begin
                counter <= counter + 1;
            end
        end
    end

    assign out = (counter == MAX_COUNT);

endmodule
