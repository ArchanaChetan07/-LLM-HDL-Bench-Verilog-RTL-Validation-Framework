module dual_port_ram(
    input clk,
    input  we_a,
    input  [3:0] addr_a,
    input  [7:0] din_a,
    output reg [7:0] dout_a,
    input  we_b,
    input  [3:0] addr_b,
    input  [7:0] din_b,
    output reg [7:0] dout_b
);
    reg [7:0] mem [0:15];

    always @(posedge clk) begin
        if (we_a) mem[addr_a] <= din_a;
        if (we_b) mem[addr_b] <= din_b;
    end

    always @(posedge clk) begin
        dout_a <= mem[addr_a];
        dout_b <= mem[addr_b];
    end
endmodule
