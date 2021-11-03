`define assert(mem_value, written_value) \
        if (mem_value !== written_value) begin \
            $display("ASSERTION FAILED in %m: mem_value != written_value"); \
            $finish; \
        end


module tb_main_memory ();

logic clk, wen, ren = 0;
logic [8:0] waddr, raddr, wdata;

integer i;

always #5ns clk = ~clk; 

reg [8:0] test_memory [0:10];   //16kB for simulation not possible because of size
initial begin
    #10ns     
    wdata = 99;
    waddr = 10;
    
    #10ns
    test_memory[waddr] = wdata; 
    
    #10ns
    `assert(test_memory[waddr], wdata)
          
    #10ns
    for (i = 0; i <= 10; i = i + 1) begin
        $display("%h", test_memory[i]);
    end
    
    
end
endmodule 