# Prompt: moore_edge_detector
Write a synthesizable Verilog module named `moore_edge_detector` implementing a Moore-type rising-edge detector on a single-bit input.

Module interface:
```
module moore_edge_detector(
    input clk,
    input rst,     // synchronous, active-high
    input din,
    output reg pulse
);
```
`pulse` should go high for exactly one clock cycle whenever `din` transitions from 0 to 1 (registered/Moore output, so `pulse` reflects the state entered on the edge, not a combinational function of din directly).
