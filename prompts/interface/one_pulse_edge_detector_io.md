# Prompt: one_pulse_edge_detector_io
Write a synthesizable Verilog module named `one_pulse_edge_detector_io` implementing a dual-edge (both rising and falling) detector on an input signal, useful as a simple I/O interface building block.

Module interface:
```
module one_pulse_edge_detector_io(
    input clk,
    input rst,      // synchronous, active-high
    input sig_in,
    output reg edge_pulse
);
```
`edge_pulse` should go high for exactly one clock cycle whenever `sig_in` changes value in either direction (0->1 or 1->0) compared to its value on the previous clock cycle.
