`timescale 1 ns / 1 ps

module control_store_tb;

reg clk = 0, wen, ren;

reg [8:0] waddr, raddr;
reg [35:0] wdata = 'h0;
wire [35:0] rdata; // output register

always begin
    #1
    clk =! clk;
end

reg [35:0] mem [512];
  
initial begin
    #10ns
    wdata = 41;
    waddr = 3;
    wen = 1; #2 wen = 0;
    #10ns
    raddr = 3;
    ren = 1; #2 ren = 0;
    
    assert (wdata == rdata) $display ("Memory Cell Check completed");
      else $error("Memory Cell Check gone wrong");

    #10
    $finish;
end
    
control_store control_store (
.clk(clk),
.wen(wen),
.ren(ren),
.waddr(waddr),
.raddr(raddr),
.wdata(wdata),
.rdata(rdata)
);    

endmodule