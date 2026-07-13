# Prompt: dual_port_ram
Write a synthesizable Verilog module named `dual_port_ram` implementing a true dual-port RAM, 16 words x 8 bits, with two independent synchronous read/write ports.

Module interface:
```
module dual_port_ram(
    input clk,
    input  we_a,
    input  [3:0] addr_a,
    input  [7:0] din_a,
    output reg [7:0] dout_a,
    input  we_b,
    input  [3:0] addr_b,
    input  [7:0] din_b,
    output reg [7:0] dout_b
);
```
Each port: on clock edge, if we_* is high, write din_* to addr_*; regardless, dout_* is updated to the (post-write, or read-before-write, either is acceptable) value at addr_* — synchronous read, standard block-RAM style. Both ports may operate independently in the same cycle to different addresses.
