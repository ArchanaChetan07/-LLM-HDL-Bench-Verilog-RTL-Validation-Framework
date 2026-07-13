# Prompt: mod4_up_down_counter_fsm
Write a synthesizable Verilog module named `mod4_up_down_counter_fsm` implementing a modulo-4 up/down counter controlled by a direction FSM.

Module interface:
```
module mod4_up_down_counter_fsm(
    input clk,
    input rst,     // synchronous, active-high, resets count to 0
    input up_down, // 1 = count up, 0 = count down
    output reg [1:0] count
);
```
On each clock edge, `count` increments (wrapping 3->0) if `up_down` is 1, or decrements (wrapping 0->3) if `up_down` is 0.
