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
    output [31:0] ALU_out,
    output N,
    output Z);

    logic [5:0] control_lines = {F0, F1, ENA, ENB, INVA, INC};
    logic [31:0] result;
    
    always @(*)
    begin
        case(control_lines)
        6'b011000:  //A
            result = A;
        6'b010100:  //B
            result = B;
        6'b011010:  //negate A
            result = ~A;
        6'b101100:  //negate B
            result = ~B;
        6'b111100:  //A+B
            result = A+B;
        6'b111101:  //A+B+1
            result = A+B+1;
        6'b111001:  //A+1
            result = A+1;
        6'b110101:  //B+1
            result = B+1;
        6'b111111:  //B-A
            result = B-A;
        6'b110110:  //B-1
            result = B-1;
        6'b111011:  //-A
            result = -A;
        6'b001100:  //A AND B
            result = A&B;
        6'b011100:  //A OR B
            result = A|B;
        6'b010000:  //0
            result = 0;
        6'b110001:  //1
            result = 1;
        6'b110010:  //-1
            result = -1;
        default: 
            result = 0;
        endcase
    end

endmodule