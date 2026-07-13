# Prompt: circular_buffer_pointer_8x8
Write a synthesizable Verilog module named `circular_buffer_pointer_8x8` implementing an 8-entry x 8-bit circular buffer where writes always succeed and simply overwrite the oldest entry once full (no "full" blocking -- this is a ring buffer / overwrite-on-full design, distinct from a blocking FIFO).

Module interface:
```
module circular_buffer_pointer_8x8(
    input clk,
    input rst,      // synchronous, active-high; empties the buffer
    input wr_en,
    input  [7:0] wdata,
    input rd_en,
    output [7:0] rdata,
    output empty
);
```
`wr_en` always writes to the current write pointer and advances it (wrapping mod 8), even if the buffer is full (oldest data is silently overwritten). `rd_en` (when not empty) reads the oldest remaining entry (combinationally, at the current read pointer) and advances the read pointer. `empty` is high only when no unread entries remain (read pointer has caught up to write pointer with no pending writes since last full drain).
