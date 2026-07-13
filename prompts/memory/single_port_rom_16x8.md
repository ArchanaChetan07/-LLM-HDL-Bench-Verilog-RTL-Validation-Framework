# Prompt: single_port_rom_16x8
Write a synthesizable Verilog module named `single_port_rom_16x8` implementing a 16-word x 8-bit read-only memory with fixed, hardcoded contents: address `i` contains the value `(i * 2) + 1` (mod 256), for i = 0 to 15.

Module interface:
```
module single_port_rom_16x8(
    input clk,
    input  [3:0] addr,
    output reg [7:0] data
);
```
Synchronous read: `data` reflects `rom[addr]` one clock cycle after `addr` is presented (registered output). No write port; contents are fixed at synthesis time.
