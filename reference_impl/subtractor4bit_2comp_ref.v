module subtractor4bit_2comp(input [3:0] a, input [3:0] b, output [3:0] diff, output borrow);
    wire [4:0] ext = {1'b0,a} - {1'b0,b};
    assign diff = ext[3:0];
    assign borrow = (a < b);
endmodule
