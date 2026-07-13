# Prompt: subtractor4bit_2comp
Write a synthesizable Verilog module named `subtractor4bit_2comp` implementing a 4-bit two's-complement subtractor (a - b) with a borrow-out flag.

Module interface:
```
module subtractor4bit_2comp(
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] diff,
    output borrow
);
```
`diff` = a - b (4-bit wraparound result, unsigned interpretation). `borrow` should be 1 when a < b (unsigned comparison), else 0. Purely combinational.
