module decoder(
input logic[3:0] decoder_in,       // 4-Bit Eingangskanal
output logic[15:0] decoder_out);   // 16-Bit Ausgang

always_comb
    begin                           // Definition des Outputs je nach Input
        case(decoder_in)
            4'b0000: decoder_out = 16'b0000000000000001;
            4'b0001: decoder_out = 16'b0000000000000010;
            4'b0010: decoder_out = 16'b0000000000000100;
            4'b0011: decoder_out = 16'b0000000000001000;
            4'b0100: decoder_out = 16'b0000000000010000;          
            4'b0101: decoder_out = 16'b0000000000100000;
            4'b0110: decoder_out = 16'b0000000001000000;
            4'b0111: decoder_out = 16'b0000000010000000;
            4'b1000: decoder_out = 16'b0000000100000000;
            4'b1001: decoder_out = 16'b0000001000000000;
            4'b1010: decoder_out = 16'b0000010000000000;
            4'b1011: decoder_out = 16'b0000100000000000;
            4'b1100: decoder_out = 16'b0001000000000000;
            4'b1101: decoder_out = 16'b0010000000000000;
            4'b1110: decoder_out = 16'b0100000000000000;
            4'b1111: decoder_out = 16'b1000000000000000;
            default: decoder_out = 16'bXXXXXXXXXXXXXXXX;
        endcase
    end
endmodule
