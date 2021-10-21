module alu( 
    // INPUTS
    input [31:0] A,
    input [31:0] B,
    input F0,
    input F1,
    input ENA,
    input ENB,
    input INVA,
    input INC,
    
    // OUTPUTS
    output [31:0] out,
    output N,
    output Z);
endmodule