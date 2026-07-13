module byte_enable_ram_16x8(
    input clk,
    input we,
    input byte_en,
    input  [3:0] addr,
    input  [7:0] wdata,
    output reg [7:0] rdata
);
    reg [7:0] mem [0:15];

    always @(posedge clk) begin
        if (we && byte_en)
            mem[addr] <= wdata;
        rdata <= mem[addr];
    end
endmodule
