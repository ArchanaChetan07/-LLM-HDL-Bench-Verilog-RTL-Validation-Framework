module single_port_rom_16x8(
    input clk,
    input  [3:0] addr,
    output reg [7:0] data
);
    reg [7:0] rom [0:15];
    integer i;
    initial begin
        for (i = 0; i < 16; i = i + 1)
            rom[i] = (i * 2 + 1);
    end

    always @(posedge clk) begin
        data <= rom[addr];
    end
endmodule
