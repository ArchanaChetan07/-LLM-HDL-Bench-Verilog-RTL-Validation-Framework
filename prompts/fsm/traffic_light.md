# Prompt: traffic_light
Write a synthesizable Verilog module named `traffic_light` implementing a simple traffic light FSM cycling GREEN -> YELLOW -> RED -> GREEN ...

Module interface:
```
module traffic_light(
    input clk,
    input rst,       // synchronous, active-high
    output reg [1:0] light  // 2'b00=RED, 2'b01=GREEN, 2'b10=YELLOW
);
```
On reset, light = RED. Hold GREEN for 4 clock cycles, YELLOW for 2 clock cycles, RED for 4 clock cycles, then repeat. Use an internal counter register.
