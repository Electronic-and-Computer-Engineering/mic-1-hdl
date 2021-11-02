module shifter( 
    // INPUTS
    input logic [31:0] ALU_out,
    input logic [1:0] SET,
  
    // OUTPUTS
    output logic [31:0] Shift);
    
    logic [31:0] result;
    
    always@(*)
    begin
        case(SET)
        2'b00:  result = $signed(ALU_out);
        
        2'b01:  result = $signed(ALU_out) << 8;
        
        2'b10:  result = $signed(ALU_out) >>> 1;
        
        2'b11:  result = $signed(ALU_out);
        
        default: result = 0;
        endcase
        Shift = result;
    end    
    
endmodule