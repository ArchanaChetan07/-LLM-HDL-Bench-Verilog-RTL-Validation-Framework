# Prompt: bin_to_bcd_2digit
Write a synthesizable Verilog module named `bin_to_bcd_2digit` that converts an 8-bit unsigned binary number (0-99 guaranteed range) into two 4-bit BCD digits (tens and ones).

Module interface:
```
module bin_to_bcd_2digit(
    input  [7:0] bin,
    output [3:0] tens,
    output [3:0] ones
);
```
For example, bin=8'd47 should produce tens=4'd4, ones=4'd7. Input is guaranteed to be 0-99. Purely combinational.
