module alu_tb();

logic F0, F1, ENA,ENB,INVA,INC;
logic [31:0] A = 32'h3AE9F840;
logic [31:0] B = 32'h578AFE71;
logic [31:0] ALU_out;
logic zero;
logic negative;
logic [5:0] control;

alu DUT(    .F0(F0),
            .F1(F1),
            .ENA(ENA),
            .ENB(ENB),
            .INVA(INVA),
            .INC(INC),
            .A(A),
            .B(B),
            .ALU_out(ALU_out),
            .Z(zero),
            .N(negative));

    assign F0 = control[5];
    assign F1 = control[4];
    assign ENA = control[3];
    assign ENB = control[2];
    assign INVA = control[1];
    assign INC = control[0];
        
always 
begin 
    #50ns control = 6'b011000;
    #1 assert (ALU_out == A) $display ("PASS");
    else $error("FAIL (A)");
    
    #50ns control = 6'b010100;
    #1 assert (ALU_out == B) $display ("PASS");
    else $error("FAIL (B)");
    
    #50ns control = 6'b011010;
    #1 assert (ALU_out == ~A) $display ("PASS");
    else $error("FAIL (~A)");
    
    #50ns control = 6'b101100;
    #1 assert (ALU_out == ~B) $display ("PASS");
    else $error("FAIL (~B)");
    
    #50ns control = 6'b111100;
    #1 assert (ALU_out == A+B) $display ("PASS");
    else $error("FAIL (A+B)");
    
    #50ns control = 6'b111101;
    #1 assert (ALU_out == A+B+1) $display ("PASS");
    else $error("FAIL (A+B+1)");
    
    #50ns control = 6'b111001;
    #1 assert (ALU_out == A+1) $display ("PASS");
    else $error("FAIL (A+1)");
    
    #50ns control = 6'b110101;
    #1 assert (ALU_out == B+1) $display ("PASS");
    else $error("FAIL (B+1)");
    
    #50ns control = 6'b111111;
    #1 assert (ALU_out == B-A) $display ("PASS");
    else $error("FAIL (B-A)");
    
    #50ns control = 6'b110110;
    #1 assert (ALU_out == B-1) $display ("PASS");
    else $error("FAIL (B-1)");
    
    #50ns control = 6'b111011;
    #1 assert (ALU_out == -A) $display ("PASS");
    else $error("FAIL (-A)");
    
    #50ns control = 6'b001100;
    #1ns assert (ALU_out == $unsigned(A&B)) $display ("PASS");
    else begin 
        $error("FAIL (A&B)");
    end    
    #50ns control = 6'b011100;
    #1 assert (ALU_out == A|B) $display ("PASS");
    else $error("FAIL (A|B)");
    
    #50ns control = 6'b010000;
    #1 assert (ALU_out == 0) $display ("PASS");
    else $error("FAIL (0)");
    
    #50ns control = 6'b110001;
    #1 assert (ALU_out == 1) $display ("PASS");
    else $error("FAIL (1)");
    
    #50ns control = 6'b110010;
    #1 assert (ALU_out == -1) $display ("PASS");
    else $error("FAIL (-1)"); 
    
    $finish;
end
endmodule