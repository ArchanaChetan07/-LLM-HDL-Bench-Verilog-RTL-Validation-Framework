# Prompt: multiplier4x4_shiftadd
Write a synthesizable Verilog module named `multiplier4x4_shiftadd` implementing a 4x4-bit unsigned multiplier (combinational; shift-add or any other correct method is acceptable).

Module interface:
```
module multiplier4x4_shiftadd(
    input  [3:0] a,
    input  [3:0] b,
    output [7:0] product
);
```
`product` = a * b (unsigned, full 8-bit result, no truncation). Purely combinational.
