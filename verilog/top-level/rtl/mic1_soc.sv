`timescale 1 ns / 1 ps

module mic1_soc #(
    parameter STACKPOINTER_ADDRESS = 'h0060,
    parameter LOCALVARIABLEFRAME_ADDRESS = 'h0050,
    parameter CONSTANTPOOL_ADDRESS = 'h0048,
    parameter MIC1_PROGRAM = "programs/add.mem",
    parameter MIC1_MICROCODE = "microcode.mem",
    parameter MEMORY_SIZE = 'h0083
    )(
    input clk,
    input resetn,
    input run,

    output ser_tx,
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
    
    logic mic1_run;
    
    // Always change mic1_run on rising edge
    always_ff @(posedge clk) begin
        mic1_run <= run && !tx_busy;
    end

    mic1 #(
        .STACKPOINTER_ADDRESS(STACKPOINTER_ADDRESS),
        .LOCALVARIABLEFRAME_ADDRESS(LOCALVARIABLEFRAME_ADDRESS),
        .CONSTANTPOOL_ADDRESS(CONSTANTPOOL_ADDRESS)
    ) mic1 (
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
        .mp_mem_rdata   (mp_mem_rdata  ),

        .out(out)
    );
    
    logic [31:0] mem_rdata_io;
    logic [7:0] my_input;
    
    always_ff @(posedge clk) begin
        if (!resetn) begin
            my_input <= 0;
        end
    end
    
    // baud generator: 100 MHz -> 153,600 (16 x 9,600)
    // 100 MHz / 153,600 = 651.04; 2^24/651.04 = 25,770
    
    // baud generator: 6 MHz -> 153,600 (16 x 9,600)
    // 6 MHz / 153,600 = 39,0625; 2^24/39,0625 = 429,497
    
    
    localparam CNT_W=24;            // baud counter width
    localparam CNT_INC=24'd429497;   // baud counter increment
    logic stb_baud, stb_sample;
    uart_baud #(
        .CNT_W(CNT_W),
        .CNT_INC(CNT_INC)
    ) baud_gen (
        .clk(clk),
        .rst(!resetn),
        .stb_baud,
        .stb_sample
    );

    // receiver (to FPGA)
    logic rx_done;
    logic [7:0] received;
    uart_rx uart_rx_inst(
        .clk(clk),
        .rst(!resetn),  // reset button is active low
        .stb_sample,
        .data_in(ser_rx),
        .data_out(received),
        .rx_done
    );

    // transmitter (from FPGA)
    logic tx_start, tx_busy, tx_next;
    uart_tx uart_tx_inst (
        .clk(clk),
        .rst(!resetn),  // reset button is active low
        .stb_baud,
        .tx_start(mem_addr == 'hFFFFFFFD && mem_write && mic1_run),
        .data_in(mem_wdata[7:0]),
        .data_out(ser_tx),
        .tx_busy,
        .tx_next
    );
    
    logic [7:0] received_register;

    // buffer RX done signal for TX start
    always_ff @(posedge clk) begin
        if (!resetn) begin
            received_register = 0;
        end
    
        if (rx_done) tx_start <= 1;
        if (stb_baud) tx_start <= 0;
        
        if (mem_addr == 'hFFFFFFFD && mem_read && mic1_run) begin
            received_register = 0;
        end else if (rx_done) begin
            received_register = received;
        end
    end
        
    always_comb begin
        case (mem_addr)
            32'hFFFFFFFD:  // IO address
                mem_rdata_io = received_register;
            default: 
                mem_rdata_io = mem_rdata;            
        endcase
    end

    control_store #(
        .INIT_F(MIC1_MICROCODE)
    ) control_store (
        .clk (clk),
        .ren (1'b1 && mic1_run),

        .waddr (mp_mem_addr),
        .raddr (mp_mem_addr),
        .rdata (mp_mem_rdata)
    );
    
    main_memory #(
        .INIT_F(MIC1_PROGRAM),
        .MEMORY_SIZE(MEMORY_SIZE)
    ) main_memory (
        .clk (clk),
        .wen_A (mem_write && mic1_run), 
        .ren_A (mem_read  && mic1_run),
        .ren_B (mem_fetch && mic1_run),

        .addr_A (mem_addr),
        .addr_B (mem_addr_instr),
        .wdata_A (mem_wdata),
        .rdata_A (mem_rdata),
        .rdata_B (mem_rd_instr)
    );
    
    /*`ifndef SYNTHESIS
    
    initial begin
        #83000;
        my_input = 8'h33;
        #24900;
        my_input = 8'h34;
        #24900;
        my_input = 8'h0A;
        #16600;
        my_input = 8'h35;
        #24900;
        my_input = 8'h36;
        #24900;
        my_input = 8'h0A;
        #16600;
        my_input = 8'h00;
    end
    
    always_ff @(negedge clk) begin
        if (mem_addr == 'hFFFFFFFD && mem_write && mic1_run) begin
            $display("IO write access: %h %c", mem_wdata, mem_wdata);
        end
    end
    
    always_ff @(negedge clk) begin
        if (mem_addr == 'hFFFFFFFD && mem_read && mic1_run) begin
            if (mem_rdata_io != 0) begin
                $display("IO read access:  %h %c", mem_rdata_io, mem_rdata_io);
            end
        end
    end
    
    `endif*/

endmodule
