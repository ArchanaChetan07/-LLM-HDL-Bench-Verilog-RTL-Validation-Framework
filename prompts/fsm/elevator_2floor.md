# Prompt: elevator_2floor
Write a synthesizable Verilog module named `elevator_2floor` implementing a simple 2-floor elevator controller FSM.

Module interface:
```
module elevator_2floor(
    input clk,
    input rst,          // synchronous, active-high; resets to floor 1 (at_floor1=1)
    input call_floor1,
    input call_floor2,
    output reg at_floor1,
    output reg at_floor2,
    output reg moving
);
```
Exactly one of `at_floor1`/`at_floor2` is high when not moving; both low while `moving` is high. Moving between floors takes exactly 2 clock cycles (assert `moving` for 2 cycles, then arrive). Ignore call requests for the floor the elevator is already at. If both calls are asserted simultaneously while idle at a floor, prioritize moving toward floor 2 if idle at floor1, or servicing floor1 if idle at floor2 (i.e., always move toward the other floor if any call is pending for it).
