# Prompt: priority_arbiter4
Write a synthesizable Verilog module named `priority_arbiter4` implementing a fixed-priority arbiter for 4 requesters (request 0 has highest priority).

Module interface:
```
module priority_arbiter4(
    input  [3:0] req,
    output [3:0] grant
);
```
Exactly one bit of `grant` should be set (the lowest-indexed asserted bit of `req`), or `grant` = 4'b0000 if no requests are asserted. Purely combinational.
