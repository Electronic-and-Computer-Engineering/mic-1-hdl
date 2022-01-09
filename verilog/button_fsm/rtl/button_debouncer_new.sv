`timescale 1 ns / 1 ps

module Button_Debouncer (input logic clk,
                         input logic pushed_button,	// asynchronous, active low
	
	                     output logic button_state);	// 1 if button really pressed
wire slow_clk_en;
wire Q1, Q2, Q2_bar, Q0;
clock_enable u1(clk, slow_clk_en);

my_dff_en d0(clk, slow_clk_en, pushed_button, Q0);

my_dff_en d1(clk, slow_clk_en, Q0, Q1);
my_dff_en d2(clk, slow_clk_en, Q1, Q2);

assign Q2_bar = ~Q2;
assign button_state = Q1 & Q2_bar & slow_clk_en;

endmodule

// Slow clock enable for debouncing button 
module clock_enable(input Clk_100M,
                    output slow_clk_en);
                    
//localparam MAX_CNT = 65535;
localparam MAX_CNT = 249999;

//logic [3:0] counter = 0;
logic [26:0] counter = 0;

always @(posedge Clk_100M)
begin
   counter <= (counter >= MAX_CNT) ?0 : counter + 1;
end

assign slow_clk_en = (counter == MAX_CNT) ?1'b1 : 1'b0;
endmodule

// D-flip-flop with clock enable signal for debouncing module 
module my_dff_en (input DFF_CLOCK, clock_enable, D,
                  output reg Q = 0);
                  
always @ (posedge DFF_CLOCK)
begin
    if(clock_enable==1) 
        Q <= D;
end
endmodule 
