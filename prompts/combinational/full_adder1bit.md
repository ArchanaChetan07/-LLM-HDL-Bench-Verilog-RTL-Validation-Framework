# Prompt: full_adder1bit
Write a synthesizable Verilog module named `full_adder1bit` implementing a single-bit full adder.

Module interface:
```
module full_adder1bit(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
```
`sum` = a XOR b XOR cin. `cout` = majority(a,b,cin). Purely combinational.
