# Prompt: xor_parity_checker
Write a synthesizable Verilog module named `xor_parity_checker` that checks whether an 8-bit data word plus its accompanying even-parity bit are consistent.

Module interface:
```
module xor_parity_checker(
    input  [7:0] data,
    input  parity_bit,
    output error
);
```
`error` should be 1 if `{parity_bit, data}` (9 bits total) has an odd number of 1s (indicating even parity was violated), else 0. Purely combinational.
