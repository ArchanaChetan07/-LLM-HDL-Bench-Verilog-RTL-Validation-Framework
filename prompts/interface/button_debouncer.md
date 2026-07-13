# Prompt: button_debouncer
Write a synthesizable Verilog module named `button_debouncer` implementing a simple counter-based button debouncer: the output only changes to match the input after the input has been stable for 4 consecutive clock cycles.

Module interface:
```
module button_debouncer(
    input clk,
    input rst,       // synchronous, active-high; resets output to 0
    input button_in,
    output reg button_out
);
```
Track how many consecutive cycles `button_in` has equaled its own previous value; once it has held the same value for 4 consecutive cycles (i.e., stable), update `button_out` to that value. Any change in `button_in` before reaching 4 cycles resets the stability counter.
