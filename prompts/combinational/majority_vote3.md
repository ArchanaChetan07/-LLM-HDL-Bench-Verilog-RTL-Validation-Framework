# Prompt: majority_vote3
Write a synthesizable Verilog module named `majority_vote3` implementing a 3-input majority voter.

Module interface:
```
module majority_vote3(
    input a,
    input b,
    input c,
    output majority
);
```
`majority` is 1 if at least 2 of the 3 inputs are 1, else 0. Purely combinational.
