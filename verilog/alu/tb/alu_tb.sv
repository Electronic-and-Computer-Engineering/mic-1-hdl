module alu_tb();

logic F0=0, F1=0, ENA=0,ENB=0,INVA=0,INC=0;
logic [31:0] A = 32'h3AE9f840;
logic [31:0] B = 32'h578AFE71;
logic [31:0] ALU_out;
logic zero;
logic negative;
logic [5:0] control;// = 6'b000000;

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
      
 always_comb 
 begin
    F0 = control[5];
    F1 = control[4];
    ENA = control[3];
    ENB = control[2];
    INVA = control[1];
    INC = control[0];
end
        
always 
begin
//    #50ns control++;
//    F0 = control[0];
//    F1 = control[1];
//    ENA = control[2];
//    ENB = control[3];
//    INVA = control[4];
//    INC = control[5]; 
    
    #50ns control = 6'b011000;
    #1 assert (ALU_out == A) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b010100;
    #1 assert (ALU_out == B) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b011010;
    #1 assert (ALU_out == ~A) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b101100;
    #1 assert (ALU_out == ~B) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b111100;
    #1 assert (ALU_out == A+B) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b111101;
    #1 assert (ALU_out == A+B+1) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b111001;
    #1 assert (ALU_out == A+1) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b110101;
    #1 assert (ALU_out == B+1) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b111111;
    #1 assert (ALU_out == B-A) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b110110;
    #1 assert (ALU_out == B-1) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b111011;
    #1 assert (ALU_out == -A) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b001100;
    #1 assert (ALU_out == A&B) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b011100;
    #1 assert (ALU_out == A|B) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b010000;
    #1 assert (ALU_out == 0) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b110001;
    #1 assert (ALU_out == 1) $display ("PASS");
    else $error("FAIL");
    
    #50ns control = 6'b110010;
    #1 assert (ALU_out == -1) $display ("PASS");
    else $error("FAIL"); 

    $finish;

end




endmodule