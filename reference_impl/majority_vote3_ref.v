module majority_vote3(input a, input b, input c, output majority);
    assign majority = (a&b)|(a&c)|(b&c);
endmodule
