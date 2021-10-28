module shifter_tb;

reg [31:0]in = 32'hAAAAAAAA;
logic [1:0] set = 2'b00;
reg [31:0]out = 32'sh0;

//shifter DUT( .ALU_out(in), .set(set), .Shifter_out(out));

initial begin
    #50ns;
    set = 2'b01;
    out = $signed(in) << 8;
    #100ns;
    set = 2'b10;
    out = $signed(in) >>> 1'b1;
    #150ns;
    out = in;
    set = 2'b11;
    #200ns;
    $finish;
end
endmodule
