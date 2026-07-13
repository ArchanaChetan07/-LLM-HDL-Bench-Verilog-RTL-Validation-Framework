# Prompt: bcd_to_7seg
Write a synthesizable Verilog module named `bcd_to_7seg` that converts a 4-bit BCD digit (0-9) to a 7-segment display pattern (active-high segments, common segment order {a,b,c,d,e,f,g} as bits [6:0], MSB=a).

Module interface:
```
module bcd_to_7seg(
    input  [3:0] bcd,
    output reg [6:0] seg
);
```
For inputs 10-15 (invalid BCD), output all segments off (7'b0000000). Purely combinational.
