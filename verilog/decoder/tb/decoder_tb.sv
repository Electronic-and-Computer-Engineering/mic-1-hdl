module decoder_tb;

logic [3:0]in = 4'b0000;
logic [15:0]out = 16'b0000000000000000;

decoder DUT(.decoder_in(in), .decoder_out(out));

always
begin
    in = 4'b0000;
    #1 assert (out == 16'b0000000000000001) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b0001;
    #1 assert (out == 16'b0000000000000010) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b0010;
    #1 assert (out == 16'b0000000000000100) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b0011;
    #1 assert (out == 16'b0000000000001000) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b0100;
    #1 assert (out == 16'b0000000000010000) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b0101;
    #1 assert (out == 16'b00000000000100000) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b0110;
    #1 assert (out == 16'b0000000001000000) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b0111;
    #1 assert (out == 16'b0000000010000000) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b1000;
    #1 assert (out == 16'b0000000100000000) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b1001;
    #1 assert (out == 16'b0000001000000000) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b1010;
    #1 assert (out == 16'b0000010000000000) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b1011;
    #1 assert (out == 16'b0000100000000000) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b1100;
    #1 assert (out == 16'b0001000000000000) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b1101;
    #1 assert (out == 16'b0010000000000000) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b1110;
    #1 assert (out == 16'b0100000000000000) $display ("PASS");
    else $error("FAIL");
    
    #100ns in = 4'b1111;
    #1 assert (out == 16'b1000000000000000) $display ("PASS");
    else $error("FAIL");
    #100 $finish;
end
endmodule