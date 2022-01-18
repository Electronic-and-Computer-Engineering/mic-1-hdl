module synchronizer_tb;

    logic clk;
    logic resetn;
    logic in;
    logic out;
    
    always #1 clk = !clk;
    
    synchronizer synchronizer (
        .clk    (clk    ),
        .resetn (resetn ),
        .in     (in     ),

        .out    (out    )
    );
    
    initial begin
        $dumpfile("synchronizer_tb.vcd");
        $dumpvars(0, synchronizer_tb);
    
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


