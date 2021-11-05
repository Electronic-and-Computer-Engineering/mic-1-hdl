module shifter( 
    // INPUTS
    input logic [31:0] ALU_out,
    input logic [1:0] SET,
    // OUTPUTS
    output logic [31:0] Shift);   
    logic [31:0] operation;
    always_comb
    begin
        case(SET)
        2'b00:  operation = $signed(ALU_out);  
        2'b01:  operation = $signed(ALU_out) << 8;       
        2'b10:  operation = $signed(ALU_out) >>> 1;  
        default: operation = 32'hXXXXXXXX;
        endcase
        Shift = operation;
    end  
endmodule
