module ripple_carry_adder4(
    input  [3:0] a,
    input  [3:0] b,
    input  cin,
    output [3:0] sum,
    output cout
);
    wire [4:0] result;
    assign result = a + b + cin;
    assign sum = result[3:0];
    assign cout = result[4];
endmodule
