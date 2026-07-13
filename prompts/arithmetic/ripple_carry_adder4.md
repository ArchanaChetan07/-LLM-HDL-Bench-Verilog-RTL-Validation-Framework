# Prompt: ripple_carry_adder4
Write a synthesizable Verilog module named `ripple_carry_adder4` implementing a 4-bit ripple-carry adder built from full adders (structural or behavioral, your choice).

Module interface:
```
module ripple_carry_adder4(
    input  [3:0] a,
    input  [3:0] b,
    input  cin,
    output [3:0] sum,
    output cout
);
```
Purely combinational, unsigned addition with carry-in and carry-out.
