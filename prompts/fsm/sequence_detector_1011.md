# Prompt: sequence_detector_1011
Write a synthesizable Verilog module named `sequence_detector_1011` implementing a Moore FSM that detects the (possibly overlapping) bit sequence 1011 on a serial input.

Module interface:
```
module sequence_detector_1011(
    input clk,
    input rst,     // synchronous, active-high
    input din,
    output reg detected
);
```
`detected` should pulse high for one clock cycle the cycle after the 4th bit of a matching 1011 sequence is received (registered Moore output). Overlapping sequences must be detected (e.g. 10110 11 contains two matches).
