module debouncer_tb;

    logic clk;
    logic resetn;
    logic in;
    logic out;
    
    always #1 clk = !clk;
    
    debouncer #(10) debouncer (
        .clk    (clk    ),
        .resetn (resetn ),
        .in     (in     ),

        .out    (out    )
    );
    
    initial begin
        $dumpfile("debouncer_tb.vcd");
        $dumpvars(0, debouncer_tb);
    
    end
    
    initial begin
        clk = 0;
        resetn = 0;
        in = 0;
        #10
        resetn = 1;
        #100
        in = 1;
        #1000
        in = 0;
        #100
        $finish;
    end

endmodule


