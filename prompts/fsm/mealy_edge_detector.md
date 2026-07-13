# Prompt: mealy_edge_detector
Write a synthesizable Verilog module named `mealy_edge_detector` implementing a Mealy-type falling-edge detector on a single-bit input.

Module interface:
```
module mealy_edge_detector(
    input clk,
    input rst,    // synchronous, active-high
    input din,
    output pulse  // combinational Mealy output
);
```
`pulse` should be high (combinationally, same cycle) exactly when `din` is currently 0 and the previous registered value of `din` was 1 (i.e. detects the falling edge one cycle after it occurs on the din waveform, using a registered "previous din" state plus combinational comparison).
