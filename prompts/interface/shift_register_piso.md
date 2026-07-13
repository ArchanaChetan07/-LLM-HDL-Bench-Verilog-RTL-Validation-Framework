# Prompt: shift_register_piso
Write a synthesizable Verilog module named `shift_register_piso` implementing an 8-bit parallel-in, serial-out shift register.

Module interface:
```
module shift_register_piso(
    input clk,
    input rst,     // synchronous, active-high
    input load,    // synchronous parallel load
    input  [7:0] parallel_in,
    input  shift_en,  // shift left (MSB first out), 0 shifted into LSB
    output serial_out  // current MSB (bit 7)
);
```
Priority: rst > load > shift_en, same as spi_shift_reg pattern. On reset, register = 0.
