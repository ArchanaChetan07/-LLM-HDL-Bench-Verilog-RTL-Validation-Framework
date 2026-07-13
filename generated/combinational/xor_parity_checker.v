module xor_parity_checker(
    input  [7:0] data,
    input  parity_bit,
    output error
);
    wire [8:0] combined = {parity_bit, data};
    assign error = ^combined;
endmodule
