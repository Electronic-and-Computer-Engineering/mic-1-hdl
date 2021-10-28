module tb_main_memory ();

logic clk = 0;

logic [8:0] waddr, raddr;

always #5ns clk = ~clk; 

initial
begin

end
endmodule 