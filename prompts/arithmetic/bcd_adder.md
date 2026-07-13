# Prompt: bcd_adder
Write a synthesizable Verilog module named `bcd_adder` implementing a single-digit BCD adder (two BCD digits + carry-in -> BCD sum + carry-out), with the standard BCD correction (+6) when the binary sum exceeds 9 or a carry is generated.

Module interface:
```
module bcd_adder(
    input  [3:0] a,     // BCD digit 0-9
    input  [3:0] b,     // BCD digit 0-9
    input  cin,
    output [3:0] sum,   // BCD digit 0-9
    output cout
);
```
Purely combinational. Inputs are guaranteed valid BCD (0-9).
