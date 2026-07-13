module incrementer4bit(input [3:0] in, output [3:0] out, output overflow);
    assign out = in + 4'b1;
    assign overflow = (in == 4'b1111);
endmodule
