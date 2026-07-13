# Prompt: decoder3to8
Write a synthesizable Verilog module named `decoder3to8` implementing a 3-to-8 line decoder with an enable input.

Module interface:
```
module decoder3to8(
    input  [2:0] in,
    input  en,
    output [7:0] out
);
```
When `en` is high, exactly one bit of `out` (bit index = `in`) is high, all others low. When `en` is low, `out` is all zero regardless of `in`. Purely combinational.
