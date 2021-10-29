`timescale 1 ns / 1 ps

module testbench;

reg clk = 1`b0;

reg [8:0] waddr, raddr
reg [31:0] wdata = 32'hAEDAADDA;
reg [31:0] rdata = 32'sh0; // output register

initial begin
    #50ns;
    wdata = 2'b01;
    rdata = wdata;
    #100ns;
    wdata = 2'b01;
    rdata = wdata;
    #150ns;
    wdata = 2'b01;
    rdata = wdata;
    #200ns;
    $finish;
end
    
endmodule