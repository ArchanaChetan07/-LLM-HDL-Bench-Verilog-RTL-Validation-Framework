module incrementer4bit(
    input  [3:0] in,
    output [3:0] out,
    output overflow
);
    assign out = in + 4'b0001;
    assign overflow = &in;
endmodule
