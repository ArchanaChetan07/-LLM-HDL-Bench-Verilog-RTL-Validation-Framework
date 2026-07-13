# Prompt: simple_spi_master
Write a synthesizable Verilog module named `simple_spi_master` implementing a minimal SPI master (mode 0: sample on rising edge, shift MSB first) that transmits and receives 8 bits per transaction, generating its own serial clock as a divided-down version of the system clock (spi_clk toggles every system clock cycle, i.e. spi_clk = sysclk/2 -- for simplicity, no separate clock-divider ratio is required).

Module interface:
```
module simple_spi_master(
    input clk,
    input rst,          // synchronous, active-high
    input start,        // pulse high for 1 cycle to begin an 8-bit transaction
    input  [7:0] tx_data,
    input miso,
    output reg sclk,
    output mosi,
    output reg [7:0] rx_data,
    output reg busy
);
```
On `start` (only accepted when not busy), begin toggling `sclk` and shifting `tx_data` out MSB-first on `mosi`, sampling `miso` into `rx_data` MSB-first, one bit per `sclk` rising edge, for 8 bits, then deassert `busy` and stop toggling `sclk` (idle low) until the next `start`.
