# Prompt: byte_enable_ram_16x8
Write a synthesizable Verilog module named `byte_enable_ram_16x8` implementing a 16-word x 8-bit synchronous RAM with a byte-enable write mask (since the word is a single byte here, `byte_en` simply gates whether the write happens at all -- included for interface realism).

Module interface:
```
module byte_enable_ram_16x8(
    input clk,
    input we,
    input byte_en,     // write only occurs if we AND byte_en are both high
    input  [3:0] addr,
    input  [7:0] wdata,
    output reg [7:0] rdata
);
```
Synchronous read (registered `rdata`, reflects `mem[addr]` one cycle after `addr` is presented). Write occurs synchronously when `we && byte_en` are both high.
