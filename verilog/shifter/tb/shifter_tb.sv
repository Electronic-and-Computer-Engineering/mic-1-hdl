module shifter_tb;

reg [31:0]in = 32'hAAAAAAAA;
logic [1:0] set = 2'b00;
reg [31:0]out = 32'h0;

shifter DUT(.ALU_out(in), .SET(set), .Shift(out));

always 
begin
    #250ns set++;
end
endmodule
