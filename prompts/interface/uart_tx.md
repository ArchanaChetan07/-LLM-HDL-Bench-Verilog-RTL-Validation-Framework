# Prompt: uart_tx
Write a synthesizable Verilog module named `uart_tx` implementing a UART transmitter, 8 data bits, no parity, 1 stop bit, operating directly at the bit rate (one bit output per clock cycle — no baud generator needed, assume clk IS the bit-rate clock for simplicity).

Module interface:
```
module uart_tx(
    input clk,
    input rst,        // synchronous, active-high
    input start,       // pulse high for 1 cycle to begin transmission
    input  [7:0] data,
    output reg tx,     // serial output line, idle high
    output reg busy    // high while a transmission is in progress
);
```
Frame format: 1 start bit (0), 8 data bits LSB-first, 1 stop bit (1). Idle state: tx=1, busy=0. On `start` pulse (only accepted when not busy), latch `data` and begin shifting out the frame over the next 10 clock cycles, asserting `busy` throughout, then return to idle.
