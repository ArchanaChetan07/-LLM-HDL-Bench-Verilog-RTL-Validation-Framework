# Prompt: dual_read_port_regfile_8x8
Write a synthesizable Verilog module named `dual_read_port_regfile_8x8` implementing an 8-entry x 8-bit register file with one synchronous write port and THREE asynchronous (combinational) read ports.

Module interface:
```
module dual_read_port_regfile_8x8(
    input clk,
    input we,
    input  [2:0] waddr,
    input  [7:0] wdata,
    input  [2:0] raddr1,
    input  [2:0] raddr2,
    input  [2:0] raddr3,
    output [7:0] rdata1,
    output [7:0] rdata2,
    output [7:0] rdata3
);
```
Write occurs synchronously on the clock edge when `we` is high. All three reads are combinational, reflecting current register contents. No reset required.
