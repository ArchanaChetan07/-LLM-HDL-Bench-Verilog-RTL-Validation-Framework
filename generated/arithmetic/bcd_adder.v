module bcd_adder(
    input  [3:0] a,
    input  [3:0] b,
    input  cin,
    output [3:0] sum,
    output cout
);
    wire [4:0] binsum;
    assign binsum = a + b + cin;
    assign cout = (binsum > 9) ? 1'b1 : 1'b0;
    assign sum = (binsum > 9) ? (binsum + 5'd6) : binsum;
endmodule
