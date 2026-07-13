# Prompt: parity_gen8
Write a synthesizable Verilog module named `parity_gen8` implementing an 8-bit even-parity generator.

Module interface:
```
module parity_gen8(
    input  [7:0] data,
    output parity
);
```
`parity` should be 1 if the number of 1s in `data` is odd (making total including parity bit even), else 0 (standard even-parity generation). Purely combinational.
