# Prompt: one_shot_pulse_gen
Write a synthesizable Verilog module named `one_shot_pulse_gen` implementing a one-shot pulse generator FSM: given a trigger input, output a pulse held high for exactly 3 clock cycles, ignoring further triggers until the pulse completes.

Module interface:
```
module one_shot_pulse_gen(
    input clk,
    input rst,      // synchronous, active-high
    input trigger,  // pulses high for 1 cycle to start
    output reg pulse_out
);
```
On `trigger` (only recognized when idle, i.e. not currently outputting a pulse), `pulse_out` goes high for exactly 3 consecutive clock cycles, then returns low and the FSM becomes ready for the next trigger.
