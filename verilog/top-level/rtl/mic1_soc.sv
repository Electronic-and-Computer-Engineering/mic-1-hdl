`timescale 1 ns / 1 ps

module mic1_soc (
    input clk,
    input resetn,
    input run,

    input ser_tx,
    input ser_rx,

    output [31:0] out
);

    wire mem_read;
    wire mem_write;
    wire mem_fetch;

     // Main memory
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [31:0] mem_rdata;
    
    wire [31:0] mem_addr_instr;
    wire [7:0]  mem_rd_instr;

    // Microprogram memory
    wire [8:0]  mp_mem_addr;
    wire [35:0] mp_mem_wdata;
    wire [35:0] mp_mem_rdata;
    
    logic mic1_run = 0;
    
    // Always change mic1_run on rising edge
    always_ff @(posedge clk) begin
        mic1_run <= run;
    end

    mic1 mic1 (
        .clk            (clk           ),
        .resetn         (resetn        ),
        .run            (mic1_run      ),

        .mem_read       (mem_read      ),
        .mem_write      (mem_write     ),
        .mem_addr       (mem_addr      ),
        .mem_wdata      (mem_wdata     ),
        .mem_rdata      (mem_rdata_io  ),
        
        .mem_fetch      (mem_fetch     ),
        .mem_addr_instr (mem_addr_instr),
        .mem_rd_instr   (mem_rd_instr  ),

        .mp_mem_addr    (mp_mem_addr   ),
        .mp_mem_wdata   (mp_mem_wdata  ),
        .mp_mem_rdata   (mp_mem_rdata  ),

        .out(out)
    );
    
    logic [31:0] mem_rdata_io;
    
    logic [7:0] my_input = 8'h00;
    
    initial begin
        #4500;
        #100;
        my_input = 8'h33;
        #300;
        my_input = 8'h34;
        #300;
        my_input = 8'h0A;
        #200;
        my_input = 8'h35;
        #300;
        my_input = 8'h36;
        #300;
        my_input = 8'h0A;
        #200;
        my_input = 8'h00;
        #1000;
    end
    
    always_comb begin
        case (mem_addr)
            32'hFFFFFFFD:  // IO address
                mem_rdata_io = my_input;
            default: 
                mem_rdata_io = mem_rdata;            
        endcase
    end

    control_store #(
        .INIT_F(`MICROCODE)
    ) control_store (
        .clk (clk),
        .wen (1'b0), 
        .ren (resetn && mic1_run),

        .waddr (mp_mem_addr),
        .raddr (mp_mem_addr),
        .wdata (mp_mem_wdata),
        .rdata (mp_mem_rdata)
    );
    
    main_memory #(
        .INIT_F(`PROGRAM)
    ) main_memory (
        .clk (clk),
        .wen_A (mem_write && resetn && mic1_run), 
        .ren_A (mem_read && resetn && mic1_run),
        .ren_B (mem_fetch && resetn && mic1_run),

        .addr_A (mem_addr),
        .addr_B (mem_addr_instr),
        .wdata_A (mem_wdata),
        .rdata_A (mem_rdata),
        .rdata_B (mem_rd_instr)
    );
    
    `ifndef SYNTHESIS
    
    always_ff @(negedge clk) begin
        if (mem_addr == 'hFFFFFFFD && mem_write && mic1_run) begin
            $display("IO write access: %h %c", mem_wdata, mem_wdata);
        end
    end
    
    always_ff @(negedge clk) begin
        if (mem_addr == 'hFFFFFFFD && mem_read && mic1_run) begin
            $display("IO read access:  %h %c", mem_rdata_io, mem_rdata_io);
        end
    end
    
    `endif

endmodule
