module shifter_tb;

reg [31:0]in = 32'hAAAAAAAA;
logic [1:0] set = 2'b00;
reg [31:0]out = 32'h0;

shifter DUT(.ALU_out(in), .SET(set), .Shift(out));

always
begin
    set = 2'b00;
    #1 assert (out == 32'haaaaaaaa) $display ("PASS");
    else $error("FAIL");
    #250ns set = 2'b01;
    #1 assert (out == 32'haaaaaa00) $display ("PASS");
    else $error("FAIL");
    #250ns set = 2'b10;
    #1 assert (out == 32'hd5555555) $display ("PASS");
    else $error("FAIL");
    #250ns set = 2'b11;
    #1 assert (out === 32'hXXXXXXXX) $display ("PASS");
    else $error("FAIL");
    #250 $finish;
end
endmodule
