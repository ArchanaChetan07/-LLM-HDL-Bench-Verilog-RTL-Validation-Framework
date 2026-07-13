# Prompt: cdc_synchronizer_2ff
Write a synthesizable Verilog module named `cdc_synchronizer_2ff` implementing a standard 2-flip-flop synchronizer for bringing an asynchronous single-bit signal into a clock domain (reduces metastability risk; does not need to model metastability itself, just the 2-FF structure).

Module interface:
```
module cdc_synchronizer_2ff(
    input clk,
    input rst,        // synchronous, active-high
    input async_in,
    output sync_out
);
```
`sync_out` is `async_in` delayed by exactly 2 clock cycles, implemented as two cascaded D flip-flops (not one, not three).
