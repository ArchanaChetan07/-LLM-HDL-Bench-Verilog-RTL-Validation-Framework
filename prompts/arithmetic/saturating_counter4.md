# Prompt: saturating_counter4
Write a synthesizable Verilog module named `saturating_counter4` implementing a 4-bit saturating up-counter: it increments each cycle `en` is high, but stops (saturates) at 4'b1111 instead of wrapping to 0.

Module interface:
```
module saturating_counter4(
    input clk,
    input rst,   // synchronous, active-high, resets count to 0
    input en,
    output reg [3:0] count
);
```
When `count` is already 4'b1111 and `en` is high, `count` stays at 4'b1111 (no wraparound). When `en` is low, `count` holds its current value.
