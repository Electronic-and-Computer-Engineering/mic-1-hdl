`timescale 1 ns / 1 ps

module mic1 (
    input clk,
    input resetn,

    // Main memory
    output reg [31:0] mem_addr,
    output reg [31:0] mem_wdata,
    input      [31:0] mem_rdata,

    // Microprogram memory
    output reg [8:0]  mp_mem_addr,
    output reg [35:0] mp_mem_wdata,
    input      [35:0] mp_mem_rdata
);

    reg [31:0] MAR = 0;
    reg [31:0] MDR = 0;
    reg [31:0] PC  = 0;
    reg [7:0]  MBR = 0;
    reg [31:0] SP  = 0;
    reg [31:0] LV  = 0;
    reg [31:0] CPP = 0;
    reg [31:0] TOS = 0;
    reg [31:0] OPC = 0;
    reg [31:0] H   = 0;
    
    reg [35:0] MIR = 0;
    reg [8:0]  MPC = 0;
    
    // C "bus"
    wire [31:0] C = 0;
    
    // B "bus"
    reg [31:0] B = 0;

    // ALU output
    wire [31:0] ALU_out;
    
    reg N_ff = 0;
    reg Z_ff = 0;

    wire N, Z;
    
    wire [3:0] B_select;
    wire [2:0] memory_ctrl;
    wire [8:0] C_select;
    wire [5:0] ALU_ctrl;
    wire [1:0] shifter_ctrl;
    wire [2:0] jump_ctrl;
    wire [8:0] next_address;
    
    // Disassemble MIR
    assign B_select     = MIR[3:0];
    assign memory_ctrl  = MIR[6:4];
    assign C_select     = MIR[15:7];
    assign ALU_ctrl     = MIR[21:16];
    assign shifter_ctrl = MIR[23:22];
    assign jump_ctrl    = MIR[26:24];
    assign next_address = MIR[35:27];
    
    /*ALU ALU (
        .A(H),
        .B(B),
        .out(ALU_out),
        
        .control(ALU_ctrl),
        
        .N(N),
        .Z(Z)
    );*/
    
    /*shifter shifter(
        .in(ALU_out),
        .out(C),
        
        .control(shifter_ctrl)
    );*/
    
    // Write to B bus
    // TODO load MIR?
    always_ff @(negedge clk) begin
        if (!resetn) begin
            
        end else begin

        end
    end
    
    // Write from C bus into registers
    // Set N and Z
    // TODO set MPC?
    always_ff @(posedge clk) begin
        if (!resetn) begin

        end else begin
            N_ff <= N;
            Z_ff <= Z;

            if (C_select & 1<<0) begin
            
            end
            
        end
    end

endmodule
