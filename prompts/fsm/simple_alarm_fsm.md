# Prompt: simple_alarm_fsm
Write a synthesizable Verilog module named `simple_alarm_fsm` implementing a simple security-alarm FSM with arm/trigger/disarm behavior.

Module interface:
```
module simple_alarm_fsm(
    input clk,
    input rst,       // synchronous, active-high; resets to DISARMED
    input arm,       // pulse high for 1 cycle to arm the system
    input sensor,    // high while a sensor is tripped
    input disarm,    // pulse high for 1 cycle to disarm (works from any state)
    output reg armed,
    output reg alarm_triggered
);
```
States: DISARMED (armed=0, alarm_triggered=0) -> on `arm`, go to ARMED (armed=1, alarm_triggered=0). While ARMED, if `sensor` goes high, transition to TRIGGERED (armed=1, alarm_triggered=1) and stay there (even if sensor later goes low) until `disarm` is asserted, at which point return to DISARMED regardless of current state. `disarm` always wins over other transitions in the same cycle.
