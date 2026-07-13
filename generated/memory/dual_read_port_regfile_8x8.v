module dual_read_port_regfile_8x8(
    input clk,
    input we,
    input  [2:0] waddr,
    input  [7:0] wdata,
    input  [2:0] raddr1,
    input  [2:0] raddr2,
    input  [2:0] raddr3,
    output [7:0] rdata1,
    output [7:0] rdata2,
    output [7:0] rdata3
);
    reg [7:0] regs [0:7];

    always @(posedge clk) begin
        if (we)
            regs[waddr] <= wdata;
    end

    assign rdata1 = regs[raddr1];
    assign rdata2 = regs[raddr2];
    assign rdata3 = regs[raddr3];
endmodule
