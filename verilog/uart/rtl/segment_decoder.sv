module segment_decoder(
    input logic[3:0] data_in,
    output logic[7:0] data_out);

always_comb
begin                  // 76543210
    case(data_in)      // ABCDEFGp
        0:  data_out = 8'b00000010;
        1:  data_out = 8'b10011110;
        2:  data_out = 8'b00100100;
        3:  data_out = 8'b00001100;
        4:  data_out = 8'b10011000;
        5:  data_out = 8'b01001000;
        6:  data_out = 8'b01000000;
        7:  data_out = 8'b00011110;
        8:  data_out = 8'b00000000;
        9:  data_out = 8'b00001000;
        10: data_out = 8'b00010001;
        11: data_out = 8'b00000001;
        12: data_out = 8'b01100011;
        13: data_out = 8'b00000011;
        15: data_out = 8'b01100001;
        16: data_out = 8'b01110001;
        default: data_out = 8'b11111111;
    endcase
end
endmodule