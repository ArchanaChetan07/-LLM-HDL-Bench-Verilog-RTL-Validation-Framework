# Prompt: mux4to1
Write a synthesizable Verilog module named `mux4to1` implementing a 4-to-1 multiplexer.

Module interface:
```
module mux4to1(
    input  [3:0] in,
    input  [1:0] sel,
    output out
);
```
`out` should equal `in[sel]`. Purely combinational, no clock.
