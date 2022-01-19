module edge_detection_tb;

    logic clk;
    logic in;
    logic out;
    
    always #5 clk = !clk;
    
    edge_detection #(
        .RISING_EDGE(0),
        .FALLING_EDGE(1)
    ) flank_detection (
        .clk    (clk    ),
        .in     (in     ),

        .out    (out    )
    );
    
    initial begin
        $dumpfile("edge_detection_tb.vcd");
        $dumpvars(0, edge_detection_tb);
    end
    
    initial begin
        clk = 0;
        in = 0;
        #15 in = 1;
        #20 in = 0;
        #15 in = 1;
        #10 in = 0;
        #20 $finish;
    end

endmodule


