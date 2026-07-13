# Prompt: comparator4bit
Write a synthesizable Verilog module named `comparator4bit` implementing a 4-bit magnitude comparator.

Module interface:
```
module comparator4bit(
    input  [3:0] a,
    input  [3:0] b,
    output gt,
    output eq,
    output lt
);
```
Exactly one of `gt`, `eq`, `lt` should be 1 at a time, reflecting whether a>b, a==b, or a<b (unsigned). Purely combinational.
