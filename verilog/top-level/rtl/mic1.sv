`timescale 1 ns / 1 ps

module mic1 #(
    parameter STACKPOINTER_ADDRESS = 'h0060,
    parameter LOCALVARIABLEFRAME_ADDRESS = 'h0050,
    parameter CONSTANTPOOL_ADDRESS = 'h0048
    )(
    input clk,
    input resetn,
    input run,

    // Main memory
    output logic [31:0] mem_addr,
    output logic [31:0] mem_wdata,
    input        [31:0] mem_rdata,
    
    output logic [31:0] mem_addr_instr,
    input        [ 7:0] mem_rd_instr,

    // Microprogram memory
    output logic [ 8:0] mp_mem_addr,
    output logic [35:0] mp_mem_wdata,
    input        [35:0] mp_mem_rdata,

    output logic mem_read,
    output logic mem_write,
    output logic mem_fetch,

    output [31:0] out
);

    reg [31:0] MAR;
    reg [31:0] MDR;
    reg [31:0] PC;
    reg [7:0]  MBR;
    reg [31:0] SP;
    reg [31:0] LV;
    reg [31:0] CPP;
    reg [31:0] TOS;
    reg [31:0] OPC;
    reg [31:0] H;

    wire [35:0] MIR;
    reg  [8:0]  MPC;

    // C "bus"
    wire [31:0] C;

    // B "bus"
    reg [31:0] B;

    // ALU output
    wire [31:0] ALU_out;

    reg N_ff;
    reg Z_ff;

    wire N, Z;

    wire [3:0] B_select;
    wire [2:0] memory_ctrl;
    reg  [2:0] old_memory_ctrl;
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

    alu alu (
        .F0     (ALU_ctrl[5]),
        .F1     (ALU_ctrl[4]),
        .ENA    (ALU_ctrl[3]),
        .ENB    (ALU_ctrl[2]),
        .INVA   (ALU_ctrl[1]),
        .INC    (ALU_ctrl[0]),
        .A      (H),
        .B      (B),

        .ALU_out(ALU_out),
        .Z      (Z),
        .N      (N)
    );

    shifter shifter (
        .ALU_out    (ALU_out),
        .SET        (shifter_ctrl),

        .Shift      (C)
    );
    
    always_ff @(posedge clk) begin
        if (!resetn) begin
            MAR <= 0;
            MDR <= 0;
            PC  <= -1;
            MBR <= 0;
            SP  <= STACKPOINTER_ADDRESS;
            LV  <= LOCALVARIABLEFRAME_ADDRESS;
            CPP <= CONSTANTPOOL_ADDRESS;
            TOS <= 0;
            OPC <= 0;
            H   <= 0;       
            MPC <= 0;
            B   <= 0;
            N_ff <= 0;
            Z_ff <= 0;
            first_cycle <= 0;
        end
    end
    
    logic first_cycle;

    // Write to B bus
    always_ff @(negedge clk) begin
        if (resetn && run) begin
            case (B_select)
                4'd0: B <= MDR;
                4'd1: B <= PC;
                4'd2: B <= $signed(MBR);
                4'd3: B <= MBR; // MBRU
                4'd4: B <= SP;
                4'd5: B <= LV;
                4'd6: B <= CPP;
                4'd7: B <= TOS;
                4'd8: B <= OPC;
                default: B <= 'X;
            endcase
        end
    end


    // Write from C bus into registers
    // Set N and Z for next instr
    always_ff @(posedge clk) begin
        if (resetn && run) begin
            N_ff <= N;
            Z_ff <= Z;

            if (C_select & 9'b000000001) begin
                MAR <= C;
            end
            if (C_select & 9'b000000010) begin
                MDR <= C;
            end
            if (C_select & 9'b000000100) begin
                PC <= C;
            end
            if (C_select & 9'b000001000) begin
                SP <= C;
            end
            if (C_select & 9'b000010000) begin
                LV <= C;
            end
            if (C_select & 9'b000100000) begin
                CPP <= C;
            end
            if (C_select & 9'b001000000) begin
                TOS <= C;
            end
            if (C_select & 9'b010000000) begin
                OPC <= C;
            end
            if (C_select & 9'b100000000) begin
                H <= C;
            end

            // Load MDR and MBR with the result of the last memory operations
            if (old_memory_ctrl[1]) begin
                MDR <= mem_rdata;
            end
            
            if (old_memory_ctrl[0]) begin
                MBR <= mem_rd_instr;
            end
            
            old_memory_ctrl <= memory_ctrl;
        end
    end
    
    // Start memory operation after MAR and/or PC are loaded
    assign mem_read = old_memory_ctrl[1];
    assign mem_write = old_memory_ctrl[2];
    assign mem_fetch = old_memory_ctrl[0];

    // Set MPC
    always_comb begin
        // JMPC
        if (jump_ctrl[2]) begin
            MPC = next_address | MBR;
        end else begin
            MPC = next_address | ((( jump_ctrl[0] && Z ) || ( jump_ctrl[1] && N )) << 8);
        end
    end
    
    assign mp_mem_addr = MPC;
    assign MIR = mp_mem_rdata;
    
    assign mem_addr = MAR;
    assign mem_wdata = MDR;
    
    assign mem_addr_instr = PC;

    // TODO remove
    assign out = H;

endmodule
