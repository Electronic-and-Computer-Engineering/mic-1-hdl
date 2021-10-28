module alu_tb();

logic F0=0, F1=0, ENA=0,ENB=0,INVA=0,INC=0;
logic [31:0] A = 32'h3AE9f840;
logic [31:0] B = 32'h578AFE71;
logic [31:0] ALU_out;
logic zero = 0;
logic negative = 0;
logic [5:0] control = 6'b000000;

always 
begin
    #50ns control++;
    F0 = control[5];
    F1 = control[4];
    ENA = control[3];
    ENB = control[2];
    INVA = control[1];
    INC = control[0];
end

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
        
endmodule