`timescale 1 ns / 1 ps

module tb_main_memory ();

logic clk, wen, wen_A, ren_A, ren_B = 0;
logic [8:0] addr_A, addr_B, wdata_A;

reg [8:0] tb_memory [0:9];
reg [8:0] rdata_A;
reg [8:0] rdata_B;

integer i;

always #5ns clk = ~clk; 

main_memory main_memory(.clk(clk),
                        .wen_A(wen_A),
                        .ren_A(ren_A),
                        .ren_B(ren_B),
                        .addr_A(addr_A),
                        .addr_B(addr_B),
                        .wdata_A(wdata_A),
                        .rdata_A(rdata_A),
                        .rdata_B(rdata_B)
                        );

initial 
begin
    // read first 5 memory cells
    #10ns
    for (i = 0; i < 5; i++) begin
        #10ns
        addr_A = i;
        ren_A = 1;
        #10ns
        tb_memory[i] <= rdata_A;
        #10ns
        ren_A = 0;        
    end
              
      
    // checking if init_memory was loaded right
    for (i = 0; i < 9; i = i + 1) begin
        assert(main_memory.test_memory[i]== tb_memory[i]) $display ("index=%2.d: PASS", i);
            else $error("index=%2.d: FAIL", i);
    end
    
    
end
endmodule 


