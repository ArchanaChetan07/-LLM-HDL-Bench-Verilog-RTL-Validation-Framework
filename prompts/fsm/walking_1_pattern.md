# Prompt: walking_1_pattern
Write a synthesizable Verilog module named `walking_1_pattern` implementing an FSM/register that outputs a "walking 1" pattern over 4 bits: 0001, 0010, 0100, 1000, then repeats.

Module interface:
```
module walking_1_pattern(
    input clk,
    input rst,    // synchronous, active-high, resets to 4'b0001
    output reg [3:0] pattern
);
```
Each clock cycle, `pattern` advances to the next value in the cycle 0001 -> 0010 -> 0100 -> 1000 -> 0001 -> ...
