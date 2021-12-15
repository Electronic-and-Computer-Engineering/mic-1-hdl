`timescale 1 ns / 1 ps

int DEBUG = 0;

module tb_main_memory ();

logic tb_clk = 0;
logic tb_wen_A = 0;
logic tb_ren_A = 0;
logic tb_ren_B = 0;

logic [8:0] tb_addr_A, tb_addr_B, tb_wdata_A;

reg [8:0] tb_memory [10];
reg [8:0] tb_rdata_A;
reg [8:0] tb_rdata_B;

integer i;

always #2ns tb_clk = ~tb_clk;

main_memory main_memory(.clk(tb_clk),
                        .wen_A(tb_wen_A),
                        .ren_A(tb_ren_A),
                        .ren_B(tb_ren_B),
                        .addr_A(tb_addr_A),
                        .addr_B(tb_addr_B),
                        .wdata_A(tb_wdata_A),
                        .rdata_A(tb_rdata_A),
                        .rdata_B(tb_rdata_B));

initial
begin

    tb_memory[5] = 8'hAA;
    tb_memory[6] = 8'hBB;
    tb_memory[7] = 8'hCC;
    tb_memory[8] = 8'hDD;
    tb_memory[9] = 8'hEE;

    // read first 5 memory cells
    #10ns
    for (i = 0; i < 5; i++) begin
        #10ns
        tb_addr_A = i;
        tb_ren_A = 1;
        #10ns
        tb_memory[i] <= tb_rdata_A;
        #10ns
        tb_ren_A = 0;
    end

    // write last 5 memory cells
    #10ns
    for (i = 5; i < 10; i++) begin
        #10ns
        tb_addr_A = i;
        tb_wen_A = 1;
        #10ns
        tb_wdata_A = tb_memory[i];
        #10ns
        tb_wen_A = 0;
    end

    if (DEBUG) begin
        $display("TEST_MEMORY:");
        for (i = 0; i < 10; i = i + 1) begin
            $display("index =%2.d: %2.h", i, main_memory.test_memory[i]);
        end

        $display("TB_MEMORY:");  
        for (i = 0; i < 10; i = i + 1) begin
            $display("index =%2.d: %2.h", i, tb_memory[i]);
        end
    end


    // checking if init_memory was loaded right
    for (i = 0; i < 10; i = i + 1) begin
        assert(main_memory.test_memory[i]== tb_memory[i]) $display ("index =%2.d: PASS", i);
            else $error("index =%2.d: FAIL", i);
    end


end
endmodule
