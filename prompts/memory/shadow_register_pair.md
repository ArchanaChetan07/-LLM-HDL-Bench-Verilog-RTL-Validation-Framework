# Prompt: shadow_register_pair
Write a synthesizable Verilog module named `shadow_register_pair` implementing a working register plus a "shadow" (backup) register: normal writes go to the working register, and a separate `commit` pulse copies the working register's value into the shadow register. A `restore` pulse copies the shadow register's value back into the working register.

Module interface:
```
module shadow_register_pair(
    input clk,
    input rst,       // synchronous, active-high; clears both registers to 0
    input we,
    input  [7:0] wdata,
    input commit,    // pulse: working -> shadow
    input restore,   // pulse: shadow -> working (takes priority over we/commit if asserted same cycle)
    output [7:0] working_out,
    output [7:0] shadow_out
);
```
Priority when multiple control signals are asserted the same cycle: `restore` > `commit` > `we`.
