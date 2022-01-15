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

    logic [31:0] MAR;
    logic [31:0] MDR;
    logic [31:0] PC;
    logic [7:0]  MBR;
    logic [31:0] SP;
    logic [31:0] LV;
    logic [31:0] CPP;
    logic [31:0] TOS;
    logic [31:0] OPC;
    logic [31:0] H;

    logic [35:0] MIR;
    logic  [8:0] MPC;

    // C "bus"
    logic [31:0] C;

    // B "bus"
    logic [31:0] B;

    // ALU output
    logic [31:0] ALU_out;

    logic N, Z;

    logic [3:0] B_select;
    logic [2:0] memory_ctrl;
    logic [2:0] old_memory_ctrl;
    logic [8:0] C_select;
    logic [5:0] ALU_ctrl;
    logic [1:0] shifter_ctrl;
    logic [2:0] jump_ctrl;
    logic [8:0] next_address;

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

    // Write to B bus
    always_ff @(negedge clk) begin
        if (!resetn) begin
            B   <= 0;
        end
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
        end
        else if (resetn && run) begin
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
    assign out = MBR;

endmodule
