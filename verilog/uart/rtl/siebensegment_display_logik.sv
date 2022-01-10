module siebensegment_display_logik(
    input logic[3:0] digit_0,
    input logic[3:0] digit_1,
    input logic[3:0] digit_2,
    input logic[3:0] digit_3,
    input logic s_rst,
    input logic clk,
    output logic[7:0]seg,
    output logic[3:0]digit);
    
logic[3:0] bcd_out;
logic[1:0] sel;
logic[18:0] cnt_19;
logic pp;

always_ff @(posedge clk) //19-bit counter erzeugt 10ms-Takt
begin
    if (s_rst)
        cnt_19 <= 0;
    else if (cnt_19 == 500000) begin
        cnt_19 <= 0;
        pp <= 1;
    end
    else begin
        cnt_19 <= cnt_19 + 1;
        pp<=0;
    end
end

always_ff @(posedge clk) //2-bit counter
begin
    if(s_rst)
        sel <= 0;
    else if(pp)
        sel <= sel +1;
end

always_comb //Multiplexer...gibt die Zahl weiter, die für das aktuelle digit bestimmt ist.
begin
    case(sel)
        0: bcd_out = digit_0;
        1: bcd_out = digit_1;
        2: bcd_out = digit_2;
        3: bcd_out = digit_3;
        default: bcd_out = 4'b0000;
    endcase
end

segment_decoder D1(.data_in(bcd_out), .data_out(seg)); //intergrierte den segment decoder
always_comb //1 aus N Decoder...gibt an welches digit beschrieben werden soll
begin
    case(sel)
        0: digit = 4'b1110;
        1: digit = 4'b1101;
        2: digit = 4'b1011;
        3: digit = 4'b0111;
        default: digit = 4'b0000;
    endcase
end
endmodule