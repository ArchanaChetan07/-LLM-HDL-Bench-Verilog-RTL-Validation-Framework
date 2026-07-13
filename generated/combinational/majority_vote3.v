module majority_vote3(
    input a,
    input b,
    input c,
    output majority
);
    assign majority = (a & b) | (b & c) | (a & c);
endmodule
