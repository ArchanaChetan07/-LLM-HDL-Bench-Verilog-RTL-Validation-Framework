# Prompt: lfsr8
Write a synthesizable Verilog module named `lfsr8` implementing an 8-bit Fibonacci LFSR (linear feedback shift register) using taps at bits 8,6,5,4 (polynomial x^8+x^6+x^5+x^4+1, a maximal-length tap set for 8 bits).

Module interface:
```
module lfsr8(
    input clk,
    input rst,     // synchronous, active-high; loads seed value 8'hFF on reset
    output [7:0] value
);
```
On each clock edge (when not in reset), shift left and insert the XOR feedback bit at bit 0. Output the full 8-bit register value.
