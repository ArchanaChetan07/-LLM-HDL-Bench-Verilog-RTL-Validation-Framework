`timescale 1ns/1ps
module tb_walking_1_pattern;
    reg clk=0, rst; wire [3:0] pattern;
    integer errors=0, i;
    reg [3:0] model;
    walking_1_pattern dut(.clk(clk), .rst(rst), .pattern(pattern));
    always #5 clk=~clk;
    initial begin
        errors=0;
        rst=1; @(posedge clk); #1; model=4'b0001;
        if (pattern!==model) begin errors=errors+1; $display("MISMATCH after reset"); end
        rst=0;
        for (i=0;i<8;i=i+1) begin
            @(posedge clk); #1;
            model = {model[2:0], model[3]};
            if (pattern!==model) begin errors=errors+1; $display("MISMATCH i=%0d pattern=%b exp=%b",i,pattern,model); end
        end
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
endmodule
