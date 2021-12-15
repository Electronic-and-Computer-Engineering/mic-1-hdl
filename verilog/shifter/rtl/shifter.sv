module shifter ( 
    // INPUTS
    input wire [31:0] ALU_out,
    input wire [1:0] SET,

    // OUTPUTS
    output logic [31:0] Shift
); 

    always_comb begin
        case(SET)
            2'b00:  Shift = $signed(ALU_out);
            2'b01:  Shift = $signed(ALU_out) >>> 1;
            2'b10:  Shift = $signed(ALU_out) << 8;
            default: Shift = 32'hXXXXXXXX;
        endcase
    end  
endmodule
