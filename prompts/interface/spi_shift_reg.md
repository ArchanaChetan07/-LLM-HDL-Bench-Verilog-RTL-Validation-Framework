# Prompt: spi_shift_reg
Write a synthesizable Verilog module named `spi_shift_reg` implementing an 8-bit SPI-style shift register (mode 0 style: shift on rising clock edge, MSB first) usable as either transmitter or receiver shift logic.

Module interface:
```
module spi_shift_reg(
    input clk,
    input rst,      // synchronous, active-high
    input load,     // synchronous load of parallel data into the register
    input  [7:0] parallel_in,
    input  shift_en,  // when high (and load low), shift left, MSB out via serial_out, new bit from serial_in enters LSB
    input  serial_in,
    output serial_out,   // = current MSB of the register (bit 7)
    output [7:0] parallel_out
);
```
Priority: rst > load > shift_en (i.e. if rst asserted, ignore load/shift; else if load asserted, load parallel data; else if shift_en, shift).
