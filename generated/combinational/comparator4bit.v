module comparator4bit(
    input  [3:0] a,
    input  [3:0] b,
    output gt,
    output eq,
    output lt
);
    assign eq = (a == b);
    assign gt = (a > b);
    assign lt = (a < b);
endmodule
