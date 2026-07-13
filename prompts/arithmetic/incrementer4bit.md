# Prompt: incrementer4bit
Write a synthesizable Verilog module named `incrementer4bit` implementing a 4-bit incrementer (adds 1) with overflow detection.

Module interface:
```
module incrementer4bit(
    input  [3:0] in,
    output [3:0] out,
    output overflow
);
```
`out` = in + 1 (wraps 15 -> 0). `overflow` is 1 exactly when `in` is 4'b1111 (i.e. the increment wraps). Purely combinational.
