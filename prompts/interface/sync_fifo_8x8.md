# Prompt: sync_fifo_8x8
Write a synthesizable Verilog module named `sync_fifo_8x8` implementing a synchronous FIFO, depth 8, width 8 bits.

Module interface:
```
module sync_fifo_8x8(
    input clk,
    input rst,       // synchronous, active-high
    input wr_en,
    input  [7:0] wdata,
    input rd_en,
    output [7:0] rdata,
    output full,
    output empty
);
```
Standard FIFO semantics: writes ignored when full, reads ignored when empty (rdata holds/undefined when empty is acceptable), `rdata` reflects the current head of the queue combinationally (or registered — your choice, but be consistent), `full`/`empty` flags reflect current occupancy. On reset, FIFO is empty.
