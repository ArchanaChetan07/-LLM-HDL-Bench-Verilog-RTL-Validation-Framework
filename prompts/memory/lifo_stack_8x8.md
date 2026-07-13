# Prompt: lifo_stack_8x8
Write a synthesizable Verilog module named `lifo_stack_8x8` implementing a synchronous LIFO stack, depth 8, width 8 bits.

Module interface:
```
module lifo_stack_8x8(
    input clk,
    input rst,      // synchronous, active-high
    input push,
    input  [7:0] push_data,
    input pop,
    output [7:0] pop_data,
    output full,
    output empty
);
```
`push` (when not full) pushes `push_data` onto the top of the stack. `pop` (when not empty) removes the top element; `pop_data` reflects the current top-of-stack value combinationally (valid when not empty). If both `push` and `pop` are asserted in the same cycle, treat it as pop-then-push (net effect: replace top of stack with new data, stack depth unchanged), unless the stack is empty (in which case treat it as push only).
