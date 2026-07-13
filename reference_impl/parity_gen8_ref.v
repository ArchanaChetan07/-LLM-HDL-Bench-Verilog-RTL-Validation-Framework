module parity_gen8(input [7:0] data, output parity);
    assign parity = ^data;
endmodule
