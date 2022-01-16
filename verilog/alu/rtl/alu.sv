module alu( 
    // INPUTS
    input logic [31:0] A,
    input logic [31:0] B,
    input logic F0,
    input logic F1,
    input logic ENA,
    input logic ENB,
    input logic INVA,
    input logic INC,    
    // OUTPUTS
    output logic [31:0] ALU_out,
    output logic N,
    output logic Z);

    logic [5:0] control_lines;
    assign control_lines = {F0, F1, ENA, ENB, INVA, INC};
    
    always_comb
    begin
        case (control_lines)
            6'b011000:  //A
                ALU_out = A;
            6'b010100:  //B
                ALU_out = B;
            6'b011010:  //negate A
                ALU_out = ~A;
            6'b101100:  //negate B
                ALU_out = ~B;
            6'b100100:  //negate B
                ALU_out = ~B;
            6'b111100:  //A+B
                ALU_out = A+B;
            6'b111101:  //A+B+1
                ALU_out = A+B+1;
            6'b111001:  //A+1
                ALU_out = A+1;
            6'b110101:  //B+1
                ALU_out = B+1;
            6'b111111:  //B-A
                ALU_out = B-A;
            6'b110110:  //B-1
                ALU_out = B-1;
            6'b110111:  //B-1
                ALU_out = B-1;
            6'b111011:  //-A
                ALU_out = -A;
            6'b001100:  //A AND B
                ALU_out = A&B;
            6'b011100:  //A OR B
                ALU_out = A|B;
            6'b010000:  //0
                ALU_out = 0;
            6'b010001:  //1
                ALU_out = 1;
            6'b110001:  //1
                ALU_out = 1;
            6'b110010:  //-1
                ALU_out = -1;
            6'b010010:  //-1
                ALU_out = -1;
            default: 
                ALU_out = 32'hXXXXXXXX;               
        endcase
        
        if (ALU_out == 0) Z = 1;
        else Z = 0;
        
        if ($signed(ALU_out) < 0) N = 1;
        else N = 0;      
    end
endmodule
