# Prompt: gray_counter4
Write a synthesizable Verilog module named `gray_counter4` implementing a 4-bit Gray code counter (increments through the standard Gray sequence each clock cycle, not binary).

Module interface:
```
module gray_counter4(
    input clk,
    input rst,   // synchronous, active-high, resets to 4'b0000
    output [3:0] gray_out
);
```
Each clock cycle, `gray_out` advances to the next value in the 4-bit Gray code sequence (only one bit changes between consecutive outputs), wrapping after 16 states.
