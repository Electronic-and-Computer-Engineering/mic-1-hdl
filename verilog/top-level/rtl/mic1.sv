`timescale 1 ns / 1 ps

module mic1 (
  input clk,
  input resetn,
  
  // Main memory
  output reg [31:0] mem_addr,
  output reg [31:0] mem_wdata,
  input      [31:0] mem_rdata,
  
  // Microprogram memory
  output reg [8:0] mem_addr,
  output reg [35:0] mem_wdata,
  input      [35:0] mem_rdata
  
  );

endmodule
