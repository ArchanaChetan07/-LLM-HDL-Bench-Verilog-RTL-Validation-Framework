`timescale 1ns/1ps
module tb_single_port_rom_16x8;
    reg clk=0; reg [3:0] addr; wire [7:0] data;
    integer i, errors=0;
    reg [7:0] exp;
    single_port_rom_16x8 dut(.clk(clk), .addr(addr), .data(data));
    always #5 clk=~clk;
    initial begin
        errors=0;
        for (i=0;i<16;i=i+1) begin
            addr = i[3:0];
            @(posedge clk); #1;
            exp = (i*2+1) & 8'hFF;
            if (data !== exp) begin
                errors=errors+1;
                $display("MISMATCH addr=%d data=%d expected=%d", addr, data, exp);
            end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
