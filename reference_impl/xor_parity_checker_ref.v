module xor_parity_checker(input [7:0] data, input parity_bit, output error);
    assign error = ^{parity_bit, data};
endmodule
