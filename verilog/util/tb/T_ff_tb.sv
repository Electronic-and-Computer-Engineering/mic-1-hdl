module T_ff_tb;

    logic clk;
    logic in;
    logic out;
    logic resetn;
    
    always #5 clk = !clk;
    
    T_ff T_ff (
        .resetn (resetn ),
        .clk    (clk    ),
        .in     (in     ),

        .out    (out    )
    );
    
    initial begin
        $dumpfile("T_ff_tb.vcd");
        $dumpvars(0, T_ff_tb);
    end
    
    initial begin
        resetn = 0;
        clk = 0;
        in = 0;
        #50 resetn = 1;
        #15 in = 1;
        #20 in = 0;
        #15 in = 1;
        #10 in = 0;
        #20 $finish;
    end

endmodule


