# Prompt: vending_machine
Write a synthesizable Verilog module named `vending_machine` implementing an FSM for a vending machine that dispenses an item costing 15 cents, accepting nickels (5) and dimes (10) one coin per cycle.

Module interface:
```
module vending_machine(
    input clk,
    input rst,        // synchronous, active-high
    input coin_5,      // pulses high for 1 cycle when a nickel is inserted
    input coin_10,     // pulses high for 1 cycle when a dime is inserted
    output reg dispense // pulses high for 1 cycle when item is dispensed
);
```
Track accumulated value in cents using FSM states (0, 5, 10, 15+ cents). When accumulated value reaches or exceeds 15 cents, assert `dispense` for one cycle and reset accumulated value to 0. Assume at most one coin input is asserted per cycle.
