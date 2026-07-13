# Prompt: sync_regfile_4x8
Write a synthesizable Verilog module named `sync_regfile_4x8` implementing a 4-entry x 8-bit register file with one synchronous write port and two asynchronous (combinational) read ports.

Module interface:
```
module sync_regfile_4x8(
    input clk,
    input we,
    input  [1:0] waddr,
    input  [7:0] wdata,
    input  [1:0] raddr1,
    input  [1:0] raddr2,
    output [7:0] rdata1,
    output [7:0] rdata2
);
```
Write occurs synchronously on the clock edge when `we` is high. Reads are combinational (no clock), reflecting current register contents. No reset is required.
