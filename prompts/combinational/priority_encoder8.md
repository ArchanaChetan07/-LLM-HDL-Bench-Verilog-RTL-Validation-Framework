# Prompt: priority_encoder8
Write a synthesizable Verilog module named `priority_encoder8` implementing an 8-input priority encoder (highest bit index wins).

Module interface:
```
module priority_encoder8(
    input  [7:0] in,
    output reg [2:0] code,
    output reg valid
);
```
`valid` is 1 if any input bit is set, else 0. `code` is the index of the highest-priority (highest index) set bit. If no bits are set, `code` should be 3'b000. Purely combinational.
