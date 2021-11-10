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
    input      [35:0] mp_mem_rdata,

    output [31:0] out
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
    wire [31:0] C;

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
    // TODO load MIR from memory with address MPC
    always_ff @(negedge clk) begin
        if (!resetn) begin

        end else begin
            case (B_select)
                4'd0: B = MDR;
                4'd1: B = PC;
                4'd2: B = $signed(MBR);
                4'd3: B = MBR; // MBRU
                4'd4: B = SP;
                4'd5: B = LV;
                4'd6: B = CPP;
                4'd7: B = TOS;
                4'd8: B = OPC;
                default: B = 'X;
            endcase
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


        end
    end

    always_comb begin
        // JMPC
        if (jump_ctrl[2]) begin
            MPC = next_address | MBR;
        end else begin
            MPC = next_address | ((( jump_ctrl[0] && Z ) || ( jump_ctrl[1] && N )) << 9);
        end
    end

    reg [35:0] mem [0:511];

    initial begin
        $display("Loading memory file into microprogram.");
        $readmemb("microcode.mem", mem, 0, 2);
    end

    reg ren = 1;

    always @(posedge clk) begin
         if (ren && resetn)
            MIR <= mem[MPC];
    end

    // TODO remove
    assign out = H;

endmodule
